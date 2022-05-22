Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07BD4C433F5
	for <linux-xfs@archiver.kernel.org>; Sun, 22 May 2022 15:28:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347999AbiEVP2f (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 May 2022 11:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241366AbiEVP2e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 May 2022 11:28:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA72C38BF6
        for <linux-xfs@vger.kernel.org>; Sun, 22 May 2022 08:28:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D658B80AC0
        for <linux-xfs@vger.kernel.org>; Sun, 22 May 2022 15:28:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39997C385AA;
        Sun, 22 May 2022 15:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653233311;
        bh=xi9Wem/Ew39Ob0/A2RHtNlN+nqdvEIHK3O0BEBJC3BM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=utyO8JVfihYHuTKskmpIwAjo7S8vP3990RVpzHcOMXWcjyJleTSej8q70t7UZIyzZ
         3nqoZH7h++y1ZUbAVFV1LwZNZtRni3jcE12PrzFVFXctiIa1/fcffBcDwjOOuPRTRR
         daEsXYOia5WyB0a1p2dbG9crC2hMd4Cy36ZmHhlsdISf5rOeqeKuYm+1jrGvOniDgb
         8nhbjm+JEnvVZSXoVbHD1aiyt7uQqUh18hTDXbtTR2/A3LtxfCoxGD9ZnUVQCf+VCS
         3gRR+ovUC2XOYOL1vknpr+Dz2VBrGWnN6IMyxks4yoj1NIC4KaDNB/SPMgBeuv2nOF
         VDZuOLDLMIChg==
Subject: [PATCH 3/5] xfs: warn about LARP once per day
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Sun, 22 May 2022 08:28:30 -0700
Message-ID: <165323331075.78886.2887944532927333265.stgit@magnolia>
In-Reply-To: <165323329374.78886.11371349029777433302.stgit@magnolia>
References: <165323329374.78886.11371349029777433302.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Since LARP is an experimental debug-only feature, we should try to warn
about it being in use once per day, not once per reboot.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 9dc748abdf33..edd077e055d5 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3910,8 +3910,8 @@ xfs_attr_use_log_assist(
 	if (error)
 		goto drop_incompat;
 
-	xfs_warn_once(mp,
-"EXPERIMENTAL logged extended attributes feature added. Use at your own risk!");
+	xfs_warn_daily(mp,
+ "EXPERIMENTAL logged extended attributes feature added. Use at your own risk!");
 
 	return 0;
 drop_incompat:

