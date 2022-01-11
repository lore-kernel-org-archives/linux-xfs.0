Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB7A6C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Jan 2022 21:50:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245168AbiAKVuK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Jan 2022 16:50:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233245AbiAKVuK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jan 2022 16:50:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7FF0C06173F;
        Tue, 11 Jan 2022 13:50:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B5CD617C5;
        Tue, 11 Jan 2022 21:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0274C36AEF;
        Tue, 11 Jan 2022 21:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641937808;
        bh=gg+b0P8uNeISV2Duojjbd9tCBHr10Rx4BbNMRgG15mA=;
        h=Subject:From:To:Cc:Date:From;
        b=jfQbBED518qr5rJPUYEQvRhaVMlE5QDz9NI9+/AhSOqghbmgMt7hy4zOi34bdDtly
         UjsVAXVoRNebzrcR1LDly3gyO5OqHdHpA13ssPQx8GpHUhRQvTBiEmHoANrxVgy3b2
         hRgzxt8h0Bprt+tZviXuoUKbfVcBrmOsmctoevhwZDxhtTmUPNlh9/AWuUcgIhdUzD
         vsDotjQF7IJYAIlH9K5xNHu7k/w/QgtO0YSeOmLwFBbFJr/V3S3VU0sav1djleIC7c
         y+Ou7lP9WFVs3ybLoRPlAur6Xec++QDtI5pgPAfQHJ6+6tBCZLUzKvTS5fr1yZfecF
         7/xjfYe0LTFRQ==
Subject: [PATCHSET 0/8] fstests: random fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     xuyang2018.jy@fujitsu.com, Theodore Ts'o <tytso@mit.edu>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 11 Jan 2022 13:50:08 -0800
Message-ID: <164193780808.3008286.598879710489501860.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here is a pile of random fstests fixes: a couple to fix xfs_scrub
unicode detection; one to fix xfs/220 so that it tests QUOTARM again;
the usual adjustments to fstests to accomodate behavior changes added to
5.17; a regression test for CVE-2021-4155; and cleanups to make fstests
less dependent on XFS_IOC_ALLOCSP/FREESP since those are going away for
5.17.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
 .gitignore        |    1 
 common/rc         |   19 ++++++---
 common/xfs        |   12 +++++
 ltp/fsx.c         |  110 +++++++++++++++++++++++++++++++++++++++++++++++++-
 ltp/iogen.c       |   32 ++++++++++----
 src/Makefile      |    2 -
 src/alloc.c       |   66 +++++++++++++++++++++++++-----
 src/allocstale.c  |  117 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/130     |    6 ++-
 tests/xfs/130.out |    1 
 tests/xfs/220     |   30 ++++++++++----
 tests/xfs/308     |    5 --
 tests/xfs/308.out |    2 -
 tests/xfs/832     |   56 +++++++++++++++++++++++++
 tests/xfs/832.out |    2 +
 15 files changed, 418 insertions(+), 43 deletions(-)
 create mode 100644 src/allocstale.c
 create mode 100755 tests/xfs/832
 create mode 100644 tests/xfs/832.out

