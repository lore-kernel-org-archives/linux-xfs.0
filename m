Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1890EDE9BC
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Sep 2023 12:36:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233620AbjINMgy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Sep 2023 08:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbjINMgy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Sep 2023 08:36:54 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC091FC9
        for <linux-xfs@vger.kernel.org>; Thu, 14 Sep 2023 05:36:50 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41843C433C8
        for <linux-xfs@vger.kernel.org>; Thu, 14 Sep 2023 12:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694695010;
        bh=z70XXigLnZCSJA1GvQH6rBbPt7zTr/irSzFfRzL1nCs=;
        h=From:To:Subject:Date:From;
        b=di1ttp0wwu90xcmim7wYLgj1hYBAK+Jubcy9OofEYzJGRNhQObT4ubyJXOPCAGEyW
         vdZKjGNeSW1TdOssIjNDyJeAIxrfe36JAyvBXGM880yjiNzdR/fB/K5geB1jqcKi9j
         4HfZjIiZ6Z/xoFi9vxpTAS10esgGEDmnEWYOB5MfhTndNkM+4SYQIr1Zp9Ftf0lAfe
         APTrQIPLeQVfpjTWUHqkr7+PeFE4mTBndQMUuxL2OEXDJ1zvjCkrAnqNx1G9S4AwQA
         Npevx5jbH4Fwck3BMvW6P1BiMx+b/tMabDSUBMBXKKrOjLgtRFxVu3kWEAa6DIXvEA
         NHR0+8kyWMCRw==
From:   cem@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] mkfs: Improve warning when AG size is a multiple of stripe width
Date:   Thu, 14 Sep 2023 14:36:40 +0200
Message-Id: <20230914123640.79682-1-cem@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Carlos Maiolino <cmaiolino@redhat.com>

The current output message prints out a suggestion of an AG size to be
used in lieu of the user-defined one.
The problem is this suggestion is printed in filesystem blocks, while
agsize= option receives a size in bytes (or m, g).

This patch tries to make user's life easier by outputing the suggesting
in bytes directly.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 mkfs/xfs_mkfs.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index d3a15cf44..827d5b656 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3179,9 +3179,11 @@ _("agsize rounded to %lld, sunit = %d\n"),
 		if (cli_opt_set(&dopts, D_AGCOUNT) ||
 		    cli_opt_set(&dopts, D_AGSIZE)) {
 			printf(_(
-"Warning: AG size is a multiple of stripe width.  This can cause performance\n\
-problems by aligning all AGs on the same disk.  To avoid this, run mkfs with\n\
-an AG size that is one stripe unit smaller or larger, for example %llu.\n"),
+"Warning: AG size is a multiple of stripe width. This can cause performance\n\
+problems by aligning all AGs on the same disk. To avoid this, run mkfs with\n\
+an AG size that is one stripe unit smaller or larger,\n\
+for example: agsize=%llu (%llu blks).\n"),
+				(unsigned long long)((cfg->agsize - dsunit) * cfg->blocksize),
 				(unsigned long long)cfg->agsize - dsunit);
 			fflush(stdout);
 			goto validate;
-- 
2.39.2

