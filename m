Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE0EDC7619A
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 00:10:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234251AbjDFAKE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Apr 2023 20:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234076AbjDFAKA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2023 20:10:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D785FD3
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2023 17:09:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4136462C9C
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 00:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5BDC433D2;
        Thu,  6 Apr 2023 00:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680739790;
        bh=O0q4X52cJBKGpobOkd5An4f/f31EZsWW6iptZLA1Ej0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=K8IVyOSKF3ssrRLM5CQLj2KHg1g6Nwso1NgRw5Gh5C1dKjGbRBDCnB9MVVozkIKXo
         AgP8LxiF3C4miKn/3RwoUycVPd046txvh8H9XiJ8hUqcclv3qrFNy2y3XlyyvFj/r4
         dsFXK2/7M/uwQaGBJTBm4VLrta3lTDmHYrjF1Xq5S/MgGESGUimFsJrgk65W60D7c6
         6VQA7H8ooQXQpd6wnDVFON6jyzaQzOGGu6XbzdlLMQja5FiH+XRl/nej5pGey+txJ4
         9P/X9M1VJ5pw1GVCScPGfPO84YGTM8W/HSvMcD/kLuCcS70tj6iYMtqdzs21MFAkhR
         pYmNckD33JuKA==
Subject: [PATCH 3/6] xfs_db: move obfuscate_name assertion to callers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Wed, 05 Apr 2023 17:09:50 -0700
Message-ID: <168073979023.1656666.15017884571352314641.stgit@frogsfrogsfrogs>
In-Reply-To: <168073977341.1656666.5994535770114245232.stgit@frogsfrogsfrogs>
References: <168073977341.1656666.5994535770114245232.stgit@frogsfrogsfrogs>
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
---
 db/metadump.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/db/metadump.c b/db/metadump.c
index 27d1df43..317ff728 100644
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

