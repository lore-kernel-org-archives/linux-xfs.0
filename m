Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFBF8C433F5
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Sep 2021 01:30:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A619461152
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Sep 2021 01:30:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235079AbhIRBbx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Sep 2021 21:31:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:37342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235000AbhIRBbx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Sep 2021 21:31:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75EF96112E;
        Sat, 18 Sep 2021 01:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631928630;
        bh=2VzjGf1PjNmYUTobjciHyr0hOdH/sNcV1WuJdO3Vs8s=;
        h=Subject:From:To:Cc:Date:From;
        b=YxqwHL7DKA2JLXceE3K57EIjXZgZJCr8JV8LPwykXkK6/JPzV7UAe7rDf6Igf7wp6
         qm9hMh8ckGX5TjxFYEkHZWTXWJ1+tBsqonfMz2C/u/ClXOmeCMqwsBCH5Xi5UCboC6
         QNJwa2fkTsMMQbtrpiIY+ixx4eOPKGiOAATsP4vLliffuC3vOqoXpTk5TccCgrlHbU
         a/s8+NRBXyNvoq/g3KgSR8OYWg2IQELnMFUGR5MNtYdz+1DiZITZhlqOyUD4CqEJxX
         qHQ73TS8gnPIYDquHrixNTy9ZlQrjkq7vQeoEtCriBFqGTWZnaV7qnpWr134Do/Unr
         x/5XdKHED1L6g==
Subject: [PATCHSET RFC achender 0/2] xfs: refactor log recovery resource
 capture
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, allison.henderson@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 17 Sep 2021 18:30:30 -0700
Message-ID: <163192863018.417887.1729794799105892028.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

During review of Allison's logged xattrs patchset last cycle, I noticed
that there was an opportunity to clean up some code structure
differences between how regular runtime deferred attributes hold on to
resources across a transaction roll, and how it's done during log
recovery.  This series, in cleaning that up, should shorten her
patchset and simplify it a bit.

During regular operation, transactions are allowed to hold up to two
inodes and two buffers across a transaction roll to finish deferred log
items.  This implies that log recovery of a log intent item ought to be
able to do the same.  However, current log recovery code open-codes
saving only a single inode, because that was all that was required.

With atomic extent swapping and logged extended attributes upon us, it
has become evident that we need to use the same runtime mechanisms
during recovery.  Refactor the deferred ops code to use the same
resource capture mechanisms for both.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=log-recovery-defer-capture-5.16
---
 fs/xfs/libxfs/xfs_defer.c  |  171 +++++++++++++++++++++++++++++++-------------
 fs/xfs/libxfs/xfs_defer.h  |   38 ++++++++--
 fs/xfs/xfs_bmap_item.c     |    2 -
 fs/xfs/xfs_extfree_item.c  |    2 -
 fs/xfs/xfs_log_recover.c   |   12 +--
 fs/xfs/xfs_refcount_item.c |    2 -
 fs/xfs/xfs_rmap_item.c     |    2 -
 fs/xfs/xfs_trans.h         |    6 --
 8 files changed, 157 insertions(+), 78 deletions(-)

