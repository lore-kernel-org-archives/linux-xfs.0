Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D708C76196
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237133AbjDFTla (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjDFTl3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:41:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69FDAE50
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:41:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0442C60EFE
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:41:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63FE8C433EF;
        Thu,  6 Apr 2023 19:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680810087;
        bh=CKRfkkizqGARVQx7jsFkEPlu2+N95ef56JKnA/6CtjY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=rbP1sOmoZQlXB9rDbm9Ik/BEs362+zZ0EyPOv/Z1Q98Z48mfNG940qQ+cI/sLZNwe
         jo9IWwR492oiYGtPVGB2E680MOTQ7Dkign+WjeuwznthoDJxfLAq2O52eH9vrlvuw/
         ISFniLxlG1kMa8wxgzg3X1PopV8byDuT0/YKtqvZ2lzvtnmPKERDR+4836mhhEwMsn
         KSza6Xe6rDbH1ObICqSpDU41MmQvy1l/yKhkqQuSvTGsOUZgmQwyoy+AunG1kR2sx8
         5sG9p+5sF4U93VKKi7F+ATIqkjIhnbOzabRPR8zBujX8ta5mUcBJ/V+3809maFla5G
         pvxi0+YWFmzpg==
Date:   Thu, 06 Apr 2023 12:41:26 -0700
Subject: [PATCH 6/7] xfs_repair: update ondisk parent pointer records
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080828338.617551.13961262959920369228.stgit@frogsfrogsfrogs>
In-Reply-To: <168080828258.617551.4008600376507330925.stgit@frogsfrogsfrogs>
References: <168080828258.617551.4008600376507330925.stgit@frogsfrogsfrogs>
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
 libxfs/libxfs_api_defs.h |    3 ++
 repair/pptr.c            |   85 ++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 85 insertions(+), 3 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index fb1865483..621768965 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -147,9 +147,12 @@
 #define xfs_parent_add			libxfs_parent_add
 #define xfs_parent_finish		libxfs_parent_finish
 #define xfs_parent_irec_from_disk	libxfs_parent_irec_from_disk
+#define xfs_parent_irec_hashname	libxfs_parent_irec_hashname
+#define xfs_parent_set			libxfs_parent_set
 #define xfs_parent_start		libxfs_parent_start
 #define xfs_parent_namecheck		libxfs_parent_namecheck
 #define xfs_parent_valuecheck		libxfs_parent_valuecheck
+#define xfs_parent_unset		libxfs_parent_unset
 #define xfs_perag_get			libxfs_perag_get
 #define xfs_perag_put			libxfs_perag_put
 #define xfs_prealloc_blocks		libxfs_prealloc_blocks
diff --git a/repair/pptr.c b/repair/pptr.c
index 8506405a1..1a0836ed4 100644
--- a/repair/pptr.c
+++ b/repair/pptr.c
@@ -674,6 +674,44 @@ load_file_pptr_name(
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
+	return -libxfs_parent_set(ip, &pptr_rec, &scratch);
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
+	return -libxfs_parent_unset(ip, &pptr_rec, &scratch);
+}
+
 /* Remove all pptrs from @ip. */
 static void
 clear_all_pptrs(
@@ -730,7 +768,16 @@ add_missing_parent_ptr(
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
@@ -772,7 +819,16 @@ remove_incorrect_parent_ptr(
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
@@ -844,7 +900,30 @@ compare_parent_ptrs(
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

