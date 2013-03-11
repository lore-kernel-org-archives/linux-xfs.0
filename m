Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 23C347F37
	for <xfs@oss.sgi.com>; Mon, 11 Mar 2013 17:45:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DF5E08F8050
	for <xfs@oss.sgi.com>; Mon, 11 Mar 2013 15:45:40 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	CmCuz49X4CKJjYWV for <xfs@oss.sgi.com>;
	Mon, 11 Mar 2013 15:45:38 -0700 (PDT)
Date: Tue, 12 Mar 2013 09:45:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS filesystem corruption
Message-ID: <20130311224536.GE21651@dastard>
References: <5137CD46.6070909@redhat.com> <5139A3B6.3040805@hardwarefreak.com>
	<5139D792.4090304@redhat.com> <513A350A.508@hardwarefreak.com>
	<20130309091152.GH23616@dastard>
	<513B84AD.2000603@hardwarefreak.com>
	<20130310224536.GK23616@dastard>
	<513D1D51.7010905@hardwarefreak.com>
	<20130311005024.GC20565@dastard>
	<513DA40B.6050903@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <513DA40B.6050903@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Julien FERRERO <jferrero06@gmail.com>, Ric Wheeler <rwheeler@redhat.com>, xfs@oss.sgi.com

On Mon, Mar 11, 2013 at 04:29:47AM -0500, Stan Hoeppner wrote:
> On 3/10/2013 7:50 PM, Dave Chinner wrote:
> > On Sun, Mar 10, 2013 at 06:54:57PM -0500, Stan Hoeppner wrote:
> >> On 3/10/2013 5:45 PM, Dave Chinner wrote:
> >>>>  Does everyone remember the transitive property of equality from math
> >>>> class decades ago?  It states "If A=B and B=C then A=C".  Thus if
> >>>> barrier writes to the journal protect the journal, and the journal
> >>>> protects metadata, then barrier writes to the journal protect metadata.
> >>>
> >>> Yup, but the devil is in the detail - we don't protect individual
> >>> metadata writes at all and that difference is significant enough to
> >>> comment on.... :P
> >>
> >> Elaborate on this a bit, if you have time.  I was under the impression
> >> that all directory updates were journaled first.
> > 
> > That's correct - they are all journalled.
> > 
> > But journalling is done at the transactional level, not that of
> > individual metadata changes. IOWs, journalled changes do not
> > contain the same information as a metadata buffer write - they
> > contain both more and less information than a metadata buffer write.
> > 
> > They contain more information in that there is change atomicity
> > information in the journal information for recovery purposes. i.e.
> > how the individual change relates to changes in other related
> > metadata objects. This information is needed in the journal so that
> > log recovery knows to either apply all the changes in a checkpoint
> > or none of them if this journal checkpoint (or a previous one) is
> > incomplete.
> > 
> > They contain less information in that the changes to a metadata
> > object is stored as a diff in the journal rather than as a complete
> > copy of the object. This is done to reduce the amount of journal
> > space and memory required to track and store all of the changes in
> > the checkpoint.
> 
> Forget the power loss issue for a moment.  If I'm digesting this
> correctly, it's seems quite an accomplishment that you got delaylog
> working, at all, let alone extremely well as it does.  Given what you
> state above, it would seem there is quite a bit of complexity involved
> in tracking these metadata change relationships and modifying the
> checkpoint information accordingly.

Yes, there is.

> I would think as you merge multiple
> traditional XFS log writes into a single write that the relationship
> information would also need to be modified as well.  Or do I lack
> sufficient understanding at this point to digest this?

Relationship information is inherent in the checkpoint method due to
a feature that has been built into the XFS transaction/journalling
code from day-zero: relogging. This is described in all it's glory
in Documentation/filesystems/xfs-delayed-logging-design.txt....

> > Hence what is written to the journal is quite different to what is
> > written during metadata writeback in both contents ad method. It is
> > the atomicity information in the journal that we know got
> > synchronised to disk (via the FUA/cache flush) that enables us to
> > get away with being lazy writing back metadata buffers in any order
> > we please without needing FUA/cache flushes...
> 
> This makes me wonder... for a given metadata write into an AG, is the
> amount of data in the corresponding journal write typically greater or
> less?

Typically less - buffer changes are logged into a dirty bitmap with
a resolution of 128 bytes. hence a single byte change will record a
single dirty bit, which means 128 bytes will be logged. Both the
dirty bitmap and the 128 byte regions are written to the journal. So
inthis case, less is written to the journal.

However, because of relogging, the more a buffer gets modified, then
larger the number of dirty regions, and so for buffers that are
repeatedly modified we typically end up logging them entirely,
including the bitmap and other information. In this case, more is
written to the journal than would be written by metadata
writeback...

The difference with delayed logging is that the frequency of journal
writes goes way down, so the fact that we typically log more per
object into the journal is greatly outweighed by the fact that the
objects are logged orders of magnitude less often....

> You stated above it is both more and less but I don't know if you
> meant that qualitatively or quantitatively, or both.  I'm
> wondering that if log write bytes is typically significantly
> lower, and we know we can recreate a lost metadata write from the
> journal data during a recovery.... Given that CPU is so much
> faster than disk, would it be plausible to do all metadata writes
> in a lazy fashion through the relevant sections of the recovery
> code, or something along these lines?

We already do that.

> Make 'recovery' the
> standard method for metadata writes?  I'm not talking about
> replacing the log journal, but replacing the metadata write method
> with something akin to a portion of the the journal recovery
> routine.

To do that, you need an unbound log size. i.e. you are talking about
a log structured filesystem rather than a traditional journalled
filesystem. The problem with log structured filesystem is that you
trade off write side speed and latency for read side speed and
latency. When you get large data sets or frequently modified data
sets larger than can be cached in memory, log structured filesystems
perform teribly because the metadata needs reconstructing or
regathering every time it is read. IOWs, log structured filesystems
simply don't scale to large sizes or large scale data sets
effectively. 

> In other words, could we make use of the delaylog concept of doing
> more work with fewer IOs to achieve a similar performance gain for
> metadata writeback?  Or is XFS metadata writeback already fully
> optimized WRT IOs and bandwidth, latency, etc?

I wouldn't say it's fully optimised (nothing ever is), but metadata
writeback is almost completely decoupled from the transactional
modification side of the filesystem and so we can do far larger
scale optimisation of writback order than othe filesystems. Hence
there are relatively few latency/bandwidth/IOPS issued with metadata
writeback.

For example: have a look at slide 24 of this presentation:

http://xfs.org/images/d/d1/Xfs-scalability-lca2012.pdf

and note how much IO XFS is doing for metadata writeback for the
given metadata performance compared to ext4. Take away message:

"XFS has the lowest IOPS rate at a given modification rate - both
ext4 and BTRFS are IO bound at higher thread counts."

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
