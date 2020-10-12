Return-Path: <SRS0=uuBg=DT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6661CC43457
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 09:30:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E0C42087D
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 09:30:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VYjBIVII"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729385AbgJLJaO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Oct 2020 05:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729400AbgJLJaO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Oct 2020 05:30:14 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448F1C0613CE
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2020 02:30:14 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o3so3674809pgr.11
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2020 02:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+bgmOXbqX3HYoQ4PudDQQARNyVCYQFk1AStVK7J5N9I=;
        b=VYjBIVIIANBxXawyq6rrsExl0IigqkLAkyQolC99wbAOV81PjnTYyMdkEXP4xdnH3p
         XKOkrlL1Tc2bhlc6FuXt8z2jOU3EOb+oN8g77iIwjz6YuaAzR577kpq7pK98t7dL7Wv/
         DzKjxt3RDGXTfw2rf/yx0+mIRUR5dD5bbItm4xzHd1W0dVVihoQt0gdIxquxGcJCtD6F
         0LoY57ABkm27ppJWukntleVPi+Mwk6vmhFwUiBgOvZ/kOTiVBYHiNTaaME1dhXbNwx6A
         77u3AkPE0e16iqnaq+IqPLWxZIZ9Qbc0LvRE286Bguo5ySeZ3/fZS9+AtawvzsF0C1yZ
         Au4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+bgmOXbqX3HYoQ4PudDQQARNyVCYQFk1AStVK7J5N9I=;
        b=GSmh7vnW24WXcn3lhyG/z5AMpG2QjFwWwcROUi/Ydidd6/xkeMuuJnLrTErj2MBMOY
         0EC7bHj00Fo7Jt4/uYYpVZmGbSKyyIXQnx4eC0lt7jKcp9Ft0xDvHA5QTW9hPVFmPAPT
         hPLmWWEwmXHiqVMUJpTepxT/ZR4GYnIDl4WUk8mMCwT1RRKc27yTaCNPDEgA+DR04UCa
         kJ+E0st1zR4eAxhrQDwP1i04s4R7pMJKa7/BN/QdsHiEHEggVxwHnkkf7UxX/Ia5PHKG
         y228sl+zEt+QtJZMTlc9vIM6ejb14Qg7+i6jaP27pa8oyq3wg+S/EH3z01GHOAD/3kAJ
         7aHw==
X-Gm-Message-State: AOAM5315M6YT5dJV2xc+pxBrEVDaIeyzQIM9A/CTOSTgEBq7qGIIOpkb
        AvfmZaJZZrhPfScnRt0U+MrCrOpr5Lo=
X-Google-Smtp-Source: ABdhPJzmI/SpWYOJTrxX6Z1KPrWkmtlOcGImWJAMPF/coXUyjsFafpcOygbTRU0rFtCf+JsOAskkLQ==
X-Received: by 2002:a17:90a:77c9:: with SMTP id e9mr17942522pjs.24.1602495013539;
        Mon, 12 Oct 2020 02:30:13 -0700 (PDT)
Received: from localhost.localdomain ([122.172.180.109])
        by smtp.gmail.com with ESMTPSA id z142sm19451985pfc.179.2020.10.12.02.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 02:30:12 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V6 03/11] xfs: Check for extent overflow when punching a hole
Date:   Mon, 12 Oct 2020 14:59:30 +0530
Message-Id: <20201012092938.50946-4-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012092938.50946-1-chandanrlinux@gmail.com>
References: <20201012092938.50946-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The extent mapping the file offset at which a hole has to be
inserted will be split into two extents causing extent count to
increase by 1.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h |  7 +++++++
 fs/xfs/xfs_bmap_item.c         | 15 +++++++++------
 fs/xfs/xfs_bmap_util.c         | 10 ++++++++++
 3 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 7fc2b129a2e7..bcac769a7df6 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -40,6 +40,13 @@ struct xfs_ifork {
  */
 #define XFS_IEXT_ADD_NOSPLIT_CNT	(1)
 
+/*
+ * Punching out an extent from the middle of an existing extent can cause the
+ * extent count to increase by 1.
+ * i.e. | Old extent | Hole | Old extent |
+ */
+#define XFS_IEXT_PUNCH_HOLE_CNT		(1)
+
 /*
  * Fork handling.
  */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 1610d6ad089b..80d828394158 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -439,6 +439,7 @@ xfs_bui_item_recover(
 	xfs_exntst_t			state;
 	unsigned int			bui_type;
 	int				whichfork;
+	int				iext_delta;
 	int				error = 0;
 
 	/* Only one mapping operation per BUI... */
@@ -497,12 +498,14 @@ xfs_bui_item_recover(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	if (bui_type == XFS_BMAP_MAP) {
-		error = xfs_iext_count_may_overflow(ip, whichfork,
-				XFS_IEXT_ADD_NOSPLIT_CNT);
-		if (error)
-			goto err_cancel;
-	}
+	if (bui_type == XFS_BMAP_MAP)
+		iext_delta = XFS_IEXT_ADD_NOSPLIT_CNT;
+	else
+		iext_delta = XFS_IEXT_PUNCH_HOLE_CNT;
+
+	error = xfs_iext_count_may_overflow(ip, whichfork, iext_delta);
+	if (error)
+		goto err_cancel;
 
 	count = bmap->me_len;
 	error = xfs_trans_log_finish_bmap_update(tp, budp, bui_type, ip,
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index dcd6e61df711..0776abd0103c 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -891,6 +891,11 @@ xfs_unmap_extent(
 
 	xfs_trans_ijoin(tp, ip, 0);
 
+	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+			XFS_IEXT_PUNCH_HOLE_CNT);
+	if (error)
+		goto out_trans_cancel;
+
 	error = xfs_bunmapi(tp, ip, startoffset_fsb, len_fsb, 0, 2, done);
 	if (error)
 		goto out_trans_cancel;
@@ -1176,6 +1181,11 @@ xfs_insert_file_space(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
+	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+			XFS_IEXT_PUNCH_HOLE_CNT);
+	if (error)
+		goto out_trans_cancel;
+
 	/*
 	 * The extent shifting code works on extent granularity. So, if stop_fsb
 	 * is not the starting block of extent, we need to split the extent at
-- 
2.28.0

