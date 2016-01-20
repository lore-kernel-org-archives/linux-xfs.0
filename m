Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 690067F37
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2016 17:43:54 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 586DB304053
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2016 15:43:51 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id khx3RyFeXMILjcfm (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Jan 2016 15:43:50 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 932918F877
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2016 23:43:49 +0000 (UTC)
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u0KNhmAm019831
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2016 18:43:49 -0500
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: don't overflow quota ID when initializing dqblk
Message-ID: <56A01BB4.1050409@redhat.com>
Date: Wed, 20 Jan 2016 17:43:48 -0600
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
To: xfs@oss.sgi.com

Quota IDs are unsigned, and so we can pass in values up
to 2^32-1.  But if we try to initialize a block containing
values over MAX_INT, curid will overflow and assert.

curid holds a quota ID, so give it the proper
xfs_dqid_t type (and remove the now-impossible ASSERT).

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 83ce4aa..5d92bb5 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -232,7 +232,8 @@ xfs_qm_init_dquot_blk(
 {
 	struct xfs_quotainfo	*q = mp->m_quotainfo;
 	xfs_dqblk_t	*d;
-	int		curid, i;
+	xfs_dqid_t	curid;
+	int		i;
 
 	ASSERT(tp);
 	ASSERT(xfs_buf_islocked(bp));
@@ -243,7 +244,6 @@ xfs_qm_init_dquot_blk(
 	 * ID of the first dquot in the block - id's are zero based.
 	 */
 	curid = id - (id % q->qi_dqperchunk);
-	ASSERT(curid >= 0);
 	memset(d, 0, BBTOB(q->qi_dqchunklen));
 	for (i = 0; i < q->qi_dqperchunk; i++, d++, curid++) {
 		d->dd_diskdq.d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
