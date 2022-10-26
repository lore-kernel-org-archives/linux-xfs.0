Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 271E3C38A2D
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Oct 2022 20:08:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234705AbiJZUI1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Oct 2022 16:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234821AbiJZUIW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2022 16:08:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3E113C3D8
        for <linux-xfs@vger.kernel.org>; Wed, 26 Oct 2022 13:08:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1118B82441
        for <linux-xfs@vger.kernel.org>; Wed, 26 Oct 2022 20:08:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50387C433C1;
        Wed, 26 Oct 2022 20:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666814898;
        bh=bXkmiY30WaUUyDjsKqs6xsfqH175DY2SHbKntChq+NI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=g4UENsY740CXNGfhgT3Quf1hVSuVGpEL5RK7kPpMT/rjNdbymn37RNO3vKxN/HJL7
         BYM9c3Iy1XuXwPJKyrME1oq+yn7+4LHUcqXZeef4qodVTqF2ld0CVb5sLPXnLsldF9
         NTU//tsHVrrDX97QVDUe/6yK8dMWaR9wn3j3rCWlkjD1K/rKJIpVd+Fnp60eMX7YIE
         422yhxTNpTF+T6T1B82vt+fETRqeKdPnffYeH//PhI4kCk08ICDrZbnS1+Zq6vyS00
         X4g+CEKo4P7M1+iD5hXbbRs0whKwEaULdsbmfjOgoY/jHKSk5M0CAlCNWIyaT/fruV
         Xwwm65HhnSv+g==
Subject: [PATCH 8/8] xfs: dump corrupt recovered log intent items to dmesg
 consistently
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Wed, 26 Oct 2022 13:08:17 -0700
Message-ID: <166681489778.3447519.2620356479140584610.stgit@magnolia>
In-Reply-To: <166681485271.3447519.6520343630713202644.stgit@magnolia>
References: <166681485271.3447519.6520343630713202644.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If log recovery decides that an intent item is corrupt and wants to
abort the mount, capture a hexdump of the corrupt log item in the kernel
log for further analysis.  Some of the log item code already did this,
so we're fixing the rest to do it consistently.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_attr_item.c     |   15 ++++++++++-----
 fs/xfs/xfs_bmap_item.c     |   12 ++++++++----
 fs/xfs/xfs_extfree_item.c  |    6 ++++--
 fs/xfs/xfs_refcount_item.c |   16 +++++++++++-----
 fs/xfs/xfs_rmap_item.c     |   10 +++++++---
 5 files changed, 40 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index ee8f678a10a1..6e0c62af827c 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -717,24 +717,28 @@ xlog_recover_attri_commit_pass2(
 	/* Validate xfs_attri_log_format before the large memory allocation */
 	len = sizeof(struct xfs_attri_log_format);
 	if (item->ri_buf[0].i_len != len) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
 		return -EFSCORRUPTED;
 	}
 
 	if (!xfs_attri_validate(mp, attri_formatp)) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
 		return -EFSCORRUPTED;
 	}
 
 	/* Validate the attr name */
 	if (item->ri_buf[1].i_len !=
 			xlog_calc_iovec_len(attri_formatp->alfi_name_len)) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				item->ri_buf[1].i_addr, item->ri_buf[1].i_len);
 		return -EFSCORRUPTED;
 	}
 
 	if (!xfs_attr_namecheck(attr_name, attri_formatp->alfi_name_len)) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				item->ri_buf[1].i_addr, item->ri_buf[1].i_len);
 		return -EFSCORRUPTED;
 	}
 
@@ -834,7 +838,8 @@ xlog_recover_attrd_commit_pass2(
 
 	attrd_formatp = item->ri_buf[0].i_addr;
 	if (item->ri_buf[0].i_len != sizeof(struct xfs_attrd_log_format)) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
+				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
 		return -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index a1da6205252b..41323da523d1 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -644,18 +644,21 @@ xlog_recover_bui_commit_pass2(
 	bui_formatp = item->ri_buf[0].i_addr;
 
 	if (item->ri_buf[0].i_len < xfs_bui_log_format_sizeof(0)) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
 		return -EFSCORRUPTED;
 	}
 
 	if (bui_formatp->bui_nextents != XFS_BUI_MAX_FAST_EXTENTS) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
 		return -EFSCORRUPTED;
 	}
 
 	len = xfs_bui_log_format_sizeof(bui_formatp->bui_nextents);
 	if (item->ri_buf[0].i_len != len) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
 		return -EFSCORRUPTED;
 	}
 
@@ -694,7 +697,8 @@ xlog_recover_bud_commit_pass2(
 
 	bud_formatp = item->ri_buf[0].i_addr;
 	if (item->ri_buf[0].i_len != sizeof(struct xfs_bud_log_format)) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
+				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
 		return -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 18c224351343..d5130d1fcfae 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -216,7 +216,8 @@ xfs_efi_copy_format(xfs_log_iovec_t *buf, xfs_efi_log_format_t *dst_efi_fmt)
 		}
 		return 0;
 	}
-	XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
+	XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, NULL, buf->i_addr,
+			buf->i_len);
 	return -EFSCORRUPTED;
 }
 
@@ -711,7 +712,8 @@ xlog_recover_efi_commit_pass2(
 	efi_formatp = item->ri_buf[0].i_addr;
 
 	if (item->ri_buf[0].i_len < xfs_efi_log_format_sizeof(0)) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
 		return -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 24cf4c64ebaa..858e3e9eb4a8 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -523,7 +523,9 @@ xfs_cui_item_recover(
 			type = refc_type;
 			break;
 		default:
-			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					&cuip->cui_format,
+					sizeof(cuip->cui_format));
 			error = -EFSCORRUPTED;
 			goto abort_error;
 		}
@@ -536,7 +538,8 @@ xfs_cui_item_recover(
 				&new_fsb, &new_len, &rcur);
 		if (error == -EFSCORRUPTED)
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-					refc, sizeof(*refc));
+					&cuip->cui_format,
+					sizeof(cuip->cui_format));
 		if (error)
 			goto abort_error;
 
@@ -658,13 +661,15 @@ xlog_recover_cui_commit_pass2(
 	cui_formatp = item->ri_buf[0].i_addr;
 
 	if (item->ri_buf[0].i_len < xfs_cui_log_format_sizeof(0)) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
 		return -EFSCORRUPTED;
 	}
 
 	len = xfs_cui_log_format_sizeof(cui_formatp->cui_nextents);
 	if (item->ri_buf[0].i_len != len) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
 		return -EFSCORRUPTED;
 	}
 
@@ -703,7 +708,8 @@ xlog_recover_cud_commit_pass2(
 
 	cud_formatp = item->ri_buf[0].i_addr;
 	if (item->ri_buf[0].i_len != sizeof(struct xfs_cud_log_format)) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
+				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
 		return -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 5a360c384ea5..534504ede1a3 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -557,7 +557,9 @@ xfs_rui_item_recover(
 			type = XFS_RMAP_FREE;
 			break;
 		default:
-			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					&ruip->rui_format,
+					sizeof(ruip->rui_format));
 			error = -EFSCORRUPTED;
 			goto abort_error;
 		}
@@ -663,13 +665,15 @@ xlog_recover_rui_commit_pass2(
 	rui_formatp = item->ri_buf[0].i_addr;
 
 	if (item->ri_buf[0].i_len < xfs_rui_log_format_sizeof(0)) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
 		return -EFSCORRUPTED;
 	}
 
 	len = xfs_rui_log_format_sizeof(rui_formatp->rui_nextents);
 	if (item->ri_buf[0].i_len != len) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				item->ri_buf[0].i_addr, item->ri_buf[0].i_len);
 		return -EFSCORRUPTED;
 	}
 

