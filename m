Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2A4F67CB7
	for <xfs@oss.sgi.com>; Thu,  3 Mar 2016 03:18:47 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 80078AC004
	for <xfs@oss.sgi.com>; Thu,  3 Mar 2016 01:18:43 -0800 (PST)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com
	[74.125.82.41]) by cuda.sgi.com with ESMTP id 3IhG59wwR52Lyqpe
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 03 Mar 2016 01:18:40 -0800 (PST)
Received: by mail-wm0-f41.google.com with SMTP id p65so22892641wmp.0
	for <xfs@oss.sgi.com>; Thu, 03 Mar 2016 01:18:40 -0800 (PST)
Message-ID: <E965894DE8D542788CCE98F72C218C05@alyakaslap>
From: "Alex Lyakas" <alex@zadarastorage.com>
References: <3685DFAD20214109878873CF81232704@alyakaslap>
	<20160222212019.GI25832@dastard>
	<CAOcd+r1XY2kcp+qJ=mPOAQSmb90QUnLfmT3-FkMjQN_+Ejmt8A@mail.gmail.com>
	<20160222235628.GK25832@dastard>
	<D5578D3E98EE48B88EA9A1126B671155@alyakaslap>
	<20160223225926.GN25832@dastard>
	<BC0CC25E00CE4CEDA1FFDFC0A2F38742@alyakaslap>
	<20160229211628.GK29057@dastard> <20160301072011.GF30721@dastard>
In-Reply-To: <20160301072011.GF30721@dastard>
Subject: Re: xfs resize: primary superblock is not updated immediately
Date: Thu, 3 Mar 2016 11:18:43 +0200
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Danny Shavit <danny@zadarastorage.com>, Shyam Kaushik <shyam@zadarastorage.com>, Yair Hershko <yair@zadarastorage.com>, xfs@oss.sgi.com

Hello Dave,
Thanks for the patch! I confirm that it fixes the scenario.

At [1] please find all the blknos that are being used during the log 
recovery (if that's of any interest).

Thanks,
Alex.

[1]
Mar  3 11:17:41 vc-00-00-350-dev kernel: [   68.068647] XFS (dm-0): Mounting 
V4 Filesystem
Mar  3 11:17:41 vc-00-00-350-dev kernel: [   68.099664] XFS (dm-0): Starting 
recovery (logdev: internal)
Mar  3 11:17:41 vc-00-00-350-dev kernel: [   68.102539] _xfs_buf_find: 
blkno=0 eofs=200704 >m_sb.sb_dblocks=25088
Mar  3 11:17:41 vc-00-00-350-dev kernel: [   68.102549] _xfs_buf_find: 
blkno=0 eofs=200704 >m_sb.sb_dblocks=25088
Mar  3 11:17:41 vc-00-00-350-dev kernel: [   68.102580] _xfs_buf_find: 
blkno=0 eofs=200704 >m_sb.sb_dblocks=25088
Mar  3 11:17:41 vc-00-00-350-dev kernel: [   68.126231] _xfs_buf_find: 
blkno=1 eofs=204800 >m_sb.sb_dblocks=25600
Mar  3 11:17:41 vc-00-00-350-dev kernel: [   68.126238] _xfs_buf_find: 
blkno=1 eofs=204800 >m_sb.sb_dblocks=25600
Mar  3 11:17:41 vc-00-00-350-dev kernel: [   68.126753] _xfs_buf_find: 
blkno=2 eofs=204800 >m_sb.sb_dblocks=25600
Mar  3 11:17:41 vc-00-00-350-dev kernel: [   68.126762] _xfs_buf_find: 
blkno=2 eofs=204800 >m_sb.sb_dblocks=25600
Mar  3 11:17:41 vc-00-00-350-dev kernel: [   68.127234] _xfs_buf_find: 
blkno=50177 eofs=204800 >m_sb.sb_dblocks=25600
Mar  3 11:17:41 vc-00-00-350-dev kernel: [   68.127244] _xfs_buf_find: 
blkno=50177 eofs=204800 >m_sb.sb_dblocks=25600
Mar  3 11:17:41 vc-00-00-350-dev kernel: [   68.127751] _xfs_buf_find: 
blkno=50178 eofs=204800 >m_sb.sb_dblocks=25600
Mar  3 11:17:41 vc-00-00-350-dev kernel: [   68.127760] _xfs_buf_find: 
blkno=50178 eofs=204800 >m_sb.sb_dblocks=25600
Mar  3 11:17:41 vc-00-00-350-dev kernel: [   68.128224] _xfs_buf_find: 
blkno=100353 eofs=204800 >m_sb.sb_dblocks=25600
Mar  3 11:17:41 vc-00-00-350-dev kernel: [   68.128234] _xfs_buf_find: 
blkno=100353 eofs=204800 >m_sb.sb_dblocks=25600
Mar  3 11:17:41 vc-00-00-350-dev kernel: [   68.128638] _xfs_buf_find: 
blkno=100354 eofs=204800 >m_sb.sb_dblocks=25600
Mar  3 11:17:41 vc-00-00-350-dev kernel: [   68.128646] _xfs_buf_find: 
blkno=100354 eofs=204800 >m_sb.sb_dblocks=25600
Mar  3 11:17:41 vc-00-00-350-dev kernel: [   68.129054] _xfs_buf_find: 
blkno=150529 eofs=204800 >m_sb.sb_dblocks=25600
Mar  3 11:17:41 vc-00-00-350-dev kernel: [   68.129062] _xfs_buf_find: 
blkno=150529 eofs=204800 >m_sb.sb_dblocks=25600
Mar  3 11:17:41 vc-00-00-350-dev kernel: [   68.129449] _xfs_buf_find: 
blkno=150530 eofs=204800 >m_sb.sb_dblocks=25600
Mar  3 11:17:41 vc-00-00-350-dev kernel: [   68.129459] _xfs_buf_find: 
blkno=150530 eofs=204800 >m_sb.sb_dblocks=25600
Mar  3 11:17:41 vc-00-00-350-dev kernel: [   68.129739] _xfs_buf_find: 
blkno=200705 eofs=204800 >m_sb.sb_dblocks=25600
Mar  3 11:17:41 vc-00-00-350-dev kernel: [   68.129746] _xfs_buf_find: 
blkno=200705 eofs=204800 >m_sb.sb_dblocks=25600
Mar  3 11:17:41 vc-00-00-350-dev kernel: [   68.130051] _xfs_buf_find: 
blkno=200706 eofs=204800 >m_sb.sb_dblocks=25600
Mar  3 11:17:41 vc-00-00-350-dev kernel: [   68.130061] _xfs_buf_find: 
blkno=200706 eofs=204800 >m_sb.sb_dblocks=25600
Mar  3 11:17:41 vc-00-00-350-dev kernel: [   68.130317] _xfs_buf_find: 
blkno=64 eofs=204800 >m_sb.sb_dblocks=25600
Mar  3 11:17:41 vc-00-00-350-dev kernel: [   68.130324] _xfs_buf_find: 
blkno=64 eofs=204800 >m_sb.sb_dblocks=25600
Mar  3 11:17:41 vc-00-00-350-dev kernel: [   68.130548] _xfs_buf_find: 
blkno=64 eofs=204800 >m_sb.sb_dblocks=25600
Mar  3 11:17:41 vc-00-00-350-dev kernel: [   68.130560] _xfs_buf_find: 
blkno=64 eofs=204800 >m_sb.sb_dblocks=25600
Mar  3 11:17:41 vc-00-00-350-dev kernel: [   68.130571] _xfs_buf_find: 
blkno=2 eofs=204800 >m_sb.sb_dblocks=25600
Mar  3 11:17:41 vc-00-00-350-dev kernel: [   68.130581] _xfs_buf_find: 
blkno=50178 eofs=204800 >m_sb.sb_dblocks=25600
Mar  3 11:17:41 vc-00-00-350-dev kernel: [   68.130591] _xfs_buf_find: 
blkno=100354 eofs=204800 >m_sb.sb_dblocks=25600
Mar  3 11:17:41 vc-00-00-350-dev kernel: [   68.130610] _xfs_buf_find: 
blkno=150530 eofs=204800 >m_sb.sb_dblocks=25600
Mar  3 11:17:41 vc-00-00-350-dev kernel: [   68.130613] _xfs_buf_find: 
blkno=200706 eofs=204800 >m_sb.sb_dblocks=25600
Mar  3 11:17:41 vc-00-00-350-dev kernel: [   68.130618] XFS (dm-0): Ending 
recovery (logdev: internal)

-----Original Message----- 
From: Dave Chinner
Sent: 01 March, 2016 9:20 AM
To: Alex Lyakas
Cc: Christoph Hellwig ; Danny Shavit ; Shyam Kaushik ; Yair Hershko ; 
xfs@oss.sgi.com
Subject: Re: xfs resize: primary superblock is not updated immediately

On Tue, Mar 01, 2016 at 08:16:28AM +1100, Dave Chinner wrote:
> On Mon, Feb 29, 2016 at 11:47:54AM +0200, Alex Lyakas wrote:
> Which means it's through the first phase of log recovery and it's
> not failing in log recovery. i.e. we are now running
> xfs_initialize_perag_data() after log recovery. So, as I said a
> couple of posts back up this thread:
>
> | If log recovery succeeds, then yes, I can see that there is a
> | problem here because the per-ag tree is not reinitialised after
> | the superblock is re-read. That's a pretty easy fix, though (3-4
> | lines of code in xlog_do_recover() to detect a change in
> | filesystem block count and call xfs_initialize_perag() again..

Patch below.

-- 
Dave Chinner
david@fromorbit.com


xfs: reinitialise per-AG structures if geometry changes during recovery

From: Dave Chinner <dchinner@redhat.com>

If a crash occurs immediately after a filesystem grow operation, the
updated superblock geometry is found only in the log. After we
recover the log, the superblock is reread and re-initialised and so
has the new geometry in memory. If the new geometry has more AGs
than prior to the grow operation, then the new AGs will not have
in-memory xfs_perag structurea associated with them.

This will result in an oops when the first metadata buffer from a
new AG is looked up in the buffer cache, as the block lies within
the new geometry but then fails to find a perag structure on lookup.
This is easily fixed by simply re-initialising the perag structure
after re-reading the superblock at the conclusion of the first pahse
of log recovery.

This, however, does not fix the case of log recovery requiring
access to metadata in the newly grown space. Fortunately for us,
because the in-core superblock has not been updated, this will
result in detection of access beyond the end of the filesystem
and so recovery will fail at that point. If this proves to be
a problem, then we can address it separately to the current
reported issue.

Reported-by: Alex Lyakas <alex@zadarastorage.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
fs/xfs/xfs_log_recover.c | 22 +++++++++++++---------
1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 1dc0e14..520471b 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4898,6 +4898,7 @@ xlog_do_recover(
  xfs_daddr_t head_blk,
  xfs_daddr_t tail_blk)
{
+ struct xfs_mount *mp = log->l_mp;
  int error;
  xfs_buf_t *bp;
  xfs_sb_t *sbp;
@@ -4912,7 +4913,7 @@ xlog_do_recover(
  /*
  * If IO errors happened during recovery, bail out.
  */
- if (XFS_FORCED_SHUTDOWN(log->l_mp)) {
+ if (XFS_FORCED_SHUTDOWN(mp)) {
  return -EIO;
  }

@@ -4925,13 +4926,13 @@ xlog_do_recover(
  * or iunlinks they will have some entries in the AIL; so we look at
  * the AIL to determine how to set the tail_lsn.
  */
- xlog_assign_tail_lsn(log->l_mp);
+ xlog_assign_tail_lsn(mp);

  /*
  * Now that we've finished replaying all buffer and inode
  * updates, re-read in the superblock and reverify it.
  */
- bp = xfs_getsb(log->l_mp, 0);
+ bp = xfs_getsb(mp, 0);
  bp->b_flags &= ~(XBF_DONE | XBF_ASYNC);
  ASSERT(!(bp->b_flags & XBF_WRITE));
  bp->b_flags |= XBF_READ;
@@ -4939,7 +4940,7 @@ xlog_do_recover(

  error = xfs_buf_submit_wait(bp);
  if (error) {
- if (!XFS_FORCED_SHUTDOWN(log->l_mp)) {
+ if (!XFS_FORCED_SHUTDOWN(mp)) {
  xfs_buf_ioerror_alert(bp, __func__);
  ASSERT(0);
  }
@@ -4948,14 +4949,17 @@ xlog_do_recover(
  }

  /* Convert superblock from on-disk format */
- sbp = &log->l_mp->m_sb;
+ sbp = &mp->m_sb;
  xfs_sb_from_disk(sbp, XFS_BUF_TO_SBP(bp));
- ASSERT(sbp->sb_magicnum == XFS_SB_MAGIC);
- ASSERT(xfs_sb_good_version(sbp));
- xfs_reinit_percpu_counters(log->l_mp);
-
  xfs_buf_relse(bp);

+ /* re-initialise in-core superblock and geometry structures */
+ xfs_reinit_percpu_counters(mp);
+ error = xfs_initialize_perag(mp, sbp->sb_agcount, &mp->m_maxagi);
+ if (error) {
+ xfs_warn(mp, "Failed post-recovery per-ag init: %d", error);
+ return error;
+ }

  xlog_recover_check_summary(log);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
