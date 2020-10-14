Return-Path: <SRS0=c4da=DV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1FCDC43467
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Oct 2020 19:30:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EE002223F
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Oct 2020 19:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602703811;
	bh=20XkeA8xKqwTx4Bcvf0F8549PQcXxbGnosNdRXGgVm4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=nf5r5Q8gQKiAwc9XX7ERtweHBuSW5SxJAZOylrR1mYqXNzyyzFPr0sbr6Wp7by5T4
	 LOTYgVcnRYYR8FWr/K73rRHXS3xHq3g2o/SDMG1hfImdL1tO3fwixMDzxBpMomdgEG
	 EG9zj+zd72xGooeX9m5XD58i/xkpxcfFBXSBEdIY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390663AbgJNTaG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Oct 2020 15:30:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389668AbgJNTaF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Oct 2020 15:30:05 -0400
Subject: Re: [GIT PULL] iomap: new code for 5.10-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602703805;
        bh=20XkeA8xKqwTx4Bcvf0F8549PQcXxbGnosNdRXGgVm4=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=zH3bMIthX3zEanuDKypSFxaordffP0IrdlCyw5DM6HIZeuS+D5X1DH49No56IUSIJ
         /INl737Z/QwPtPV3CKu56qgUjCiAsPg4JueOI7KS80cIMUAUn7t3A0d3EEJyW5OTRf
         ep31oEymKsn7nxvu3+6X14jX1HDCpKaXplvCoESk=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201013164131.GB9832@magnolia>
References: <20201013164131.GB9832@magnolia>
X-PR-Tracked-List-Id: <linux-btrfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201013164131.GB9832@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/iomap-5.10-merge-4
X-PR-Tracked-Commit-Id: 1a31182edd0083bb9f26e582ed39f92f898c4d0a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 37187df45af7d28d27b5c130c23f407ca9dbefa2
Message-Id: <160270380520.23686.2410213425284683792.pr-tracker-bot@kernel.org>
Date:   Wed, 14 Oct 2020 19:30:05 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        sandeen@sandeen.net, hch@lst.de,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>, riteshh@linux.ibm.com,
        rgoldwyn@suse.de, agruenba@redhat.com, linux-btrfs@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Tue, 13 Oct 2020 09:41:31 -0700:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/iomap-5.10-merge-4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/37187df45af7d28d27b5c130c23f407ca9dbefa2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
