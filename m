Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5867EC61D97
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Nov 2023 23:07:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235132AbjKVXHc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Nov 2023 18:07:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234580AbjKVXHc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Nov 2023 18:07:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17B9191
        for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2023 15:07:28 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978F1C433C8;
        Wed, 22 Nov 2023 23:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700694448;
        bh=MRIgorRgUDLX9ol9c8lAXGp/oz/gULmhipin2mkyD/g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=H01OIQWThKYnt0Nv5c82TTG1jebyJYCMhmpbfoo94e8YR7IedqkT02nXgLdZXgzzY
         biqdqahI8CZUOVC/fA88zMHEH2IodRQ+Ql0lm1jW2+kSU9CMRPEHdB6W1mEsLuI0T/
         XO4EP2tSpsfjOWGZa3Dnv81qvFsRXfV8Saf35Wh6r6o0BHjWMqphx6hHo6eXs2rOS3
         URdI+b4+eWfHsSk2edgb2z2WrgHz7wh4GLoaSo7MvBW869egdpf8uqFCMpHTkUXXBd
         FHbNuJbFiEzAcAA89WwDIYy2LURCImAKqxbSSnt9AfAwH9QGqfAcjJm8f3FzTAPc3d
         2rADvVlH1NxFw==
Subject: [PATCH 7/9] xfs_mdrestore: emit newlines for fatal errors
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 22 Nov 2023 15:07:28 -0800
Message-ID: <170069444804.1865809.10101273264911340367.stgit@frogsfrogsfrogs>
In-Reply-To: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
References: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Spit out a newline after a fatal error message.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mdrestore/xfs_mdrestore.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 5dfc423493e..3190e07e478 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -275,10 +275,10 @@ read_header_v2(
 		fatal("error reading from metadump file\n");
 
 	if (h->v2.xmh_incompat_flags != 0)
-		fatal("Metadump header has unknown incompat flags set");
+		fatal("Metadump header has unknown incompat flags set\n");
 
 	if (h->v2.xmh_reserved != 0)
-		fatal("Metadump header's reserved field has a non-zero value");
+		fatal("Metadump header's reserved field has a non-zero value\n");
 
 	want_external_log = !!(be32_to_cpu(h->v2.xmh_incompat_flags) &
 			XFS_MD2_COMPAT_EXTERNALLOG);

