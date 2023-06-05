Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D867BC77B73
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jun 2023 15:36:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbjFEPgs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jun 2023 11:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234726AbjFEPgn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 11:36:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B4B197
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 08:36:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A61E6130E
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 15:36:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E9CC433D2;
        Mon,  5 Jun 2023 15:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685979399;
        bh=wJKCLBl3vxME+KAgInfxNyo6vtqFT3EkM+dcyPtBEZ0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GlRma2obUeArO/UdJehej7LNqHaVwdTlTBzlmQ4kyek95z1UHQhi6r0IDJmV1FGUp
         5XwM98GJwgUcloRz9QlG2Ka4sw7/sknR/3FTtXQEDUhqRnMlwpg1DzhhG6Nor+2I9I
         PW6Wccj9A3yaRdg+Zd7PE6B4LRfNCQWBb9LEJYXwZO6m1Fr/e4zNGHlyxvrQYTkbMH
         KeN1AYj1sNK4ijkt0GmMgzg3eMAna9PVapmnczN4YsfqG4vRb2FEeRXbjf/wjEbswU
         uRvi+SK9/texAy//0fz2fZFiB+3HlvsbhhnMDAt15ihBf/LKHG0cHMfSgI7f7dutv2
         XBHQ0KRTesI+Q==
Subject: [PATCH 2/5] xfs_db: move obfuscate_name assertion to callers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, hch@infradead.org
Date:   Mon, 05 Jun 2023 08:36:38 -0700
Message-ID: <168597939847.1226098.13616825678460264329.stgit@frogsfrogsfrogs>
In-Reply-To: <168597938725.1226098.18077307069307502725.stgit@frogsfrogsfrogs>
References: <168597938725.1226098.18077307069307502725.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Currently, obfuscate_name asserts that the hash of the new name is the
same as the old name.  To enable bug fixes in the next patch, move this
assertion to the callers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/metadump.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/db/metadump.c b/db/metadump.c
index 27d1df43279..317ff72802d 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -882,7 +882,6 @@ obfuscate_name(
 		*first ^= 0x10;
 		ASSERT(!is_invalid_char(*first));
 	}
-	ASSERT(libxfs_da_hashname(name, name_len) == hash);
 }
 
 /*
@@ -1208,6 +1207,7 @@ generate_obfuscated_name(
 
 	hash = libxfs_da_hashname(name, namelen);
 	obfuscate_name(hash, namelen, name);
+	ASSERT(hash == libxfs_da_hashname(name, namelen));
 
 	/*
 	 * Make sure the name is not something already seen.  If we
@@ -1321,6 +1321,7 @@ obfuscate_path_components(
 			namelen = strnlen((char *)comp, len);
 			hash = libxfs_da_hashname(comp, namelen);
 			obfuscate_name(hash, namelen, comp);
+			ASSERT(hash == libxfs_da_hashname(comp, namelen));
 			break;
 		}
 		namelen = slash - (char *)comp;
@@ -1332,6 +1333,7 @@ obfuscate_path_components(
 		}
 		hash = libxfs_da_hashname(comp, namelen);
 		obfuscate_name(hash, namelen, comp);
+		ASSERT(hash == libxfs_da_hashname(comp, namelen));
 		comp += namelen + 1;
 		len -= namelen + 1;
 	}

