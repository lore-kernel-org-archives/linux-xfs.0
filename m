Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24C64C43331
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 04:40:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 027DC6528D
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 04:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbhCIEjf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 23:39:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:60712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229701AbhCIEjG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 23:39:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B20E6523B;
        Tue,  9 Mar 2021 04:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615264746;
        bh=2mr2jk2GxdUDFelfvsx5qscSq02IvV9z0aqmL0NCQUY=;
        h=Subject:From:To:Cc:Date:From;
        b=BrCWDdZ72T4GoC6vfIlMvtF1/suuedyZVPpEllS5buRdOqQtqGbQBbBKkRUk6Z2no
         U6qM8Xb5QDwgUF8QKyrhPkmMmPclEYVTW67Oq0EI2dCORUV2xJzCXVd8peiFJYIE0F
         bzKXhD3hBiOnO4nU1TzVWy/Akrk3ucAkU13cT7BKhTPJpzHdM54sw0nA85Ev9Had5V
         NwYyCza6kzHv826WfpWfPQOgADV7oDJNUUzGQUnwAqUQu4uWIgYVKmwfvJphp5oxvb
         oPBZ3Wkvr2KnVOHX9pqzoa7nP/95MIsLkhq7GS7l8QYSqIcbAwkXtcYbkMpP5uL3az
         iLN7J7qjlI9Qg==
Subject: [PATCHSET 0/4] fstests: improve metadata dump capture helpers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 08 Mar 2021 20:39:05 -0800
Message-ID: <161526474588.1212855.9208390435676413014.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

I have often found it useful to capture metadata dumps from xfs and ext*
filesystems when they are found to be corrupt while running fstests.
The patches in this series enable systematic capturing of dumps from
corrupted fs to aid in debugging regressions and test failures, along
with extra compression knobs so that they don't eat a ton of space.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=better-metadumps
---
 README          |    7 ++++++
 common/config   |    1 +
 common/populate |   25 ++++++++++++++++++----
 common/rc       |   33 ++++++++++++++++++-----------
 common/xfs      |   63 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
 tests/xfs/129   |    2 +-
 tests/xfs/234   |    2 +-
 tests/xfs/253   |    2 +-
 tests/xfs/284   |    4 ++-
 tests/xfs/291   |    2 +-
 tests/xfs/336   |    2 +-
 tests/xfs/432   |    2 +-
 tests/xfs/503   |    8 +++----
 13 files changed, 119 insertions(+), 34 deletions(-)

