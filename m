Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p87CR47L158072 for <xfs@oss.sgi.com>; Wed, 7 Sep 2011 07:27:04 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4EAE513B8D8
	for <xfs@oss.sgi.com>; Wed,  7 Sep 2011 05:27:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Zs1H6DAesIC6SuuQ for
	<xfs@oss.sgi.com>; Wed, 07 Sep 2011 05:27:03 -0700 (PDT)
Date: Wed, 7 Sep 2011 14:26:54 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v2] xfs: fix possible overflow in xfs_ioc_trim()
In-Reply-To: <20110907112155.GA1017@infradead.org>
Message-ID: <alpine.LFD.2.00.1109071333110.4579@dhcp-27-109.brq.redhat.com>
References: <1315322977-22736-1-git-send-email-lczerner@redhat.com>
	<20110906153301.GA21675@infradead.org>
	<alpine.LFD.2.00.1109071200480.4579@dhcp-27-109.brq.redhat.com>
	<20110907112155.GA1017@infradead.org>
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com

On Wed, 7 Sep 2011, Christoph Hellwig wrote:

> On Wed, Sep 07, 2011 at 12:05:14PM +0200, Lukas Czerner wrote:
> > > > +	if (len > max_blks)
> > > > +		len = max_blks - start;
> > > 
> > > Is this really the correct check?
> > > 
> > > Shouldn't it be
> > > 
> > > 	if (start + len > max_blks)
> > > 		len = max_blks - start;
> > > 
> > > I'd also just use the mp->m_sb.sb_dblocks value directly instead
> > > of assigning it to a local variable.
> > > 
> > 
> > Agh, you're right. I am bit too hasty I guess. I thought that
> > 
> > if (start_agno >= mp->m_sb.sb_agcount)
> > 	return -XFS_ERROR(EINVAL);
> > 
> > will cover us from the unreasonably big start, however if the file
> > system has really huge number of AGs than it will fail to prevent the
> > overflow, I am not sure if that is possible to happen, but what you
> > proposed is definitely better.
> 
> The problem is that start could be very far into the fs, so checking
> len alone won't help very much.  And we probably want a check if 
> start + len is overflowing, too.

I do not think that start + len can overflow since we are doing
XFS_B_TO_FSBT() on it first. Am I missing something ?

The commit description is a bit misleading since the overflow can happen
when storing the value of XFS_FSB_TO_AGNO() rather than start
+ len alone. I'll update it as well.

Also this is wrong:

	start_agno = XFS_FSB_TO_AGNO(mp, start);
	if (start_agno >= mp->m_sb.sb_agcount)
		return -XFS_ERROR(EINVAL);

because XFS_FSB_TO_AGNO() might overflow as I mentioned above. This is
very similar problem to ext4 as well, but it is kind of hard to test
since the both block size and AF might be different, moreover in XFS
AG differs with the different fs size.

> 
> Care to update the test case to cover these cases as well?
> 

I am not sure what do you mean ? There already is a check when both
start and len are huge numbers. I am not sure if we can do more without
significantly complicating the test to cover various start, or len
numbers where can the fsblock->group_number overflow for various file
systems.

Thanks!
-Lukas

Anyway what about this patch ?

Subject: [PATCH] xfs: fix possible overflow in xfs_ioc_trim()

In xfs_ioc_trim it is possible that computing the last allocation group
to discard might overflow for big start & len values, because the result
might be bigger then xfs_agnumber_t which is 32 bit long. Fix this by not
allowing the start and end block of the range to be beyond the end of the
file system.

Note that if the start is beyond the end of the file system we have to
return -EINVAL, but in the "end" case we have to truncate it to the fs
size.

Also introduce "end" variable, rather than using start+len which which
might be more confusing to get right as this bug shows.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/xfs/xfs_discard.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 244e797..5ef3568 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -38,7 +38,7 @@ xfs_trim_extents(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
 	xfs_fsblock_t		start,
-	xfs_fsblock_t		len,
+	xfs_fsblock_t		end,
 	xfs_fsblock_t		minlen,
 	__uint64_t		*blocks_trimmed)
 {
@@ -100,7 +100,7 @@ xfs_trim_extents(
 		 * down partially overlapping ranges for now.
 		 */
 		if (XFS_AGB_TO_FSB(mp, agno, fbno) + flen < start ||
-		    XFS_AGB_TO_FSB(mp, agno, fbno) >= start + len) {
+		    XFS_AGB_TO_FSB(mp, agno, fbno) > end) {
 			trace_xfs_discard_exclude(mp, agno, fbno, flen);
 			goto next_extent;
 		}
@@ -145,7 +145,7 @@ xfs_ioc_trim(
 	struct request_queue	*q = mp->m_ddev_targp->bt_bdev->bd_disk->queue;
 	unsigned int		granularity = q->limits.discard_granularity;
 	struct fstrim_range	range;
-	xfs_fsblock_t		start, len, minlen;
+	xfs_fsblock_t		start, end, minlen;
 	xfs_agnumber_t		start_agno, end_agno, agno;
 	__uint64_t		blocks_trimmed = 0;
 	int			error, last_error = 0;
@@ -165,19 +165,21 @@ xfs_ioc_trim(
 	 * matter as trimming blocks is an advisory interface.
 	 */
 	start = XFS_B_TO_FSBT(mp, range.start);
-	len = XFS_B_TO_FSBT(mp, range.len);
+	end = start + XFS_B_TO_FSBT(mp, range.len) - 1;
 	minlen = XFS_B_TO_FSB(mp, max_t(u64, granularity, range.minlen));
 
-	start_agno = XFS_FSB_TO_AGNO(mp, start);
-	if (start_agno >= mp->m_sb.sb_agcount)
+	if (start >= mp->m_sb.sb_dblocks)
 		return -XFS_ERROR(EINVAL);
+	start_agno = XFS_FSB_TO_AGNO(mp, start);
 
-	end_agno = XFS_FSB_TO_AGNO(mp, start + len);
-	if (end_agno >= mp->m_sb.sb_agcount)
+	if (end >= mp->m_sb.sb_dblocks) {
+		end = mp->m_sb.sb_dblocks - 1;
 		end_agno = mp->m_sb.sb_agcount - 1;
+	} else
+		end_agno = XFS_FSB_TO_AGNO(mp, end);
 
 	for (agno = start_agno; agno <= end_agno; agno++) {
-		error = -xfs_trim_extents(mp, agno, start, len, minlen,
+		error = -xfs_trim_extents(mp, agno, start, end, minlen,
 					  &blocks_trimmed);
 		if (error)
 			last_error = error;
-- 
1.7.4.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
