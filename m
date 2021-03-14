Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F414C433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 14 Mar 2021 18:08:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2144964EC3
	for <linux-xfs@archiver.kernel.org>; Sun, 14 Mar 2021 18:08:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbhCNSIT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 14 Mar 2021 14:08:19 -0400
Received: from out20-63.mail.aliyun.com ([115.124.20.63]:40108 "EHLO
        out20-63.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbhCNSHr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 14 Mar 2021 14:07:47 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.08137877|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_alarm|0.109124-0.00148862-0.889387;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047192;MF=guan@eryu.me;NM=1;PH=DS;RN=6;RT=6;SR=0;TI=SMTPD_---.Jl-Lhph_1615745264;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.Jl-Lhph_1615745264)
          by smtp.aliyun-inc.com(10.147.41.231);
          Mon, 15 Mar 2021 02:07:44 +0800
Date:   Mon, 15 Mar 2021 02:07:44 +0800
From:   Eryu Guan <guan@eryu.me>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, wenli xie <wlxie7296@gmail.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCHSET 00/10] fstests: test kernel regressions fixed in 5.12
Message-ID: <YE5Q8L3is1RscqfJ@desktop>
References: <161526480371.1214319.3263690953532787783.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161526480371.1214319.3263690953532787783.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 08, 2021 at 08:40:03PM -0800, Darrick J. Wong wrote:
> Hi all,
> 
> Here are new tests for problems that were fixed in upstream Linux
> between 5.9 and 5.12.

I've applied all patches except 3/10 and 9/10, thanks for the tests and
fixes!

Eryu

> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D
> 
> fstests git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=kernel-regressions
> ---
>  .gitignore             |    1 
>  common/filter          |   24 +++
>  src/Makefile           |    4 -
>  src/chprojid_fail.c    |   92 ++++++++++++
>  src/deduperace.c       |  370 ++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/1300     |  109 ++++++++++++++
>  tests/generic/1300.out |    2 
>  tests/generic/947      |  118 +++++++++++++++
>  tests/generic/947.out  |   15 ++
>  tests/generic/948      |   92 ++++++++++++
>  tests/generic/948.out  |    9 +
>  tests/generic/949      |   51 +++++++
>  tests/generic/949.out  |    2 
>  tests/generic/group    |    4 +
>  tests/xfs/050          |   30 +---
>  tests/xfs/122          |    1 
>  tests/xfs/122.out      |    1 
>  tests/xfs/299          |   30 +---
>  tests/xfs/758          |   59 ++++++++
>  tests/xfs/758.out      |    2 
>  tests/xfs/759          |  100 +++++++++++++
>  tests/xfs/759.out      |    2 
>  tests/xfs/760          |   68 +++++++++
>  tests/xfs/760.out      |    9 +
>  tests/xfs/761          |   45 ++++++
>  tests/xfs/761.out      |    1 
>  tests/xfs/765          |   71 +++++++++
>  tests/xfs/765.out      |    4 +
>  tests/xfs/915          |  162 +++++++++++++++++++++
>  tests/xfs/915.out      |  151 ++++++++++++++++++++
>  tests/xfs/group        |    6 +
>  31 files changed, 1584 insertions(+), 51 deletions(-)
>  create mode 100644 src/chprojid_fail.c
>  create mode 100644 src/deduperace.c
>  create mode 100755 tests/generic/1300
>  create mode 100644 tests/generic/1300.out
>  create mode 100755 tests/generic/947
>  create mode 100644 tests/generic/947.out
>  create mode 100755 tests/generic/948
>  create mode 100644 tests/generic/948.out
>  create mode 100755 tests/generic/949
>  create mode 100644 tests/generic/949.out
>  create mode 100755 tests/xfs/758
>  create mode 100644 tests/xfs/758.out
>  create mode 100755 tests/xfs/759
>  create mode 100644 tests/xfs/759.out
>  create mode 100755 tests/xfs/760
>  create mode 100644 tests/xfs/760.out
>  create mode 100755 tests/xfs/761
>  create mode 100644 tests/xfs/761.out
>  create mode 100755 tests/xfs/765
>  create mode 100644 tests/xfs/765.out
>  create mode 100755 tests/xfs/915
>  create mode 100644 tests/xfs/915.out
