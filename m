Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 53CDC29DFF
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 15:45:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1B02A8F804B
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 13:45:10 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id dlCREt1feFmMFWrq for
	<xfs@oss.sgi.com>; Mon, 21 Apr 2014 13:45:10 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s3LKj9Tw009257
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 16:45:09 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s3LKj7J1007987
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 16:45:08 -0400
Message-ID: <53558354.5040309@redhat.com>
Date: Mon, 21 Apr 2014 15:45:08 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: bulletfproof xfs_qm_scall_trunc_qfiles()
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

Coverity noticed that if we sent junk into
xfs_qm_scall_trunc_qfiles(), we could get back an
uninitialized error value.  So sanitize the flags we
will accept, and initialize error anyway for good measure.

(This bug may have been introduced via c61a9e39).

Should resolve Coverity CID 1163872.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 3daf5ea..17ec2c2 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -278,9 +279,10 @@ xfs_qm_scall_trunc_qfiles(
 	xfs_mount_t	*mp,
 	uint		flags)
 {
-	int		error;
+	int		error = EINVAL;
 
-	if (!xfs_sb_version_hasquota(&mp->m_sb) || flags == 0) {
+	if (!xfs_sb_version_hasquota(&mp->m_sb) || flags == 0 ||
+	    (flags & ~XFS_DQ_ALLTYPES)) {
 		xfs_debug(mp, "%s: flags=%x m_qflags=%x",
 			__func__, flags, mp->m_qflags);
 		return XFS_ERROR(EINVAL);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
