Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06FA9C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jul 2022 21:38:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240146AbiGSViA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jul 2022 17:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240127AbiGSVh7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jul 2022 17:37:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA9960683;
        Tue, 19 Jul 2022 14:37:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 890F2B81C77;
        Tue, 19 Jul 2022 21:37:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3300DC341C6;
        Tue, 19 Jul 2022 21:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658266676;
        bh=dHjj3MWI04LTxPz/0vI1mQXRqIo9BWTVdyPlhSxv6ZE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CicTvfZlWgjjGhOieSOhNd2LHoA3uz5aw1uBKYSoapa9Kyo8pe0Rbq0zz+3WXr9Lx
         CewILPtrWVMh8jjhh8P0rXGDVdqjYdqxtFCWJso8I0ZKFe8lmC1Kv0O6iZloYKDQsd
         5iAb9nbROCsykVVZ3wR0tAXJKhD9NzQ1fz8e0jyZ58GadE/Aud2QcuLgnOvb0ZVLT5
         pfFh8bI3qUwjHwf9aVDjg+GKbnm/4wmRDqrqb9pBXZIuuD1hv5mX+T7DAiruTN9Twq
         xx4GMoGVaHGlSrKh/XNSVd7q+jQ/Q8EpQ33AVCD6ZrSjl79LiV3LshVigoTSm8yCxR
         Z8ElV51/DOUvg==
Subject: [PATCH 7/8] filter: report data block mappings and od offsets in
 multiples of allocation units
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        tytso@mit.edu, leah.rumancik@gmail.com
Date:   Tue, 19 Jul 2022 14:37:55 -0700
Message-ID: <165826667582.3249494.4199351742712143400.stgit@magnolia>
In-Reply-To: <165826663647.3249494.13640199673218669145.stgit@magnolia>
References: <165826663647.3249494.13640199673218669145.stgit@magnolia>
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
Reviewed-by: Zorro Lang <zlang@redhat.com>
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

