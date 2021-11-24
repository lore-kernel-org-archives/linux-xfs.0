Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 903A0C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Nov 2021 18:28:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242404AbhKXSbf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Nov 2021 13:31:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:38162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242028AbhKXSbf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Nov 2021 13:31:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61F5C60273
        for <linux-xfs@vger.kernel.org>; Wed, 24 Nov 2021 18:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637778505;
        bh=6K5PGfDdrfyAekZY8DCORojkSLWdP2Z/UAyyVIqnI+I=;
        h=Date:From:To:Subject:From;
        b=bB7q4pT/gLHt8XAMUbRkj3pHBNw4qEY3BrTvLWs+eXtMCK0DaJvPLstnjD5sPjjCQ
         qgIEFySi9vcHKP1E8v63aKHG6rEYdqfRe9yxEsziayK+KKTO5VeTfNiA6IdB3wMlkY
         Rl4bTvaAfktgFPpgCEfygVJh5EUvorUmF8k6NJuBtrCny2dvGSH8hefIKq0AOfhpB8
         JE3je+gF9sV7hDBRrqSOWd9raXkc8i1FCzBa1/JAWcPy66FFw3SdF+cAPdbHMKGJg1
         5IRGcKpa9zpEW5X2hIO5yUbCNiGs3yFZwE7T3TpMQ+W1WjswwqadAuPQJ1AnYc2W/A
         jBSq+quv4BXnQ==
Date:   Wed, 24 Nov 2021 10:28:25 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 1090427bf18f
Message-ID: <20211124182825.GD266024@magnolia>
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
the next update.  Just a couple of bugfixes and a fast forward to
5.16-rc2.

The new head of the for-next branch is commit:

1090427bf18f xfs: remove xfs_inew_wait

New Commits:

Christoph Hellwig (1):
      [1090427bf18f] xfs: remove xfs_inew_wait

Yang Xu (1):
      [a1de97fe296c] xfs: Fix the free logic of state in xfs_attr_node_hasname


Code Diffstat:

 fs/xfs/libxfs/xfs_attr.c | 27 ++++++++++++---------------
 fs/xfs/xfs_icache.c      | 21 ---------------------
 fs/xfs/xfs_inode.h       |  4 +---
 3 files changed, 13 insertions(+), 39 deletions(-)
