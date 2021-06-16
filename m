Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57A25C48BE5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 23:55:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3479F6112D
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 23:55:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234723AbhFPX5e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Jun 2021 19:57:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:55132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229503AbhFPX5c (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 16 Jun 2021 19:57:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5016461351;
        Wed, 16 Jun 2021 23:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623887725;
        bh=Q63mQtF0nTYFQD0O55cm8Ib0vBWo1+Fv61ZEd6/t0SE=;
        h=Subject:From:To:Cc:Date:From;
        b=Qqm24kdpDzTEfm5fihIMru0fZXjzUPs6elqR5+WtbGa+1/qwRjydi0Ym5FxkLNcNE
         3c9csbTbPAI2EM0CHOsTXqvIOywCwNqW4a5uL0syKalQF787HQcyDoHnMngrClDNCf
         f7PtIjCHYcRqu094bfbvsmB6fX93rEokK50PKRzajLWVySYyFVPRp2r/W1TIBGXSP2
         AKh5QkdmR73iufL755Hv7xkcKLCHkIXvaMbiBxEpD14U1+M+VKOUQEF/Un4Gkdlxbt
         /QALDIfIzz5BxWVrXiv9oOUFRoAhFKVxuISTOzbiCCoXjNz2Zx3/dYEgE9L8VCQgH1
         TXVybOjRZdzSA==
Subject: [PATCHSET 0/2] xfs: various small fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 16 Jun 2021 16:55:24 -0700
Message-ID: <162388772484.3427063.6225456710511333443.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

I found a couple of small things that looked like they needed cleaning
while debugging other problems in my development tree.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes-5.14
---
 fs/xfs/xfs_fsops.c  |    2 +-
 fs/xfs/xfs_icache.c |    8 ++++----
 fs/xfs/xfs_icache.h |    6 +++---
 fs/xfs/xfs_trace.h  |    4 ++--
 4 files changed, 10 insertions(+), 10 deletions(-)

