Return-Path: <SRS0=7iaS=VP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5D5AC7618F
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jul 2019 18:30:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A35E321019
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jul 2019 18:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563474612;
	bh=x8Nk5GJOhuMy+pZ8Xw/vslfHWXcHyxNpej1FibTd5Us=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=zA8xnxHUEZAf0w0e9gD9+OS3ZR4U5P1dBvEeFIwDzuc3PVPDHOWBBTrnxlpKTKCOA
	 7unEIsYbgoGSSf+TY0ysOejCYypCv1Haitpcusw12bugD9t8zfI9RSnaCcMKKiEa2n
	 9IYgDzWf9lMrN64ElobBgkB+LixzMWFcU+ul1lgE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391043AbfGRSaE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Jul 2019 14:30:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726040AbfGRSaE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Jul 2019 14:30:04 -0400
Subject: Re: [GIT PULL] xfs: cleanups for 5.3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563474603;
        bh=x8Nk5GJOhuMy+pZ8Xw/vslfHWXcHyxNpej1FibTd5Us=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=BWisgZ3JQy5ccZzVkcy3fheevMEurdsOwCWQU38Nq9MqdOxyHR7sf2EuuLtZbokV1
         Kkkxb5cdQbM8wwyXqolvOe2hpS3zddvGoof/VByZ6Gh9PpbazPBbGztRIXJUKQ6LWr
         MS3sdEr1P4ER8eq1resqPi5AJUbhyB9ioCoRSzHU=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190718161824.GE7093@magnolia>
References: <20190718161824.GE7093@magnolia>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190718161824.GE7093@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
 tags/xfs-5.3-merge-13
X-PR-Tracked-Commit-Id: 89b408a68b9dd163b2705b6f73d8e3cc3579b457
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 366a4e38b8d0d3e8c7673ab5c1b5e76bbfbc0085
Message-Id:
 <156347460362.12683.14396368420270673517.pr-tracker-bot@kernel.org>
Date:   Thu, 18 Jul 2019 18:30:03 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        sandeen@sandeen.net, hch@lst.de
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20190718183003.4QPcFHkX0MF44Hgf7Oz6lodaGkigZldnkTOrQ6Kkj3Y@z>

The pull request you sent on Thu, 18 Jul 2019 09:18:24 -0700:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.3-merge-13

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/366a4e38b8d0d3e8c7673ab5c1b5e76bbfbc0085

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
