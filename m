Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41E21C6FD19
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:31:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbjCPTbZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjCPTbY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:31:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A541EB3E3A
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:31:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DC69620F8
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:31:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934BFC433EF;
        Thu, 16 Mar 2023 19:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678995082;
        bh=rQ2skfWQBCNwwUPwW0lTkIssnchqJMQY6M+uxdRejes=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=jleYuF2ROYAoZQH/iCv/c79JTbCjV8gyyYDdEXxBGRhEDQVoeIqGXY3uzq4IBX57v
         wirR5R38qaauWQaebF0+cXNi5T3BZF27JEpUHlZm66vDYMirdTqLp1PqREd1QghjZN
         9qxZBbPOwyEvYWcJQwGRK6OdGgRQ5OOqr3QJM6jK2eqF2KvZcut9LebKQ9I84ROjrn
         apG9AweG6qkOdkfL5NiSj+e9zP6SKP15YqDWABPwkTbLiLbbPljVJT7CgH5s034zdq
         lTfKicJs8+JhZH+eY0Ou8M0cCkkmkCj0SVaa9Z9QNe6dbGmjzgwZhE8f39u9uw6RyB
         tLOUdjFQPvtxw==
Date:   Thu, 16 Mar 2023 12:31:22 -0700
Subject: [PATCH 3/5] xfs: fix GETPARENTS ioctl
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899416496.16836.5795337536304426306.stgit@frogsfrogsfrogs>
In-Reply-To: <167899416457.16836.2981078472584318439.stgit@frogsfrogsfrogs>
References: <167899416457.16836.2981078472584318439.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix a few remaining issues with this ioctl:

The ioctl encodes the size of the parent rec, not the parent head.

The parent rec should say that it returns a null terminated filename.

The parent head encodes the buffer size, not the size of the parent
record array, but the field name and documentation doesn't make this
clear.

The getparents sizeof function is pointless and wrong.

Get rid of the last vestiges of the non-flex-array definitions.

The rec address should take an unsigned argument

Whitespace damage

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/pptrs.c |    2 +-
 libxfs/xfs_fs.h |   30 +++++++++++-------------------
 2 files changed, 12 insertions(+), 20 deletions(-)


diff --git a/libfrog/pptrs.c b/libfrog/pptrs.c
index eff994df8..f3465941d 100644
--- a/libfrog/pptrs.c
+++ b/libfrog/pptrs.c
@@ -21,7 +21,7 @@ alloc_pptr_buf(
 	pi = calloc(bufsize, 1);
 	if (!pi)
 		return NULL;
-	pi->gp_ptrs_size = bufsize;
+	pi->gp_bufsize = bufsize;
 	return pi;
 }
 
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index c8edc7c09..d7e061089 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -752,8 +752,6 @@ struct xfs_scrub_metadata {
 				 XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED)
 #define XFS_SCRUB_FLAGS_ALL	(XFS_SCRUB_FLAGS_IN | XFS_SCRUB_FLAGS_OUT)
 
-#define XFS_GETPARENTS_MAXNAMELEN	256
-
 /* return parents of the handle, not the open fd */
 #define XFS_GETPARENTS_IFLAG_HANDLE	(1U << 0)
 
@@ -769,11 +767,11 @@ struct xfs_scrub_metadata {
 
 /* Get an inode parent pointer through ioctl */
 struct xfs_getparents_rec {
-	__u64		gpr_ino;			/* Inode */
-	__u32		gpr_gen;			/* Inode generation */
-	__u32		gpr_diroffset;			/* Directory offset */
-	__u64		gpr_rsvd;			/* Reserved */
-	__u8		gpr_name[];			/* File name */
+	__u64		gpr_ino;	/* Inode number */
+	__u32		gpr_gen;	/* Inode generation */
+	__u32		gpr_diroffset;	/* Directory offset */
+	__u64		gpr_rsvd;	/* Reserved */
+	__u8		gpr_name[];	/* File name and null terminator */
 };
 
 /* Iterate through an inodes parent pointers */
@@ -794,8 +792,8 @@ struct xfs_getparents {
 	/* Must be set to zero */
 	__u32				gp_reserved;
 
-	/* size of the trailing buffer in bytes */
-	__u32				gp_ptrs_size;
+	/* Size of the buffer in bytes, including this header */
+	__u32				gp_bufsize;
 
 	/* # of entries filled in (output) */
 	__u32				gp_count;
@@ -807,19 +805,13 @@ struct xfs_getparents {
 	__u32				gp_offsets[];
 };
 
-static inline size_t
-xfs_getparents_sizeof(int nr_ptrs)
-{
-	return sizeof(struct xfs_getparents) +
-	       (nr_ptrs * sizeof(struct xfs_getparents_rec));
-}
-
 static inline struct xfs_getparents_rec*
 xfs_getparents_rec(
 	struct xfs_getparents	*info,
-	int			idx)
+	unsigned int		idx)
 {
-	return (struct xfs_getparents_rec *)((char *)info + info->gp_offsets[idx]);
+	return (struct xfs_getparents_rec *)((char *)info +
+					     info->gp_offsets[idx]);
 }
 
 /*
@@ -867,7 +859,7 @@ xfs_getparents_rec(
 /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
 #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
 #define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct xfs_ag_geometry)
-#define XFS_IOC_GETPARENTS	_IOWR('X', 62, struct xfs_getparents_rec)
+#define XFS_IOC_GETPARENTS	_IOWR('X', 62, struct xfs_getparents)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s

