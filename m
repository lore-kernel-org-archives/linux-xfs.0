Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75126C12002
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jul 2021 01:12:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7025361166
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jul 2021 01:12:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354089AbhGTAbW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Jul 2021 20:31:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1381210AbhGTA3x (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Jul 2021 20:29:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09E8F61166;
        Tue, 20 Jul 2021 01:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626743343;
        bh=TQa8TukWwQ3vAssi8Mn/0Np8k5x5+L2FLl0Vpj47QrI=;
        h=Subject:From:To:Cc:Date:From;
        b=qdOf/Kim+osGZgaALQvNMLAn+/iZUPDFHCE4hF8pGVRQpCd+hWGzAjPPgXECSyVDf
         V7bV/qmwyYBvmaVk85C+ev65BKwI7iE0ksz3XDDWJnC7OcTGenJk/tGBvk0YEBddlv
         TiAmJVhq52jFdeBULCTK3XQ5AYN7yqY8nkksrNhb/AI7kmRofQiOu88ykcDjQxjdfe
         VwE+xqnkC4Il2dGOd4TdlgS208of48MITV/9SIF/IAHE7owiP9tc/Q9fnjHqp7ctmA
         Rr8tMmRv3drWgrXfVCo1aJ/oHpjSHn8xmWD8m30be7//PbjxGDmmZds5fjE9xBB+we
         odlRVmxidR9Vw==
Subject: [PATCHSET 0/3] common/dm*: support external log and rt devices
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        tytso@mit.edu
Date:   Mon, 19 Jul 2021 18:09:02 -0700
Message-ID: <162674334277.2651055.14927938006488444114.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

There are a growing number of fstests that examine what happens to a
filesystem when the block device underneath it goes offline.  Many of
them do this to simulate system crashes, and none of them (outside of
btrfs) can handle filesystems with multiple devices.  XFS is one of
those beasts that does, so enhance the dm-error and dm-flakey helpers to
take the log and rt devices offline when they're testing the data
device.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=dmerror-on-rt-devices
---
 common/dmerror    |  190 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 common/dmflakey   |  106 +++++++++++++++++++++++++++++-
 src/dmerror       |   13 +---
 tests/generic/441 |    2 -
 tests/generic/487 |    2 -
 5 files changed, 289 insertions(+), 24 deletions(-)

