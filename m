Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A089629DF8
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2014 11:35:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3C959AC004
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2014 09:35:20 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8En0eWNv6vdkaFyF for
	<xfs@oss.sgi.com>; Mon, 28 Apr 2014 09:35:18 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s3SGZIGs018738
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2014 12:35:18 -0400
Message-ID: <535E8344.2070209@redhat.com>
Date: Mon, 28 Apr 2014 11:35:16 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: test for shut down fs in xfs_dir_fsync()
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
To: xfs-oss <xfs@oss.sgi.com>
Cc: Boris Ranto <branto@redhat.com>

Similar to xfs_file_fsync(), I think xfs_dir_fsync() needs
to test for a shut down fs, lest we go down paths we'll
never be able to complete; Boris reported that during some
stress tests he had threads stuck in xlog_cil_force_lsn
via xfs_dir_fsync().

[ 3663.361709] sfsuspend-par   D ffff88042f0b4540     0  3981   3947 0x00000080

[ 3663.394472] Call Trace:
[ 3663.397199]  [<ffffffff815f1889>] schedule+0x29/0x70
[ 3663.402743]  [<ffffffffa01feda5>] xlog_cil_force_lsn+0x185/0x1a0 [xfs]
[ 3663.416249]  [<ffffffffa01fd3af>] _xfs_log_force_lsn+0x6f/0x2f0 [xfs]
[ 3663.429271]  [<ffffffffa01a339d>] xfs_dir_fsync+0x7d/0xe0 [xfs]
[ 3663.435873]  [<ffffffff811df8c5>] do_fsync+0x65/0xa0
[ 3663.441408]  [<ffffffff811dfbc0>] SyS_fsync+0x10/0x20
[ 3663.447043]  [<ffffffff815fc7d9>] system_call_fastpath+0x16/0x1b

Reported-by: Boris Ranto <branto@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

NB: While I've not asked Boris to test this yet, it seems
clear (?) that dir_fsync should behave the same as
file_fsync() in the face of a shut-down fs.

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 4c749ab..2b94362 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -146,6 +146,9 @@ xfs_dir_fsync(
 
 	trace_xfs_dir_fsync(ip);
 
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -XFS_ERROR(EIO);
+
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	if (xfs_ipincount(ip))
 		lsn = ip->i_itemp->ili_last_lsn;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
