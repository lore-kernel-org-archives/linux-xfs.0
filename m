Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2BCBC7EE2C
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jun 2023 15:37:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232590AbjFEPhd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jun 2023 11:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234700AbjFEPh1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 11:37:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47123109
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 08:37:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83A6F620B8
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 15:37:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF9EFC433EF;
        Mon,  5 Jun 2023 15:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685979444;
        bh=XLcFtp/kwoCun8H1VfZLEOESOud4cOEzGtYJUpgyNvM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jxZyJeDsdntioCzUSml74vl0/rMuqKr45RHFnE+nxgOkV1780Hq+o5WlT7bCYkz6H
         6QiyekRTnpQGLvp62wyeuFulSgWqQtRiRqnnAuIDxjRyfCZOyxZ+SzlHEHtosm1b2P
         NCRDZ+6bk97prGqPNyfKt8ERw00YxvW7IGi+cAbv3eMGX0BtY9CAv6YibPZ0nlWTbs
         sN1C/GHEYb7VOjGvWLIZAs+gBMHCRrMWFmrIdC+0pmFy+hg/BJFA5Xt2o1bw4Bjfui
         GBi8rWTy5gVy4kutfhSIXhypc71sZEa9p2i9haGdap71fuHV+AZZQgZGegVy0SKoea
         vJxlOZZmLO7Pw==
Subject: [PATCH 1/2] xfs_repair: don't add junked entries to the rebuilt
 directory
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 05 Jun 2023 08:37:24 -0700
Message-ID: <168597944454.1226372.3979295005270810427.stgit@frogsfrogsfrogs>
In-Reply-To: <168597943893.1226372.1356501443716713637.stgit@frogsfrogsfrogs>
References: <168597943893.1226372.1356501443716713637.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If a directory contains multiple entries with the same name, we create
separate objects in the directory hashtab for each dirent.  The first
one has p->junkit==0, but the subsequent ones have p->junkit==1.
Because these are duplicate names that are not garbage, the first
character of p->name.name is not set to a slash.

Don't add these subsequent hashtab entries to the rebuilt directory.

Found by running xfs/155 with the parent pointers patchset enabled.

Fixes: 33165ec3b4b ("Fix dirv2 rebuild in phase6 Merge of master-melb:xfs-cmds:26664a by kenmcd.")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase6.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index 48bf57359c5..37573b4301b 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1319,7 +1319,8 @@ longform_dir2_rebuild(
 	/* go through the hash list and re-add the inodes */
 
 	for (p = hashtab->first; p; p = p->nextbyorder) {
-
+		if (p->junkit)
+			continue;
 		if (p->name.name[0] == '/' || (p->name.name[0] == '.' &&
 				(p->name.len == 1 || (p->name.len == 2 &&
 						p->name.name[1] == '.'))))

