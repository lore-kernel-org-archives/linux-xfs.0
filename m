Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 083498083
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 06:58:06 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 93418AC002
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 04:58:02 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id X2yIDiIkAnktwp6L (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 02 Dec 2015 04:58:01 -0800 (PST)
Date: Wed, 2 Dec 2015 13:57:26 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: sleeps and waits during io_submit
Message-ID: <20151202125726.GA16871@redhat.com>
References: <20151201160133.GE26129@bfoster.bfoster>
	<565DC613.4090608@scylladb.com>
	<20151201162958.GF26129@bfoster.bfoster>
	<565DD449.5090101@scylladb.com> <20151201180321.GA4762@redhat.com>
	<565DEFE2.2000308@scylladb.com> <20151201211914.GZ19199@dastard>
	<565E1355.4020900@scylladb.com> <20151201230644.GD19199@dastard>
	<565EB390.3020309@scylladb.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <565EB390.3020309@scylladb.com>
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

> >>>>compatibility.
> >>>>
> >>>>>XFS spread files across the allocation groups, based on the directory these
> >>>>>files are created,
> >>>>Idea: create the files in some subdirectory, and immediately move
> >>>>them to their required location.
> >>>See xfs_fsr.
> >>Can you elaborate?  I don't see how it is applicable.
> >Just pointing out that this is what xfs_fsr does to control locality
> >of allocation for files it is defragmenting. Except that rather than
> >moving files, it uses XFS_IOC_SWAPEXT to switch the data between two
> >inodes atomically...
> 
> Ok, thanks.
> 
> >
> >>My hack involves creating the file in a random directory, and while
> >>it is still zero sized, move it to its final directory.  This is
> >>simply to defeat the ag selection heuristic.
> >Which you really don't want to do.
> 
> Why not?  For my directory structure, files in the same directory do not
> share temporal locality.  What does the ag selection heuristic give me?
> 
> 
> 
> >
> >>>>>  trying to keep files as close as possible from their
> >>>>>metadata.
> >>>>This is pointless for an SSD. Perhaps XFS should randomize the ag on
> >>>>nonrotational media instead.
> >>>Actually, no, it is not pointless. SSDs do not require optimisation
> >>>for minimal seek time, but data locality is still just as important
> >>>as spinning disks, if not moreso. Why? Because the garbage
> >>>collection routines in the SSDs are all about locality and we can't
> >>>drive garbage collection effectively via discard operations if the
> >>>filesystem is not keeping temporally related files close together in
> >>>it's block address space.
> >>In my case, files in the same directory are not temporally related.
> >>But I understand where the heuristic comes from.
> >>
> >>Maybe an ioctl to set a directory attribute "the files in this
> >>directory are not temporally related"?
> >And exactly what does that gain us?
> 
> I have a directory with commitlog files that are constantly and rapidly
> being created, appended to, and removed, from all logical cores in the
> system.  Does this not put pressure on that allocation group's locks?
> 
> >Exactly what problem are you
> >trying to solve by manipulating file locality that can't be solved
> >by existing knobs and config options?
> 
> I admit I don't know much about the existing knobs and config options.
> Pointers are appreciated.
> 
> 
> >
> >Perhaps you'd like to read up on how the inode32 allocator behaves?
> 
> Indeed I would, pointers are appreciated.
> 
inode32 mount option limit inode allocations to the first AG of the
filesystem, instead of allocate inodes across the whole AGs.

This exists basically because since inode numbers are based on where the inode
is allocated, inodes allocated beyond the first TB of the filesystem, will have
64bit inode numbers, which, in case, might cause compatibility problems with
applications which are not able to read 64bit inode numbers.





> >
> >>>e.g. If the files in a directory are all close together, and the
> >>>directory is removed, we then leave a big empty contiguous region in
> >>>the filesystem free space map, and when we send discards over that
> >>>we end up with a single big trim and the drive handles that far more
> >>Would this not be defeated if a directory that happens to share the
> >>allocation group gets populated simultaneously?
> >Sure. But this sort of thing is rare in the real world, and when
> >they do occur, it generally only takes small tweaks to algorithms
> >and layouts make them go away.  I don't care to bikeshed about
> >theoretical problems - I'm in the business of finding the root cause
> >of the problems users are having and solving those problems. So far
> >what you've given us is a ball of "there's blocking in AIO
> >submission", and the only one that is clear cut is the timestamp
> >update.
> >
> >Go back and categorise the types of blocking that you are seeing -
> >whether it be on the AGIs during inode manipulation, one the AGFs
> >becuse of concurrent extent allocation, on log forces because of
> >slow discards in the transcation completion, on the transaction
> >subsystem because of a lack of log space for concurrent
> >reservations, etc. And then determine if changing the layout of the
> >filesystem (e.g. number of AGs, size of log, etc) and different
> >mount options (e.g. turning off discard, using inode32 allocator,
> >etc) make any difference to the blocking issues you are seeing.
> >
> >Once we know which of the different algorithms is causing the
> >blocking issues, we'll know a lot more about why we're having
> >problems and a better idea of what problems we actually need to
> >solve.
> 
> I'm happy to hack off the lowest hanging fruit and then go after the next
> one.  I understand you're annoyed at having to defend against what may be
> non-problems; but for me it is an opportunity to learn about the file
> system.  For us it is the weakest spot in our system, because on the one
> hand we heavily depend on async behavior and on the other hand Linux is
> notoriously bad at it.  So we are very nervous when blocking happens.
> 
> >
> >>>effectively than lots of little trims (i.e. one per file) that the
> >>>drive cannot do anything useful with because they are all smaller
> >>>than the internal SSD page/block sizes and so get ignored.  This is
> >>>one of the reasons fstrim is so much more efficient and effective
> >>>than using the discard mount option.
> >>In my use case, the files are fairly large, and there is constant
> >>rewriting (not in-place: files are read, merged, and written back).
> >>So I'm worried an fstrim can happen too late.
> >Have you measured the SSD performance degradation over time due to
> >large overwrites? If not, then again it is a good chance you are
> >trying to solve a theoretical problem rather than a real problem....
> >
> 
> I'm not worried about that (maybe I should be) but about the SSD reaching
> internal ENOSPC due to the fstrim happening too late.
> 
> Consider this scenario, which is quite typical for us:
> 
> 1. Fill 1/3rd of the disk with a few large files.
> 2. Copy/merge the data into a new file, occupying another 1/3rd of the disk.
> 3. Repeat 1+2.
> 
> If this is repeated few times, the disk can see 100% of its space occupied
> (depending on how free space is allocated), even if from a user's
> perspective it is never more than 2/3rds full.
> 
> Maybe a simple countermeasure is to issue an fstrim every time we write
> 10%-20% of the disk's capacity.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
