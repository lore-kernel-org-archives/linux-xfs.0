Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 292B8C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 23:57:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16522600CC
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 23:57:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbhESX6i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 19:58:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:48718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229681AbhESX6h (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 May 2021 19:58:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42AFB61007;
        Wed, 19 May 2021 23:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621468637;
        bh=IPZ/LFYkiDiAKITR3H2kj94cG/UOsADTmHjKuAxvEZs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=G1MRYRU2DJmF82njnvhzGiRLAfijw2CkaKnHDlHNvjSUwgTR7j8pxj8rRArgI6uh8
         upk/krL0WmgjNjqqDlyo0Gfda7LrflBEJtXKm9gc8PFndOwnoMyder2v6aNOe+JCI9
         1mp4pZhJmY3wjSOYoLGw36XkBpIXNEnTKeTvYOiXX0N1T4eLVi96Msxf2Boow3B5KS
         6nwnBonPSKCuDOvYJxIDf6hzBJ/ecgw0uDQV5t50luUgCg/O41+uTigQK3MPRYkfzH
         vflNvSLw/6E508jXa8caRY2y1aZUwngsh6CK2xdyFXkpxiopf+r+WXWoU26wiNGwEa
         GNbjFojXUuScQ==
Subject: [PATCH 6/6] aio-dio-append-write-fallocate-race: fix directio buffer
 alignment bugs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Wed, 19 May 2021 16:57:16 -0700
Message-ID: <162146863667.2500122.9363433713420860828.stgit@magnolia>
In-Reply-To: <162146860057.2500122.8732083536936062491.stgit@magnolia>
References: <162146860057.2500122.8732083536936062491.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This program fails on filesystems where the stat() block size isn't a
strict power of two because it foolishly feeds that to posix_memalign to
allocate an aligned memory buffer for directio.  posix_memalign requires
the alignment value to be a power of two, so generic/586 fails.

The system page size generally works well for directio buffers, so use
that instead.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 .../aio-dio-append-write-fallocate-race.c          |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/src/aio-dio-regress/aio-dio-append-write-fallocate-race.c b/src/aio-dio-regress/aio-dio-append-write-fallocate-race.c
index 091b047d..d3a2e5fc 100644
--- a/src/aio-dio-regress/aio-dio-append-write-fallocate-race.c
+++ b/src/aio-dio-regress/aio-dio-append-write-fallocate-race.c
@@ -65,7 +65,7 @@ test(
 	}
 	blocksize = sbuf.st_blksize;
 
-	ret = posix_memalign((void **)&buf, blocksize, blocksize);
+	ret = posix_memalign((void **)&buf, sysconf(_SC_PAGESIZE), blocksize);
 	if (ret) {
 		errno = ret;
 		perror("buffer");

