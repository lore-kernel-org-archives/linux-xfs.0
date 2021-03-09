Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18537C43332
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 04:40:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0E5565299
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 04:40:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhCIEkL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 23:40:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:60968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229475AbhCIEkE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 23:40:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC9A06528A;
        Tue,  9 Mar 2021 04:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615264804;
        bh=1lTW4btLHoCvsw7JL+u880jhn+IvXtpF6XD7FRfa3fQ=;
        h=Subject:From:To:Cc:Date:From;
        b=tEn70pf7BYaUG/KAMsJSHYzxxTDv6HlA4xghoSjbWclZH69SsCFudP/8T3szCwEnj
         P3YE8V5Jx7e81+lKxSKszkaVOBlh9u4bsAGN64IC3vYQgVgcVmXD4HLOhNSWTOemDw
         AJE1xce6P054SOMFOYUiLTeMMkhzbjiwxec65w6P9cnvU9DdOrTEqXCoEDhlv8Kyh4
         X//8cpoBBI8YcvzPyXy3+N9tn7AJg2NAj24q0lP3ueoMiPqv0TPzau44aCnKJlIdSu
         d+1zPupqcGb5IIhqaEj+JXWF39fW8TOn6poWJSL+8WaDA6BF86J41TvxAj8YIJGbWz
         XI7iJYQnjtl0Q==
Subject: [PATCHSET 00/10] fstests: test kernel regressions fixed in 5.12
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     wenli xie <wlxie7296@gmail.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 08 Mar 2021 20:40:03 -0800
Message-ID: <161526480371.1214319.3263690953532787783.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here are new tests for problems that were fixed in upstream Linux
between 5.9 and 5.12.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=kernel-regressions
---
 .gitignore             |    1 
 common/filter          |   24 +++
 src/Makefile           |    4 -
 src/chprojid_fail.c    |   92 ++++++++++++
 src/deduperace.c       |  370 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/1300     |  109 ++++++++++++++
 tests/generic/1300.out |    2 
 tests/generic/947      |  118 +++++++++++++++
 tests/generic/947.out  |   15 ++
 tests/generic/948      |   92 ++++++++++++
 tests/generic/948.out  |    9 +
 tests/generic/949      |   51 +++++++
 tests/generic/949.out  |    2 
 tests/generic/group    |    4 +
 tests/xfs/050          |   30 +---
 tests/xfs/122          |    1 
 tests/xfs/122.out      |    1 
 tests/xfs/299          |   30 +---
 tests/xfs/758          |   59 ++++++++
 tests/xfs/758.out      |    2 
 tests/xfs/759          |  100 +++++++++++++
 tests/xfs/759.out      |    2 
 tests/xfs/760          |   68 +++++++++
 tests/xfs/760.out      |    9 +
 tests/xfs/761          |   45 ++++++
 tests/xfs/761.out      |    1 
 tests/xfs/765          |   71 +++++++++
 tests/xfs/765.out      |    4 +
 tests/xfs/915          |  162 +++++++++++++++++++++
 tests/xfs/915.out      |  151 ++++++++++++++++++++
 tests/xfs/group        |    6 +
 31 files changed, 1584 insertions(+), 51 deletions(-)
 create mode 100644 src/chprojid_fail.c
 create mode 100644 src/deduperace.c
 create mode 100755 tests/generic/1300
 create mode 100644 tests/generic/1300.out
 create mode 100755 tests/generic/947
 create mode 100644 tests/generic/947.out
 create mode 100755 tests/generic/948
 create mode 100644 tests/generic/948.out
 create mode 100755 tests/generic/949
 create mode 100644 tests/generic/949.out
 create mode 100755 tests/xfs/758
 create mode 100644 tests/xfs/758.out
 create mode 100755 tests/xfs/759
 create mode 100644 tests/xfs/759.out
 create mode 100755 tests/xfs/760
 create mode 100644 tests/xfs/760.out
 create mode 100755 tests/xfs/761
 create mode 100644 tests/xfs/761.out
 create mode 100755 tests/xfs/765
 create mode 100644 tests/xfs/765.out
 create mode 100755 tests/xfs/915
 create mode 100644 tests/xfs/915.out

