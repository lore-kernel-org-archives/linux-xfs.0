Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 712FBC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 00:30:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DB5422D08
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 00:30:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390778AbhALAZy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 19:25:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:33504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404036AbhAKXXO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Jan 2021 18:23:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11F1F22D05;
        Mon, 11 Jan 2021 23:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610407354;
        bh=6hx6nxhO2Hd5Ck2dwfYpETGRMsAQma4jrQJCNsfFOMs=;
        h=Subject:From:To:Cc:Date:From;
        b=HBaEKmTnP6t8aJyI06640uiQsxI9yamDe3K/YGpsUb3wSzrRzTMA0w/Qz0K73Pjn2
         JnBdeqQBQmUC6dtEZqcqwk3X6l/3CuOMMOPSupnFH1WFvLTt3mmEjwIed9e06h/krJ
         PchScksVwZVNerdt+OzIEf9IqY8jgv0Vr8DvYXaFAhFrp5xQrVN2w5+vNbMxsovyFz
         AcidOZqXz4u1yk3/4VcQj2OlN/OsK5B7hCbNWh5iUVyfyepyoe2FjtlgSGH/bgJWo+
         AmoFKiObC5IUSmAtWAcoY8SqUGLkIeLn/gVF6Edl8H4NxNOMwpe1srYy/AA+WgmWYO
         o+1/Qb/N5N2sw==
Subject: [PATCHSET v2 0/6] xfs: try harder to reclaim space when we run out
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 11 Jan 2021 15:22:34 -0800
Message-ID: <161040735389.1582114.15084485390769234805.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Historically, when users ran out of space or quota when trying to write
to the filesystem, XFS didn't try very hard to reclaim space that it
might have speculatively allocated for the purpose of speeding up
front-end filesystem operations (appending writes, cow staging).  The
upcoming deferred inactivation series will greatly increase the amount
of allocated space that isn't actively being used to store user data.

Therefore, try to reduce the circumstances where we return EDQUOT or
ENOSPC to userspace by teaching the write paths to try to clear space
and retry the operation one time before giving up.

v2: clean up and rebase against 5.11.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=reclaim-space-harder-5.12
---
 fs/xfs/xfs_bmap_util.c   |   29 ++++++++++
 fs/xfs/xfs_file.c        |   24 +++------
 fs/xfs/xfs_icache.c      |  129 +++++++++++++++++++++++++++++++++++-----------
 fs/xfs/xfs_icache.h      |   14 ++---
 fs/xfs/xfs_inode.c       |   29 ++++++++++
 fs/xfs/xfs_ioctl.c       |    2 +
 fs/xfs/xfs_iomap.c       |   33 +++++++++++-
 fs/xfs/xfs_qm_syscalls.c |    3 -
 fs/xfs/xfs_reflink.c     |   63 +++++++++++++++++++++-
 fs/xfs/xfs_trace.c       |    1 
 fs/xfs/xfs_trace.h       |   41 +++++++++++++++
 11 files changed, 303 insertions(+), 65 deletions(-)

