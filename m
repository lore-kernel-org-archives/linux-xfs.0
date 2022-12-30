Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82BCFC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:34:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236244AbiLaCd7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:33:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236243AbiLaCd7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:33:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8363D26D9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:33:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3ECE4B81DED
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2FB0C433D2;
        Sat, 31 Dec 2022 02:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454036;
        bh=VAhmcfNQEaTNX7DChoQS48AFAvs/CIv/NO9I60W4Q0w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=iqIzwhfsN0NjErs4YYpId35qr41YFF+mireiwyWJtEg1r/AUx9suPKf/zh+UVED+y
         XR7emWJ2PNf+mpQcMWeOmPnv8w/GOyIHOhOIauim2PVSJr71Ta7m5VEZ5Qc6bq1JgB
         Uc0BhXgfKBCft3kCoMIpyestno+Ey+vmxd7zG6MKrmXeSLc2b90NPF3VcnGbxu2NSz
         X9d5XmFlHrkLkpC50L7vzGg/r+DO/gn4c0BTgwWMvRHcTdn3ZamaE98Zb49VoNOou1
         t5YgNcfxagxxoUnFx8vgtkPLo/FYK+JN7N3wHbz0KCvIersBkf4FFOVhAHrFhXZshs
         axQXm27/pBIJA==
Subject: [PATCH 15/45] xfs: encode the rtsummary in big endian format
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:45 -0800
Message-ID: <167243878562.731133.13874280726766187783.stgit@magnolia>
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

Currently, the ondisk realtime summary file counters are accessed in
units of 32-bit words.  There's no endian translation of the contents of
this file, which means that the Bad Things Happen(tm) if you go from
(say) x86 to powerpc.  Since we have a new feature flag, let's take the
opportunity to enforce an endianness on the file.  Encode the summary
information in big endian format, like most of the rest of the
filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_format.h   |    4 +++-
 libxfs/xfs_rtbitmap.c |    8 +++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 47b2e31e256..7e76bedda68 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -748,10 +748,12 @@ union xfs_rtword_ondisk {
 
 /*
  * Realtime summary counts are accessed by the word, which is currently
- * stored in host-endian format.
+ * stored in host-endian format.  Starting with the realtime groups feature,
+ * the words are stored in be32 ondisk.
  */
 union xfs_suminfo_ondisk {
 	__u32		raw;
+	__be32		rtg;
 };
 
 /*
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 4ed3bd261f6..26428898d60 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -558,6 +558,9 @@ xfs_suminfo_get(
 	struct xfs_mount	*mp,
 	union xfs_suminfo_ondisk *infoptr)
 {
+	if (xfs_has_rtgroups(mp))
+		return be32_to_cpu(infoptr->rtg);
+
 	return infoptr->raw;
 }
 
@@ -567,7 +570,10 @@ xfs_suminfo_add(
 	union xfs_suminfo_ondisk *infoptr,
 	int			delta)
 {
-	infoptr->raw += delta;
+	if (xfs_has_rtgroups(mp))
+		be32_add_cpu(&infoptr->rtg, delta);
+	else
+		infoptr->raw += delta;
 }
 
 /*

