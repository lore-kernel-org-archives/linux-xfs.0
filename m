Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8158CC46CA1
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 16:22:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235459AbjJSQWG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233233AbjJSQWF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 12:22:05 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38004119
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 09:22:04 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D112FC433CA;
        Thu, 19 Oct 2023 16:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697732523;
        bh=+i6DYL0Khgew9J1w31kwjN2t6xzEVApSPrN8JxZHRok=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=C+ZGKwoxnr1xJ+4SaRSjSlXckTEZ9yuO+i9mCqw1r4DNYNxifQmW5yedGaEjYuXWC
         D5fw01mq5KHdzpDAkw3TaMYJ934K10Bij4VhNBW0zjDTEBEaiKYaBSuH713SWRdu6K
         KGM+14L3vxsuWjFybMsWWNt/2Ox42OyGejQ0YzmHm4Upj69FpRLH/GN+IKCwHyWDMC
         /V5gtnHD1c1A9i4u4sY7JnnwRAROCHj7mXTldzLJGo70uo2ccN/jTZpB9TcDcIOoEw
         D6CpchqO+0tkLZHwuhXvMOQWyO/BJo9abw6kyoBqNXqOKnLurS8B3ONmFXNEqp7ng+
         ljyizC5K3hNIg==
Date:   Thu, 19 Oct 2023 09:22:03 -0700
Subject: [PATCH 3/4] xfs: prevent rt growfs when quota is enabled
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        osandov@fb.com, hch@lst.de
Message-ID: <169773209790.223190.3696306818932239686.stgit@frogsfrogsfrogs>
In-Reply-To: <169773209741.223190.10496728134720349846.stgit@frogsfrogsfrogs>
References: <169773209741.223190.10496728134720349846.stgit@frogsfrogsfrogs>
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
# mount /dev/sda /mnt -o rtdev=/dev/sdb,usrquota
# xfs_growfs -r /mnt

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 16534e9873f6..31fd65b3aaa9 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -954,7 +954,7 @@ xfs_growfs_rt(
 		return -EINVAL;
 
 	/* Unsupported realtime features. */
-	if (xfs_has_rmapbt(mp) || xfs_has_reflink(mp))
+	if (xfs_has_rmapbt(mp) || xfs_has_reflink(mp) || xfs_has_quota(mp))
 		return -EOPNOTSUPP;
 
 	nrblocks = in->newblocks;

