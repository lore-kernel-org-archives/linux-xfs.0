Return-Path: <SRS0=h0IP=5S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C3D9C2BA15
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Apr 2020 20:25:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7C10206E9
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Apr 2020 20:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585859125;
	bh=Y8qtOll2IyBI33QOV1nRr9WLmHNP4KAFVW1tEoKDI3o=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=AFAQBy15yoeGqTmqXXGulvgmym9Hk6wO4R81sscAo6ChD+Fup4EDMABCUhx4F8cex
	 OGu8+mqWXDgsEH+xgBxq3FG9B7L38IJjqQzGvwrRa7RXZQjJmSZAD4pEG5IwXeP5Ti
	 60E8OjOlE5ZkyAeqfkpan15TBx6B8IOPUPsGvvQo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390231AbgDBUZT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Apr 2020 16:25:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389484AbgDBUZG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Apr 2020 16:25:06 -0400
Subject: Re: [GIT PULL] vfs: bug fix for 5.7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585859105;
        bh=Y8qtOll2IyBI33QOV1nRr9WLmHNP4KAFVW1tEoKDI3o=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=C5MoOAMr1LFqJbp5Xi/a+hCWZu53z3PcrlSa5iYQ4BzdywIrFjSx9Bs16cM4lnZe8
         jyjmpg6dlPCcO92iGzkfNC67M9CRRPtZ98e8nNxx3NS5axaaPBU5nMUtGWXDwg2w48
         XtONeWjJPdEI+PSRNvdQHqwAPPbO1TPOJuVxg+yE=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200402161600.GI80283@magnolia>
References: <20200402161600.GI80283@magnolia>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200402161600.GI80283@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
 tags/vfs-5.7-merge-1
X-PR-Tracked-Commit-Id: 56939e014a6c212b317414faa307029e2e80c3b9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7db83c070bd29e73c8bb42d4b48c976be76f1dbe
Message-Id: <158585910581.7195.2128083454634559676.pr-tracker-bot@kernel.org>
Date:   Thu, 02 Apr 2020 20:25:05 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        sandeen@sandeen.net, hch@lst.de,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>, domenico.andreoli@linux.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Thu, 2 Apr 2020 09:16:00 -0700:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/vfs-5.7-merge-1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7db83c070bd29e73c8bb42d4b48c976be76f1dbe

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
