Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDEC0C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjEZCct (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjEZCcs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:32:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB0FB2
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:32:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28A6664C27
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:32:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4D5C433D2;
        Fri, 26 May 2023 02:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685068366;
        bh=I7Qp3JOxOtrKaE+JLfR8b+pWwEFxIR2TTe69a114H0c=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=r6MxAYdQBu+CQjsqhZRAUEKcpZ6rLexBy+Gsdsd5qNj2b9u+vgMkCeHtPn5GwYjZV
         v+Yuz6LX83E9nMWwpeTNOWvu8M1pQFuQKqBbnpynXt2RttS+HWqc1tf8sP5svfPyWf
         drbD56JJK1LWVMcUHuhQ+RKJiEOH7UVNADnITeQaG+8UwxNkjR+M3MHgv+adCtUZxg
         8sZl/yGJWVHdOUK8h6iBOHS0i1ZjV6xJgX653Gu0icwfyqY8VVmFb2d33uOCvTOXz9
         eXi10kYMTjpYZPgGfTetTXKTu0D7Z4ORspfEh8mpuBCKS2kgbXxXFavgRk4CgtbuaC
         DDlfMnNm0DLlg==
Date:   Thu, 25 May 2023 19:32:46 -0700
Subject: [PATCH 12/14] xfs_repair: update ondisk parent pointer records
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506078757.3750196.14325965699631611616.stgit@frogsfrogsfrogs>
In-Reply-To: <168506078591.3750196.1821601831633863822.stgit@frogsfrogsfrogs>
References: <168506078591.3750196.1821601831633863822.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Update the ondisk parent pointer records as necessary.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    2 +
 repair/pptr.c            |   85 ++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 84 insertions(+), 3 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 795df630d76..5f87d2be8d8 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -184,9 +184,11 @@
 #define xfs_parent_irec_from_disk	libxfs_parent_irec_from_disk
 #define xfs_parent_irec_hashname	libxfs_parent_irec_hashname
 #define xfs_parent_lookup		libxfs_parent_lookup
+#define xfs_parent_set			libxfs_parent_set
 #define xfs_parent_start		libxfs_parent_start
 #define xfs_parent_namecheck		libxfs_parent_namecheck
 #define xfs_parent_valuecheck		libxfs_parent_valuecheck
+#define xfs_parent_unset		libxfs_parent_unset
 #define xfs_perag_get			libxfs_perag_get
 #define xfs_perag_put			libxfs_perag_put
 #define xfs_prealloc_blocks		libxfs_prealloc_blocks
diff --git a/repair/pptr.c b/repair/pptr.c
index dcd7c7574ff..ae5cc260e1f 100644
--- a/repair/pptr.c
+++ b/repair/pptr.c
@@ -677,6 +677,44 @@ load_file_pptr_name(
 			name, file_pptr->namelen);
 }
 
+/* Add an on disk parent pointer to a file. */
+static int
+add_file_pptr(
+	struct xfs_inode		*ip,
+	const struct ag_pptr		*ag_pptr,
+	const unsigned char		*name)
+{
+	struct xfs_parent_name_irec	pptr_rec = {
+		.p_ino			= ag_pptr->parent_ino,
+		.p_gen			= ag_pptr->parent_gen,
+		.p_namelen		= ag_pptr->namelen,
+	};
+	struct xfs_parent_scratch	scratch;
+
+	memcpy(pptr_rec.p_name, name, ag_pptr->namelen);
+	libxfs_parent_irec_hashname(ip->i_mount, &pptr_rec);
+	return -libxfs_parent_set(ip, ip->i_ino, &pptr_rec, &scratch);
+}
+
+/* Remove an on disk parent pointer from a file. */
+static int
+remove_file_pptr(
+	struct xfs_inode		*ip,
+	const struct file_pptr		*file_pptr,
+	const unsigned char		*name)
+{
+	struct xfs_parent_name_irec	pptr_rec = {
+		.p_ino			= file_pptr->parent_ino,
+		.p_gen			= file_pptr->parent_gen,
+		.p_namelen		= file_pptr->namelen,
+	};
+	struct xfs_parent_scratch	scratch;
+
+	memcpy(pptr_rec.p_name, name, file_pptr->namelen);
+	libxfs_parent_irec_hashname(ip->i_mount, &pptr_rec);
+	return -libxfs_parent_unset(ip, ip->i_ino, &pptr_rec, &scratch);
+}
+
 /* Remove all pptrs from @ip. */
 static void
 clear_all_pptrs(
@@ -733,7 +771,16 @@ add_missing_parent_ptr(
 			ag_pptr->namelen,
 			name);
 
-	/* XXX actually do the work */
+	error = add_file_pptr(ip, ag_pptr, name);
+	if (error)
+		do_error(
+ _("adding ino %llu pptr (ino %llu gen 0x%x name '%.*s') failed: %s\n"),
+			(unsigned long long)ip->i_ino,
+			(unsigned long long)ag_pptr->parent_ino,
+			ag_pptr->parent_gen,
+			ag_pptr->namelen,
+			name,
+			strerror(error));
 }
 
 /* Remove @file_pptr from @ip. */
@@ -775,7 +822,16 @@ remove_incorrect_parent_ptr(
 			file_pptr->namelen,
 			name);
 
-	/* XXX actually do the work */
+	error = remove_file_pptr(ip, file_pptr, name);
+	if (error)
+		do_error(
+ _("removing ino %llu pptr (ino %llu gen 0x%x name '%.*s') failed: %s\n"),
+			(unsigned long long)ip->i_ino,
+			(unsigned long long)file_pptr->parent_ino,
+			file_pptr->parent_gen,
+			file_pptr->namelen,
+			name,
+			strerror(error));
 }
 
 /*
@@ -847,7 +903,30 @@ compare_parent_ptrs(
 			ag_pptr->namelen,
 			name1);
 
-	/* XXX do the work */
+	if (ag_pptr->parent_gen != file_pptr->parent_gen ||
+	    ag_pptr->namehash   != file_pptr->namehash) {
+		error = remove_file_pptr(ip, file_pptr, name2);
+		if (error)
+			do_error(
+ _("erasing ino %llu pptr (ino %llu gen 0x%x name '%.*s') failed: %s\n"),
+				(unsigned long long)ip->i_ino,
+				(unsigned long long)file_pptr->parent_ino,
+				file_pptr->parent_gen,
+				file_pptr->namelen,
+				name2,
+				strerror(error));
+	}
+
+	error = add_file_pptr(ip, ag_pptr, name1);
+	if (error)
+		do_error(
+ _("updating ino %llu pptr (ino %llu gen 0x%x name '%.*s') failed: %s\n"),
+			(unsigned long long)ip->i_ino,
+			(unsigned long long)ag_pptr->parent_ino,
+			ag_pptr->parent_gen,
+			ag_pptr->namelen,
+			name1,
+			strerror(error));
 }
 
 static int

