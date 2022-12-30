Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BFB8C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:15:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236186AbiLaCPT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:15:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbiLaCPR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:15:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF901C430
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:15:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E1BD61CA0
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:15:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0540CC433D2;
        Sat, 31 Dec 2022 02:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452916;
        bh=RbKgkwIQczXh6N455rHILrgsLvlMAoEIMpVjDcLTJ3U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Le+VoPhLi1tnS+CVNeW5rTtTDb0tdXUlnvTY2VEqbdNTjol9gbebldQD50tGlvkgo
         nnVTLvffgvkBtn/sKUA+EG8+sxg/HCDcqqmfNWGyLZ8turLB0+2ILEniWWNfWrKlk7
         c0m+tv1QGMX4+VrF+dauKRJh8rW4Vq8gLKExG3rV5rgXBOiAjK1bQ1zKYJjI3+1ell
         0Ie6uQz1HcXWvMps8othDpDPLS3+lACdcwKdc9pWNf8tV5RsJWsV4WlSsN91HFgGn6
         PdQH9xFlhX9h7VD8ReRLSoxPXTEDZd8K2kjv6BaWV3mXTZGE8ULcDsryzcRSRP4KTU
         nzZNA/lXJ2VEw==
Subject: [PATCH 21/46] xfs_db: report metadir support for version command
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:22 -0800
Message-ID: <167243876210.725900.5341988189927048769.stgit@magnolia>
In-Reply-To: <167243875924.725900.7061782826830118387.stgit@magnolia>
References: <167243875924.725900.7061782826830118387.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Report metadir support if we have it enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/inode.c |    3 +++
 db/sb.c    |    2 ++
 2 files changed, 5 insertions(+)


diff --git a/db/inode.c b/db/inode.c
index c9b506b905d..4c2fd19f446 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -207,6 +207,9 @@ const field_t	inode_v3_flds[] = {
 	{ "nrext64", FLDT_UINT1,
 	  OI(COFF(flags2) + bitsz(uint64_t) - XFS_DIFLAG2_NREXT64_BIT - 1), C1,
 	  0, TYP_NONE },
+	{ "metadata", FLDT_UINT1,
+	  OI(COFF(flags2) + bitsz(uint64_t) - XFS_DIFLAG2_METADATA_BIT-1), C1,
+	  0, TYP_NONE },
 	{ NULL }
 };
 
diff --git a/db/sb.c b/db/sb.c
index 095c59596a4..8a54ff7b00c 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -707,6 +707,8 @@ version_string(
 		strcat(s, ",NEEDSREPAIR");
 	if (xfs_has_large_extent_counts(mp))
 		strcat(s, ",NREXT64");
+	if (xfs_has_metadir(mp))
+		strcat(s, ",METADIR");
 	return s;
 }
 

