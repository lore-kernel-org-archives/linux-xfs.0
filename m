Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB003C4707F
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 16:52:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADCF4613B6
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 16:52:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234203AbhE0QyM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 12:54:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:45272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236335AbhE0QyK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 May 2021 12:54:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BA8D613B5
        for <linux-xfs@vger.kernel.org>; Thu, 27 May 2021 16:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622134357;
        bh=fnajOHLhGTbCNFj3jcfIzdWAh9mSENM4spZ7865gVjA=;
        h=Date:From:To:Subject:From;
        b=HDqW2VbaUQ14nU9Z7IEKNrDuB5yL+ctqJXkPlawO2/ZsVtaQ035o/G8hvQTk+jMtI
         F8ISiR+ztHyLiWnLOmk77UDNJ1kleJ9+8pnMDtLkqomPpe6G1KMkMLdTtC8wcChq/V
         g8RG1hBPMvHOdQ2tbJJrx6Gzz5HHAJd1luVrYtyeECbnl2lRcKOQgKxPcCjLrDqmWG
         g9Fu/TIyzAzOb0i7KeU3Ax+qPy6ry+0cfMwJYwmmRudnVavuGlsumRXtvQqzlCWwb1
         sc/SdM2/Ucx/M8qa+pXnHOaAYxfBPevrHxRlu5N8GrybGkrrsC5m4O/P9Xtr5QcDFv
         rUG+JiL/tFWLA==
Date:   Thu, 27 May 2021 09:52:36 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 0fe0bbe00a6f
Message-ID: <20210527165236.GF202121@locust>
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

0fe0bbe00a6f xfs: bunmapi has unnecessary AG lock ordering issues

New Commits:

Darrick J. Wong (4):
      [0f9342513cc7] xfs: check free AG space when making per-AG reservations
      [6b69e485894b] xfs: standardize extent size hint validation
      [603f000b15f2] xfs: validate extsz hints against rt extent size when rtinherit is set
      [9f5815315e0b] xfs: add new IRC channel to MAINTAINERS

Dave Chinner (2):
      [991c2c5980fb] xfs: btree format inode forks can have zero extents
      [0fe0bbe00a6f] xfs: bunmapi has unnecessary AG lock ordering issues


Code Diffstat:

 MAINTAINERS                     |   1 +
 fs/xfs/libxfs/xfs_ag_resv.c     |  18 +++++--
 fs/xfs/libxfs/xfs_bmap.c        |  12 -----
 fs/xfs/libxfs/xfs_inode_buf.c   |  46 ++++++++++++++++--
 fs/xfs/libxfs/xfs_trans_inode.c |  17 +++++++
 fs/xfs/xfs_inode.c              |  29 ++++++++++++
 fs/xfs/xfs_ioctl.c              | 101 ++++++++++++++--------------------------
 fs/xfs/xfs_message.h            |   2 +
 8 files changed, 140 insertions(+), 86 deletions(-)
