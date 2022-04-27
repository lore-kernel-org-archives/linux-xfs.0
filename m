Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BE2AC433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 00:52:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356529AbiD0AzY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 20:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356530AbiD0AzX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 20:55:23 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E7B13EBC
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 17:52:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8DBDFCE228C
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 00:52:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DCBBC385AC;
        Wed, 27 Apr 2022 00:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651020729;
        bh=c6bnLoLW1xv7N935L85CDq780KXhfhcW00Mlpx1gNWk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Ck9VEyIYt2t0X2/DHx17X45cJNcrnD9UeyEQclpG9aw0CzSGsDGo1HE4bcLHjbFwR
         7MeDBQzuab95AguwxDIMF8HE/k/YXuVl03cMKtBCt8sZqv416Z33RK6NyOOITdlpXk
         8Hgzljh2+TZ/2fhkF3UUqlk1YS+soLhNUqUK1uGV2HQ2KAEnVDUGWJ7JEa5Xxm/XBj
         QdLHrWO0ytk98oAjVv3bkIa6A8j3Mmmm446sryhdkDrQ2PE3yOvWY/gjJpCdv8lf2A
         V6+UNhU1EwaaR+69PggbYxIUlmVzVKBpy2k21GcJFtqJmpc+nwsUitGUHBfJe4msSD
         nCUkShqylN9ug==
Subject: [PATCH 3/9] xfs: remove a __xfs_bunmapi call from reflink
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org
Date:   Tue, 26 Apr 2022 17:52:09 -0700
Message-ID: <165102072920.3922658.13220953312201833980.stgit@magnolia>
In-Reply-To: <165102071223.3922658.5241787533081256670.stgit@magnolia>
References: <165102071223.3922658.5241787533081256670.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This raw call isn't necessary since we can always remove a full delalloc
extent.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_reflink.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 1ae6d3434ad2..960917628a44 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1138,7 +1138,7 @@ xfs_reflink_remap_extent(
 		xfs_refcount_decrease_extent(tp, &smap);
 		qdelta -= smap.br_blockcount;
 	} else if (smap.br_startblock == DELAYSTARTBLOCK) {
-		xfs_filblks_t	len = smap.br_blockcount;
+		int		done;
 
 		/*
 		 * If the extent we're unmapping is a delalloc reservation,
@@ -1146,10 +1146,11 @@ xfs_reflink_remap_extent(
 		 * incore state.  Dropping the delalloc reservation takes care
 		 * of the quota reservation for us.
 		 */
-		error = __xfs_bunmapi(NULL, ip, smap.br_startoff, &len, 0, 1);
+		error = xfs_bunmapi(NULL, ip, smap.br_startoff,
+				smap.br_blockcount, 0, 1, &done);
 		if (error)
 			goto out_cancel;
-		ASSERT(len == 0);
+		ASSERT(done);
 	}
 
 	/*

