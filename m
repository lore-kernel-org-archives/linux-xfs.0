Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12595C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:07:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381706AbiEEQL1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381722AbiEEQLZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:11:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F445C749
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:07:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A59DCB82DFA
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:07:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61280C385C2;
        Thu,  5 May 2022 16:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766862;
        bh=iswNCMSr8k74zAGmB5W33jakDbYnsxEtaCjWPU1DZ0Y=;
        h=Subject:From:To:Cc:Date:From;
        b=Ft3EKEHCg56vMOpEDI+ryCr1+X3opsexb8Yw/0lIlQUjHkv5VOsz+6OITKwl1Zsah
         fWJ1glMU3nUiaGMAF5U7m9xw/BAltpb2JHqsJjIz3sCvQ6os+yq/6cYtiVMjBYSKH6
         uD/5RA+Jr6peDpTxjhbpTTZ3lh9SaZamSlCUlOGlyfeFvZCE9RB1j7sft3qo4K1wv/
         I+TRrgE7DxBfM6GaV973S6LNK9+PJhMz00VGPg7pIYBGxB1x4Q+PfV/Kl8DBjwifsz
         Cgt/6zPkyQfvRMmxKAriwk6TxbZL0Hvy+kUkaAbiH3lghDunDgJCcMS92tyrjsbfKK
         mbklMKD7jIW4w==
Subject: [PATCHSET 0/6] xfs_scrub: small performance tweaks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 09:07:41 -0700
Message-ID: <165176686186.252160.2880340500532409944.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Improve the performance of xfs_scrub when scrubbing file metadata by
using the file descriptor to issue scrub ioctls instead of scrubbing by
handle.  This saves us from having to do an untrusted iget (since we
have an open fd, we know the inode number is good) for every single
scrub invocation.  Surprisingly, this adds up to about a 3% reduction in
runtime for phase 3.

Second, if the filesystem doesn't require any repair work and scrub was
invoked in wet run (aka no -n) mode, then the only work for phase 4 is
to run FITRIM.  In this case, phase 4 can skip the precautionary
fscounter scan that we do before running metadata repairs since we'll do
that during phase 7.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-performance-tweaks
---
 scrub/phase3.c |  122 ++++++++++++++++++++++++++++++++++++++++----------------
 scrub/phase4.c |   55 ++++++++++++++++++++-----
 scrub/phase7.c |    2 -
 scrub/repair.c |   17 +++++++-
 scrub/repair.h |    6 +++
 scrub/scrub.c  |  120 ++++++++++++-------------------------------------------
 scrub/scrub.h  |   23 ++---------
 7 files changed, 185 insertions(+), 160 deletions(-)

