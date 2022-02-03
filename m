Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD226C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Feb 2022 16:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352185AbiBCQTy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Feb 2022 11:19:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352174AbiBCQTy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Feb 2022 11:19:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1EB4C061714
        for <linux-xfs@vger.kernel.org>; Thu,  3 Feb 2022 08:19:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E8F36141C
        for <linux-xfs@vger.kernel.org>; Thu,  3 Feb 2022 16:19:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0949C340E8
        for <linux-xfs@vger.kernel.org>; Thu,  3 Feb 2022 16:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643905193;
        bh=ngU+pyj2KaiE9bfHYvz/PmC73Wq1fvcYazL50v6jFnA=;
        h=Date:From:To:Subject:From;
        b=aXTy92N9AE8n0EkNLoR7cc7F8JhG4+S7BiqEVKVzLDpqKfqx5mEpJH2CtFjZADgNT
         5WxGQ8KzXrrt8NfwfpPulkXKyXsZ5vIjRsmwE9cT4FPNjshK9cYIeAOzn6MTGhAWap
         Fjc1UXFJiyD+ntzTO2qYKVcSouvF2O1W4uMClV+6bIwMofgDNqkNir8HXCEmYQyV+b
         uR6t9i1ZYuVM4vDTpF5ma3eNTn/1KVJTPuxEDLmMqZDp2eHM6MZ+C+sQgI5+hCYheX
         Zfp0sLBRZqrXFJiCWV6Qjh9aN/xFkeVsHJViabch5s1CiXwHc04Vgx+sl9BgHxzQXy
         /Oro4+TA0K0Sw==
Date:   Thu, 3 Feb 2022 08:19:52 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to cea267c235e1
Message-ID: <20220203161952.GR8313@magnolia>
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

cea267c235e1 xfs: ensure log flush at the end of a synchronous fallocate call

6 new commits:

Darrick J. Wong (1):
      [29d650f7e3ab] xfs: reject crazy array sizes being fed to XFS_IOC_GETBMAP*

Dave Chinner (5):
      [472c6e46f589] xfs: remove XFS_PREALLOC_SYNC
      [fbe7e5200365] xfs: fallocate() should call file_modified()
      [0b02c8c0d75a] xfs: set prealloc flag in xfs_alloc_file_space()
      [b39a04636fd7] xfs: move xfs_update_prealloc_flags() to xfs_pnfs.c
      [cea267c235e1] xfs: ensure log flush at the end of a synchronous fallocate call

Code Diffstat:

 fs/xfs/xfs_bmap_util.c |  9 ++----
 fs/xfs/xfs_file.c      | 86 +++++++++++++++-----------------------------------
 fs/xfs/xfs_inode.h     |  9 ------
 fs/xfs/xfs_ioctl.c     |  2 +-
 fs/xfs/xfs_pnfs.c      | 42 ++++++++++++++++++++++--
 5 files changed, 69 insertions(+), 79 deletions(-)
