Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB975C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 02:06:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiKICGh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 21:06:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiKICGe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2022 21:06:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F49B663E1
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 18:06:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFB1861808
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 02:06:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B731C433D6;
        Wed,  9 Nov 2022 02:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667959593;
        bh=bfWun4uSMFgH+W6v76YBGOgQVtJjf6QyvENWuqQ3KD0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nja+/t51u5dRFvkAukyu7Hk4AVO8Ozl5cSGfDs4oNw5ao4JSR0qnQgPykopP7Qtyt
         4+Fnz6GCrrezix+WHNX6q3BIKPGLoNUZIYaM5cIdIiDq32vgBq/BPnUmY3/UihAeuN
         GCsFk6b0m8XLFaojxXJpiYf5wGMmMvII3IK1jL/0K1TOstkkpfuiJgug/AanJeGFVe
         jdxyYTKeUV4T/giaq8wf5lldXzFeD0/bUu0Ny7PiuS65ogzPp9rBkKlLVhTOeR4ncH
         dk/QSQlwzzvW8I+dciZrT5lA00Jcoax65RDkd9QwRnVltiP+A9lD1yT8d2NclorCF4
         l365NIWssJh+Q==
Subject: [PATCH 09/24] xfs: fix memcpy fortify errors in EFI log format
 copying
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 08 Nov 2022 18:06:32 -0800
Message-ID: <166795959288.3761583.14358034387087854299.stgit@magnolia>
In-Reply-To: <166795954256.3761583.3551179546135782562.stgit@magnolia>
References: <166795954256.3761583.3551179546135782562.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: b276f256ced3233b74b83d7df4e1b4ba8672ee98

Starting in 6.1, CONFIG_FORTIFY_SOURCE checks the length parameter of
memcpy.  Since we're already fixing problems with BUI item copying, we
should fix it everything else.

Refactor the xfs_efi_copy_format function to handle the copying of the
head and the flex array members separately, and do the same for the EFI
relogging functions.  While we're at it, fix a minor validation
deficiency in the recovery function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_log_format.h |   12 ++++++------
 logprint/log_redo.c     |   12 ++++++------
 2 files changed, 12 insertions(+), 12 deletions(-)


diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index b351b9dc65..2f41fa8477 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -613,7 +613,7 @@ typedef struct xfs_efi_log_format {
 	uint16_t		efi_size;	/* size of this item */
 	uint32_t		efi_nextents;	/* # extents to free */
 	uint64_t		efi_id;		/* efi identifier */
-	xfs_extent_t		efi_extents[1];	/* array of extents to free */
+	xfs_extent_t		efi_extents[];	/* array of extents to free */
 } xfs_efi_log_format_t;
 
 typedef struct xfs_efi_log_format_32 {
@@ -621,7 +621,7 @@ typedef struct xfs_efi_log_format_32 {
 	uint16_t		efi_size;	/* size of this item */
 	uint32_t		efi_nextents;	/* # extents to free */
 	uint64_t		efi_id;		/* efi identifier */
-	xfs_extent_32_t		efi_extents[1];	/* array of extents to free */
+	xfs_extent_32_t		efi_extents[];	/* array of extents to free */
 } __attribute__((packed)) xfs_efi_log_format_32_t;
 
 typedef struct xfs_efi_log_format_64 {
@@ -629,7 +629,7 @@ typedef struct xfs_efi_log_format_64 {
 	uint16_t		efi_size;	/* size of this item */
 	uint32_t		efi_nextents;	/* # extents to free */
 	uint64_t		efi_id;		/* efi identifier */
-	xfs_extent_64_t		efi_extents[1];	/* array of extents to free */
+	xfs_extent_64_t		efi_extents[];	/* array of extents to free */
 } xfs_efi_log_format_64_t;
 
 /*
@@ -642,7 +642,7 @@ typedef struct xfs_efd_log_format {
 	uint16_t		efd_size;	/* size of this item */
 	uint32_t		efd_nextents;	/* # of extents freed */
 	uint64_t		efd_efi_id;	/* id of corresponding efi */
-	xfs_extent_t		efd_extents[1];	/* array of extents freed */
+	xfs_extent_t		efd_extents[];	/* array of extents freed */
 } xfs_efd_log_format_t;
 
 typedef struct xfs_efd_log_format_32 {
@@ -650,7 +650,7 @@ typedef struct xfs_efd_log_format_32 {
 	uint16_t		efd_size;	/* size of this item */
 	uint32_t		efd_nextents;	/* # of extents freed */
 	uint64_t		efd_efi_id;	/* id of corresponding efi */
-	xfs_extent_32_t		efd_extents[1];	/* array of extents freed */
+	xfs_extent_32_t		efd_extents[];	/* array of extents freed */
 } __attribute__((packed)) xfs_efd_log_format_32_t;
 
 typedef struct xfs_efd_log_format_64 {
@@ -658,7 +658,7 @@ typedef struct xfs_efd_log_format_64 {
 	uint16_t		efd_size;	/* size of this item */
 	uint32_t		efd_nextents;	/* # of extents freed */
 	uint64_t		efd_efi_id;	/* id of corresponding efi */
-	xfs_extent_64_t		efd_extents[1];	/* array of extents freed */
+	xfs_extent_64_t		efd_extents[];	/* array of extents freed */
 } xfs_efd_log_format_64_t;
 
 /*
diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index 1974382d2d..12d041da1c 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -20,9 +20,9 @@ xfs_efi_copy_format(
 {
 	uint i;
 	uint nextents = ((xfs_efi_log_format_t *)buf)->efi_nextents;
-	uint dst_len = sizeof(xfs_efi_log_format_t) + (nextents - 1) * sizeof(xfs_extent_t);
-	uint len32 = sizeof(xfs_efi_log_format_32_t) + (nextents - 1) * sizeof(xfs_extent_32_t);
-	uint len64 = sizeof(xfs_efi_log_format_64_t) + (nextents - 1) * sizeof(xfs_extent_64_t);
+	uint dst_len = sizeof(xfs_efi_log_format_t) + nextents * sizeof(xfs_extent_t);
+	uint len32 = sizeof(xfs_efi_log_format_32_t) + nextents * sizeof(xfs_extent_32_t);
+	uint len64 = sizeof(xfs_efi_log_format_64_t) + nextents * sizeof(xfs_extent_64_t);
 
 	if (len == dst_len || continued) {
 		memcpy((char *)dst_efi_fmt, buf, len);
@@ -86,7 +86,7 @@ xlog_print_trans_efi(
 	*ptr += src_len;
 
 	/* convert to native format */
-	dst_len = sizeof(xfs_efi_log_format_t) + (src_f->efi_nextents - 1) * sizeof(xfs_extent_t);
+	dst_len = sizeof(xfs_efi_log_format_t) + src_f->efi_nextents * sizeof(xfs_extent_t);
 
 	if (continued && src_len < core_size) {
 		printf(_("EFI: Not enough data to decode further\n"));
@@ -144,7 +144,7 @@ xlog_recover_print_efi(
 	 * Need to convert to native format.
 	 */
 	dst_len = sizeof(xfs_efi_log_format_t) +
-		(src_f->efi_nextents - 1) * sizeof(xfs_extent_t);
+		src_f->efi_nextents * sizeof(xfs_extent_t);
 	if ((f = (xfs_efi_log_format_t *)malloc(dst_len)) == NULL) {
 		fprintf(stderr, _("%s: xlog_recover_print_efi: malloc failed\n"),
 			progname);
@@ -177,7 +177,7 @@ xlog_print_trans_efd(char **ptr, uint len)
 	xfs_efd_log_format_t *f;
 	xfs_efd_log_format_t lbuf;
 	/* size without extents at end */
-	uint core_size = sizeof(xfs_efd_log_format_t) - sizeof(xfs_extent_t);
+	uint core_size = sizeof(struct xfs_efd_log_format);
 
 	/*
 	 * memmove to ensure 8-byte alignment for the long longs in

