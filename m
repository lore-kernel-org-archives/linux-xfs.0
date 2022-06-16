Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 403ABC43334
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jun 2022 14:43:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377102AbiFPOnz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jun 2022 10:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377323AbiFPOnw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jun 2022 10:43:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628E941993
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 07:43:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4CDE61DC6
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 14:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE1FC34114
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 14:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655390624;
        bh=OUe4vv8tdwptTVExiIV4UJqVb8yg45vVjQu8AnisbGs=;
        h=Date:From:To:Subject:From;
        b=F5bBoiZnGSgC1SPJgsh00sP5iFb8DZTVzw2d2Vd96nFODjbZC9AWD7J/FBw0QTDi/
         zOb0w0W6pgPSQ0ulLJpgdAJpXD71NH1klfF2zHt9IGC9ndPPLBfrfpBuJefXSeJBzT
         K6z2rZx1R1M7KX7NGQq9CfmSQFP6As86GrFDKv2+RMYP6vEFAuPKwZpAIwIjsjJIzR
         /qLOAn/NHPIpxX7GvSM58I9wc4Z8RT5uFo0ySNsGwD8yrp1Euvt7SQabbcLnsjEwuU
         vIy8Z7er7z3cFpH+eGlF449Y5wRqlz1eEUb3UI430E1qnEPDexWHzOoz0aazo4N1DB
         1OXDoO8zofy6w==
Date:   Thu, 16 Jun 2022 07:43:43 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to e89ab76d7e25
Message-ID: <YqtBnxX4PmtvLI9v@magnolia>
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

(I'm still on vacation, but queued these fixes anyway...)

The new head of the for-next branch is commit:

e89ab76d7e25 xfs: preserve DIFLAG2_NREXT64 when setting other inode attributes

3 new commits:

Darrick J. Wong (3):
      [f4288f01820e] xfs: fix TOCTOU race involving the new logged xattrs control knob
      [10930b254d5b] xfs: fix variable state usage
      [e89ab76d7e25] xfs: preserve DIFLAG2_NREXT64 when setting other inode attributes

Code Diffstat:

 fs/xfs/libxfs/xfs_attr.c      |  9 +++++----
 fs/xfs/libxfs/xfs_attr.h      | 12 +-----------
 fs/xfs/libxfs/xfs_attr_leaf.c |  2 +-
 fs/xfs/libxfs/xfs_da_btree.h  |  4 +++-
 fs/xfs/xfs_attr_item.c        | 15 +++++++++------
 fs/xfs/xfs_ioctl.c            |  3 ++-
 fs/xfs/xfs_xattr.c            | 17 ++++++++++++++++-
 7 files changed, 37 insertions(+), 25 deletions(-)
