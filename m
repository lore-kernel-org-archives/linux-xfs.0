Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4915C433C1
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:21:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA1F0619F8
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:21:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbhCZAVK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:21:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229695AbhCZAVA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 20:21:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E303A619F3;
        Fri, 26 Mar 2021 00:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616718060;
        bh=GnONXdNaBqZZuRDECTjgF5Gf8fPX8j+q2N3mF66CBsk=;
        h=Subject:From:To:Cc:Date:From;
        b=em3PxGJds6ZEgslnsfQlW9Ezxu7PvZUiLv+4krkBu18lPEJHZOhA6wmCRnxdv/gXR
         wnXWN8i9IxMxhWc2DVr+tYJdxDzVGJ9dL4/6L40BiqkX8c76Mvnjez66KmJR9TtIUz
         F69OiJZ+Uwizi43Z25zo3mXXHwmGg2z2MMcuUyjCTYzuzNSVK1hPjNOLJmdNoq/FaH
         9wax6AZYhKRforhBfMS/i7fsG4TXHz3LNTwaNsNj1w7G1c1CK+8vFRSRCmg3HWKP+j
         3QPioBY52jJNBXS7K4GSdzmiKcXtfhL3JwoZ36S/GkMn6M6OBEu7ZpYvnFEm4ghdlk
         Me7sjXxy9ai9g==
Subject: [PATCHSET v2 0/2] xfs: make xfs_can_free_eofblocks a predicate
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Thu, 25 Mar 2021 17:20:59 -0700
Message-ID: <161671805938.621829.266575450099624132.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

The two patches in this set reorganize the responsibilities between
xfs_can_free_eofblocks and xfs_free_eofblocks so that the first becomes
a true predicate, and the second becomes a simple update function.  The
goal is to be able to use the predicate to decide if a linked but
unopened inode has speculative post-EOF preallocations and hence must go
through the extra inactivation step.

This requires a slight change in behavior of the background block gc
workers, which will try to take the IOLOCK before calling the predicate.

v2: Various fixes recommended by Christoph.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=refactor-has-eofblocks-5.13
---
 fs/xfs/xfs_bmap_util.c |  155 ++++++++++++++++++++++++++----------------------
 fs/xfs/xfs_icache.c    |   15 ++---
 2 files changed, 92 insertions(+), 78 deletions(-)

