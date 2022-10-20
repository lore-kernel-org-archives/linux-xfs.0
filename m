Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77D6FC433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Oct 2022 16:48:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbiJTQsR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Oct 2022 12:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbiJTQsC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Oct 2022 12:48:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9C534DF0
        for <linux-xfs@vger.kernel.org>; Thu, 20 Oct 2022 09:48:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D99AAB828AD
        for <linux-xfs@vger.kernel.org>; Thu, 20 Oct 2022 16:47:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817E1C433C1
        for <linux-xfs@vger.kernel.org>; Thu, 20 Oct 2022 16:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666284477;
        bh=5esdyduLvvMoJiaOn46egeTOGFMfE+KpgxplxoL14lo=;
        h=Date:From:To:Subject:From;
        b=DuO6Zrj1526sv6yu6gtyQdhqN33BXDtmYdyFZ+amABmhtVqU2VNxRYPDZ/Ge88EFE
         yAnMMmL4l15mdBv7alRGU/TQ9d1A4cNFcvv5zyRSvkrjoweqhY3Hau0LHWeaTx9Cn5
         9aK3Oy0CeZfMtqXlfpqonG63N8qY40emdgI0Ol23XMKqEiDM+xT1KUnOI0Nzf4X7ug
         MgzSbaYXvKFdeNRJMkEOpmajnV+3PLYzLxJp2mXV/b21Iy5gTJQ8ZSO/tvEWuSwyJA
         wUfz/U0KKP+tTiaw33OezIu6InzIjjCcn1bonuK0RKMtuGsp1cByTdvd6vkFBNh/mh
         bisTNyBoPb99A==
Date:   Thu, 20 Oct 2022 09:47:57 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to d08af40340ca
Message-ID: <Y1F7vXnv4lR6HlYy@magnolia>
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
the next update.

The new head of the for-next branch is commit:

d08af40340ca xfs: Fix unreferenced object reported by kmemleak in xfs_sysfs_init()

5 new commits:

Colin Ian King (1):
      [fc93812c7250] xfs: remove redundant pointer lip

Darrick J. Wong (1):
      [97cf79677ecb] xfs: avoid a UAF when log intent item recovery fails

Guo Xuenan (1):
      [13cf24e00665] xfs: fix exception caused by unexpected illegal bestcount in leaf dir

Li Zetao (1):
      [d08af40340ca] xfs: Fix unreferenced object reported by kmemleak in xfs_sysfs_init()

Zeng Heng (1):
      [cf4f4c12dea7] xfs: fix memory leak in xfs_errortag_init

Code Diffstat:

 fs/xfs/libxfs/xfs_dir2_leaf.c |  9 +++++++--
 fs/xfs/xfs_error.c            |  9 +++++++--
 fs/xfs/xfs_log_recover.c      | 10 ++++++++--
 fs/xfs/xfs_sysfs.h            |  7 ++++++-
 fs/xfs/xfs_trans_ail.c        |  3 +--
 5 files changed, 29 insertions(+), 9 deletions(-)
