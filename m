Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D70657F7D
	for <xfs@oss.sgi.com>; Wed, 28 Jan 2015 16:16:43 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C648C8F8059
	for <xfs@oss.sgi.com>; Wed, 28 Jan 2015 14:16:40 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FdTZvyXKigRTJLRV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 28 Jan 2015 14:16:36 -0800 (PST)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t0SMGZ0N000510
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Wed, 28 Jan 2015 17:16:35 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t0SMGXNX025457
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 28 Jan 2015 17:16:35 -0500
Message-ID: <54C95FC1.3050808@redhat.com>
Date: Wed, 28 Jan 2015 16:16:33 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: report proper f_files in statfs if we overshoot imaxpct
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

Normally, a statfs syscall reports m_maxicount as f_files
(total file nodes in file system) because it is supposed
to be the upper limit for dynamically-allocated inodes.

It's possible, however, to overshoot imaxpct / m_maxicount.
If this happens, we should report the actual number of allocated
inodes, which is contained in sb_icount.  Add one more adjustment
to the statfs code to make this happen.

Reported-by: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---


diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 19cbda1..9c1d479 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1111,6 +1111,11 @@ xfs_fs_statfs(
 					statp->f_files,
 					mp->m_maxicount);
 
+	/* If sb_icount overshot maxicount, report actual allocation */
+	statp->f_files = max_t(typeof(statp->f_files),
+					statp->f_files,
+					sbp->sb_icount);
+
 	/* make sure statp->f_ffree does not underflow */
 	ffree = statp->f_files - (sbp->sb_icount - sbp->sb_ifree);
 	statp->f_ffree = max_t(__int64_t, ffree, 0);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
