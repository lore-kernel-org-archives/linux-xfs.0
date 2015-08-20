Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 279F07CBE
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2015 14:52:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 16AE28F8059
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2015 12:52:17 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id fu89d3VMrRsiw9L1 for <xfs@oss.sgi.com>;
	Thu, 20 Aug 2015 12:52:16 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 036A3661D58C
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2015 14:52:15 -0500 (CDT)
Message-ID: <55D62FEF.3020404@sandeen.net>
Date: Thu, 20 Aug 2015 14:52:15 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: remove self-assignment in libxfs/util.c
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

We don't have percpu counters in userspace, so libxfs plays
tricks.  Rather than calling percpu_counter_set() in
xfs_reinit_percpu_counters, we just directly assign
the values in mp->m_sb to the counters in mp.

But this was already handled by #defining the percpu counters
in the mount structure to those in the superblock, i.e.:

#define m_icount        m_sb.sb_icount
#define m_ifree         m_sb.sb_ifree
#define m_fdblocks      m_sb.sb_fdblocks

so we actually end up with pointless self-assignment.

Define away the xfs_reinit_percpu_counters() function,
because it's a no-op.

Addresses-Coverity-Id: 1298009
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 1b01764..105290e 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -494,7 +494,8 @@ struct xfs_buf *xfs_trans_buf_item_match(struct xfs_trans *,
 #define xfs_mod_frextents(mp, delta) \
 	libxfs_mod_incore_sb(mp, XFS_TRANS_SB_FREXTENTS, delta, 0)
 int  libxfs_mod_incore_sb(struct xfs_mount *, int, int64_t, int);
-void xfs_reinit_percpu_counters(struct xfs_mount *mp);
+/* percpu counters in mp are #defined to the superblock sb_ counters */
+#define xfs_reinit_percpu_counters(mp)
 
 void xfs_trans_mod_sb(struct xfs_trans *, uint, long);
 void xfs_trans_init(struct xfs_mount *);
diff --git a/libxfs/util.c b/libxfs/util.c
index 8272609..c9f9175 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -729,12 +729,3 @@ xfs_verifier_error(
 		  bp->b_error == -EFSBADCRC ? "CRC error" : "corruption",
 		  bp->b_bn, BBTOB(bp->b_length));
 }
-
-void
-xfs_reinit_percpu_counters(
-	struct xfs_mount	*mp)
-{
-	mp->m_icount = mp->m_sb.sb_icount;
-	mp->m_ifree = mp->m_sb.sb_ifree;
-	mp->m_fdblocks = mp->m_sb.sb_fdblocks;
-}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
