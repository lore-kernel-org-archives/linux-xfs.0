Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36FE5C433E9
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Jan 2021 01:25:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16B1E23AFE
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Jan 2021 01:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725601AbhAPBZ0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Jan 2021 20:25:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:33110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728657AbhAPBZW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Jan 2021 20:25:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA9F023A3C;
        Sat, 16 Jan 2021 01:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610760282;
        bh=1yDSyuT2VBgDYDbNViNoJJXwHT548NRuK3lyNUgLyOg=;
        h=Subject:From:To:Cc:Date:From;
        b=lTJa/hg/ea7efCJ3OCT9Ql8sFQuZGjQ/WvuGXPDJ86gM/EgErPbQVXLjfExOMdO4m
         bzBsHNWr/KhPYfbsADvTu8gaLmaHVfy0iN2rcbaiI24yJadp0v0c1M5+qOCpoRjH+E
         eZ4aO62mn1Srx0BX4ojxsrDXTOmEwj0L36HbwqdbiussFk0RlYIa2LurKy2vUJnDsb
         SjihTEIys1Lj3/fQRFGZ7HEX2H3RAcfV1Vj45ZnwKjG8Bq7yZ5KtZdoUFd7oDODeSp
         0njJvoWPCIh6F3idTnKxVRKFzHKQc8HRBeYaPPsBTEZEuPjG3EEupcqkjJRNZlJs99
         iYjSJ/4s0i4vA==
Subject: [PATCHSET v2 0/2] xfs: add the ability to flag a fs for repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 15 Jan 2021 17:24:41 -0800
Message-ID: <161076028124.3386490.8050189989277321393.stgit@magnolia>
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
 db/sb.c              |  153 ++++++++++++++++++++++++++++++++++++++++++++++++--
 db/xfs_admin.sh      |   10 ++-
 man/man8/xfs_admin.8 |   15 +++++
 man/man8/xfs_db.8    |    5 ++
 repair/agheader.c    |   15 +++++
 6 files changed, 193 insertions(+), 10 deletions(-)

