Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D62C97F54
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 04:26:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C0ED2304039
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 02:26:53 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id 0YHCaCFcx4YFJzzj (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Aug 2015 02:26:51 -0700 (PDT)
From: Jan Kara <jack@suse.com>
Subject: [PATCH] xfs: Fix xfs_attr_leafblock definition
Date: Thu, 13 Aug 2015 11:26:40 +0200
Message-Id: <1439458000-28395-1-git-send-email-jack@suse.com>
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
may optimize away all accesses beyond the end of array resulting in
non-working code. This problem was only observed with userspace code in
xfsprogs, however it's better to be safe in kernel as well and have
matching kernel and xfsprogs definitions.

Signed-off-by: Jan Kara <jack@suse.com>
---
 fs/xfs/libxfs/xfs_da_format.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

 This is a kernel version of the xfsprogs patch I've sent a while ago.

diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 74bcbabfa523..b14bbd6bb05f 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -680,8 +680,15 @@ typedef struct xfs_attr_leaf_name_remote {
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
