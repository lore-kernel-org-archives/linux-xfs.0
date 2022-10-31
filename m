Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F1FFFA3741
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Oct 2022 16:31:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbiJaQb0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Oct 2022 12:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbiJaQb0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Oct 2022 12:31:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C2112639
        for <linux-xfs@vger.kernel.org>; Mon, 31 Oct 2022 09:31:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23A1FB81902
        for <linux-xfs@vger.kernel.org>; Mon, 31 Oct 2022 16:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0FD6C433C1
        for <linux-xfs@vger.kernel.org>; Mon, 31 Oct 2022 16:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667233815;
        bh=ucaoB1Gj9x1vR/VJp0/JBHtay2kMy3lXx8Vme/50kbU=;
        h=Date:From:To:Subject:From;
        b=aGnytIU4K8vOeyhBcUZU9WEvTm1zqauDctWNG6vhoHtTvJZRWHdioSvQ3yT8rW0eV
         D/BfzUBa+DQMeavl1ogNA6tKebdiSlaqAut2JZCr8b6BMtQDLl2FzE2aR5kURHKTPM
         fC2WDIpsnqLZ7N4yolcBgcI2v/ojRXXIok98edZHZ/ec7jzoxBLHKcmABqlAkuD6OX
         LlKm4/yRaXlFilqQ5sdPO2DojGDD+VjEKmD5VkKXmCtgIRy4VegLvqT53If8Ozs1eg
         0uGskQ/Nqer2oDNB9ecT/DnXja2CvyQz1dU6Qnal/SVe0bMxWVRsjGcfsHb4sOU4E1
         JFrtRVX4aZOuQ==
Date:   Mon, 31 Oct 2022 09:30:15 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 9f187ba0d517
Message-ID: <Y1/4F6d02GjCfYnq@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.  This second update contains bugfixes for log recovery
so that they can get wider testing in for-next.  There will be a third
update in a day or two with the fixes for infinite loops in the refcount
processing code.

The new head of the for-next branch is commit:

9f187ba0d517 Merge tag 'fix-log-recovery-misuse-6.1_2022-10-31' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-6.1-fixes

9 new commits:

Darrick J. Wong (9):
      [59da7ff49d67] xfs: fix validation in attr log item recovery
      [a38ebce1da27] xfs: fix memcpy fortify errors in BUI log format copying
      [a38935c03c79] xfs: fix memcpy fortify errors in CUI log format copying
      [b45ca961e946] xfs: fix memcpy fortify errors in RUI log format copying
      [03a7485cd701] xfs: fix memcpy fortify errors in EFI log format copying
      [3c5aaaced999] xfs: refactor all the EFI/EFD log item sizeof logic
      [921ed96b4f4e] xfs: actually abort log recovery on corrupt intent-done log items
      [950f0d50ee71] xfs: dump corrupt recovered log intent items to dmesg consistently
      [9f187ba0d517] Merge tag 'fix-log-recovery-misuse-6.1_2022-10-31' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-6.1-fixes

Code Diffstat:

 fs/xfs/libxfs/xfs_log_format.h | 60 ++++++++++++++++++++++++---
 fs/xfs/xfs_attr_item.c         | 67 +++++++++++++++---------------
 fs/xfs/xfs_bmap_item.c         | 54 ++++++++++++------------
 fs/xfs/xfs_extfree_item.c      | 94 ++++++++++++++++++++----------------------
 fs/xfs/xfs_extfree_item.h      | 16 +++++++
 fs/xfs/xfs_ondisk.h            | 23 +++++++++--
 fs/xfs/xfs_refcount_item.c     | 57 +++++++++++++------------
 fs/xfs/xfs_rmap_item.c         | 70 ++++++++++++++++---------------
 fs/xfs/xfs_super.c             | 12 ++----
 9 files changed, 266 insertions(+), 187 deletions(-)
