Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE4A5CDB474
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Oct 2023 15:48:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344015AbjJQPsJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Oct 2023 11:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343939AbjJQPsJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 11:48:09 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A23A95
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 08:48:08 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC0CC433C7;
        Tue, 17 Oct 2023 15:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697557687;
        bh=Y7yY48VRb6G/g6eRyDlM7/Tj+L54CrHXDKxEYL7klCU=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=BLf5N3vBpf19zCccj2OyAWUEPayGokdhlruMtwapil2haxupCvtBW2y9wkuUalqNB
         PbLMSNgTKmQfNwDB4nlUv2/GrwdDgVTC5x4j3gJNIB4re+b+WXE+2+TC+U0yHTY4k5
         O8oigrQ/WEwfiNoenR8wOyOPIZw3RXF/QkheWKKl7EYavAbssXj1JFr2hUQC5BTckT
         fAMs2xOg5NBcO7acomAHA5v2/CNnifnT7QtSpHXUPB24n/qy6u+LN1IkM6TU0GF8I+
         chI7KpI6ubVBypLr++O3gBNYOQ2LPHKe39VVVf9gBkwHo5cT+bGFWRmvUAdw2r2Whl
         2gTm7oz4LaVPw==
Date:   Tue, 17 Oct 2023 08:48:07 -0700
Subject: [PATCH 1/8] xfs: fix units conversion error in
 xfs_bmap_del_extent_delay
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     osandov@fb.com, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <169755741293.3165534.2595093205226976244.stgit@frogsfrogsfrogs>
In-Reply-To: <169755741268.3165534.11886536508035251574.stgit@frogsfrogsfrogs>
References: <169755741268.3165534.11886536508035251574.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The unit conversions in this function do not make sense.  First we
convert a block count to bytes, then divide that bytes value by
rextsize, which is in blocks, to get an rt extent count.  You can't
divide bytes by blocks to get a (possibly multiblock) extent value.

Fortunately nobody uses delalloc on the rt volume so this hasn't
mattered.

Fixes: fa5c836ca8eb5 ("xfs: refactor xfs_bunmapi_cow")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 26bfa34b4bbf..617cc7e78e38 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4827,7 +4827,7 @@ xfs_bmap_del_extent_delay(
 	ASSERT(got_endoff >= del_endoff);
 
 	if (isrt) {
-		uint64_t rtexts = XFS_FSB_TO_B(mp, del->br_blockcount);
+		uint64_t	rtexts = del->br_blockcount;
 
 		do_div(rtexts, mp->m_sb.sb_rextsize);
 		xfs_mod_frextents(mp, rtexts);

