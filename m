Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59B85CDB473
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 18:02:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234771AbjJKSCX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 14:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232891AbjJKSCW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 14:02:22 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F1B9D
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 11:02:20 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D5BC433C8;
        Wed, 11 Oct 2023 18:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697047339;
        bh=nU0hBWSsI2Ua5pET77rDKFcJ8D3pXowLO52jJs6T0r8=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=dzbplzt0fE3uUo04JoVzTfnKh/7MLdX7o23BlOGNaWfmiSeuEGdvwiLoj0v16ONmK
         e3IL6EZ3GPeRhkQM0fodhikxC+WlyyviYU0L1H6F1Iq+LE7C7an2cfPog7GFD7jhQz
         VNsiwotpDPHlk1uLOEnung57Stx3lJzoM2QYHYfMrO8JKrDQLHIWYOEG7EuRNKwIfd
         Y/qRiMxrLGyxhNQgDnD4ywXzMrujh85wE2+DyQqvDqm5q9kWI2+zEYN02kgOklr3nk
         UCTh5ywTa/AD0x+bIn30J2w5vgdWGRYAEa9x94RNsXraXO6P4EWzALqBELEdIrYQjN
         Dj1VlvtWIbQDw==
Date:   Wed, 11 Oct 2023 11:02:19 -0700
Subject: [PATCH 2/3] xfs: prevent rt growfs when quota is enabled
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Message-ID: <169704720365.1773263.12533098463437598674.stgit@frogsfrogsfrogs>
In-Reply-To: <169704720334.1773263.7733376994081793895.stgit@frogsfrogsfrogs>
References: <169704720334.1773263.7733376994081793895.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Quotas aren't (yet) supported with realtime, so we shouldn't allow
userspace to set up a realtime section when quotas are enabled, even if
they attached one via mount options.  IOWS, you shouldn't be able to do:

# mkfs.xfs -f /dev/sda
# mount /dev/sda /mnt -o rtdev=/dev/sdb
# xfs_growfs -r /mnt

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index dbc81ea0f4ff6..5429a019159a6 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -959,7 +959,7 @@ xfs_growfs_rt(
 		return -EINVAL;
 
 	/* Unsupported realtime features. */
-	if (xfs_has_rmapbt(mp) || xfs_has_reflink(mp))
+	if (xfs_has_rmapbt(mp) || xfs_has_reflink(mp) || xfs_has_quota(mp))
 		return -EOPNOTSUPP;
 
 	nrblocks = in->newblocks;

