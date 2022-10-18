Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E557BC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Oct 2022 22:45:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbiJRWpS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Oct 2022 18:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbiJRWpR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Oct 2022 18:45:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B7B50B89;
        Tue, 18 Oct 2022 15:45:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF328B82113;
        Tue, 18 Oct 2022 22:45:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA0EC433D6;
        Tue, 18 Oct 2022 22:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666133113;
        bh=aLJyufDdp1S4HHnJpk7uK5MMSEmiOWI36ztQJNh1EFI=;
        h=Subject:From:To:Cc:Date:From;
        b=HH5xgWTB/+EC2Jh3saLynvfpjVyYWo3IuW7yT5fpoxRlbWt+djePKrLOde5np1IfG
         EtDiljqu6HiO0P8+1Yll50zmbMW9y6/Xy3jXNcz4AyKPK7gJ7F4W40uzt1cxep8Wr+
         uKCVmH0e9JCjzb4nbkKncYZTb5O6uAu7pRzkC+4MOUzG0h5PvOeTOxKEHoZC5mqGwr
         qQZkw1OgdGDFbkyrarYUTjjC+5bR1m8TOSHI7XLZkgyrOAt2EPGo9UN17h5+x1nF/o
         VZkxP2fIDnduOE+wAc8DScSP5zaM/RE+HoQB5jUg0ndZslHkXQ2eVel7qoPGH6l2uC
         mpwrDVHjn/NsA==
Subject: [PATCHSET v23.1 0/1] fstests: test xfs_scrub media scan
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 18 Oct 2022 15:45:13 -0700
Message-ID: <166613311327.868072.4009665862280713748.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Use dm-error to simulate disk errors for written file extents and ensure
that the media scanner in xfs_scrub actually detects them.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-media-error-reporting

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=scrub-media-error-reporting
---
 common/dmerror    |  136 +++++++++++++++++++++++++++++++++++++++++++++--
 common/xfs        |    9 +++
 tests/xfs/747     |  155 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/747.out |   12 ++++
 4 files changed, 309 insertions(+), 3 deletions(-)
 create mode 100755 tests/xfs/747
 create mode 100644 tests/xfs/747.out

