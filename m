Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63607C47080
	for <linux-xfs@archiver.kernel.org>; Mon, 24 May 2021 01:01:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38E80611CE
	for <linux-xfs@archiver.kernel.org>; Mon, 24 May 2021 01:01:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbhEXBCm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 May 2021 21:02:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232050AbhEXBCm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 23 May 2021 21:02:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F413611CB;
        Mon, 24 May 2021 01:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621818075;
        bh=F+A9Ua2OhZya+XZdMPhTWJ5uX0+TOX2zZljfL2Wl8bc=;
        h=Subject:From:To:Cc:Date:From;
        b=nnVmlWhgfrzn0KFzMJFDuw5OriyS7mUvRv7uIIETntCsRFFHxb9XqM38FedXvxqyH
         orm4o268t6DqEUiRsdy3q2nJ2bchgQoxqrkM/ucd1g+srua3+rEQ+uPNV/l6V3dgPA
         AqYAf6mgwDagLbqBdXwFMfHfcSMFIYYJkQ19PtxqYc95cZaBGzGwugsPQAAOrQPiiH
         528Aqz4ZmT+n498gWcbau6LMFMwH4dskxC3LcjnOO2gPsfV+X6tKzrBF0F0OSmtKBL
         SSbY2McxNHyFXf60uuPTx7SYAFrQQxdfwVrHGmv7Ley9vAqgqa9CTRFHgOf5EE+Wpg
         UJ07ZyUGlK1Lg==
Subject: [PATCHSET v2 0/2] xfs: strengthen validation of extent size hints
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, bfoster@redhat.com, hch@infradead.org
Date:   Sun, 23 May 2021 18:01:14 -0700
Message-ID: <162181807472.202929.18194381144862527586.stgit@locust>
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

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=extsize-fixes-5.13
---
 fs/xfs/libxfs/xfs_inode_buf.c   |   37 +++++++++++++-
 fs/xfs/libxfs/xfs_trans_inode.c |   15 ++++++
 fs/xfs/xfs_inode.c              |   29 +++++++++++
 fs/xfs/xfs_ioctl.c              |  101 +++++++++++++--------------------------
 4 files changed, 111 insertions(+), 71 deletions(-)

