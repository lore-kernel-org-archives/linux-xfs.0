Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65648C4167B
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Dec 2022 19:45:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236663AbiLMTps (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 14:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236292AbiLMTpr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 14:45:47 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DFF32648C;
        Tue, 13 Dec 2022 11:45:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BCB17CE1784;
        Tue, 13 Dec 2022 19:45:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006FAC433D2;
        Tue, 13 Dec 2022 19:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670960743;
        bh=H6sFmYbco8LL+0o7vvmGkF13QMXz8PHKYoiLXxW+LXo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=s4mYqp/QS3Oqo9N3/9iyi7f5fyauHFGH5mdLXx8OExZSSH2K/9Z9ld+Qje90VNz/i
         8p39rkTiv3Qzab7Ok/YLikB8JgIL+782t21jQ588DUlK9rkqSvpFCcsjTXRcl9aDvH
         egTQ6uzT+OoAAastVM+scgf5JsJ7CC/jMXkg0p4h4fC4whLDDqKdlN14Tn8f6dScxQ
         94pEiZMVg2AtUMLaCqRInttPh6mV3ENgWREpljCHUVQ5sI9fH0MYY+espaDbhxM2+W
         A2y2dvLDf4lvYrj9umQ5R+tcWTfW1KHLZ13dBApGGXUAMdsprPDtEPvKhh7EHXTL7t
         gW40UoG6fNycA==
Subject: [PATCH 1/1] xfs/122: fix EFI/EFD log format structure size after flex
 array conversion
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 13 Dec 2022 11:45:42 -0800
Message-ID: <167096074260.1750519.311637326793150150.stgit@magnolia>
In-Reply-To: <167096073708.1750519.5668846655153278713.stgit@magnolia>
References: <167096073708.1750519.5668846655153278713.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Adjust this test since made EFI/EFD log item format structs proper flex
arrays instead of array[1].

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/122.out |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index a56cbee84f..95e53c5081 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -161,10 +161,10 @@ sizeof(xfs_disk_dquot_t) = 104
 sizeof(xfs_dq_logformat_t) = 24
 sizeof(xfs_dqblk_t) = 136
 sizeof(xfs_dsb_t) = 264
-sizeof(xfs_efd_log_format_32_t) = 28
-sizeof(xfs_efd_log_format_64_t) = 32
-sizeof(xfs_efi_log_format_32_t) = 28
-sizeof(xfs_efi_log_format_64_t) = 32
+sizeof(xfs_efd_log_format_32_t) = 16
+sizeof(xfs_efd_log_format_64_t) = 16
+sizeof(xfs_efi_log_format_32_t) = 16
+sizeof(xfs_efi_log_format_64_t) = 16
 sizeof(xfs_error_injection_t) = 8
 sizeof(xfs_exntfmt_t) = 4
 sizeof(xfs_exntst_t) = 4

