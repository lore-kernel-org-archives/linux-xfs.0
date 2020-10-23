Return-Path: <SRS0=+s6N=D6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D1FFC56201
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Oct 2020 18:53:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECF6A20E65
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Oct 2020 18:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603479196;
	bh=HHt80Ha7I/hetx4FemW8Gke/bL18AaLTJWY5rr037oQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=U9zIGEr7rh/ZFZwhz6l705gBdAsDvOfDYtJMTC65UU7iDwXBS88qKSNr0weDIwkO7
	 0ZyflwrMOqFmd5CyrV9gbVbarw3CmyfWW7k9HKa/GlHpRXPvkqF60nYATU66vadnN+
	 uYHMCKV0DHrYVR7j1aY7rQrJR5fO6JpiLfE1J8Xw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1755083AbgJWSxL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Oct 2020 14:53:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751075AbgJWSxL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Oct 2020 14:53:11 -0400
Subject: Re: [GIT PULL] vfs: move the clone/dedupe/remap helpers to a single file
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603479190;
        bh=HHt80Ha7I/hetx4FemW8Gke/bL18AaLTJWY5rr037oQ=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=DLYX7c/AhjZTAerCcfUdQob+yeV3nEfKbuh7RwnCJSM3lf3bgk6qnBIHsF8SnkmR+
         BMC/rkc22FtzdOqjv+suTPNrnoeKrls256AWFzcnRKYKYcDykCF2I7KvmO05zHxD9S
         g/ZNTJJqgszAtbuz9YAOpASxOG1yXoKEJImiqSPo=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201022222358.GD9825@magnolia>
References: <20201022222358.GD9825@magnolia>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20201022222358.GD9825@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/vfs-5.10-merge-1
X-PR-Tracked-Commit-Id: 407e9c63ee571f44a2dfb0828fc30daa02abb6dc
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c4728cfbed0f54eacc21138c99da2a91895c8c5a
Message-Id: <160347919039.2166.4768124292251668926.pr-tracker-bot@kernel.org>
Date:   Fri, 23 Oct 2020 18:53:10 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Thu, 22 Oct 2020 15:23:58 -0700:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/vfs-5.10-merge-1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c4728cfbed0f54eacc21138c99da2a91895c8c5a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
