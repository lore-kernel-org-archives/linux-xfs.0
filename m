Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p421K2nu201968
	for <linux-xfs@oss.sgi.com>; Sun, 1 May 2011 20:20:02 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C1C521EC68D4
	for <linux-xfs@oss.sgi.com>; Sun,  1 May 2011 18:23:35 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	R8CVPQaUXPkljfpq for <linux-xfs@oss.sgi.com>;
	Sun, 01 May 2011 18:23:35 -0700 (PDT)
Date: Mon, 2 May 2011 11:23:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: op-journaled fs, journal size and storage speeds
Message-ID: <20110502012306.GJ13542@dastard>
References: <19900.8703.214676.218477@tree.ty.sabi.co.UK>
	<20110501092758.GG13542@dastard>
	<19901.41647.606112.243194@tree.ty.sabi.co.UK>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <19901.41647.606112.243194@tree.ty.sabi.co.UK>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Peter Grandi <pg_mh@sabi.co.UK>
Cc: Linux fs XFS <linux-xfs@oss.sgi.com>, Linux fs JFS <jfs-discussion@lists.SourceForge.net>

On Sun, May 01, 2011 at 07:13:03PM +0100, Peter Grandi wrote:
> 
> >> Been thinking about journals and RAID6s and SSDs. In particular
> >> for file system designs like JFS and XFS that do operation
> >> journaling (while ext[34] do block journaling).
> 
> > XFS is not an operation journalling filesystem. Most of the
> > metadata is dirty-region logged via buffers, just like ext3/4.
> 
> Looking at the sources, XFS does operations journaling, in the
> form of physical ("dirty region") operation logging,

Operation logging contains no physical changes - it just indicates
the change to be made typically via an intent/done transaction pair.
It says what is going to be done, then what has been done, but not
the details of the changes made.

XFs _always_ logs the details of the changes made, and....

> instead of
> logical operation logging like JFS. Both are very different from
> block journaling.

When you are dirtying entire blocks, then the way the blocks are
logged is really no different to ext3/4's block logging...

> More in details, to me there is a stark contrast between 'jbd.h':
> 
>   http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.38.y.git;a=blob;f=include/linux/jbd.h;h=e06965081ba5548f74db935543af84334f58259e;hb=HEAD
> 
> where I find only a few journal transaction types (blocks) and
> 'xfs_trans.h' where I find many journal transaction types (ops):
> 
>  http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.38.y.git;a=blob;f=fs/xfs/xfs_trans.h;h=c2042b736b81131a780703d8a5907c848793eebb;hb=HEAD

Yeah, so that number goes into the transaction header on disk mainly
for debugging purposes - you can identify what operation triggered
the transaction in the log just by looking at the log.

However, taht is _completely ignored_ for delayed logging - you'll
only ever see "checkpoint" transactions with delayed logging as it
throws away all the transaction specific metadata in memory...

> Given that in the latter I see transaction types like
> 'XFS_TRANS_RENAME' or 'XFS_TRANS_MKDIR' it is hard to imagine how
> one can argue that the XFS journals something other than ops, even
> if in a buffered way of sorts.

Why don't you look at the transaction reservations that define what
one of those "transaction ops" contains. e.g. MKDIR uses the inode
create reservation:

/*
 * For create we can modify:
 *    the parent directory inode: inode size
 *    the new inode: inode size
 *    the inode btree entry: block size
 *    the superblock for the nlink flag: sector size
 *    the directory btree: (max depth + v2) * dir block size
 *    the directory inode's bmap btree: (max depth + v2) * block size
 * Or in the first xact we allocate some inodes giving:
 *    the agi and agf of the ag getting the new inodes: 2 * sectorsize
 *    the superblock for the nlink flag: sector size
 *    the inode blocks allocated: XFS_IALLOC_BLOCKS * blocksize
 *    the inode btree: max depth * blocksize
 *    the allocation btrees: 2 trees * (max depth - 1) * block size
 */
STATIC uint
xfs_calc_create_reservation(
        struct xfs_mount        *mp)
{
        return XFS_DQUOT_LOGRES(mp) +
                MAX((mp->m_sb.sb_inodesize +
                     mp->m_sb.sb_inodesize +
                     mp->m_sb.sb_sectsize +
                     XFS_FSB_TO_B(mp, 1) +
                     XFS_DIROP_LOG_RES(mp) +
                     128 * (3 + XFS_DIROP_LOG_COUNT(mp))),
                    (3 * mp->m_sb.sb_sectsize +
                     XFS_FSB_TO_B(mp, XFS_IALLOC_BLOCKS(mp)) +
                     XFS_FSB_TO_B(mp, mp->m_in_maxlevels) +
                     XFS_ALLOCFREE_LOG_RES(mp, 1) +
                     128 * (2 + XFS_IALLOC_BLOCKS(mp) + mp->m_in_maxlevels +
                            XFS_ALLOCFREE_LOG_COUNT(mp, 1))));
}

> > How do you know what "one second" of "in flight" operations is
> > going to be?
> 
> Well, that's what I discuss later, it is a "rule of thumb" based
> on on *some* rationale, but I have been questioning it.
> 
> [ ... interesting summary of some of the many issue related to
> journal sizing ... ]
> 
> > Easiest and most reliable method seems to be to size your
> > journal appropriatly in the first place and have you
> > algorithms key off that....
> 
> Sure, but *I* am asking that question :-).

And my response is that there is no one correct answer, and that
physical limits are usually the issue...

> >> This seems to me a fairly bad idea, because then the journal
> >> becomes a massive hot spot on the disk and draws the disk arm
> >> like black hole. I suspect that operations should not stay on
> 
> > That's why you can configure an external log....
> 
> ...and lose barriers :-). But indeed.

As always, if performance and data safety is your concern, spend a
few hundred dollars more and buy a decent HW RAID card with a BBWC....

> >> the journal for a long time. However if the journal is too
> >> small processes that do metadata updates start to hang on it.
> 
> > Well, yes. The journal needs to be large enough to hold all
> > the transaction reservations for the active transactions. XFS,
> > in the worse case for a default filesystem config, needs about
> > 100MB of log space per 300 concurrent transactions. [ ... ]
> 
> So something like 300KB per transaction?

Yup. And the size is dependent on filesystem block size, filesystem
and AG size (max btree depths). So for a 64k block size filesystem,
that 300kb transaction reservation blows out to about 3MB....

> That seems a pretty
> extreme worst case. How is that possible? A metadata transaction
> with a "dirty region" of 300KB sound enormously expensive. It may
> be about extent maps for a very fragmented file I guess.

It's actually very small. Have you ever looked at how much metadata
a directory contains?  Rule of thumb is that a directory consumes
about 100MB of metadata for every million entries for average length
filenames. having a create transaction consume 300KB at maximum for
a worst case modification of a directory with a million, 10M or 100M
entries makes that 300k look pretty small...


> clear here what  concurrent  means because the log is sequential.
> I'll guess that it means "in flight".
> 
> [ ... ]
> 
> >> * What should journal size be proportional to?
> 
> > Your workload.
> 
> Sure, as a very top level goal. But that's not an answer, it is
> handwaving. As you argue earlier, it could be proportional in some
> cases to IO threads; or it could be number of arms, filesystem
> size, size of each volume, sequential transfer rate, random
> transfer rate, large IO transfer rate, small IO transfer rate, ...

Nice definition of "workload dependent".

> Some tighter guideline might be better than just guessing.
> 
> >> * What is the downside of a too small journal?
> 
> > Performance sucks.
> 
> But why? Without a journal completely performance is better;
> assuming a one-transaction journal this becomes slower because
> of writing everything twice, but that happens for any size of
> journal, as it is unavoidable.

Why does having a writeback cache improve perfromance? Larger
journals enable longer caching of dirty metadata before writeback
must occur. 

> When the journal fills up the effect is the same as that of a 1
> transaction journal. That's the same for every type of buffer.

And then you've got the problem of having to wait for those 10
objects to complete IO before you can do another transaction, while
if you have a large log, you can push on it before you run out of
space to try to ensure it never stalls. And when you have
100,000 metadata objects to write back, you can optimise the IO a
whole lot better than when you only have 10 objects.

> So the effect of a journal larger than 1 transaction must be
> felt only when the journal is not full,

Sure, and we've spent years optimising the metadata flushing to
ensure we empty the log as fast as possible under sustained
workloads. You need enough space in the journal to decouple
transactions from the flow of metadata writeback - how much is very
workload dependent.

> that is there are pauses
> in the flow of transactions; and then it does not matter a lot
> just how large the journal is.
>
> So the journal should be large enough to accomodate the highest
> possible rate of metadata updates for the longest time this
> happens until there is a pause in the metadata updates.

We need to be able to sustain hundreds of thousands of transactions
per second, every second, 24x7. There are no "pauses" we can take
advantage of to "catch up" - metadata writeback must take place
simultaneously with new transactions, and the journal must be large
enough to decouple these effectively.

> This of course depends on workload, but some rule of thumb based
> on experience might help.

Sure - we encode that experience in the mkfs and kernel default
behaviour. 

> And here my guess is that shorter journals are better than
> longer ones, because also:
> 
> >> * What is the downside of a too large journal other than space?
> 
> > Recovery times too long, lots of outstanding metadata pinned
> > in memory (hello OOM-killer!), and other resource management
> > related scalability issues.
> 
> I would have expected also more seeks, as reading logged but not
> yet finalized metadata has to go back to the journal, but I guess
> that's a small effect.

Say what? Nobody reads from the journal except during recovery.
Anything that is in the journal is dirty in memory, so any reads
come from the memory objects, not the journal....

> > Got a supplier for the custom hardware you'd need?
> 
> There are still a few, for example at different ends of the scale:
> 
>   http://www.ramsan.com/solutions/oracle/
>   http://www.microdirect.co.uk/home/product/39434/ACARD-RAM-Disk-SSD-ANS-9010B-6X-DDR-II-Slots

Neither of them are what I'd consider "battery backed RAM" - to the
filesystem they are simply fast block devices behind a SATA/SAS/FC
interface.  Effectively no different to a SAS/SATA/FC- or PCIe-based
flash SSD.

> But as another contributor said a fast/small disk RAID1 might be
> quite decent in many situations.

Not fast enough for an XFS log - I can push >500MB/s through the XFS
journal on a device (12 disk (7200rpm) RAID-0) that will do 700MB/s
for sequential data IO.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
