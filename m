Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE6ACC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:42:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C57326105A
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:42:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233147AbhIOXnU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:43:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:45248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233046AbhIOXnU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:43:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD14A60527;
        Wed, 15 Sep 2021 23:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631749320;
        bh=OZ6CxklBPFHEJKodsIvpnvb2303elTGJbrpFz91fsgo=;
        h=Subject:From:To:Cc:Date:From;
        b=lnwl64k3xYr3B/G6q6N4RvvoNObacZGwghPxt0Z5zrNRUoscVU5r+9cUx6fmYqXD3
         MnqY08lL/Z5PHeQW/OkwnpXjVv8hqF12YAhtcKKIA8hlb5Nx2rk9gHcHFUl7SCVGUz
         2buP05wGUr20dYFTqdXvxQVA3KWa0kL7CwEP/9CYXT+e/IBVFLJqP3r+Yau+zYTIYq
         K08wADUVlFRfGPDXsdoPz2Uu73SpY36YJfc4npwtLDn5Iqf35GspG4XVEI46NCIV6+
         +q4z43vNc2tTIZvfO6uJU+ce7qAtLMqMnRuesVeh4DkcdwXV/OegWrUzfnB/5hZv88
         n8tMmZODKr4qA==
Subject: [PATCHSET 0/1] fstests: random fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Wed, 15 Sep 2021 16:42:00 -0700
Message-ID: <163174932046.379383.10637812567210248503.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This week, I only have a single fix to the fsdax support detection code.

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
 common/rc |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

