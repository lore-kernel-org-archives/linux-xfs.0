Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E006BC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 17:24:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF73961268
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 17:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234308AbhKKR1b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Nov 2021 12:27:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:47330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233987AbhKKR1a (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Nov 2021 12:27:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AF6060EE4
        for <linux-xfs@vger.kernel.org>; Thu, 11 Nov 2021 17:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636651481;
        bh=FQjmRdvMApbondxxWjU8fhuVJQf3x/WCJY6RfKp98oE=;
        h=Date:From:To:Subject:From;
        b=M+eKbHxUCFie1k3DrqhGTOfVMctYKqtIp/Vh6ap6tOUNgkUQcfGaGYVfnRb+KyWiN
         4zy7/dmwXH/whz8+nVd967gaoyvd49I9advaIDgIRMnvHtYcaJQpZ7jWjBN0IKFHCV
         dO+Fx77g33Xpy1ad9IWfyoMX1ogpVfvO48vQQF93NXqyBG75H/LoAjV5a5b58P8NYr
         UODptT1MpQN/NV1PowVJfQU+Qz+qeB8VaDfv4dzT+Ix4f5R8dbBiyiz4g4nr4MM7nb
         NeDvLPxExCu6qVzqxalfoP6vFuC/42vSN6TbUs7V+mmFD+TWoa2aaZaEUfW8pYisLv
         1McMLbw4gIDQg==
Date:   Thu, 11 Nov 2021 09:24:40 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 4a6b35b3b3f2
Message-ID: <20211111172440.GD24307@magnolia>
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

4a6b35b3b3f2 xfs: sync xfs_btree_split macros with userspace libxfs

New Commits:

Darrick J. Wong (1):
      [4a6b35b3b3f2] xfs: sync xfs_btree_split macros with userspace libxfs

Eric Sandeen (1):
      [29f11fce211c] xfs: #ifdef out perag code for userspace

Yang Guang (1):
      [5b068aadf62d] xfs: use swap() to make dabtree code cleaner


Code Diffstat:

 fs/xfs/libxfs/xfs_ag.c       | 2 ++
 fs/xfs/libxfs/xfs_ag.h       | 8 +++++---
 fs/xfs/libxfs/xfs_btree.c    | 4 ++++
 fs/xfs/libxfs/xfs_da_btree.c | 5 +----
 4 files changed, 12 insertions(+), 7 deletions(-)
