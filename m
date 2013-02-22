Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1CB077F58
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2013 02:13:10 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D47BF8F8037
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2013 00:13:06 -0800 (PST)
Received: from USMAMAIL.TILERA.COM (usmamail.tilera.com [12.216.194.151]) by
	cuda.sgi.com with ESMTP id 5RiQxHFr2UmcQnfB (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 22 Feb 2013 00:13:05 -0800 (PST)
From: Tony Lu <zlu@tilera.com>
Subject: [PATCH] xfs: Fix possible truncation of log data in
	xlog_bread_noalign()
Date: Fri, 22 Feb 2013 08:12:52 +0000
Message-ID: <BAB94DBB0E89D8409949BC28AC95914C47C485E5@USMAExch1.tad.internal.tilera.com>
Content-Language: zh-CN
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, Dave Chinner <dchinner@redhat.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Chris Metcalf <cmetcalf@tilera.com>, Tony Lu <zlu@tilera.com>

I encountered the following panic when using xfs partitions as rootfs, which
is due to the truncated log data read by xlog_bread_noalign(). We should
extend the buffer by one extra log sector to ensure there's enough space to
accommodate requested log data, which we indeed did in xlog_get_bp(), but we
forgot to do in xlog_bread_noalign().

XFS mounting filesystem sda2
Starting XFS recovery on filesystem: sda2 (logdev: internal)
XFS: xlog_recover_process_data: bad clientid
XFS: log mount/recovery failed: error 5
XFS: log mount failedVFS: Cannot open root device "sda2" or unknown-block(8,)
Please append a correct "root=" boot option; here are the available partitio:
0800       156290904 sda  driver: sd
  0801        31463271 sda1 00000000-0000-0000-0000-000000000000
  0802        31463302 sda2 00000000-0000-0000-0000-000000000000
  0803        31463302 sda3 00000000-0000-0000-0000-000000000000
  0804               1 sda4 00000000-0000-0000-0000-000000000000
  0805        10490413 sda5 00000000-0000-0000-0000-000000000000
  0806        51407968 sda6 00000000-0000-0000-0000-000000000000
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(8,)

Starting stack dump of tid 1, pid 1 (swapper) on cpu 35 at cycle 42273138234
  frame 0: 0xfffffff70016e5a0 dump_stack+0x0/0x20 (sp 0xfffffe03fbedfe88)
  frame 1: 0xfffffff7004af470 panic+0x150/0x3a0 (sp 0xfffffe03fbedfe88)
  frame 2: 0xfffffff700881e88 mount_block_root+0x2c0/0x4c8 (sp 0xfffffe03fbe)
  frame 3: 0xfffffff700882390 prepare_namespace+0x250/0x358 (sp 0xfffffe03fb)
  frame 4: 0xfffffff700880778 kernel_init+0x4c8/0x520 (sp 0xfffffe03fbedffb0)
  frame 5: 0xfffffff70011ecb8 start_kernel_thread+0x18/0x20 (sp 0xfffffe03fb)
Stack dump complete

Signed-off-by: Zhigang Lu <zlu@tilera.com>
Reviewed-by: Chris Metcalf <cmetcalf@tilera.com>
---
 fs/xfs/xfs_log_recover.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 96fcbb8..64264a5 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -179,6 +179,21 @@ xlog_bread_noalign(
                return EFSCORRUPTED;
        }
 
+       /*
+        * The blk_no may be a non-sector-aligned block offset, in
+        * which case we round down the blk_no to be aligned with
+        * the sector size, and if the nbblks is sector-aligned,
+        * an I/O of the size nbblks could truncate the requested
+        * log data.  If the requested size is only 1 basic block it
+        * will never straddle a sector boundary, so this won't be
+        * an issue.  Nor will this be a problem if the log I/O is
+        * done in basic blocks (sector size 1).  But otherwise we
+        * extend the buffer by one extra log sector to ensure
+        * there's space to accommodate this possibility.
+        */
+       if (nbblks > 1 && log->l_sectBBsize > 1)
+               nbblks += log->l_sectBBsize;
+
        blk_no = round_down(blk_no, log->l_sectBBsize);
        nbblks = round_up(nbblks, log->l_sectBBsize);
 
-- 
1.7.10.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
