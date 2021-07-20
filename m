Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 826DBC636C9
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jul 2021 01:11:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6ABE361164
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jul 2021 01:11:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381445AbhGTAa7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Jul 2021 20:30:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380381AbhGTA1p (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Jul 2021 20:27:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21DC760FF3;
        Tue, 20 Jul 2021 01:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626743304;
        bh=1bYHbAutNTtfUp100LdOGHVwxnVMZRUPKUvp8Z1GLK4=;
        h=Subject:From:To:Cc:Date:From;
        b=eKnjDPXANm0GMXF1gx3ZtsHvC3L6eh/wHMWbWXxcZgSaIUaQq1CO+UO91Z1IPY9QL
         5dKvc3JVTmzgH4ZBnE4wx70cg1f894PwBRtUAttje9He+m+oJat4r8QC9jHDGQHTN3
         YkKYkf2/hFJRmQHgf62IpZ6QvgfbbySpcrs5HA78CNS6T8ZsPwuW077KHSlUrTO0Zp
         qRobNX3FdL2L79m8NOooLhCRwRXLxGvDPVDz+mXxKx5/7DK833+ilzpQ8ifhkKmUCz
         tGd2bSNEeJAaAx7G59Fv4+/Jz3xUBei1hfoBf8vR5zvwPkN8fU7mie7tAW6AIsWHqF
         ZYV1i0RJaRueQ==
Subject: [PATCHSET v2 0/1] fstests: random fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 19 Jul 2021 18:08:23 -0700
Message-ID: <162674330387.2650745.4586773764795034384.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series fixes a small problems in generic/561 that was causing
intermittent test failures.

v2: update comments per review suggestions

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
 tests/generic/561 |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

