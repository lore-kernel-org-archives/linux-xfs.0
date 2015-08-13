Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F29747F51
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 04:11:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D211A304032
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 02:11:50 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id Lcdbhry9kWOL9SMu (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Aug 2015 02:11:49 -0700 (PDT)
From: Jan Kara <jack@suse.com>
Subject: [PATCH] xfsprogs: Fix attr leaf block definition
Date: Thu, 13 Aug 2015 11:11:40 +0200
Message-Id: <1439457100-19977-1-git-send-email-jack@suse.com>
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
4.8.3) thinks that the array has the fixed size of 1 element and thus
optimizes away all accesses beyond the end of array resulting in
non-working code. In particular this problem was seen with
xfsprogs-3.1.8.

Signed-off-by: Jan Kara <jack@suse.com>
---
 include/xfs_da_format.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/xfs_da_format.h b/include/xfs_da_format.h
index 11f142078e12..f5e1d9df6a5c 100644
--- a/include/xfs_da_format.h
+++ b/include/xfs_da_format.h
@@ -1180,8 +1180,15 @@ typedef struct xfs_attr_leaf_name_remote {
 typedef struct xfs_attr_leafblock {
 	xfs_attr_leaf_hdr_t	hdr;	/* constant-structure header block */
 	xfs_attr_leaf_entry_t	entries[1];	/* sorted on key, not name */
-	xfs_attr_leaf_name_local_t namelist;	/* grows from bottom of buf */
-	xfs_attr_leaf_name_remote_t valuelist;	/* grows from bottom of buf */
+	/*
+	 * The rest of the block contains the following structures after the
+	 * leaf entries, growing from the bottom up. The variables are never
+	 * referenced and definining them can actually make gcc optimize away
+	 * accesses to the 'entries' array above index 0 so don't do that.
+	 *
+	 * xfs_attr_leaf_name_local_t namelist;
+	 * xfs_attr_leaf_name_remote_t valuelist;
+	 */
 } xfs_attr_leafblock_t;
 
 /*
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
