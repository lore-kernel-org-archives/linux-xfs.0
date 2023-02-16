Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DF5BC636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:09:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjBPVJ3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:09:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbjBPVJ3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:09:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1638F2BF17
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:09:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 956BFB826BA
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:09:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44572C433EF;
        Thu, 16 Feb 2023 21:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581765;
        bh=QamHp6bJxobrpyIYtEWWFba66Omo9437Op6Oz1CYJHA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=FH3MgZHPiRBHTwAhXKAAj2Ill1LaVUgGDiN9Bkx/MdhVMEl8Qgh8jNLtVrTn1wc/4
         XYxaD+OzA2sGMy1xib/Gc505ebEhUspK3DvSAhrNtgOnOJkmnkIrO4fntNOihK4o1m
         mVHa5MdarKmjgDqoa1jgxTIicyH1cz3U9rBqSw7jAE5POh3zTqJZ97aJ2UhVH/zsD6
         xbFgyKGJPx0UT5nMv7flh792gN/UeqJzzUOzFVp8op7fk/e9A9DyEBnQDNtrONi/Px
         xIO29YgXdkrVs1drfVDR7fNH0xCH30Y94VG+Tdza6ntlUtRLltP0BdlykLufbh3s0l
         /bEjKegrtFQuQ==
Date:   Thu, 16 Feb 2023 13:09:24 -0800
Subject: [PATCH 4/8] xfs_repair: update ondisk parent pointer records
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657882018.3477807.10657512746908096447.stgit@magnolia>
In-Reply-To: <167657881963.3477807.5005383731904631094.stgit@magnolia>
References: <167657881963.3477807.5005383731904631094.stgit@magnolia>
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
 repair/pptr.c            |   74 ++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 73 insertions(+), 3 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 92cdb6cc..ab8bdc1c 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -147,7 +147,9 @@
 #define xfs_parent_add			libxfs_parent_add
 #define xfs_parent_finish		libxfs_parent_finish
 #define xfs_parent_irec_from_disk	libxfs_parent_irec_from_disk
+#define xfs_parent_set			libxfs_parent_set
 #define xfs_parent_start		libxfs_parent_start
+#define xfs_parent_unset		libxfs_parent_unset
 #define xfs_perag_get			libxfs_perag_get
 #define xfs_perag_put			libxfs_perag_put
 #define xfs_prealloc_blocks		libxfs_prealloc_blocks
diff --git a/repair/pptr.c b/repair/pptr.c
index 695177ce..53ac1013 100644
--- a/repair/pptr.c
+++ b/repair/pptr.c
@@ -528,6 +528,42 @@ examine_xattr(
 	return 0;
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
+		.p_diroffset		= ag_pptr->diroffset,
+		.p_namelen		= ag_pptr->namelen,
+	};
+	struct xfs_parent_scratch	scratch;
+
+	memcpy(pptr_rec.p_name, name, ag_pptr->namelen);
+
+	return -libxfs_parent_set(ip, &pptr_rec, &scratch);
+}
+
+/* Remove an on disk parent pointer from a file. */
+static int
+remove_file_pptr(
+	struct xfs_inode		*ip,
+	const struct file_pptr		*file_pptr)
+{
+	struct xfs_parent_name_irec	pptr_rec = {
+		.p_ino			= file_pptr->parent_ino,
+		.p_gen			= file_pptr->parent_gen,
+		.p_diroffset		= file_pptr->diroffset,
+	};
+	struct xfs_parent_scratch	scratch;
+
+	return -libxfs_parent_unset(ip, &pptr_rec, &scratch);
+}
+
 /* Remove all pptrs from @ip. */
 static void
 clear_all_pptrs(
@@ -582,7 +618,14 @@ add_missing_parent_ptr(
 			ag_pptr->parent_gen, ag_pptr->diroffset,
 			ag_pptr->namelen, name);
 
-	/* XXX actually do the work */
+	error = add_file_pptr(ip, ag_pptr, name);
+	if (error)
+		do_error(
+ _("adding ino %llu pptr (ino %llu gen 0x%x diroffset %u name '%.*s') failed: %s\n"),
+			(unsigned long long)ip->i_ino,
+			(unsigned long long)ag_pptr->parent_ino,
+			ag_pptr->parent_gen, ag_pptr->diroffset,
+			ag_pptr->namelen, name, strerror(error));
 }
 
 /* Remove @file_pptr from @ip. */
@@ -623,7 +666,14 @@ remove_incorrect_parent_ptr(
 			file_pptr->parent_gen, file_pptr->diroffset,
 			file_pptr->namelen, name);
 
-	/* XXX actually do the work */
+	error = remove_file_pptr(ip, file_pptr);
+	if (error)
+		do_error(
+ _("removing ino %llu pptr (ino %llu gen 0x%x diroffset %u name '%.*s') failed: %s\n"),
+			(unsigned long long)ip->i_ino,
+			(unsigned long long)file_pptr->parent_ino,
+			file_pptr->parent_gen, file_pptr->diroffset,
+			file_pptr->namelen, name, strerror(error));
 }
 
 /*
@@ -690,7 +740,25 @@ compare_parent_pointers(
 			ag_pptr->parent_gen, ag_pptr->diroffset,
 			ag_pptr->namelen, name1);
 
-	/* XXX do the work */
+	if (ag_pptr->parent_gen != file_pptr->parent_gen) {
+		error = remove_file_pptr(ip, file_pptr);
+		if (error)
+			do_error(
+ _("erasing ino %llu pptr (ino %llu gen 0x%x diroffset %u name '%.*s') failed: %s\n"),
+				(unsigned long long)ip->i_ino,
+				(unsigned long long)file_pptr->parent_ino,
+				file_pptr->parent_gen, file_pptr->diroffset,
+				file_pptr->namelen, name2, strerror(error));
+	}
+
+	error = add_file_pptr(ip, ag_pptr, name1);
+	if (error)
+		do_error(
+ _("updating ino %llu pptr (ino %llu gen 0x%x diroffset %u name '%.*s') failed: %s\n"),
+			(unsigned long long)ip->i_ino,
+			(unsigned long long)ag_pptr->parent_ino,
+			ag_pptr->parent_gen, ag_pptr->diroffset,
+			ag_pptr->namelen, name1, strerror(error));
 }
 
 /*

