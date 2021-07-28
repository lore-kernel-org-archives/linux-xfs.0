Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B192BC432BE
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 21:15:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94E4F60462
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 21:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbhG1VP5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 17:15:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:34082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231350AbhG1VP5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Jul 2021 17:15:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72DC6600CD;
        Wed, 28 Jul 2021 21:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627506955;
        bh=rkcDsL5Ecs4mNgKTu8iKm1vOaNpB2DEOYIRtydiEgUU=;
        h=Subject:From:To:Cc:Date:From;
        b=iq8m5Loh7/cNFE5SzVIjCMXybsQT3lBfnn3Yjs+nWZzvfJMhRKT5Zjo3++j3eCB+U
         SSQ2IJJNRH217hSXS52dlrR47R49BjZ5tfuR9Y9WKYJx4J4X1Srr6ONIms4fABEsUI
         xi7ATwE/mHUy5N9GAPBMJrPjatL73xHLNVa2OT+9Av0WJXMGfT2ubU+tEacSSIrOUM
         /Th57iA9Q9Pn3xMmqJyK8cMmwnwbvYkVJPVLKMCTdnpbAu/gGfNOtxUVAE8okoDAMd
         cE330eZFOWJ0tKx/dqiOuWLBkd0UZACjBaKBevakSyj4dnxGNJ088P+iw352c9ga7e
         hFE91CDtZdG5w==
Subject: [PATCHSET 0/2] xfs_io: small fixes to funshare command
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        linux-xfs@vger.kernel.org
Date:   Wed, 28 Jul 2021 14:15:55 -0700
Message-ID: <162750695515.44508.15362873895872268737.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

A couple of small fixes to the funshare command.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=funshare-fixes
---
 io/prealloc.c |   33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

