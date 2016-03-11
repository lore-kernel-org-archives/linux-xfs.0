Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5A5F87CA1
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 16:12:40 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2021C8F8033
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 14:12:39 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id vV31cr6gnZLcDGD5 for <xfs@oss.sgi.com>;
	Fri, 11 Mar 2016 14:12:38 -0800 (PST)
Received: from Liberator.local (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 6D8042AD4
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 16:12:25 -0600 (CST)
Subject: [PATCH 4/4] xfs: collapse cases in xfs_attr3_leaf_list_int
References: <56E3425E.40509@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56E342D5.7000900@sandeen.net>
Date: Fri, 11 Mar 2016 16:12:37 -0600
MIME-Version: 1.0
In-Reply-To: <56E3425E.40509@redhat.com>
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

Consolidate the 2 calls to ->put_listent in
xfs_attr3_leaf_list_int(), by setting up name, namelen, and
valuelen for the local vs remote cases, then call ->put_listent
and do the error handling all in one spot.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_attr_list.c |   42 ++++++++++++++++++++----------------------
 1 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 900164c..007be5c 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -410,6 +410,9 @@ xfs_attr3_leaf_list_int(
 	 */
 	retval = 0;
 	for (; i < ichdr.count; entry++, i++) {
+		char *name;
+		int namelen, valuelen;
+
 		if (be32_to_cpu(entry->hashval) != cursor->hashval) {
 			cursor->hashval = be32_to_cpu(entry->hashval);
 			cursor->offset = 0;
@@ -419,30 +422,25 @@ xfs_attr3_leaf_list_int(
 			continue;		/* skip incomplete entries */
 
 		if (entry->flags & XFS_ATTR_LOCAL) {
-			xfs_attr_leaf_name_local_t *name_loc =
-				xfs_attr3_leaf_name_local(leaf, i);
-
-			retval = context->put_listent(context,
-						entry->flags,
-						name_loc->nameval,
-						(int)name_loc->namelen,
-						be16_to_cpu(name_loc->valuelen));
-			if (retval)
-				return retval;
+			xfs_attr_leaf_name_local_t *name_loc;
+
+			name_loc = xfs_attr3_leaf_name_local(leaf, i);
+			name = name_loc->nameval;
+			namelen = name_loc->namelen;
+			valuelen = be16_to_cpu(name_loc->valuelen);
 		} else {
-			xfs_attr_leaf_name_remote_t *name_rmt =
-				xfs_attr3_leaf_name_remote(leaf, i);
-
-			int valuelen = be32_to_cpu(name_rmt->valuelen);
-
-			retval = context->put_listent(context,
-						entry->flags,
-						name_rmt->name,
-						(int)name_rmt->namelen,
-						valuelen);
-			if (retval)
-				return retval;
+			xfs_attr_leaf_name_remote_t *name_rmt;
+
+			name_rmt = xfs_attr3_leaf_name_remote(leaf, i);
+			name = name_rmt->name;
+			namelen = name_rmt->namelen;
+			valuelen = be32_to_cpu(name_rmt->valuelen);
 		}
+
+		retval = context->put_listent(context, entry->flags,
+					      name, namelen, valuelen);
+		if (retval)
+			return retval;
 		if (context->seen_enough)
 			break;
 		cursor->offset++;
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
