Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E09F5C433DB
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Mar 2021 19:59:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB92461936
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Mar 2021 19:59:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbhCTT7W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 20 Mar 2021 15:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbhCTT6t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 Mar 2021 15:58:49 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A1AC061574;
        Sat, 20 Mar 2021 12:58:49 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id g15so6603897qkl.4;
        Sat, 20 Mar 2021 12:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EhWUWWvovcwqppfOFN8l1mqmbbRdJNS1JO4GqxSZrQg=;
        b=gJPc5bvFAlM+itJgrlrSguPTKjzqhJuHJUZ8GJjf5MXeuUUlKQ99yti+ATPtXpJUIx
         6NCZmpxcObj1zEAxBB2LFggDhMqMODxzlgDirzxyTsKtm4J/VepJ0vL+qGP0WRh2TjgH
         3j+GxE3sRmUetxDmwlgcL4flAvxn4czMkeC+b1asiAIAgG6BemG4o4gw5cIr33ATl/J8
         JFqu5oddpVWyvcAZhT+jFv5iPA7IZDCLutpk4me5U0rd46Bgn0kkRVSQ9dEdgpZ2QqyB
         hGSiNLILIU3Wbg/MjsPVEIXj30Xhcl8dGXve5v+zr45qpkPsYQsZ77yz8n6rP2wxRcAM
         +E7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EhWUWWvovcwqppfOFN8l1mqmbbRdJNS1JO4GqxSZrQg=;
        b=LrPuYxCl0UgeoWz0XrO3BduRJbQbzzZYVQtwk7pQvCZT0tWD5U0yEg6uv85iVQcJXQ
         J9MTFEo+HsJAZOAq5d6kKk9C+813gX6ztIdKdVYAIqgZeaLuNrKbWNy+UrhAzEimtuDN
         WHe961/slyoVYsfuK7OVOQQVze1+JGMeh/hqDf14YyiofKFTNizOc5WBGz8OE6XxHnee
         lnEv8GXhpAYePwv9sclTbikaHuSDc0tAhfhUltU2hhLH2pAUvyiTUKDwko1RAq00xnLm
         yN0viyhXs79SV6QKzjyjxIpe8sPrPpdaJBuccfRLC9MlXaZ67/TGtUkmzK45IqGBDRN9
         SWOQ==
X-Gm-Message-State: AOAM532IhVJAxZB+sKw507p0pi4UL+AqRuO9WP6aUq52sxTyidQq74DX
        7D2iN87JkjL7rlsQ7J1D6V0=
X-Google-Smtp-Source: ABdhPJwijJfQAnXHukWWBWqRG86wranIjOOAiVxh5LXdINlls7rrB5LzGQ8BCOdi+nAc+51KP2qJ7g==
X-Received: by 2002:a37:a404:: with SMTP id n4mr4192009qke.439.1616270328487;
        Sat, 20 Mar 2021 12:58:48 -0700 (PDT)
Received: from localhost.localdomain ([138.199.13.205])
        by smtp.gmail.com with ESMTPSA id z5sm6409711qtc.42.2021.03.20.12.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 12:58:48 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     djwong@kernel.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] xfs: Rudimentary typo fixes
Date:   Sun, 21 Mar 2021 01:26:26 +0530
Message-Id: <20210320195626.19400-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


s/filesytem/filesystem/
s/instrumention/instrumentation/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 fs/xfs/xfs_log_recover.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 97f31308de03..ffa4f6f2f31e 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2736,7 +2736,7 @@ xlog_recover_process_one_iunlink(
  * of log space.
  *
  * This behaviour is bad for latency on single CPU and non-preemptible kernels,
- * and can prevent other filesytem work (such as CIL pushes) from running. This
+ * and can prevent other filesystem work (such as CIL pushes) from running. This
  * can lead to deadlocks if the recovery process runs out of log reservation
  * space. Hence we need to yield the CPU when there is other kernel work
  * scheduled on this CPU to ensure other scheduled work can run without undue
@@ -3404,7 +3404,7 @@ xlog_recover(

 		/*
 		 * Delay log recovery if the debug hook is set. This is debug
-		 * instrumention to coordinate simulation of I/O failures with
+		 * instrumentation to coordinate simulation of I/O failures with
 		 * log recovery.
 		 */
 		if (xfs_globals.log_recovery_delay) {
--
2.26.2

