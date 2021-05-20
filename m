Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBD2FC433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 May 2021 16:42:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE428611AB
	for <linux-xfs@archiver.kernel.org>; Thu, 20 May 2021 16:42:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233635AbhETQni (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 May 2021 12:43:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:41258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232565AbhETQni (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 May 2021 12:43:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 747BE60FDC;
        Thu, 20 May 2021 16:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621528936;
        bh=suYD434GsssymEt3yUCFiqQl7SBNAl23M3qzTqwx78I=;
        h=Subject:From:To:Cc:Date:From;
        b=S3UW81SNPXltlJzZ5AVyGyDtN69fWdYfjolw0f5gw2EtCuhv+YdGQWBKGNDlP935/
         18yrk9pafMlBJe5xf6ykRmKuC9Um+F0eKPbwCWGzzvfO37ZhsX9PZcUAjAkPQbq+St
         kPDWV6tVDAkVs69YKRicaiJP5Amotge3xzWVqvQWBIy2SzC+f7ORwiPtv83ROJqWJR
         zSIKLe8GL/7lwQTIEmyULS8Jbm+aJcQy2PBgF2e0wR+197CzuNTpaB2mygBn9VUu7D
         DJnUY9hqEb2PaSjl76sOez8YVtpH2tL7IJZmhwZGdzDxiBhVUJCqygHGWGKHEIRMfe
         amvt+FsGrRKAw==
Subject: [PATCHSET v2 0/2] xfs: strengthen validation of extent size hints
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com
Date:   Thu, 20 May 2021 09:42:15 -0700
Message-ID: <162152893588.2694219.2462663047828018294.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_inode_buf.c   |   39 +++++++++++++--
 fs/xfs/libxfs/xfs_trans_inode.c |   13 +++++
 fs/xfs/xfs_inode.c              |   46 +++++++++++++-----
 fs/xfs/xfs_ioctl.c              |  100 +++++++++++++--------------------------
 4 files changed, 113 insertions(+), 85 deletions(-)

