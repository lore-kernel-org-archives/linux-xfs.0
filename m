Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75BBAC433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 04:09:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 544D96140E
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 04:09:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhD1EKc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 00:10:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229451AbhD1EKc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Apr 2021 00:10:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2203613ED;
        Wed, 28 Apr 2021 04:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619582988;
        bh=HcqN95A7dB1ENH3z4osEJ4JF9H4bKLGHQ0WuWcN+4Nw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=X9+YljI+GpS5r/IBaWkM/D7Z3J81ap5559VdcyLGqpkFjwB9sIdmAe8qpbZM5G+BA
         rwLXNKArXjXzve9ITOFXJzKD6+l9/N8DTcXKvMPOirpndF0rlLpCkmAKjNx4P4XJfM
         3NIyAZG2sOG/DQa7swaK6mPNM2FTV4H/CLaLWFSaelOQDDYhq2tBcmam0954lCkBd4
         O0Z4N6xOVcR0cKU9Up4MDUjN8RGBIJBxA/JEhjVg4hs3N1AIsG0xSXsFnGaR1eyt3N
         SAvqOkk/TdymOxmFue6wrakBsMMCy7gUVOORaDyVJIHBYokrAR8Ypnc0K0LN9W6QdS
         puBBOWJd/EW3Q==
Subject: [PATCH 3/3] common/rc: relax xfs swapfile support checks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 27 Apr 2021 21:09:47 -0700
Message-ID: <161958298729.3452499.11374046947109958849.stgit@magnolia>
In-Reply-To: <161958296906.3452499.12678290296714187590.stgit@magnolia>
References: <161958296906.3452499.12678290296714187590.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In commit 725feeff, I forgot that xfs has *not* always supported all
swap file configurations -- the bmap swapfile activation prior to the
introduction of iomap_swapfile_activate did not permit the use of
unwritten extents in the swap file.  Therefore, kick xfs out of the
always-supported list.

Fixes: 725feeff ("common/rc: swapon should not fail for given FS in _require_scratch_swapfile()")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/common/rc b/common/rc
index 429cc24d..7882355a 100644
--- a/common/rc
+++ b/common/rc
@@ -2494,10 +2494,10 @@ _require_scratch_swapfile()
 	statx_attr="$($XFS_IO_PROG -c 'statx -r' $SCRATCH_MNT/swap 2>/dev/null | grep 'stat.attributes = ' | awk '{print $3}')"
 	test "$((statx_attr & 0x200000))" -gt 0 && _notrun "swapfiles not supported on DAX"
 
-	# ext* and xfs have supported all variants of swap files since their
+	# ext* has supported all variants of swap files since their
 	# introduction, so swapon should not fail.
 	case "$FSTYP" in
-	ext2|ext3|ext4|xfs)
+	ext2|ext3|ext4)
 		if ! swapon "$SCRATCH_MNT/swap" >/dev/null 2>&1; then
 			_scratch_unmount
 			_fail "swapon failed for $FSTYP"

