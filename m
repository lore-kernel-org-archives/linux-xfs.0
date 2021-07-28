Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21ECAC432BE
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 21:16:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04B7B6103B
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 21:16:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbhG1VQK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 17:16:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231574AbhG1VQK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Jul 2021 17:16:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B5A06101C;
        Wed, 28 Jul 2021 21:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627506968;
        bh=dMnEdaPx9/EdrUMGVUrKTs1ZyPeyDqU7vPvS/9KdVc0=;
        h=Subject:From:To:Cc:Date:From;
        b=iKctsdfXGn68K983+MIdI3MG0sw1NvLxs5sGPvY/xhWV79Yjd8MIsXFeborIHh+2e
         g/pd0cGoTZ+OvaiLD/njdMfa3zjIXpKQ/ZAo8U0M2MLB09lRy5l1QrxqVXsJzgwCKe
         VnWO/GPeSBwXZBhkU9FvvooqIQD32FmSP9dOhg9pVXdteu2LM7HxWU+6zvi6Q2A0FP
         XbzkARXrFFNTa1OZT+efNDwG+CVdMsN9a/6MllJZCxH+VP4PTTHvDl2KDAu3wbG2hA
         3EHcKmgazxHmKafsZC3KTtMHqOz8i3D/XPa2P/Tlfrg4yXU8I8G+sCFP3f4AEAMN46
         0XezXvghb1mog==
Subject: [PATCHSET 0/2] xfs_io: small fixes to fsmap command
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Wed, 28 Jul 2021 14:16:07 -0700
Message-ID: <162750696777.45811.13113252405327690016.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

A couple of small fixes to the fsmap command.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=fsmap-fixes
---
 io/fsmap.c |   33 ++-------------------------------
 1 file changed, 2 insertions(+), 31 deletions(-)

