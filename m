Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30217C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:31:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236235AbiLaCbX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:31:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236141AbiLaCbW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:31:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72FC71CB21
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:31:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FC8161CD4
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:31:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7368DC433D2;
        Sat, 31 Dec 2022 02:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453880;
        bh=lvvbPKaUTmphH/AWq+fhzw327SeeM5MTCtYs736SZvs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bL6I+8qUNdMWq0hB/FDt/6Mb32aPOW+pbMRBbM0tgC2NV+mT8xOQCeZoqd9bbj3DV
         WssImQaKjcoUKsvqQ36RRG1/BoeXx1WAp29l9jP8CBYepmA94jPs+VpotAAGPlVZFC
         TY+lx8MmOqHW/GoyzdkLNsl5vCqcIIOu5W6DmlDbYFmtVMjTZZcWJsaaL8tQXeznwu
         55D4NdX3Dp9W/JTcsDVf81CTAae5GNiH4YQBa3chBDdSs5H5Y7hHQlIvkOxY4kW411
         INp496g0hGwR08ReUY8GbRPllf5UijpmiCYIetvn5PuMPSvk/X/E4ZKiZYQcntKfSt
         Lzw3yRa/J79DQ==
Subject: [PATCH 05/45] xfs: grow the realtime section when realtime groups are
 enabled
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:44 -0800
Message-ID: <167243878432.731133.18391590584377747462.stgit@magnolia>
In-Reply-To: <167243878346.731133.14642166452774753637.stgit@magnolia>
References: <167243878346.731133.14642166452774753637.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Enable growing the rt section when realtime groups are enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_shared.h |    1 +
 1 file changed, 1 insertion(+)


diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index e76e735b1d0..bcdf298889a 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -111,6 +111,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 #define	XFS_TRANS_SB_RBLOCKS		0x00000800
 #define	XFS_TRANS_SB_REXTENTS		0x00001000
 #define	XFS_TRANS_SB_REXTSLOG		0x00002000
+#define XFS_TRANS_SB_RGCOUNT		0x00004000
 
 /*
  * Here we centralize the specification of XFS meta-data buffer reference count

