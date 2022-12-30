Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C5E6C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:46:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236239AbiLaCqp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:46:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiLaCqm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:46:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 743A98FE9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:46:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24306B81E69
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:46:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D85C433F0;
        Sat, 31 Dec 2022 02:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454798;
        bh=HIpczFmRXynC5wbjMVlIyEaqsu7WiAShcjRaspZ5O7I=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KZk6wAPk0aZaOW0VZCIw1x/kObP1E/dEzCHeJ43415IrYZ69ZTkmZC+Mi85GNm1HX
         zSSnx8tkklsyICoszCjhrC/6zMn/5raIKhrJwMtO4W96Q3Dv6t0COaXE64TvZvZEUm
         m0qKXkrOzCUSM2DwUslphszwT9PCFmX+cfgZP7IFq+h0ZbxUaa/Du02b+DgReuCRVP
         CnI3oYttAKmUppis1vXbDvY3mhu9XvdOjteEPjCdW7JOXYCYzf4ic5Tk8SHsDtEuZw
         vILwUe8QMn1bagSWlX32gop7mFIkflvJJ4vX6BsqgVCXbEoqdTk8v1IefQ1UHULIk1
         uMbGhgrwlO/xA==
Subject: [PATCH 16/41] xfs: scrub the realtime rmapbt
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:58 -0800
Message-ID: <167243879806.732820.2902628043000935280.stgit@magnolia>
In-Reply-To: <167243879574.732820.4725863402652761218.stgit@magnolia>
References: <167243879574.732820.4725863402652761218.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Check the realtime reverse mapping btree against the rtbitmap, and
modify the rtbitmap scrub to check against the rtrmapbt.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_fs.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 5c557d5ff13..8547ba85c55 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -744,9 +744,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_HEALTHY	27	/* everything checked out ok */
 #define XFS_SCRUB_TYPE_RGSUPER	28	/* realtime superblock */
 #define XFS_SCRUB_TYPE_RGBITMAP	29	/* realtime group bitmap */
+#define XFS_SCRUB_TYPE_RTRMAPBT	30	/* rtgroup reverse mapping btree */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	30
+#define XFS_SCRUB_TYPE_NR	31
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1u << 0)

