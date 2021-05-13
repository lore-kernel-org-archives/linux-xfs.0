Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F942C433ED
	for <linux-xfs@archiver.kernel.org>; Thu, 13 May 2021 01:01:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FE85610F7
	for <linux-xfs@archiver.kernel.org>; Thu, 13 May 2021 01:01:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232858AbhEMBCw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 21:02:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:50630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229646AbhEMBCv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 May 2021 21:02:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78D6F610F7;
        Thu, 13 May 2021 01:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620867702;
        bh=oaxJimZn2bX9pgM8ZIe2tfHS6ys1wYsvBNWn72D5h2U=;
        h=Subject:From:To:Cc:Date:From;
        b=E0IE6wPBnBbFNfpAcD16lCaKX69dk0MqkfrzJo/aILjvZJOYIN5SDEng0MLqjyioT
         rgJewN140jDX0bEaYMKYz1gTINWsOd16xVDyHSeXZrVsh+6VRaVqLyAjZwLYQBG+Mt
         v6yzjn8wqElJLh+5tBStCMBe8sAh0DEHgzgQgumjKnTMRaIsTNSQmPk1quf/boENWu
         Borvwk+0omgVUqHW97Ic8klEwqt3eNpkWzqnlKB0PXKuEAo5TjASNWpB0t0PPYGeUm
         QatqadwdkrzCbsLNVVnMH91E1f/ipeUVPQhwcwG4YRrKxBFBn6tj6vTZ3FK08b8Oh3
         gi5Gh2Ra6006g==
Subject: [PATCHSET 0/4] xfs: strengthen validation of extent size hints
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 12 May 2021 18:01:42 -0700
Message-ID: <162086770193.3685783.14418051698714099173.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

While playing around with realtime extent sizes and extent size hints, I
noticed that it was very possible for userspace to trip the inode
verifiers if they tried to set an extent size hint that wasn't aligned
to the rt extent size and then create realtime files.  This series
tightens the existing checks and refactors the ioctls to use the libxfs
validation functions like the verifiers, mkfs, and repair use.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=extsize-fixes-5.13
---
 fs/xfs/libxfs/xfs_inode_buf.c |   20 ++++++---
 fs/xfs/xfs_inode.c            |   19 +++++++++
 fs/xfs/xfs_ioctl.c            |   90 +++++++++--------------------------------
 3 files changed, 52 insertions(+), 77 deletions(-)

