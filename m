Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C19AFA3741
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Oct 2022 16:09:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbiJaQJU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Oct 2022 12:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiJaQJT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Oct 2022 12:09:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC44DF61
        for <linux-xfs@vger.kernel.org>; Mon, 31 Oct 2022 09:09:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6759612FC
        for <linux-xfs@vger.kernel.org>; Mon, 31 Oct 2022 16:09:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B74EC433D6
        for <linux-xfs@vger.kernel.org>; Mon, 31 Oct 2022 16:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667232558;
        bh=uJvuGymdDw6tVkt3c6chE31Fe/LcquMpOi6ANO4Qneo=;
        h=Date:From:To:Subject:From;
        b=mcnEKKUBJrfjW2wYa5R9k8Y4ek9JUOBmqAjbrUoGI+RbSh2dCuTVdRoKc9sPzjKoA
         i4sfdQpJ77ZUD3OkmnAp6PGNQX0bl19tPGJ8lT7JxN+GSGtAFaD5wRST6NzF+gIkf+
         ZAzBC5F8I73qXuNKUObKPpoMNQIDRg41pdwGTwvAcF2NzTM3OkoADRbEYVsXmFRn7M
         4SQYtaHxXwZo4+aziIagHLG+uvoA5DbhNbw5sEiGnvBY4ON4tBNs48mBd2tuiDMv+w
         ItYT2xXw9tY7Y7eiTtWcfJ1n1mu3NJdesTFOzrKvfw30nw/F945jJBExwE5ON1N2e1
         Lk1HcejhEG0yA==
Date:   Mon, 31 Oct 2022 09:09:17 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 47ba8cc7b4f8
Message-ID: <Y1/zLVTLNa/gVu4n@magnolia>
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

This is an announcement for transparency purposes so that I can send
myself pull requests for the two bugfix patchsets.  Don't rebase until
you see the second announcement in about 10 minutes.

The new head of the for-next branch is commit:

47ba8cc7b4f8 xfs: fix incorrect return type for fsdax fault handlers

2 new commits:

Allison Henderson (1):
      [e07ee6fe21f4] xfs: increase rename inode reservation

Darrick J. Wong (1):
      [47ba8cc7b4f8] xfs: fix incorrect return type for fsdax fault handlers

Code Diffstat:

 fs/xfs/libxfs/xfs_trans_resv.c | 4 ++--
 fs/xfs/xfs_file.c              | 7 ++++---
 fs/xfs/xfs_inode.c             | 2 +-
 3 files changed, 7 insertions(+), 6 deletions(-)
