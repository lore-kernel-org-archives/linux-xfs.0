Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E68E97F50
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2015 08:53:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BF760304043
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2015 06:53:26 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id AbOoCpqMq2DhfTYh (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 12 Aug 2015 06:53:24 -0700 (PDT)
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id B2D14ABC6
	for <xfs@oss.sgi.com>; Wed, 12 Aug 2015 13:53:22 +0000 (UTC)
From: Jan Kara <jack@suse.com>
Subject: [PATCH] xfsprogs: Fix attr leaf block definition
Date: Wed, 12 Aug 2015 15:53:14 +0200
Message-Id: <1439387594-8747-1-git-send-email-jack@suse.com>
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
Cc: Jan Kara <jack@suse.com>

struct xfs_attr_leafblock contains 'entries' array which is declared
with size 1 altough it can in fact contain much more entries. Since this
array is followed by further struct members, gcc (at least in version
4.8.3) thinks that the delared size of the array is the real one and
thus optimizes away all accesses beyond the end of array resulting in
non-working code.

Signed-off-by: Jan Kara <jack@suse.com>
---
 include/xfs_da_format.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/xfs_da_format.h b/include/xfs_da_format.h
index 11f142078e12..39bfeb042844 100644
--- a/include/xfs_da_format.h
+++ b/include/xfs_da_format.h
@@ -1180,8 +1180,14 @@ typedef struct xfs_attr_leaf_name_remote {
 typedef struct xfs_attr_leafblock {
 	xfs_attr_leaf_hdr_t	hdr;	/* constant-structure header block */
 	xfs_attr_leaf_entry_t	entries[1];	/* sorted on key, not name */
+	/*
+	 * Definitions below are commented out so that gcc doesn't optimize
+	 * away accesses into 'entries' for indexes larger than 1
+	 */
+#if 0
 	xfs_attr_leaf_name_local_t namelist;	/* grows from bottom of buf */
 	xfs_attr_leaf_name_remote_t valuelist;	/* grows from bottom of buf */
+#endif
 } xfs_attr_leafblock_t;
 
 /*
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
