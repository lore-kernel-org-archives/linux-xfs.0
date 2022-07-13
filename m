Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF69FCCA47F
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jul 2022 00:57:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbiGMA5Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jul 2022 20:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbiGMA5P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jul 2022 20:57:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1AFECFB45;
        Tue, 12 Jul 2022 17:57:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D53661898;
        Wed, 13 Jul 2022 00:57:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8644C385A5;
        Wed, 13 Jul 2022 00:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657673833;
        bh=OGYw8jj+DtJsK8uMtmnIfrQf650oo702OQYeLXu4ZOc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Mnqsfg7VP71VVBv/QtQlcGgw8FVwOD0HZvRhFAuemOgn28nNwkxz8sh2JwgskMciX
         DuAWkZnR6OqRkWQ2dFz5BcKueFdLDZVTPhoiyWoD93D5NFBxBXjUINRdnfNgA2m5Ja
         3EGPP/27mP5JH3q923cT313xHT2MQdbn6NX5OSdhmWksh4nyR9hgEpN5+D8HIk94CO
         L8SIKBVNla0BzjUDPSczJpuRpdWyGnW74VC8xu6ia/j5KRck4Bt4v3BENl4C2qP7U/
         IvfvT32v1JIgGt4K41TBwtTsNqesuVtqBT5DBmO3IIGN7ckWnekhYMrdujote0ZBhO
         imBEeTzhRs8Aw==
Subject: [PATCH 7/8] filter: report data block mappings and od offsets in
 multiples of allocation units
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        tytso@mit.edu, leah.rumancik@gmail.com
Date:   Tue, 12 Jul 2022 17:57:13 -0700
Message-ID: <165767383332.869123.15665387460779572064.stgit@magnolia>
In-Reply-To: <165767379401.869123.10167117467658302048.stgit@magnolia>
References: <165767379401.869123.10167117467658302048.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

All the tests that use these two filter functions also make all of their
fallocate calls in units of file allocation units, not filesystem
blocks.  Make them transform the file offsets to multiples of file
allocation units (via _get_file_block_size) so that xfs/242 and xfs/252
will work with XFS with a rt extent size set.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/filter |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/common/filter b/common/filter
index 14f6a027..28dea646 100644
--- a/common/filter
+++ b/common/filter
@@ -221,7 +221,7 @@ _filter_xfs_io_units_modified()
 
 _filter_xfs_io_blocks_modified()
 {
-	BLOCK_SIZE=$(_get_block_size $SCRATCH_MNT)
+	BLOCK_SIZE=$(_get_file_block_size $SCRATCH_MNT)
 
 	_filter_xfs_io_units_modified "Block" $BLOCK_SIZE
 }
@@ -457,7 +457,7 @@ _filter_busy_mount()
 
 _filter_od()
 {
-	BLOCK_SIZE=$(_get_block_size $SCRATCH_MNT)
+	BLOCK_SIZE=$(_get_file_block_size $SCRATCH_MNT)
 	$AWK_PROG -v block_size=$BLOCK_SIZE '
 		/^[0-9]+/ {
 			offset = strtonum("0"$1);

