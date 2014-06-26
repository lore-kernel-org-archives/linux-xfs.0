Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 37C047F62
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 21:23:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B5360AC001
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 19:23:54 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	9dIL71DwivtjzOfn for <xfs@oss.sgi.com>;
	Wed, 25 Jun 2014 19:23:49 -0700 (PDT)
Date: Thu, 26 Jun 2014 12:23:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Metadata CRC error upon unclean unmount
Message-ID: <20140626022334.GR9508@dastard>
References: <CA+o=1OW0OXhzU+b9ACMZzg0dq=B7BSj+yPXD2Vrr9F6mWK8ruQ@mail.gmail.com>
	<20140624201946.GJ9508@dastard>
	<CA+o=1OVnORG0Ah3Zx8dkGzs7vtT7odRH=v12KqtLW0MP_3oHjQ@mail.gmail.com>
	<20140625012144.GK9508@dastard> <20140626002859.GQ9508@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140626002859.GQ9508@dastard>
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
To: Fanael Linithien <fanael4@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Jun 26, 2014 at 10:28:59AM +1000, Dave Chinner wrote:
> On Wed, Jun 25, 2014 at 11:21:44AM +1000, Dave Chinner wrote:
> > On Tue, Jun 24, 2014 at 11:50:52PM +0200, Fanael Linithien wrote:
> > Ok, so the CRC corresponds to the version of the AGI that was logged
> > at lsn = 0x30000017e. That means the version on disk is a partial
> > update without a CRC recalculation. Ok, so how can that happen?
> > 
> > Given the lsn mismatch, I suspect log recovery has played a part as
> > it will not update the LSN when replaying changes in the log. It
> > should, however, always be attaching the appropriate verifier to
> > the buffers being recovered so the CRC should be recalculated
> > correctly.
> 
> Ok, I have confirmed that this is occurring and behaving correctly.
> 
> [   24.437878] XFS (vdb): Mounting V5 Filesystem
> [   24.554429] XFS (vdb): Starting recovery (logdev: internal)
> [   24.623466] XFS (vdb): xfs_agi_write_verify: lsn reset block 0x2
> [   24.625263] XFS (vdb): xfs_btree_sblock_calc_crc: lsn reset block 0x8
> [   24.627307] XFS (vdb): xfs_btree_sblock_calc_crc: lsn reset block 0x10
> [   24.628729] XFS (vdb): xfs_btree_sblock_calc_crc: lsn reset block 0x18
> [   24.630085] XFS (vdb): xfs_dir3_data_write_verify: lsn reset block 0x20000
> [   24.631504] XFS (vdb): xfs_da3_node_write_verify: lsn reset block 0x20008
> [   24.632935] XFS (vdb): xfs_dir3_data_write_verify: lsn reset block 0x20010
> [   24.634360] XFS (vdb): xfs_dir3_data_write_verify: lsn reset block 0x20018
> [   24.635622] XFS (vdb): xfs_dir3_free_write_verify: lsn reset block 0x201e0
> [   24.636656] XFS (vdb): __write_verify: lsn reset block 0x201e8
> [   24.637510] XFS (vdb): __write_verify: lsn reset block 0x201f0
> [   24.638365] XFS (vdb): xfs_dir3_data_write_verify: lsn reset block 0x201f8
> [   24.639378] XFS (vdb): xfs_dir3_data_write_verify: lsn reset block 0x202c0
> [   24.640397] XFS (vdb): __write_verify: lsn reset block 0x202c8
> [   24.641260] XFS (vdb): xfs_dir3_data_write_verify: lsn reset block 0x202d0
> [   24.664330] XFS (vdb): Ending recovery (logdev: internal)
> 
> But that also confirms that log recovery is recalculating the CRC
> after replaying changes into that block:
> 
> # xfs_db -c "agi 0" -c "p lsn" -c "p crc" /dev/vdb
> lsn = 0xffffffffffffffff
> crc = 0x788c4f63 (correct)
> 
> So the common log recovery path for buffers is working as it is
> designed to do.
> 
> What I still don't understand yet is how changes after this recovery
> phase are getting to disk without updating the CRC. That implies
> buffers without verifiers being written....
> 
> More debug to come...

Can you apply this patch and run your tests? If should spew warnings
to dmesg if a metadata buffer is ever written without an ops
structure attached to it (i.e. won't have CRCs recalculated).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: spew warnings on cached buffers without b_ops callbacks.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c | 6 ++++++
 fs/xfs/xfs_log.c | 7 ++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index a6dc83e..95e5516 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1330,6 +1330,12 @@ _xfs_buf_ioapply(
 						   SHUTDOWN_CORRUPT_INCORE);
 				return;
 			}
+		} else if (bp->b_bn != -1LL) {
+			xfs_warn(bp->b_target->bt_mount,
+				"%s: no ops on block 0x%llx/0x%llx",
+				__func__, bp->b_bn, bp->b_maps[0].bm_bn);
+			xfs_hex_dump(bp->b_addr, 64);
+			dump_stack();
 		}
 	} else if (bp->b_flags & XBF_READ_AHEAD) {
 		rw = READA;
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 7647818..ecf2048 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1369,8 +1369,13 @@ xlog_alloc_log(
 
 	xlog_get_iclog_buffer_size(mp, log);
 
+	/*
+	 * Use a block number of -1 for the extra log buffer used during splits
+	 * so that it will trigger errors if we ever try to do IO on it without
+	 * first having set it up properly.
+	 */
 	error = -ENOMEM;
-	bp = xfs_buf_alloc(mp->m_logdev_targp, 0, BTOBB(log->l_iclog_size), 0);
+	bp = xfs_buf_alloc(mp->m_logdev_targp, -1LL, BTOBB(log->l_iclog_size), 0);
 	if (!bp)
 		goto out_free_log;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
