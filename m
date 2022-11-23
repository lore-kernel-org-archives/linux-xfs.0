Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F01D8C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Nov 2022 17:09:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239222AbiKWRJy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Nov 2022 12:09:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239233AbiKWRJZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Nov 2022 12:09:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011AC5B859
        for <linux-xfs@vger.kernel.org>; Wed, 23 Nov 2022 09:09:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2AAFB821BC
        for <linux-xfs@vger.kernel.org>; Wed, 23 Nov 2022 17:09:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BFCBC433D6;
        Wed, 23 Nov 2022 17:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669223357;
        bh=DpRD44229X9amFgdS4JeB2pQvuQtapjqy1Yi7iG+D2c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UlZfvnD1o0YR00U4ejebbTshUZRPty46jOPsaXdOpQ6sltNohTmunFFwEtwUSvwuQ
         tjSmePWo/Mk4RvrloK15HZSua7yiWhPeYyfoaaGM21IWckutRCHx1RXyo7SnJ/rr8d
         4fcrmiTujvxPVttGfhYVwDQQg51DRPfkspznffpOieCnl5n62sLVROi1zoMvvXtny1
         fvcJcJw7FdrO5UGPCPxwzugIk7ogvbVPXoR5JoiohPk7Cz8Fixt2FMpis6+TJxu0ZM
         +AyOffJIPnxLhyhFB5VZ53ePAYvWk2uN+td8Ov4dAv+8r6nc97e+SPJsTgk6C9A41X
         2CCX53D9SiXKQ==
Subject: [PATCH 4/9] xfs_db: fix octal conversion logic
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 23 Nov 2022 09:09:17 -0800
Message-ID: <166922335710.1572664.4478914425268206526.stgit@magnolia>
In-Reply-To: <166922333463.1572664.2330601679911464739.stgit@magnolia>
References: <166922333463.1572664.2330601679911464739.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix the backwards boolean logic here, which results in weird behavior.

# xfs_db -x -c /dev/sda
xfs_db> print fname
fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
xfs_db> write fname "mo\0h5o"
fname = "mo\005o\000\000\000\000\000\000\000\000"
xfs_db> print fname
fname = "mo\005o\000\000\000\000\000\000\000\000"

Notice that we passed in octal-zero, 'h', '5', 'o', but the fs label is
set to octal-5, 'o' because of the incorrect loop logic.  -Wlogical-op
found this one.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/write.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/db/write.c b/db/write.c
index 70cb0518d01..6c67e839a9e 100644
--- a/db/write.c
+++ b/db/write.c
@@ -479,7 +479,7 @@ convert_oct(
 		if (arg[count] == '\0')
 			break;
 
-		if ((arg[count] < '0') && (arg[count] > '7'))
+		if ((arg[count] < '0') || (arg[count] > '7'))
 			break;
 	}
 
@@ -553,7 +553,7 @@ convert_arg(
 
 			/* do octal conversion */
 			if (*ostr == '\\') {
-				if (*(ostr + 1) >= '0' || *(ostr + 1) <= '7') {
+				if (*(ostr + 1) >= '0' && *(ostr + 1) <= '7') {
 					ret = convert_oct(ostr + 1, &octval);
 					*rbuf++ = octval;
 					ostr += ret + 1;

