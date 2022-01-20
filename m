Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0902C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:22:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240471AbiATAW2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:22:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbiATAW1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:22:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5771FC061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:22:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13495B81AD5
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22EFC004E1;
        Thu, 20 Jan 2022 00:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638144;
        bh=v5h/dr6MaTv84L00lNZJRKcVKI4DmTzEXGKo/HBZoP4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kou+bz5MNQmaBYOz+n4cnSksJwUzJA2xJfLDuqiLBKCulZxiPYJz2wOsRdc4LLpk5
         8Wuyn9As78bh9v8RaJsg+8s3xdSKLWfIIBTJuusjJ+kxgJ9m9P0uc/dAGASmtQ30Ee
         CEgr+geTZ6TMfCXHG/dmZyhwJBfpJkyKQB8Fyk7bWNmgAA+3cHVHBhbW0XTvgGZUsz
         VU0wzXlZvumy1fTNFpXnt4/WuktDGsP/Tw2em+JljANffa3PMOZi+YW4Be7Iwv/Sl1
         MFZ//Xfvj5/6pywmTd4H/6J9BWl92NFLvXSHdYyPh/GbdFocMH+E+LW9w68fHQNu4Y
         2CAQuaGNFFLag==
Subject: [PATCH 09/17] xfs_repair: explicitly cast directory inode numbers in
 do_warn
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Date:   Wed, 19 Jan 2022 16:22:24 -0800
Message-ID: <164263814439.863810.11076153423409347035.stgit@magnolia>
In-Reply-To: <164263809453.863810.8908193461297738491.stgit@magnolia>
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Explicitly cast the ondisk directory inode argument to do_warn when
complaining about corrupt directories.  This avoids build warnings on
armv7l.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dir2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/repair/dir2.c b/repair/dir2.c
index fdf91532..946e729e 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -1358,7 +1358,7 @@ _("can't read block %" PRIu64 " for directory inode %" PRIu64 "\n"),
 		}
 		if (bp->b_error == -EFSCORRUPTED) {
 			do_warn(
-_("corrupt directory data block %lu for inode %" PRIu64 "\n"),
+_("corrupt directory data block %" PRIu64 " for inode %" PRIu64 "\n"),
 				dbno, ino);
 			libxfs_buf_relse(bp);
 			continue;

