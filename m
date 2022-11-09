Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30391C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 02:06:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbiKICGm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 21:06:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiKICGm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2022 21:06:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7740168294
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 18:06:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DC5CB81619
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 02:06:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3C9C433C1;
        Wed,  9 Nov 2022 02:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667959598;
        bh=SpHR5Waiz5a9EK9GLHJFvFOQ5RtC6jyKYMAio89VcGQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hWzPn/6YcLGZZX0zj8rtw2e6TGghKDeYGgkrcva2LKxplMmV9Vn2Ioe6moQ7ztrSI
         +jxmbOZ5881sS3riu1KQK3UvuA5Sq6uNhJbrAAWNponHgwwQgTBAom2Skztjx5XlmD
         5kNjE/ENjU8lWogDD8VvKSHbx7qvdSOAFBkM5LIt9j64aOeCCANQugsJFgbyqZ5oWc
         1jirHhgzLShUhBXG7gdNMBGYKimzwkAwkDD71Efc4dWhg44zB9JSJ/1LAtu9KehwnR
         ZlbfTMTd1PoTBx4uEtGFyS6KIwUJ5L8eql9RExzU0O5FsxHnGBiUb+ms6Pgcis+wDP
         hCTrPMueTRDeQ==
Subject: [PATCH 10/24] xfs: refactor all the EFI/EFD log format sizeof logic
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 08 Nov 2022 18:06:38 -0800
Message-ID: <166795959840.3761583.11500851812367396592.stgit@magnolia>
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

Source kernel commit: eaf7a21a10f90578f14966c2eafaab4896add356

Refactor all the open-coded sizeof logic for EFI/EFD log items into a
common helper function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_log_format.h |   48 +++++++++++++++++++++++++++++++++++++++++++++++
 logprint/log_redo.c     |    8 ++++----
 2 files changed, 52 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 2f41fa8477..f13e0809dc 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -616,6 +616,14 @@ typedef struct xfs_efi_log_format {
 	xfs_extent_t		efi_extents[];	/* array of extents to free */
 } xfs_efi_log_format_t;
 
+static inline size_t
+xfs_efi_log_format_sizeof(
+	unsigned int		nr)
+{
+	return sizeof(struct xfs_efi_log_format) +
+			nr * sizeof(struct xfs_extent);
+}
+
 typedef struct xfs_efi_log_format_32 {
 	uint16_t		efi_type;	/* efi log item type */
 	uint16_t		efi_size;	/* size of this item */
@@ -624,6 +632,14 @@ typedef struct xfs_efi_log_format_32 {
 	xfs_extent_32_t		efi_extents[];	/* array of extents to free */
 } __attribute__((packed)) xfs_efi_log_format_32_t;
 
+static inline size_t
+xfs_efi_log_format32_sizeof(
+	unsigned int		nr)
+{
+	return sizeof(struct xfs_efi_log_format_32) +
+			nr * sizeof(struct xfs_extent_32);
+}
+
 typedef struct xfs_efi_log_format_64 {
 	uint16_t		efi_type;	/* efi log item type */
 	uint16_t		efi_size;	/* size of this item */
@@ -632,6 +648,14 @@ typedef struct xfs_efi_log_format_64 {
 	xfs_extent_64_t		efi_extents[];	/* array of extents to free */
 } xfs_efi_log_format_64_t;
 
+static inline size_t
+xfs_efi_log_format64_sizeof(
+	unsigned int		nr)
+{
+	return sizeof(struct xfs_efi_log_format_64) +
+			nr * sizeof(struct xfs_extent_64);
+}
+
 /*
  * This is the structure used to lay out an efd log item in the
  * log.  The efd_extents array is a variable size array whose
@@ -645,6 +669,14 @@ typedef struct xfs_efd_log_format {
 	xfs_extent_t		efd_extents[];	/* array of extents freed */
 } xfs_efd_log_format_t;
 
+static inline size_t
+xfs_efd_log_format_sizeof(
+	unsigned int		nr)
+{
+	return sizeof(struct xfs_efd_log_format) +
+			nr * sizeof(struct xfs_extent);
+}
+
 typedef struct xfs_efd_log_format_32 {
 	uint16_t		efd_type;	/* efd log item type */
 	uint16_t		efd_size;	/* size of this item */
@@ -653,6 +685,14 @@ typedef struct xfs_efd_log_format_32 {
 	xfs_extent_32_t		efd_extents[];	/* array of extents freed */
 } __attribute__((packed)) xfs_efd_log_format_32_t;
 
+static inline size_t
+xfs_efd_log_format32_sizeof(
+	unsigned int		nr)
+{
+	return sizeof(struct xfs_efd_log_format_32) +
+			nr * sizeof(struct xfs_extent_32);
+}
+
 typedef struct xfs_efd_log_format_64 {
 	uint16_t		efd_type;	/* efd log item type */
 	uint16_t		efd_size;	/* size of this item */
@@ -661,6 +701,14 @@ typedef struct xfs_efd_log_format_64 {
 	xfs_extent_64_t		efd_extents[];	/* array of extents freed */
 } xfs_efd_log_format_64_t;
 
+static inline size_t
+xfs_efd_log_format64_sizeof(
+	unsigned int		nr)
+{
+	return sizeof(struct xfs_efd_log_format_64) +
+			nr * sizeof(struct xfs_extent_64);
+}
+
 /*
  * RUI/RUD (reverse mapping) log format definitions
  */
diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index 12d041da1c..580abf9b15 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -20,9 +20,9 @@ xfs_efi_copy_format(
 {
 	uint i;
 	uint nextents = ((xfs_efi_log_format_t *)buf)->efi_nextents;
-	uint dst_len = sizeof(xfs_efi_log_format_t) + nextents * sizeof(xfs_extent_t);
-	uint len32 = sizeof(xfs_efi_log_format_32_t) + nextents * sizeof(xfs_extent_32_t);
-	uint len64 = sizeof(xfs_efi_log_format_64_t) + nextents * sizeof(xfs_extent_64_t);
+	uint dst_len = xfs_efi_log_format_sizeof(nextents);
+	uint len32 = xfs_efi_log_format32_sizeof(nextents);
+	uint len64 = xfs_efi_log_format64_sizeof(nextents);
 
 	if (len == dst_len || continued) {
 		memcpy((char *)dst_efi_fmt, buf, len);
@@ -86,7 +86,7 @@ xlog_print_trans_efi(
 	*ptr += src_len;
 
 	/* convert to native format */
-	dst_len = sizeof(xfs_efi_log_format_t) + src_f->efi_nextents * sizeof(xfs_extent_t);
+	dst_len = xfs_efi_log_format_sizeof(src_f->efi_nextents);
 
 	if (continued && src_len < core_size) {
 		printf(_("EFI: Not enough data to decode further\n"));

