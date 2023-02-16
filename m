Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03829C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:58:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjBPV6H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:58:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjBPV6G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:58:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976CD34F4A
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:58:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF022B829C2
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:53:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE0CC433EF;
        Thu, 16 Feb 2023 21:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676584379;
        bh=3we7A9vDCGbgxQAjt4sDrPfuFt/V8kiXm2FMM0iuXN4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Za6t4jP1EDGjFQCR86JQ5KXWHrheh46thUlOm+wYsoFV89SGs0Jgx3cOKs2pqwZjx
         tPyg4Vr2dvC5hiUF8PpFJzPutqt9tPD7kkrrB9bNa/S54k45mityQkihR4jRXHeUmg
         gJ7uk4ZHsHxyWb70L4UT+Iqd45yIlRXKreN3OpfMBt0+dv/9R+rFtxaIl8VMNhC8mp
         vLONysBTH3FZQRzzCvEOHzuqumQrLR5LJ730XZOAL7yTNQneSj1bOdE/o9KXtGw9vU
         ++ndz+y7N0ljoV5h5DdBOYHuPp0mRZf1oa8vajV0p31ocOLJL1XG4KMWD4+oTbuYS6
         zzACArEwQ2D2Q==
Subject: [PATCH 2/5] xfs_scrub: fix broken realtime free blocks unit
 conversions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, daan.j.demeyer@gmail.com
Date:   Thu, 16 Feb 2023 13:52:58 -0800
Message-ID: <167658437893.3590000.1698651202541264559.stgit@magnolia>
In-Reply-To: <167658436759.3590000.3700844510708970684.stgit@magnolia>
References: <167658436759.3590000.3700844510708970684.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

r_blocks is in units of fs blocks, but freertx is in units of realtime
extents.  Add the missing conversion factor so we don't end up with
bogus things like this:

Pretend that sda and sdb are both 100T volumes.

# mkfs.xfs -f /dev/sda -b -r rtdev=/dev/sdb,extsize=2m
# mount /dev/sda /mnt -o rtdev=/dev/sdb
# xfs_scrub -dTvn /mnt
<snip>
Phase 7: Check summary counters.
3.5TiB data used;  99.8TiB realtime data used;  55 inodes used.
2.0GiB data found; 50.0MiB realtime data found; 55 inodes found.
55 inodes counted; 0 inodes checked.

We just created the filesystem, the realtime volume should be empty.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/fscounters.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/scrub/fscounters.c b/scrub/fscounters.c
index f21b24e0935..3ceae3715dc 100644
--- a/scrub/fscounters.c
+++ b/scrub/fscounters.c
@@ -138,7 +138,7 @@ scrub_scan_estimate_blocks(
 	*d_blocks = ctx->mnt.fsgeom.datablocks;
 	*d_bfree = fc.freedata;
 	*r_blocks = ctx->mnt.fsgeom.rtblocks;
-	*r_bfree = fc.freertx;
+	*r_bfree = fc.freertx * ctx->mnt.fsgeom.rtextsize;
 	*f_files_used = fc.allocino - fc.freeino;
 
 	return 0;

