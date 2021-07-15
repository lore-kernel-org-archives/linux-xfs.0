Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89E9DC636C8
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Jul 2021 20:56:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73108613DA
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Jul 2021 20:56:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbhGOU7b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Jul 2021 16:59:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229459AbhGOU7a (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Jul 2021 16:59:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEA046120A
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jul 2021 20:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626382597;
        bh=To/fhRo4LS0M55EPR5Ktj5oMI+GQIZ2SHhda3m6JaNM=;
        h=Date:From:To:Subject:From;
        b=MNROp4xmEkntZVe9vTWksyHQI58exd9X3bppLryro92NvgwV3Dr2uZi+YnbK5ofX5
         wgt+NrwgHMNYh3Se/cpHNqwSwSQX3DMOC3HGSgzpH6LYuBL/wQj6jmbqZM+Rfdewz7
         ya9mygxdM0VgUi05qhZgTxKM5eX8s+dh962oSZYlSzurIT2vIFTK42GlCGcJYd85/G
         qRKe8a0gXyAb4/1WIV5iy9e6Yj+MddblN+0R/vZvkFavvYw1lJmkLyjLwBmN6jzVvs
         IFKnZGifZ6PRv4hX6Su84sQ15psSbiizmAJS6bQv6DwSE+mGYZUY+TdFnRS7PW7PaF
         nhT08krt0DR6g==
Date:   Thu, 15 Jul 2021 13:56:36 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to b102a46ce16f
Message-ID: <20210715205636.GX22402@magnolia>
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

b102a46ce16f xfs: detect misaligned rtinherit directory extent size hints

New Commits:

Darrick J. Wong (7):
      [da062d16a897] xfs: check for sparse inode clusters that cross new EOAG when shrinking
      [5838d0356bb3] xfs: reset child dir '..' entry when unlinking child
      [83193e5ebb01] xfs: correct the narrative around misaligned rtinherit/extszinherit dirs
      [5aa5b278237f] xfs: don't expose misaligned extszinherit hints to userspace
      [0e2af9296f4f] xfs: improve FSGROWFSRT precondition checking
      [0925fecc5574] xfs: fix an integer overflow error in xfs_growfs_rt
      [b102a46ce16f] xfs: detect misaligned rtinherit directory extent size hints


Code Diffstat:

 fs/xfs/libxfs/xfs_ag.c          |  8 ++++++
 fs/xfs/libxfs/xfs_ialloc.c      | 55 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ialloc.h      |  3 +++
 fs/xfs/libxfs/xfs_inode_buf.c   | 28 ++++++++++++---------
 fs/xfs/libxfs/xfs_trans_inode.c | 10 +++-----
 fs/xfs/scrub/inode.c            | 18 ++++++++++++--
 fs/xfs/xfs_inode.c              | 13 ++++++++++
 fs/xfs/xfs_ioctl.c              | 27 ++++++++++++++++----
 fs/xfs/xfs_rtalloc.c            | 49 +++++++++++++++++++++++++++---------
 9 files changed, 174 insertions(+), 37 deletions(-)
