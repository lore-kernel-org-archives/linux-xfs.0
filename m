Return-Path: <SRS0=yyqk=36=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACB3AC2BA83
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Feb 2020 00:10:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 786B020714
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Feb 2020 00:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581293404;
	bh=+0ab0nW6FMHJRBjMyIMhOaR1V8oIJkxBL7h0WmWrCfo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=B5ZnlkcMtCzRA/8rzgVNiPQA82+LRYU54VUuvUo9h5BbaVb1brwuCNKkE3ofjAq6d
	 2iLRnFJJJxdpWuxHVp+B1btOJ23gHRiWRsT/aYTWuulUEstkOw/w5t8DwPxoDFJJt7
	 olFE0kqKA5qrYdp34+lnM84H8E7QJIOzhAKLJXlk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbgBJAKD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 9 Feb 2020 19:10:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:52444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726915AbgBJAKD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 9 Feb 2020 19:10:03 -0500
Subject: Re: [GIT PULL] New zonefs file system for 5.6-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581293403;
        bh=+0ab0nW6FMHJRBjMyIMhOaR1V8oIJkxBL7h0WmWrCfo=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=bA2hcZRVtszjl11frrSRyUwAsC22LmQ4ah8n4aemLkrLQMtuAPrRtz4vj5W4kazCW
         YIXY/1abYJZLrQEXp8d2mz5bRgyoQ5UrzbJgzCSQCf+OM2FWKoevJgKM1Fme0nz/RL
         TLBjYa7G4oxAQFcTEbYAQ055ziYeaYRD5YLT+cgc=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200207150239.685712-1-damien.lemoal@wdc.com>
References: <20200207150239.685712-1-damien.lemoal@wdc.com>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200207150239.685712-1-damien.lemoal@wdc.com>
X-PR-Tracked-Remote: ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/dlemoal/zonefs.git/
 tags/zonefs-5.6-rc1
X-PR-Tracked-Commit-Id: fcb9c24bef3d1d0942c50fb25fbb8ab45c7c3753
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 380a129eb2c20d4b7b5be744e80e2ec18b24220b
Message-Id: <158129340302.32523.16390158715022108156.pr-tracker-bot@kernel.org>
Date:   Mon, 10 Feb 2020 00:10:03 +0000
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Sat,  8 Feb 2020 00:02:39 +0900:

> ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/dlemoal/zonefs.git/ tags/zonefs-5.6-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/380a129eb2c20d4b7b5be744e80e2ec18b24220b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
