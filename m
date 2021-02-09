Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51516C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:19:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1623C64EB1
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:19:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhBIETB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Feb 2021 23:19:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:48560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230234AbhBIEPq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Feb 2021 23:15:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85AD064EB9;
        Tue,  9 Feb 2021 04:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612843804;
        bh=W7HWE1wJdGENAoYvjOM+HnMkDkY8qcNt1uOLDndlCXQ=;
        h=Subject:From:To:Cc:Date:From;
        b=X9Gf/AvNCmeKTMD57hqhWDzYve1Vwaot8stlFysea650FYfkBbxN4S4mVx7/8+jnM
         aP1/Qyu0ESFBpBh2IY4JNbCWLNS8DRE41q+aRuK8cthoZi59s6sX5R2WnZ2N8oqVV8
         0HCIlCC9r8AKmqMdGODEyDQTzYVbbziKbhQ5jxlVad0xWCqhEqyo0Tz3pIrCGLIInN
         myuMOdqrCfvsGCNTzsJjRg2DEaSoe+HZGqp2eUFUZBDTKcuLzAfCUlTSIknXuwG/jr
         pyVXRIZYzHJUrrMgtzTnicj3JznKhuK8rg5Ptj+hk4e0fx8LwFfKxubbixwD6Dj2kV
         uh+A5vriOrd0g==
Subject: [PATCHSET v4 00/10] xfs: add the ability to flag a fs for repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com
Date:   Mon, 08 Feb 2021 20:10:04 -0800
Message-ID: <161284380403.3057868.11153586180065627226.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series adds a new incompat feature flag so that we can force a
sysadmin to run xfs_repair on a filesystem before mounting.  This will
be used in conjunction with v5 feature upgrades.

v2: tweak the "can't upgrade" behavior and repair messages
v3: improve documentation, define error codes for the upgrade process, and
    only force repair if NEEDSREPAIR is set
v4: move all the upgrader code to xfs_repair per Eric suggestion

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=needsrepair

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=needsrepair

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=needsrepair
---
 db/check.c           |    5 ++
 db/sb.c              |   13 ++++++
 db/xfs_admin.sh      |   15 ++++---
 include/xfs_mount.h  |    1 
 libxfs/init.c        |   25 ++++++------
 man/man8/xfs_admin.8 |   30 ++++++++++++++
 repair/agheader.c    |   21 ++++++++++
 repair/agheader.h    |    2 +
 repair/dir2.c        |    3 +
 repair/globals.c     |    3 +
 repair/globals.h     |    4 ++
 repair/phase1.c      |   28 +++++++++++++
 repair/phase6.c      |    7 +++
 repair/xfs_repair.c  |  107 ++++++++++++++++++++++++++++++++++++++++++++++++--
 14 files changed, 241 insertions(+), 23 deletions(-)

