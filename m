Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A641C7EE2C
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jun 2023 15:36:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234583AbjFEPgx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jun 2023 11:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234322AbjFEPgw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 11:36:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0E394
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 08:36:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBB6062733
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 15:36:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B22C433D2;
        Mon,  5 Jun 2023 15:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685979410;
        bh=78tnRIjlRHUUhsVd0Oiz/MKv3PNe0MgaQHhcT6IzcCg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=oqJ7Pj5vO7SPYuSzdQyh2W/2nQ11hKiWvkiijdq1mPLTS58/0yaHzitTJPsRo7k7r
         wBMQTBocyLs0+fu/Ash60nNa7vGYa5XPf3GsmamRGxARBt+xBCZ6phUhndj785ss2k
         OOJzn/uNHoyd1009OmCOkF5qBFPly5DkpAPLUWlsBu4rt+WZUFfzftGTN7Kup2758U
         mfcuy1hmvy4MNBxDAxUdlNPAiu2Wd0fVu+D1jW4h6ZbpfadWg5N3ixBV0tTEBD6M9o
         fZKJww/LiUX4z8Sv/i5tgLJUlPCn42Jh1i3tC4Z/GpTPr7K2a96yclYMJod+P5e4N7
         2+73WRoFJVyhA==
Subject: [PATCH 4/5] mkfs.xfs.8: warn about the version=ci feature
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, hch@infradead.org
Date:   Mon, 05 Jun 2023 08:36:49 -0700
Message-ID: <168597940973.1226098.13275031442279709007.stgit@frogsfrogsfrogs>
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

Document the exact byte transformations that happen during directory
name lookup when the version=ci feature is enabled.  Warn that this is
not generally compatible, and that people should not use this feature.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 man/man8/mkfs.xfs.8.in |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)


diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index 49e64d47ae4..6fc7708bc94 100644
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

