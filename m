Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07FC4C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 22:34:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C42FB64F57
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 22:34:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbhCRWd5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Mar 2021 18:33:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230368AbhCRWd1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Mar 2021 18:33:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E52A264E02;
        Thu, 18 Mar 2021 22:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616106807;
        bh=LlRueU5VCiquaro3f0CgRpsD/Js/dRpHxVC2JaFCWXE=;
        h=Subject:From:To:Cc:Date:From;
        b=srFY+kfSlR9QUoJIZmS9YjB7EN+QDKuC6KwW99ufhbvFBFClG+svqO/k5rn+1GfCW
         UKncASszLvTS4rW5p0/B3gKBXBdOnUrsRBEvUhGRKTC9r42bQhFdY4zzyf2Rg8OL0H
         noUUVyC0bC3NiaTqVWX9g1X1wIh8UlOWgh7rS47n1M9kS7atng2Vxp8D+oeuwI15wI
         bj7D1d/v4ogLJTky2AMxfrYdLoKZpPUJxy/iv+YIDSYxmoAkpiN9vaplKEMhHmBBgF
         pOHm6IS0Jcj88TP+QPw9Yj5Ad1H6koqZmJI5M29nW/en+PAmxMcP06XrViCOywByNT
         aBoF5SPKNeuIg==
Subject: [PATCHSET 0/2] xfs: make xfs_can_free_eofblocks a predicate
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Thu, 18 Mar 2021 15:33:26 -0700
Message-ID: <161610680641.1887542.10509468263256161712.stgit@magnolia>
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

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=refactor-has-eofblocks-5.13
---
 fs/xfs/xfs_bmap_util.c |  148 +++++++++++++++++++++++++-----------------------
 fs/xfs/xfs_icache.c    |   12 +---
 2 files changed, 82 insertions(+), 78 deletions(-)

