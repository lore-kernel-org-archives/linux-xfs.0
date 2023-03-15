Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 962D9C6FD1F
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Mar 2023 01:01:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbjCOBBP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Mar 2023 21:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjCOBBP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Mar 2023 21:01:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E514E5F6
        for <linux-xfs@vger.kernel.org>; Tue, 14 Mar 2023 18:01:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF759B81C38
        for <linux-xfs@vger.kernel.org>; Wed, 15 Mar 2023 01:01:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B77AC433EF;
        Wed, 15 Mar 2023 01:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678842071;
        bh=M4p/jIpwrKwFINpDy7Q3qy2niLDJTQLkpJW8q9PFVG8=;
        h=Date:From:To:Cc:Subject:From;
        b=Kz4FufHrTyuyry8cfQ11s7qp5A/eczkAKilemet76c10bXKNCkotUK9Y8eTByUfum
         91braBKxkj6iM1U9rrPXOkYtVeriFRYZY5tewLauBaf/lhs7ly+cfgLppCarQwfoB0
         gpWFtAH4TcfYcF/ON4BNGU2N+TSXugO1n88NJZDcxfbV2pKJbsdSx1KQCDgAMUWx2c
         naGPQxKsmBJSDUYsQQuaJGQ73oMuugQUpncvwjZXTFsaihx2VEJGX/0iJkr11/zjze
         T+7n5l6/Rm2OGiiDR0YNlPQVjdsKFxGZoW6G3TIqMNqDYsb4jTpI3Ua9Fh8M8mv7Pr
         XV8/4lx+7nwNA==
Date:   Tue, 14 Mar 2023 18:01:10 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs_db: fix complaints about unsigned char casting
Message-ID: <20230315010110.GD11376@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make the warnings about signed/unsigned char pointer casting go away.
For printing dirent names it doesn't matter at all.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/namei.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/db/namei.c b/db/namei.c
index 00e8c8dc6d5..063721ca98f 100644
--- a/db/namei.c
+++ b/db/namei.c
@@ -98,7 +98,7 @@ path_navigate(
 
 	for (i = 0; i < dirpath->depth; i++) {
 		struct xfs_name	xname = {
-			.name	= dirpath->path[i],
+			.name	= (unsigned char *)dirpath->path[i],
 			.len	= strlen(dirpath->path[i]),
 		};
 
@@ -250,7 +250,7 @@ dir_emit(
 	uint8_t			dtype)
 {
 	char			*display_name;
-	struct xfs_name		xname = { .name = name };
+	struct xfs_name		xname = { .name = (unsigned char *)name };
 	const char		*dstr = get_dstr(mp, dtype);
 	xfs_dahash_t		hash;
 	bool			good;
