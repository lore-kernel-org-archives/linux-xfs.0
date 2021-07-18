Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 495AEC636CA
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Jul 2021 14:35:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 281D261183
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Jul 2021 14:35:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233951AbhGROi3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Jul 2021 10:38:29 -0400
Received: from out20-61.mail.aliyun.com ([115.124.20.61]:44603 "EHLO
        out20-61.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233953AbhGROi2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Jul 2021 10:38:28 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.2969857|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0464452-0.0132664-0.940288;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047206;MF=guan@eryu.me;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.KkrxKF3_1626618928;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.KkrxKF3_1626618928)
          by smtp.aliyun-inc.com(10.147.44.129);
          Sun, 18 Jul 2021 22:35:28 +0800
Date:   Sun, 18 Jul 2021 22:35:28 +0800
From:   Eryu Guan <guan@eryu.me>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCHSET 0/8] fstests: random fixes
Message-ID: <YPQ8MDb4u2EE9HVo@desktop>
References: <162561726690.543423.15033740972304281407.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162561726690.543423.15033740972304281407.stgit@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 06, 2021 at 05:21:07PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> This series fixes a bunch of small problems in the test suite that were
> causing intermittent test failures.

I've applied all fixes except patch 2/8, apparently it got a new version
in your local tree.

Thanks for all the fixes!

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
> kernel git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes
> 
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes
> 
> fstests git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
> ---
>  check             |   24 +++++++++++++++++-------
>  common/dmthin     |    8 ++++++--
>  tests/generic/019 |    3 +++
>  tests/generic/371 |    8 ++++++++
>  tests/generic/561 |    9 +++++++--
>  tests/shared/298  |    2 +-
>  tests/xfs/084     |    8 ++++++--
>  tests/xfs/172     |   30 +++++++++++++++++++++++++++++-
>  8 files changed, 77 insertions(+), 15 deletions(-)
