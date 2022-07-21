Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ADF3C43334
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jul 2022 17:01:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiGURBC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Jul 2022 13:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiGURBB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jul 2022 13:01:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 254E43A493
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jul 2022 10:01:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBD9661E92
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jul 2022 17:01:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F613C3411E
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jul 2022 17:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658422860;
        bh=Z5loci/t1HvMKVq0CpTExGCfU5dhXlvOANHnYEmO4JI=;
        h=Date:From:To:Subject:From;
        b=QEEBGa8jI0DUOTlyKSbjTxm2fqfQaqwB3uVnaso3dDcuAHScAgW/O4sikqfJX3fCX
         korFB9z/95shjkjh/7dODT1sjpnNhnEQ1Re1kiTANeuAP1UfsasL7oCE3u0er4R+Dd
         4CrDrAzVs8kitON6tqK0jge33inTPQzU2XWOawKX17wjGHC3O1LpQ2NUEGp8B2y74E
         WL7qHS7t6UMKHZdwMq4Y1jEy8/WW+93JjrqbMZpg+it2eciRRFytQ8c1yf94jbhAnS
         0RTs0Da9qZXQP7wYhCuuoh8g017VUwnhuRLdrTWuR2W+o4hkc2iFloIw2PzV1cCrzp
         dsOGNxsmcNelw==
Date:   Thu, 21 Jul 2022 10:00:59 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-documentation: for-next updated to b91f114
Message-ID: <YtmGS76FtWgiVEz9@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


Hi folks,

The for-next branch of the xfs-documentation repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-documentation.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

b91f114 xfsdocs: fix a minor levelling problem

2 new commits:

Darrick J. Wong (1):
      [b91f114] xfsdocs: fix a minor levelling problem

Xiaole He (1):
      [9d491d4] xfsdocs: fix extent record format image

Code Diffstat:

 .../XFS_Filesystem_Structure/allocation_groups.asciidoc |   4 ++--
 design/XFS_Filesystem_Structure/data_extents.asciidoc   |  14 +++++++++++++-
 design/XFS_Filesystem_Structure/images/31.png           | Bin 10652 -> 0 bytes
 3 files changed, 15 insertions(+), 3 deletions(-)
 delete mode 100644 design/XFS_Filesystem_Structure/images/31.png
