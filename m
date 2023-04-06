Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD283C761A6
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 00:10:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbjDFAKG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Apr 2023 20:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234328AbjDFAKE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2023 20:10:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00B161AE
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2023 17:10:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8390C60B67
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 00:10:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E459FC433EF;
        Thu,  6 Apr 2023 00:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680739801;
        bh=il/HmiLjMpZxwq56RKTgdazNAJK8pTnI4CwLCjYbgoE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=p9sKBHLTQkTytbsuKRV1tyeUAe6llQn03vW/gJCgauN364v8hrinRyaX3/ghuDEFC
         r698MK7TZMvdo/cFkl58ektKrFiauHlY34Pb5TMmaZbndjfqZnoGvNPoU+2FMcWDAE
         WI4Da3Ec950AZjMo5yrrIbfItSM7dHJnDpqrskk80BGXb+jR2RujHa2Rs2u8fVCF+j
         pDVvgADaSvoGpJRtzRSpeZMvZFgHtUUVHA8fF3zf0DkV75Pwff2M4Q5bfdhuoNBqpG
         TEcUvRgy0/TzTXY6IcJbL1R4RHGdmfLJAbBJO5EQ09jwKuOh5Zb66bfUy77Qc7RVlK
         zJB8LHUIfa3eA==
Subject: [PATCH 5/6] mkfs.xfs.8: warn about the version=ci feature
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Wed, 05 Apr 2023 17:10:01 -0700
Message-ID: <168073980144.1656666.8831148327830741767.stgit@frogsfrogsfrogs>
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

Document the exact byte transformations that happen during directory
name lookup when the version=ci feature is enabled.  Warn that this is
not generally compatible, and that people should not use this feature.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man8/mkfs.xfs.8.in |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)


diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index 49e64d47..6fc7708b 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -809,11 +809,25 @@ can be either 2 or 'ci', defaulting to 2 if unspecified.
 With version 2 directories, the directory block size can be
 any power of 2 size from the filesystem block size up to 65536.
 .IP
-The
+If the
 .B version=ci
-option enables ASCII only case-insensitive filename lookup and version
-2 directories. Filenames are case-preserving, that is, the names
-are stored in directories using the case they were created with.
+option is specified, the kernel will transform certain bytes in filenames
+before performing lookup-related operations.
+The byte sequence given to create a directory entry is persisted without
+alterations.
+The lookup transformations are defined as follows:
+
+    0x41-0x5a -> 0x61-0x7a
+
+    0xc0-0xd6 -> 0xe0-0xf6
+
+    0xd8-0xde -> 0xf8-0xfe
+
+This transformation roughly corresponds to case insensitivity in ISO
+8859-1.
+The transformations are not compatible with other encodings (e.g. UTF8).
+Do not enable this feature unless your entire environment has been coerced
+to ISO 8859-1.
 .IP
 Note: Version 1 directories are not supported.
 .TP

