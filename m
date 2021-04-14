Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B6F1C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 01:05:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E913613BD
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 01:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348970AbhDNBF4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Apr 2021 21:05:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:38150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348968AbhDNBFv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Apr 2021 21:05:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BC42613B6;
        Wed, 14 Apr 2021 01:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618362331;
        bh=4lwE67G1YzgsjebKrdG9VZxi0M0PMq2qL471bZhcEjo=;
        h=Subject:From:To:Cc:Date:From;
        b=Jl69Gf1YdRUpmdr4MtmpOXtpugahzeGHl1tbCy7FhNRMPdDhOwCItVMoiUANf4BbV
         3g54xMzzKvOw0Yka1K/irjKLjtFFdZLYEvy/ETJB+GHyK+t3tz1EiKw5iV2Nie7MkF
         Z2tB9PnRPlw9E4ZhFqJvZdcGtC07+bOWR7qts2Zlsm9bgZIcbsH9JTkMsCFMrLHT1I
         M+/Bz44HiImVi1S824/Ar37GQrx6REoH/a1JCZ6ONKgW7Zlt7l9H76W8Cw2F4Jz/0p
         1pfYQG4PBQOzv44tfQ1MO0Tl+84Y8xcHwZFeGuJ7D0wssSLO/7KcOi7KwTshhwtdcF
         cBJiJqJJAre6g==
Subject: [PATCHSET v4 0/1] fstests: make sure NEEDSREPAIR feature stops mounts
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 13 Apr 2021 18:05:30 -0700
Message-ID: <161836233058.2755262.72157999681408577.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Quick test to make sure that having the new incompat "needs repair" feature
flag actally prevents mounting, and that xfs_repair can clean up whatever
happened.

v2: fix bash variable error, fix a problem found when using xfs_admin
    with external log devices
v3: Fix a stupid naming bug in v2.
v4: Fix other review comments.

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
 common/xfs        |   21 ++++++++++++++
 tests/xfs/768     |   80 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/768.out |    4 +++
 tests/xfs/770     |   82 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/770.out |    2 +
 tests/xfs/group   |    2 +
 6 files changed, 191 insertions(+)
 create mode 100755 tests/xfs/768
 create mode 100644 tests/xfs/768.out
 create mode 100755 tests/xfs/770
 create mode 100644 tests/xfs/770.out

