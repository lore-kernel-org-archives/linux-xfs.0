Return-Path: <SRS0=EwQn=72=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09FD5C433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Jun 2020 19:50:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC009208E4
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Jun 2020 19:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592077817;
	bh=PIDr7krUz7eRz37b3Yuex93OVD7tFEbF0YtN9KBD4L8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=ZGGM91na4NH+g+Swd8qMvJwRo1trPPLqYWIFJnuNVSQ+e/x3FZytj65AYf6270clr
	 i05mwko6vMDSfNom0gBZYX5D9bjb0T0y+CbCxL5ek5oQaAAV9GuVCSSAMNtIVGktIL
	 dkQeKjgwkxvZMbmTmv5m/vgE5wi3pqBNtiYuV0eE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgFMTuI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 13 Jun 2020 15:50:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:59548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbgFMTuH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 13 Jun 2020 15:50:07 -0400
Subject: Re: [GIT PULL] iomap: bug fix for 5.8-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592077806;
        bh=PIDr7krUz7eRz37b3Yuex93OVD7tFEbF0YtN9KBD4L8=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=ex66Op3zfI5MADKExjF5G4ZDeTExb/570oU8ZNDPWM9aEvdV9XzrRa3eefGfXTmG1
         8V+ZlGniZion5miqCHz+ceb/ljeh3KUKT+vr3n8SoRgEvIKv4jufWAuhloihK5VvEu
         7ez4pO7cHOSpvL9L015axAsyhPn4AO9E74lh1KU0=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200613054431.GL11245@magnolia>
References: <20200613054431.GL11245@magnolia>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200613054431.GL11245@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
 tags/iomap-5.8-merge-1
X-PR-Tracked-Commit-Id: d4ff3b2ef901cd451fb8a9ff4623d060a79502cd
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 593bd5e5d3e245262c40c7dd2f5edbac705ff578
Message-Id: <159207780664.22916.15207516755327237475.pr-tracker-bot@kernel.org>
Date:   Sat, 13 Jun 2020 19:50:06 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        sandeen@sandeen.net, hch@lst.de,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>, riteshh@linux.ibm.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Fri, 12 Jun 2020 22:44:31 -0700:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/iomap-5.8-merge-1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/593bd5e5d3e245262c40c7dd2f5edbac705ff578

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
