Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8960C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:16:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236189AbiLaCQG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:16:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbiLaCQG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:16:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF2A2DD6
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:16:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F09F9B81E5A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:16:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB630C433D2;
        Sat, 31 Dec 2022 02:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452962;
        bh=6nEiyUwYOCZxvNYx4g9sepYJpt0ErlRk4WOJX3bLQhs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Ce9aHprY3/2M7B41Twsc+PNJB7gGa2fkxJoreWGyF4YoR6aDuKTEu01/rS6DXMDPS
         Q90ZHfUJEmul9atfyntYgkpQSTO+sxFtpB/nDqfTXJJTNVFk7v+LtPKER1M8bl5hjE
         JSHCbbmLGpcKW6wGdldUugYWdJhx4QE0KRvdELFfIQ3n5TZunXVDoMSIieXZ2w8jp5
         S3avVVuibFdi2NgK9Mb/iomjScXvhHDxrScQED+tFXYezwhx4CS2oTmppLAdANb1HV
         ff9ma7Lg0F8JMUSkVRSzMsNMnn9T8xzecBXRlB3QMGCH92P2+OLBsGgxIh1bXjIlHx
         69KK6FPRO/M+A==
Subject: [PATCH 24/46] xfs_db: mask superblock fields when metadir feature is
 enabled
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:22 -0800
Message-ID: <167243876250.725900.12673636848921853417.stgit@magnolia>
In-Reply-To: <167243875924.725900.7061782826830118387.stgit@magnolia>
References: <167243875924.725900.7061782826830118387.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When the metadata directory feature is enabled, mask the superblock
fields (rt, quota inodes) that got migrated to the directory tree.
Similarly, hide the 'metadirino' field when the feature is disabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/sb.c |   41 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 5 deletions(-)


diff --git a/db/sb.c b/db/sb.c
index 8a54ff7b00c..d7df55e02e9 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -50,6 +50,30 @@ sb_init(void)
 	add_command(&version_cmd);
 }
 
+/*
+ * Counts superblock fields that only exist when the metadata directory feature
+ * is enabled.
+ */
+static int
+metadirino_count(
+	void		*obj,
+	int		startoff)
+{
+	return xfs_has_metadir(mp) ? 1 : 0;
+}
+
+/*
+ * Counts superblock fields that only existed before the metadata directory
+ * feature came along.
+ */
+static int
+rootino_count(
+	void		*obj,
+	int		startoff)
+{
+	return xfs_has_metadir(mp) ? 0 : 1;
+}
+
 #define	OFF(f)	bitize(offsetof(struct xfs_dsb, sb_ ## f))
 #define	SZC(f)	szcount(struct xfs_dsb, sb_ ## f)
 const field_t	sb_flds[] = {
@@ -61,8 +85,12 @@ const field_t	sb_flds[] = {
 	{ "uuid", FLDT_UUID, OI(OFF(uuid)), C1, 0, TYP_NONE },
 	{ "logstart", FLDT_DFSBNO, OI(OFF(logstart)), C1, 0, TYP_LOG },
 	{ "rootino", FLDT_INO, OI(OFF(rootino)), C1, 0, TYP_INODE },
-	{ "rbmino", FLDT_INO, OI(OFF(rbmino)), C1, 0, TYP_INODE },
-	{ "rsumino", FLDT_INO, OI(OFF(rsumino)), C1, 0, TYP_INODE },
+	{ "metadirino", FLDT_INO, OI(OFF(rbmino)), metadirino_count,
+	  FLD_COUNT, TYP_INODE },
+	{ "rbmino", FLDT_INO, OI(OFF(rbmino)), rootino_count, FLD_COUNT,
+	  TYP_INODE },
+	{ "rsumino", FLDT_INO, OI(OFF(rsumino)), rootino_count, FLD_COUNT,
+	  TYP_INODE },
 	{ "rextsize", FLDT_AGBLOCK, OI(OFF(rextsize)), C1, 0, TYP_NONE },
 	{ "agblocks", FLDT_AGBLOCK, OI(OFF(agblocks)), C1, 0, TYP_NONE },
 	{ "agcount", FLDT_AGNUMBER, OI(OFF(agcount)), C1, 0, TYP_NONE },
@@ -85,8 +113,10 @@ const field_t	sb_flds[] = {
 	{ "ifree", FLDT_UINT64D, OI(OFF(ifree)), C1, 0, TYP_NONE },
 	{ "fdblocks", FLDT_UINT64D, OI(OFF(fdblocks)), C1, 0, TYP_NONE },
 	{ "frextents", FLDT_UINT64D, OI(OFF(frextents)), C1, 0, TYP_NONE },
-	{ "uquotino", FLDT_INO, OI(OFF(uquotino)), C1, 0, TYP_INODE },
-	{ "gquotino", FLDT_INO, OI(OFF(gquotino)), C1, 0, TYP_INODE },
+	{ "uquotino", FLDT_INO, OI(OFF(uquotino)), rootino_count, FLD_COUNT,
+	  TYP_INODE },
+	{ "gquotino", FLDT_INO, OI(OFF(gquotino)), rootino_count, FLD_COUNT,
+	  TYP_INODE },
 	{ "qflags", FLDT_UINT16X, OI(OFF(qflags)), C1, 0, TYP_NONE },
 	{ "flags", FLDT_UINT8X, OI(OFF(flags)), C1, 0, TYP_NONE },
 	{ "shared_vn", FLDT_UINT8D, OI(OFF(shared_vn)), C1, 0, TYP_NONE },
@@ -110,7 +140,8 @@ const field_t	sb_flds[] = {
 		C1, 0, TYP_NONE },
 	{ "crc", FLDT_CRC, OI(OFF(crc)), C1, 0, TYP_NONE },
 	{ "spino_align", FLDT_EXTLEN, OI(OFF(spino_align)), C1, 0, TYP_NONE },
-	{ "pquotino", FLDT_INO, OI(OFF(pquotino)), C1, 0, TYP_INODE },
+	{ "pquotino", FLDT_INO, OI(OFF(pquotino)), rootino_count, FLD_COUNT,
+	  TYP_INODE },
 	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
 	{ "meta_uuid", FLDT_UUID, OI(OFF(meta_uuid)), C1, 0, TYP_NONE },
 	{ NULL }

