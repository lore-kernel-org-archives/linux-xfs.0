Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4529C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 20:48:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbiF1Usp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiF1Usn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:48:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48DAC2FFD1
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 13:48:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46AE1B81E06
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 20:48:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35E9C341C8;
        Tue, 28 Jun 2022 20:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656449318;
        bh=567PYF198SZgILpbhROV4h251ujmBnn467Vqm7nAhqo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=m24/lnZ8an/+Rit5X48QujPirZqjIMWjyhqnqAcl1TAEE1cDuDL6tOvi5wiExB3ht
         Eb7Og1Pr1wN1Fmpc/TdjA5MVVW9WMl+O2k+zJF9HYWyWxwX/poI3yJulmxjFhtpw7k
         nt6aPTYbtqsZz+RJTgn4FLzlI2Spsl/ClMo1M7A/jAgKw9o9DRMbn3apDsEW/NZjtJ
         wCdw7TxYkN0XNdISuli1bfcx05ELI5AI5CeytWUo2XBSQaLTu+a+3YuGveJMyx8mPX
         6x7JhRlmVNitiBJSl/GTjjOR0n3m8+Kb8FCc+v9c0a8AypH9jXX27uoA3Q8ic1mLc5
         8/x6hcWwuRd+A==
Subject: [PATCH 2/8] xfs_logprint: fix formatting specifiers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 28 Jun 2022 13:48:37 -0700
Message-ID: <165644931754.1089724.16023443761407042271.stgit@magnolia>
In-Reply-To: <165644930619.1089724.12201433387040577983.stgit@magnolia>
References: <165644930619.1089724.12201433387040577983.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix a missing %u -> %PRIu32 conversion, and add the required '%' in the
format specifiers because PRIu{32,64} do not include it on their own.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 logprint/log_print_all.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index f7c32d6a..8d3ede19 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -267,7 +267,7 @@ xlog_recover_print_inode_core(
 			xlog_extract_dinode_ts(di->di_ctime));
 	printf(_("		flushiter:%d\n"), di->di_flushiter);
 	printf(_("		size:0x%llx  nblks:0x%llx  exsize:%d  "
-	     "nextents:" PRIu64 "  anextents:%u\n"), (unsigned long long)
+	     "nextents:%" PRIu64 "  anextents:%" PRIu32 "\n"), (unsigned long long)
 	       di->di_size, (unsigned long long)di->di_nblocks,
 	       di->di_extsize, nextents, anextents);
 	printf(_("		forkoff:%d  dmevmask:0x%x  dmstate:%d  flags:0x%x  "

