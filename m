Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC3CCC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:01:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbjBPVBk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbjBPVBj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:01:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8061505D9
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:01:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F634B82958
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:01:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B581C433D2;
        Thu, 16 Feb 2023 21:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581295;
        bh=FRpWoOGlwtyuHn9xLVJUWZAVUxFwEa9C2ffU4OobmZY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=q/ovwizL9VdQei/jpO+AWk+xGXjhoJCoIINaw1u+t1BTWgQenSJUkMTO4U1VQ5iky
         4pONwOiZh/+feo7clDjmo64kKYfdDBKkAOkKRkDDbsSDYhfdgCiyM2Aood749fxFv7
         D0QdDN9vK/8zG1wJTUjKbiohj2Pdytu583X5gRjOkCbO98svjrdErjD7HTVEpA+NAj
         EmtovKRQ9qDG4W9s5Xe71TCt0YtKzJiWsxOZ834a336pFyipLdZu6WT5J1YdP1Gp+u
         HP81g5uekq0+czcQqxtXWf96lA/f1ipdQr5p8wFN6MY82r5r9mvQtGwUpAJe8xuuCI
         r5Zf8fTojC+Ig==
Date:   Thu, 16 Feb 2023 13:01:34 -0800
Subject: [PATCH 6/6] xfs: replace the XFS_IOC_GETPARENTS backend
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657879613.3476725.13548814793158748741.stgit@magnolia>
In-Reply-To: <167657879533.3476725.4672667573997149436.stgit@magnolia>
References: <167657879533.3476725.4672667573997149436.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that xfs_attr_list can pass local xattr values to the put_listent
function, build a new version of the GETPARENTS backend that supplies a
custom put_listent function to format parent pointer info directly into
the caller's buffer.  This uses a lot less memory and obviates the
iterate list and then grab the values logic, since parent pointers
aren't supposed to have remote values anyway.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_parent.c |   40 ++++++++++++++++++++++++++++++----------
 libxfs/xfs_parent.h |   21 +++++++++++++++++++--
 2 files changed, 49 insertions(+), 12 deletions(-)


diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index 654eaec7..74c7f1f7 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -30,16 +30,6 @@
 
 struct kmem_cache		*xfs_parent_intent_cache;
 
-/* Initializes a xfs_parent_ptr from an xfs_parent_name_rec */
-void
-xfs_init_parent_ptr(struct xfs_parent_ptr		*xpp,
-		    const struct xfs_parent_name_rec	*rec)
-{
-	xpp->xpp_ino = be64_to_cpu(rec->p_ino);
-	xpp->xpp_gen = be32_to_cpu(rec->p_gen);
-	xpp->xpp_diroffset = be32_to_cpu(rec->p_diroffset);
-}
-
 /*
  * Parent pointer attribute handling.
  *
@@ -116,6 +106,36 @@ xfs_init_parent_name_rec(
 	rec->p_diroffset = cpu_to_be32(p_diroffset);
 }
 
+/*
+ * Convert an ondisk parent_name xattr to its incore format.  If @value is
+ * NULL, set @irec->p_namelen to zero and leave @irec->p_name untouched.
+ */
+void
+xfs_parent_irec_from_disk(
+	struct xfs_parent_name_irec	*irec,
+	const struct xfs_parent_name_rec *rec,
+	const void			*value,
+	int				valuelen)
+{
+	irec->p_ino = be64_to_cpu(rec->p_ino);
+	irec->p_gen = be32_to_cpu(rec->p_gen);
+	irec->p_diroffset = be32_to_cpu(rec->p_diroffset);
+
+	if (!value) {
+		irec->p_namelen = 0;
+		return;
+	}
+
+	ASSERT(valuelen > 0);
+	ASSERT(valuelen < MAXNAMELEN);
+
+	valuelen = min(valuelen, MAXNAMELEN);
+
+	irec->p_namelen = valuelen;
+	memcpy(irec->p_name, value, valuelen);
+	memset(&irec->p_name[valuelen], 0, sizeof(irec->p_name) - valuelen);
+}
+
 int
 __xfs_parent_init(
 	struct xfs_mount		*mp,
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index 4ffcb81d..f4f5887d 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
@@ -15,6 +15,25 @@ bool xfs_parent_namecheck(struct xfs_mount *mp,
 bool xfs_parent_valuecheck(struct xfs_mount *mp, const void *value,
 		size_t valuelen);
 
+/*
+ * Incore version of a parent pointer, also contains dirent name so callers
+ * can pass/obtain all the parent pointer information in a single structure
+ */
+struct xfs_parent_name_irec {
+	/* Key fields for looking up a particular parent pointer. */
+	xfs_ino_t		p_ino;
+	uint32_t		p_gen;
+	xfs_dir2_dataptr_t	p_diroffset;
+
+	/* Attributes of a parent pointer. */
+	uint8_t			p_namelen;
+	unsigned char		p_name[MAXNAMELEN];
+};
+
+void xfs_parent_irec_from_disk(struct xfs_parent_name_irec *irec,
+		const struct xfs_parent_name_rec *rec,
+		const void *value, int valuelen);
+
 /*
  * Dynamically allocd structure used to wrap the needed data to pass around
  * the defer ops machinery
@@ -32,8 +51,6 @@ struct xfs_parent_defer {
 void xfs_init_parent_name_rec(struct xfs_parent_name_rec *rec,
 			      struct xfs_inode *ip,
 			      uint32_t p_diroffset);
-void xfs_init_parent_ptr(struct xfs_parent_ptr *xpp,
-			 const struct xfs_parent_name_rec *rec);
 int __xfs_parent_init(struct xfs_mount *mp, bool grab_log,
 		struct xfs_parent_defer **parentp);
 

