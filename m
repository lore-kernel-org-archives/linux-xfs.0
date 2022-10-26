Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9917C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Oct 2022 20:08:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234688AbiJZUIU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Oct 2022 16:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234828AbiJZUIQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2022 16:08:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA0013C3EC
        for <linux-xfs@vger.kernel.org>; Wed, 26 Oct 2022 13:08:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01796B82444
        for <linux-xfs@vger.kernel.org>; Wed, 26 Oct 2022 20:08:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97381C433D6;
        Wed, 26 Oct 2022 20:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666814892;
        bh=xyY0zko3/5JbRfJa77hPqpCKYtg3KMpWy8dijX39HJM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=g3i6ia8RpPctZ9DEH+6qxKsqEGM9rT/WDfiEC7dnIX9ur9TZn0VbWC4mDG0ftrW49
         F6FBuCruqpAzTIj8OIU9/v+hDnsKfZBmYyMo7xBD2U34FRhkI5/54346vDlKWx/eIb
         r6l1lOXwfUffSDDRb707Z4X0O+DM2D88DFcTsL4wkZD3ZIzdtg3eLaAXM3DLBLULNN
         zCLzAA1EXvT5JBHED8nrzYplDiH1KBUrYm/ebs8Nv0AGTvNww7WXdht9ORbA3Mczwz
         p7QzOTRrI1wuMxbsC0CnPZ0MqHpMmh+C2491oyro3G3+kUBtOnKcNoa4GldZw/84Ki
         ANekumfgj96vg==
Subject: [PATCH 7/8] xfs: actually abort log recovery on corrupt intent-done
 log items
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Wed, 26 Oct 2022 13:08:12 -0700
Message-ID: <166681489220.3447519.15381302502050780897.stgit@magnolia>
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

If log recovery picks up intent-done log items that are not of the
correct size it needs to abort recovery and fail the mount.  Debug
assertions are not good enough.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_extfree_item.c |   20 ++++++++++++++++----
 fs/xfs/xfs_rmap_item.c    |    6 +++++-
 2 files changed, 21 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index f7e52db8da66..18c224351343 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -751,12 +751,24 @@ xlog_recover_efd_commit_pass2(
 	xfs_lsn_t			lsn)
 {
 	struct xfs_efd_log_format	*efd_formatp;
+	int				buflen = item->ri_buf[0].i_len;
 
 	efd_formatp = item->ri_buf[0].i_addr;
-	ASSERT(item->ri_buf[0].i_len == xfs_efd_log_format32_sizeof(
-						efd_formatp->efd_nextents) ||
-	       item->ri_buf[0].i_len == xfs_efd_log_format64_sizeof(
-						efd_formatp->efd_nextents));
+
+	if (buflen < sizeof(struct xfs_efd_log_format)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
+				efd_formatp, buflen);
+		return -EFSCORRUPTED;
+	}
+
+	if (item->ri_buf[0].i_len != xfs_efd_log_format32_sizeof(
+						efd_formatp->efd_nextents) &&
+	    item->ri_buf[0].i_len != xfs_efd_log_format64_sizeof(
+						efd_formatp->efd_nextents)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
+				efd_formatp, buflen);
+		return -EFSCORRUPTED;
+	}
 
 	xlog_recover_release_intent(log, XFS_LI_EFI, efd_formatp->efd_efi_id);
 	return 0;
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 27047e73f582..5a360c384ea5 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -707,7 +707,11 @@ xlog_recover_rud_commit_pass2(
 	struct xfs_rud_log_format	*rud_formatp;
 
 	rud_formatp = item->ri_buf[0].i_addr;
-	ASSERT(item->ri_buf[0].i_len == sizeof(struct xfs_rud_log_format));
+	if (item->ri_buf[0].i_len != sizeof(struct xfs_rud_log_format)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
+				rud_formatp, item->ri_buf[0].i_len);
+		return -EFSCORRUPTED;
+	}
 
 	xlog_recover_release_intent(log, XFS_LI_RUI, rud_formatp->rud_rui_id);
 	return 0;

