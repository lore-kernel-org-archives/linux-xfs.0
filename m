Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D5ACC6FD1C
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Mar 2023 20:25:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbjCXUZn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Mar 2023 16:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbjCXUZm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Mar 2023 16:25:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A4A128
        for <linux-xfs@vger.kernel.org>; Fri, 24 Mar 2023 13:25:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 619B462CAA
        for <linux-xfs@vger.kernel.org>; Fri, 24 Mar 2023 20:25:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A1EC433EF;
        Fri, 24 Mar 2023 20:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679689540;
        bh=m3OJlhE9fZl4dpTOjSwWoB0zdrbFIW63wdCMOx8CdNA=;
        h=Date:From:To:Cc:Subject:From;
        b=bRBYbH3s0LMTFT8D0uTjSQap2U2IpPmrqhzu2AeFaQy0snL+kbkKTPV6opHsbeuhu
         1KIKdH7fpxii2v4mlsQvEQ2Ew+6w+HYSdw6hDdAE4/wG7ZvP81Lb3dQ/9wMKTwAoMx
         rSjVZlscW2f9SEpOWsHjPaEFQPnr8VrTeVKpQMhoeYOujx+zePri229RMoaaEjNm90
         j0UM8OUE+/V3m8zBlUkUuwsuv2gPI1ekmzxDwdoWsVxKJSpPrn6uS7CjLsyXFte7QB
         fOMJpK2DWus6vFFqh80P7DmQTSxMfSIS8Crmc4KnK+CIFoS2NsQg09xKreapH0Hknz
         08mYFrSHSW79g==
Date:   Fri, 24 Mar 2023 13:25:40 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 4dfb02d5cae8
Message-ID: <167968939075.265996.16878726595607777381.stg-ugh@magnolia>
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
the next update.  Same fixes as this morning, only now with a fix to the
new tracepoints patch because I exported the patch from djwong-dev, and
git-am decided to rearrange the changes when I import it into xfs-fixes.
Wrangling patches out of git and back in through a mailing list is
stuuuupid.

The new head of the for-next branch is commit:

4dfb02d5cae8 xfs: fix mismerged tracepoints

3 new commits:

Darrick J. Wong (3):
[fcde88af6a78] xfs: pass the correct cursor to xfs_iomap_prealloc_size
[e2e63b071b2d] xfs: clear incore AGFL_RESET state if it's not needed
[4dfb02d5cae8] xfs: fix mismerged tracepoints

Code Diffstat:

fs/xfs/libxfs/xfs_alloc.c | 10 ++++++----
fs/xfs/xfs_iomap.c        |  5 ++++-
2 files changed, 10 insertions(+), 5 deletions(-)
