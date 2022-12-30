Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79F9DC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:14:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236181AbiLaCOD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:14:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236179AbiLaCOB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:14:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E35D91C430
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:14:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99343B81E52
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:13:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 542F1C433EF;
        Sat, 31 Dec 2022 02:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452838;
        bh=ntuxThvpCds/q6yYaUpK0iyADc642WnQv/rclgwqfgk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eRIOT/cYuFQlhthajetnNpX7I9BX1Q3XRFlX6+jxBPQQ8D9hWmXf2h95ZQWVEMLJj
         +6PGa1SWVWxA6h8ZhbB6fMWfkTKZiRrTh5FRThZrtt+fq6eCOlw5UCWndTpzL4oDh4
         SK7mVEhnCfUA6AYGZd6Y7DiEvwWvLU1ixxHa7se89dJPwjV/H7tjpb1eJGUJhGky7p
         ozB5TieNg0NmouN+816d+XJcKYPt13UWFK/NCoEP/U+tBQrArNaiwzO2tlpFN6Krq6
         AUZciZlTNGLfx5xDZmo+1LjfDHLCeajZ+YyuFNVnm+KZtyTq6eKRduyAyob5hP+1tw
         BxtxGn65omWbg==
Subject: [PATCH 16/46] xfs: allow bulkstat to return metadata directories
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:21 -0800
Message-ID: <167243876148.725900.1045487481097112001.stgit@magnolia>
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

Allow the V5 bulkstat ioctl to return information about metadata
directory files so that xfs_scrub can find and scrub them, since they
are otherwise ordinary directories.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_fs.h |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 7de31a6692a..6e0c45fcfee 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -485,9 +485,17 @@ struct xfs_bulk_ireq {
  */
 #define XFS_BULK_IREQ_NREXT64	(1U << 2)
 
+/*
+ * Allow bulkstat to return information about metadata directories.  This
+ * enables xfs_scrub to find them for scanning, as they are otherwise ordinary
+ * directories.
+ */
+#define XFS_BULK_IREQ_METADIR	(1U << 31)
+
 #define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO |	 \
 				 XFS_BULK_IREQ_SPECIAL | \
-				 XFS_BULK_IREQ_NREXT64)
+				 XFS_BULK_IREQ_NREXT64 | \
+				 XFS_BULK_IREQ_METADIR)
 
 /* Operate on the root directory inode. */
 #define XFS_BULK_IREQ_SPECIAL_ROOT	(1)

