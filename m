Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 675A37CA1
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 16:11:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CD26DAC003
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 14:11:48 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id hGZGaV91HklbGImG for <xfs@oss.sgi.com>;
	Fri, 11 Mar 2016 14:11:43 -0800 (PST)
Received: from Liberator.local (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 9BFF62AD4
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 16:11:30 -0600 (CST)
Subject: [PATCH 2/4] xfs: don't pass value into attr ->put_listent
References: <56E3425E.40509@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56E3429E.4030003@sandeen.net>
Date: Fri, 11 Mar 2016 16:11:42 -0600
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

The value is not used; only names and value lengths are
returned.  Remove the argument.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_attr.h      |    2 +-
 fs/xfs/xfs_attr_list.c |   18 ++++++------------
 fs/xfs/xfs_xattr.c     |    3 +--
 3 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_attr.h b/fs/xfs/xfs_attr.h
index 2343312..dab4f41 100644
--- a/fs/xfs/xfs_attr.h
+++ b/fs/xfs/xfs_attr.h
@@ -114,7 +114,7 @@ typedef struct attrlist_cursor_kern {
 
 /* Return 0 on success, or -errno; other state communicated via *context */
 typedef int (*put_listent_func_t)(struct xfs_attr_list_context *, int,
-			      unsigned char *, int, int, unsigned char *);
+			      unsigned char *, int, int);
 
 typedef struct xfs_attr_list_context {
 	struct xfs_inode		*dp;		/* inode */
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index d5ab59f..1d36d78 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -106,8 +106,7 @@ xfs_attr_shortform_list(xfs_attr_list_context_t *context)
 					   sfe->flags,
 					   sfe->nameval,
 					   (int)sfe->namelen,
-					   (int)sfe->valuelen,
-					   &sfe->nameval[sfe->namelen]);
+					   (int)sfe->valuelen);
 			if (error)
 				return error;
 			/*
@@ -198,8 +197,7 @@ xfs_attr_shortform_list(xfs_attr_list_context_t *context)
 					sbp->flags,
 					sbp->name,
 					sbp->namelen,
-					sbp->valuelen,
-					&sbp->name[sbp->namelen]);
+					sbp->valuelen);
 		if (error)
 			return error;
 		if (context->seen_enough)
@@ -428,8 +426,7 @@ xfs_attr3_leaf_list_int(
 						entry->flags,
 						name_loc->nameval,
 						(int)name_loc->namelen,
-						be16_to_cpu(name_loc->valuelen),
-						&name_loc->nameval[name_loc->namelen]);
+						be16_to_cpu(name_loc->valuelen));
 			if (retval)
 				return retval;
 		} else {
@@ -458,16 +455,14 @@ xfs_attr3_leaf_list_int(
 						entry->flags,
 						name_rmt->name,
 						(int)name_rmt->namelen,
-						valuelen,
-						args.value);
+						valuelen);
 				kmem_free(args.value);
 			} else {
 				retval = context->put_listent(context,
 						entry->flags,
 						name_rmt->name,
 						(int)name_rmt->namelen,
-						valuelen,
-						NULL);
+						valuelen);
 			}
 			if (retval)
 				return retval;
@@ -548,8 +543,7 @@ xfs_attr_put_listent(
 	int		flags,
 	unsigned char	*name,
 	int		namelen,
-	int		valuelen,
-	unsigned char	*value)
+	int		valuelen)
 {
 	struct attrlist *alist = (struct attrlist *)context->alist;
 	attrlist_ent_t *aep;
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index f220129..7fdcf33 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -166,8 +166,7 @@ xfs_xattr_put_listent(
 	int		flags,
 	unsigned char	*name,
 	int		namelen,
-	int		valuelen,
-	unsigned char	*value)
+	int		valuelen)
 {
 	char *prefix;
 	int prefix_len;
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
