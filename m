Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3CBBA7F37
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 09:53:01 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1DB318F804B
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 07:52:58 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 7DiGfEVrGI5J9RrV (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 04 Jan 2016 07:52:57 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 9B641C1090AE
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 15:52:56 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-121.bos.redhat.com [10.18.41.121])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u04Fquca019228
	for <xfs@oss.sgi.com>; Mon, 4 Jan 2016 10:52:56 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: fix kbuild regression due to log recovery crc
	verification
Date: Mon,  4 Jan 2016 10:52:55 -0500
Message-Id: <1451922775-15502-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The auto kbuild infrastructure reports several failures on
non-standard arches (i386, sh, arm) due to a regression in the
recent log recovery crc verification (short write detection)
patches:

   fs/built-in.o: In function `xlog_find_tail':
>> xfs_log_recover.c:(.text+0x1c5db5): undefined reference to `__moddi3'
   xfs_log_recover.c:(.text+0x1c5e9d): undefined reference to `__moddi3'

This is due to the introduction of 64-bit modulus operations that
were 32-bit operations prior to the change. xlog_find_tail() used an
int to store the record header start block for the head of the log.
This was converted to an xfs_daddr_t as this is how the value is
represented in the callee functions that handle record
detection/verification, etc.

This was included as a minor cleanup as there wasn't an obvious
reason for using an int for this value in xlog_find_tail(). The
previously implicit cast was likely safe as this value represents a
log relative block number and the log can only be so big (2G). That
said, since all of the surrounding functionality uses xfs_daddr_t,
including the log buffer I/O helpers, update these calculations to
use do_mod() and handle the 64-bit modulus correctly regardless of
architecture.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Compile tested with ARCH=i386 and spot tested with xfstests on x86-64.

Brian

 fs/xfs/xfs_log_recover.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 5bf8076..26e67b4 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1330,12 +1330,13 @@ xlog_find_tail(
 	} else {
 		hblks = 1;
 	}
-	after_umount_blk = (rhead_blk + hblks + (int)
-		BTOBB(be32_to_cpu(rhead->h_len))) % log->l_logBBsize;
+	after_umount_blk = rhead_blk + hblks + BTOBB(be32_to_cpu(rhead->h_len));
+	after_umount_blk = do_mod(after_umount_blk, log->l_logBBsize);
 	tail_lsn = atomic64_read(&log->l_tail_lsn);
 	if (*head_blk == after_umount_blk &&
 	    be32_to_cpu(rhead->h_num_logops) == 1) {
-		umount_data_blk = (rhead_blk + hblks) % log->l_logBBsize;
+		umount_data_blk = rhead_blk + hblks;
+		umount_data_blk = do_mod(umount_data_blk, log->l_logBBsize);
 		error = xlog_bread(log, umount_data_blk, 1, bp, &offset);
 		if (error)
 			goto done;
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
