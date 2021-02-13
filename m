Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7CC7C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Feb 2021 05:47:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8F1264D9D
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Feb 2021 05:47:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbhBMFrp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 13 Feb 2021 00:47:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:57476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230117AbhBMFro (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 13 Feb 2021 00:47:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAB9564E9A;
        Sat, 13 Feb 2021 05:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613195223;
        bh=aRDe33ErkhvXS8JDoh9kagFZ/u0Lm99nN1J9iRD382Y=;
        h=Subject:From:To:Cc:Date:From;
        b=ZG6d5ZY9SB5pprFbzzi3cv4CjkcQdRtedVk7KIqREURp9GfgVtcO9FkfxhvUYXWyp
         JYLssOif92zro8BQx+gwc4dHB4GTUxLcSMA1cewKVurWOcgShzDLHchrbSDjcZDN6u
         F9/KwIoc99zSx23XYX7JGdZzEOd9he/evrOciYvmbVU9AnrbRH47yWRikGQxcWYrdV
         qdbbiDb8XDmmrSmAVUirobWN0aguwIL2Qtw9szdt85q12tdWoI4nTbfhOmM4S0zDF+
         xaO7JtlRizorcTW3ZYmb0zMpCrATSwpLSDoNybrla9gXmCGkcWsLJakBIsZ+3UAhor
         tbXpQxAGRvXhA==
Subject: [PATCHSET v6 0/5] xfs_admin: support upgrading v5 filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, hch@lst.de, bfoster@redhat.com
Date:   Fri, 12 Feb 2021 21:47:03 -0800
Message-ID: <161319522350.423010.5768275226481994478.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This submission extends xfs_repair and xfs_admin to support adding the
inode btree counter and bigtime features to an existing v5 filesystem.
The first three patches lay the groundwork in both tools for performing
upgrades, and the last two patches add the ability to add features.

v2: Rebase to 5.10-rc0
v3: respond to reviewer comments
v4: document which kernel version these new features showed up in
v5: move all the upgrader code to xfs_repair per Eric suggestion, which
    eliminates a bunch of fragile db/admin/repair coordination.
v6: update mkfs/admin/repair manpages to identify CLI options that apply
    only to V4 fses and are therefore deprecated

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=fs-upgrades
---
 db/xfs_admin.sh      |    6 ++-
 man/man8/mkfs.xfs.8  |   16 +++++++++
 man/man8/xfs_admin.8 |   47 +++++++++++++++++++++++++
 repair/globals.c     |    2 +
 repair/globals.h     |    2 +
 repair/phase2.c      |   93 ++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/xfs_repair.c  |   22 ++++++++++++
 7 files changed, 186 insertions(+), 2 deletions(-)

