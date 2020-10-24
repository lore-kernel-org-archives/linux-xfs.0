Return-Path: <SRS0=Od9L=D7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2FE6C388F9
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Oct 2020 00:26:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F6332467F
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Oct 2020 00:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603499176;
	bh=xEZA5eAyvjKsnmWcVA6BjM6jx4I2oOntToTPsOKMtO4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=f6+j1nO0FfehUhXflQoz+DwaU1L7BgRyqj3j3M56LF/BQXOXImjjvPV8edqj8CDzW
	 XsIKKi6+xiP22IvMuWTSdhKRrVABCXkLqT2I+CVm4jrAjTRo8S6GJfKHg5kUYXpdCx
	 AQCwS+Ofp0AKCEfTCoFm6wWaNORWVIsY6W85rLuk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1756354AbgJXA0N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Oct 2020 20:26:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:40346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756287AbgJXA0N (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Oct 2020 20:26:13 -0400
Subject: Re: [GIT PULL] xfs: fixes for 5.10-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603499172;
        bh=xEZA5eAyvjKsnmWcVA6BjM6jx4I2oOntToTPsOKMtO4=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=AnwiXFI8bvA71FOhGi90KFoBH204A7egTtrC6+Qk0vs7l7bTyKm3Y+FMqJHC2oVYE
         5spFpjBUbqFwBKJS2msaaL9ABufZuZHha5SYrXajfzDJUZyo+rrnha52ExbJ4c/CqD
         E3nUWC30xd9L2ZIw0CGqm+Xd4lGJLk+gs5iKJ+dY=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201023215546.GU9832@magnolia>
References: <20201023215546.GU9832@magnolia>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201023215546.GU9832@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.10-merge-7
X-PR-Tracked-Commit-Id: 2e76f188fd90d9ac29adbb82c30345f84d04bfa4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f11901ed723d1351843771c3a84b03a253bbf8b2
Message-Id: <160349917257.12519.11429881560285800762.pr-tracker-bot@kernel.org>
Date:   Sat, 24 Oct 2020 00:26:12 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        sandeen@sandeen.net, hch@lst.de
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Fri, 23 Oct 2020 14:55:46 -0700:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.10-merge-7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f11901ed723d1351843771c3a84b03a253bbf8b2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
