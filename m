Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9A02A7CA1
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 16:12:16 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 282A3AC002
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 14:12:15 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 11WUFZBHxWndxQOZ for <xfs@oss.sgi.com>;
	Fri, 11 Mar 2016 14:12:14 -0800 (PST)
Received: from Liberator.local (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 838562AD4
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2016 16:12:01 -0600 (CST)
Subject: [PATCH 3/4] xfs: remove put_value from attr ->put_listent context
References: <56E3425E.40509@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56E342BD.2030103@sandeen.net>
Date: Fri, 11 Mar 2016 16:12:13 -0600
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

The put_value context member is never set; remove it
and the conditional test in xfs_attr3_leaf_list_int().

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_attr.h      |    1 -
 fs/xfs/xfs_attr_list.c |   26 +-------------------------
 2 files changed, 1 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_attr.h b/fs/xfs/xfs_attr.h
index dab4f41..e3da5d4 100644
--- a/fs/xfs/xfs_attr.h
+++ b/fs/xfs/xfs_attr.h
@@ -127,7 +127,6 @@ typedef struct xfs_attr_list_context {
 	int				firstu;		/* first used byte in buffer */
 	int				flags;		/* from VOP call */
 	int				resynch;	/* T/F: resynch with cursor */
-	int				put_value;	/* T/F: need value for listent */
 	put_listent_func_t		put_listent;	/* list output fmt function */
 	int				index;		/* index into output buffer */
 } xfs_attr_list_context_t;
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 1d36d78..900164c 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -435,35 +435,11 @@ xfs_attr3_leaf_list_int(
 
 			int valuelen = be32_to_cpu(name_rmt->valuelen);
 
-			if (context->put_value) {
-				xfs_da_args_t args;
-
-				memset((char *)&args, 0, sizeof(args));
-				args.geo = context->dp->i_mount->m_attr_geo;
-				args.dp = context->dp;
-				args.whichfork = XFS_ATTR_FORK;
-				args.valuelen = valuelen;
-				args.rmtvaluelen = valuelen;
-				args.value = kmem_alloc(valuelen, KM_SLEEP | KM_NOFS);
-				args.rmtblkno = be32_to_cpu(name_rmt->valueblk);
-				args.rmtblkcnt = xfs_attr3_rmt_blocks(
-							args.dp->i_mount, valuelen);
-				retval = xfs_attr_rmtval_get(&args);
-				if (retval)
-					return retval;
-				retval = context->put_listent(context,
-						entry->flags,
-						name_rmt->name,
-						(int)name_rmt->namelen,
-						valuelen);
-				kmem_free(args.value);
-			} else {
-				retval = context->put_listent(context,
+			retval = context->put_listent(context,
 						entry->flags,
 						name_rmt->name,
 						(int)name_rmt->namelen,
 						valuelen);
-			}
 			if (retval)
 				return retval;
 		}
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
