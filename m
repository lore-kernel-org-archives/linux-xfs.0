Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66EFCC64E7B
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 00:15:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2170E22260
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 00:15:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZEkbLdlt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgKNAPG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 19:15:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:58362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726299AbgKNAPG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Nov 2020 19:15:06 -0500
Subject: Re: [GIT PULL] vfs: fs freeze fix for 5.10-rc4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605312905;
        bh=04du0DdS0HrM/LP+jfmEfkE4M/cjR/2z9oq6c2IeejE=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=ZEkbLdltgCIzV0M0XfXSF4lvn7NEveOHrxfjJoPKYCHEN4Yb3CNK0Ida0I1Ca0+71
         mcD2HvbQ22nZqu9dI1jxkVQS68aFwD9eAIFY4JQ7fhvN83t8gfor/1y9u0itYlu6Ox
         A+xDcDT5RdFwQ2AYLdvmZF4pdabo0deiFssXppic=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201113233847.GG9685@magnolia>
References: <20201113233847.GG9685@magnolia>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201113233847.GG9685@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/vfs-5.10-fixes-1
X-PR-Tracked-Commit-Id: 22843291efc986ce7722610073fcf85a39b4cb13
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8a3c84b649b033024d2349f96234b26cbd6083a6
Message-Id: <160531290559.27003.6774390998993259207.pr-tracker-bot@kernel.org>
Date:   Sat, 14 Nov 2020 00:15:05 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, fdmanana@kernel.org,
        linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        djwong@kernel.org, Theodore Ts'o <tytso@mit.edu>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Fri, 13 Nov 2020 15:38:47 -0800:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/vfs-5.10-fixes-1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8a3c84b649b033024d2349f96234b26cbd6083a6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
