Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 634A6C4321A
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 04:40:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41B296528D
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 04:40:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbhCIEjg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 23:39:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:60822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229829AbhCIEj3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 23:39:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B2676528A;
        Tue,  9 Mar 2021 04:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615264769;
        bh=f4Ni9PvbWfdogvZ+BOvdKrhN9aCTSUGjoD6ZoXEqjZo=;
        h=Subject:From:To:Cc:Date:From;
        b=EvQaiMIF/h6Lx1iB67iYT4RFujLp8Rlt+NYwq7f0kH2oQGHeNDgN9BAjg1ahUv5Yq
         JztGTZVkoaMoEMERRr0sj4Wq0HMQcFf88HUs/+XWtFXzj7Zr+Hyj8itjoB9YE6NU+R
         +0nzqO+LrpV7lZZCdDPQlg+qjFjGVac6TG08bf+Z5RUXrozOGbJTnpaHBZWmZUCDnK
         sjuQtwswhU4Jv5iX9gA1ZwLWLXMnxEq66kA6WYSEwr0RO8tMCqlId5TbrAmNj8UFRJ
         SArIkpuF0EkGkQ7UNZd1NfFJE3z/dNTgfRfMVIxgtvdUEC521wsFJwHXx2ta2Q4IKx
         zVMiQlEgVV3tQ==
Subject: [PATCHSET 0/2] fstests: fix compiler warnings with fsx/fsstress
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 08 Mar 2021 20:39:29 -0800
Message-ID: <161526476928.1212985.15718497220408703599.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Fix all the compiler warnings emitted when building fsstress and fsx.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fix-fsx-and-fsstress-warnings
---
 README                     |    4 +-
 build/rpm/xfstests.spec.in |    2 +
 configure.ac               |    4 --
 include/builddefs.in       |    2 -
 ltp/Makefile               |    5 ---
 ltp/fsstress.c             |   86 +++++++++++++++++++-------------------------
 m4/Makefile                |    1 -
 m4/package_attrdev.m4      |   54 ----------------------------
 8 files changed, 40 insertions(+), 118 deletions(-)
 delete mode 100644 m4/package_attrdev.m4

