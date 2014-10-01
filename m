Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2A87E7F73
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 11:16:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0B0188F8035
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 09:16:38 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CebfAFHMUFr39hHr (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Oct 2014 09:16:38 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s91GGbgP014071
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Wed, 1 Oct 2014 12:16:37 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s91GGaAY024427
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 1 Oct 2014 12:16:37 -0400
Message-ID: <542C28E5.506@redhat.com>
Date: Wed, 01 Oct 2014 11:16:37 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: check for null dquot in xfs_quota_calc_throttle()
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

Coverity spotted this.

Granted, we *just* checked xfs_inod_dquot() in the caller (by calling
xfs_quota_need_throttle), but to be honest I don't know if this can
race, and this is the only place we don't check the return value -
and the check seems cheap and future-proof.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Sorry for the handwavy commit log, if it's obvious that it can
race, feel free to fix the description. ;)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index e9c47b6..afcf3c9 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -404,8 +404,8 @@ xfs_quota_calc_throttle(
 	int shift = 0;
 	struct xfs_dquot *dq = xfs_inode_dquot(ip, type);
 
-	/* over hi wmark, squash the prealloc completely */
-	if (dq->q_res_bcount >= dq->q_prealloc_hi_wmark) {
+	/* no dq, or over hi wmark, squash the prealloc completely */
+	if (!dq || dq->q_res_bcount >= dq->q_prealloc_hi_wmark) {
 		*qblocks = 0;
 		*qfreesp = 0;
 		return;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
