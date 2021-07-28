Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7E3CC4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 21:15:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C39666103C
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 21:15:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbhG1VPp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 17:15:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:33980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231350AbhG1VPo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Jul 2021 17:15:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA7C56101B;
        Wed, 28 Jul 2021 21:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627506942;
        bh=bW3ghPFvOO71XGJhDF4hitFuyKNMV1a/prR6krLytXU=;
        h=Subject:From:To:Cc:Date:From;
        b=MynvnFGpjODh9pxjf93Z0fbG9dNNan1M2eaQKmDVtWCqamT+jn6AhYImq5B/Kmv+v
         JGEsMLPbE4ueR4WptTql1+lbfYClw9G8OFL7eJ9YCxVdD8hyPgOnaytLb47NZ2q0ev
         OcuNOerwlgjJpR1woodaOJU9FpajuyUDf10/LYPq3b/ubErut0H1sRXMtHrQOsqM2x
         kQXDUL/6JWO4KZiJHFnnR03l6Rh/jn4RB6LO3tK1SkXOd3doj+h6Qufw0vM4m4Z1Zs
         wPB2Pd/dPTW2lJk5XliN2rP6qxEvJZ62QjoHJVmaAuh+0v3qB6MH/LZIEsdCtYAjrD
         7libgW/CQG5gA==
Subject: [PATCHSET v3 0/2] xfsprogs: strengthen validation of extent size
 hints
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Carlos Maiolino <cmaiolino@redhat.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com, hch@infradead.org
Date:   Wed, 28 Jul 2021 14:15:42 -0700
Message-ID: <162750694254.44422.4804944030019836862.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

While playing around with realtime extent sizes and extent size hints, I
noticed that it was very possible for userspace to trip the inode
verifiers if they tried to set an extent size hint that wasn't aligned
to the rt extent size and then create realtime files.  This series
tightens the existing checks and refactors the ioctls to use the libxfs
validation functions like the verifiers, mkfs, and repair use.

For v2, we also detect invalid extent size hints on existing filesystems
and mitigate the problem by (a) not propagating the invalid hints to new
realtime files and (b) removing invalid hints when set on directories.

v3: move the extsize validation code into a single function

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=extsize-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=extsize-fixes
---
 mkfs/xfs_mkfs.c |    7 +++--
 repair/dinode.c |   71 ++++++++++++++++++++++++++++++++++++++++---------------
 2 files changed, 55 insertions(+), 23 deletions(-)

