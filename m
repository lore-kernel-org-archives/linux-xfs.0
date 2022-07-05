Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED9CFCCA47F
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jul 2022 22:02:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbiGEWCi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Jul 2022 18:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232617AbiGEWCZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jul 2022 18:02:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99BD519284;
        Tue,  5 Jul 2022 15:02:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36A3761CFF;
        Tue,  5 Jul 2022 22:02:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90DDCC341C7;
        Tue,  5 Jul 2022 22:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657058543;
        bh=z9/MHsPY/hI1vctgc1WDznCy6cdahL1WqClTB0YpeaI=;
        h=Subject:From:To:Cc:Date:From;
        b=gCeBBoUjlV5ydy2sj60c8p28Sxd3yZ+5GuYxE5VdY/fYp8CI7xsR9vGDlN6/h0QhV
         leauRaQO7piqObkp73bRfguLeC4chuny02Xp/TCvBHan8x98JFpJ233hdyYBtzlMea
         Qv0/xwYZh6UhXynckDwFSqqQym7j+0v/XJGoY8AbRMt1lPeJuaLC7qhkyCR/M8YpuL
         L7YKba2EHRD0nrsSzGBR6BLObS6Uzr6rR2IDyR+mBATkD7bUQZgX9kVWlILd5Dvb8M
         lPXZb331oaN9bnpk5AAtB16DvU8SmYLuWYbx1PgfmWJxp9nOHZRdKtZ814T+9/qhid
         gl46qiccyXT5w==
Subject: [PATCHSET 0/2] fstests: new tests for kernel 5.19
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 05 Jul 2022 15:02:23 -0700
Message-ID: <165705854325.2821854.10317059026052442189.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Add new tests for xattr bugfixes merged during 5.19.  Specifically, we
add a new test to encode the desired behavior of the metadata verifiers,
the xattr code, and the fsck tools when the xattr leaf block header
count being zero; and fix a problem in an existing xattr test.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-merge-5.19

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=xfs-merge-5.19
---
 tests/xfs/288 |   32 ++++++--------
 tests/xfs/845 |  131 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 144 insertions(+), 19 deletions(-)
 create mode 100755 tests/xfs/845

