Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DD7107F5A
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 17:07:09 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CD7928F8039
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 15:07:06 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	rq9YULdWAZiFq483 for <xfs@oss.sgi.com>;
	Tue, 01 Dec 2015 15:06:59 -0800 (PST)
Date: Wed, 2 Dec 2015 10:06:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: sleeps and waits during io_submit
Message-ID: <20151201230644.GD19199@dastard>
References: <20151201145631.GD26129@bfoster.bfoster>
	<565DBB3E.2010308@scylladb.com>
	<20151201160133.GE26129@bfoster.bfoster>
	<565DC613.4090608@scylladb.com>
	<20151201162958.GF26129@bfoster.bfoster>
	<565DD449.5090101@scylladb.com> <20151201180321.GA4762@redhat.com>
	<565DEFE2.2000308@scylladb.com> <20151201211914.GZ19199@dastard>
	<565E1355.4020900@scylladb.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <565E1355.4020900@scylladb.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Avi Kivity <avi@scylladb.com>
Cc: Glauber Costa <glauber@scylladb.com>, xfs@oss.sgi.com

On Tue, Dec 01, 2015 at 11:38:29PM +0200, Avi Kivity wrote:
> On 12/01/2015 11:19 PM, Dave Chinner wrote:
> >On Tue, Dec 01, 2015 at 09:07:14PM +0200, Avi Kivity wrote:
> >>On 12/01/2015 08:03 PM, Carlos Maiolino wrote:
> >>>Hi Avi,
> >>>
> >>>>>else is going to execute in our place until this thread can make
> >>>>>progress.
> >>>>For us, nothing else can execute in our place, we usually have exactly one
> >>>>thread per logical core.  So we are heavily dependent on io_submit not
> >>>>sleeping.
> >>>>
> >>>>The case of a contended lock is, to me, less worrying.  It can be reduced by
> >>>>using more allocation groups, which is apparently the shared resource under
> >>>>contention.
> >>>>
> >>>I apologize if I misread your previous comments, but, IIRC you said you can't
> >>>change the directory structure your application is using, and IIRC your
> >>>application does not spread files across several directories.
> >>I miswrote somewhat: the application writes data files and commitlog
> >>files.  The data file directory structure is fixed due to
> >>compatibility concerns (it is not a single directory, but some
> >>workloads will see most access on files in a single directory.  The
> >>commitlog directory structure is more relaxed, and we can split it
> >>to a directory per shard (=cpu) or something else.
> >>
> >>If worst comes to worst, we'll hack around this and distribute the
> >>data files into more directories, and provide some hack for
> >>compatibility.
> >>
> >>>XFS spread files across the allocation groups, based on the directory these
> >>>files are created,
> >>Idea: create the files in some subdirectory, and immediately move
> >>them to their required location.
> >See xfs_fsr.
> 
> Can you elaborate?  I don't see how it is applicable.

Just pointing out that this is what xfs_fsr does to control locality
of allocation for files it is defragmenting. Except that rather than
moving files, it uses XFS_IOC_SWAPEXT to switch the data between two
inodes atomically...

> My hack involves creating the file in a random directory, and while
> it is still zero sized, move it to its final directory.  This is
> simply to defeat the ag selection heuristic. 

Which you really don't want to do.

> >>>  trying to keep files as close as possible from their
> >>>metadata.
> >>This is pointless for an SSD. Perhaps XFS should randomize the ag on
> >>nonrotational media instead.
> >Actually, no, it is not pointless. SSDs do not require optimisation
> >for minimal seek time, but data locality is still just as important
> >as spinning disks, if not moreso. Why? Because the garbage
> >collection routines in the SSDs are all about locality and we can't
> >drive garbage collection effectively via discard operations if the
> >filesystem is not keeping temporally related files close together in
> >it's block address space.
> 
> In my case, files in the same directory are not temporally related.
> But I understand where the heuristic comes from.
> 
> Maybe an ioctl to set a directory attribute "the files in this
> directory are not temporally related"?

And exactly what does that gain us? Exactly what problem are you
trying to solve by manipulating file locality that can't be solved
by existing knobs and config options?

Perhaps you'd like to read up on how the inode32 allocator behaves?

> >e.g. If the files in a directory are all close together, and the
> >directory is removed, we then leave a big empty contiguous region in
> >the filesystem free space map, and when we send discards over that
> >we end up with a single big trim and the drive handles that far more
> 
> Would this not be defeated if a directory that happens to share the
> allocation group gets populated simultaneously?

Sure. But this sort of thing is rare in the real world, and when
they do occur, it generally only takes small tweaks to algorithms
and layouts make them go away.  I don't care to bikeshed about
theoretical problems - I'm in the business of finding the root cause
of the problems users are having and solving those problems. So far
what you've given us is a ball of "there's blocking in AIO
submission", and the only one that is clear cut is the timestamp
update.

Go back and categorise the types of blocking that you are seeing -
whether it be on the AGIs during inode manipulation, one the AGFs
becuse of concurrent extent allocation, on log forces because of
slow discards in the transcation completion, on the transaction
subsystem because of a lack of log space for concurrent
reservations, etc. And then determine if changing the layout of the
filesystem (e.g. number of AGs, size of log, etc) and different
mount options (e.g. turning off discard, using inode32 allocator,
etc) make any difference to the blocking issues you are seeing.

Once we know which of the different algorithms is causing the
blocking issues, we'll know a lot more about why we're having
problems and a better idea of what problems we actually need to
solve. 

> >effectively than lots of little trims (i.e. one per file) that the
> >drive cannot do anything useful with because they are all smaller
> >than the internal SSD page/block sizes and so get ignored.  This is
> >one of the reasons fstrim is so much more efficient and effective
> >than using the discard mount option.
> 
> In my use case, the files are fairly large, and there is constant
> rewriting (not in-place: files are read, merged, and written back).
> So I'm worried an fstrim can happen too late.

Have you measured the SSD performance degradation over time due to
large overwrites? If not, then again it is a good chance you are
trying to solve a theoretical problem rather than a real problem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
