Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FCACC63697
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Nov 2020 14:30:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3172B20888
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Nov 2020 14:30:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbgKVOaJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 Nov 2020 09:30:09 -0500
Received: from out20-49.mail.aliyun.com ([115.124.20.49]:50572 "EHLO
        out20-49.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgKVOaJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Nov 2020 09:30:09 -0500
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07725626|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0810306-0.00218023-0.916789;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047198;MF=guan@eryu.me;NM=1;PH=DS;RN=5;RT=5;SR=0;TI=SMTPD_---.IzrW-Lh_1606055264;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.IzrW-Lh_1606055264)
          by smtp.aliyun-inc.com(10.147.40.44);
          Sun, 22 Nov 2020 22:27:45 +0800
Date:   Sun, 22 Nov 2020 22:27:44 +0800
From:   Eryu Guan <guan@eryu.me>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 0/7] various: test xfs things fixed in 5.10
Message-ID: <20201122142744.GK3853@desktop>
References: <160505542802.1388823.10368384826199448253.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160505542802.1388823.10368384826199448253.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 10, 2020 at 04:43:48PM -0800, Darrick J. Wong wrote:
> Hi all,
> 
> Here are a bunch of new tests for problems that were fixed in 5.10.
> Er.... 5.10 and 5.9.  I have not been good at sending to fstests
> upstream lately. :( :(

It seems all these tests are regression tests for bugs that have been
fixed in v5.10 cycle, and some of the tests didn't list the associated
commits that fixed the bug, and some tests listed the patch titles but
not the commit IDs. Would you please fix them up as well?

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
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=test-fixes-5.10
> ---
>  tests/generic/947     |  117 ++++++++++++++++++++++++++++++++
>  tests/generic/947.out |   15 ++++
>  tests/generic/948     |   90 ++++++++++++++++++++++++
>  tests/generic/948.out |    9 ++
>  tests/generic/group   |    2 +
>  tests/xfs/122         |    1 
>  tests/xfs/122.out     |    1 
>  tests/xfs/758         |   59 ++++++++++++++++
>  tests/xfs/758.out     |    2 +
>  tests/xfs/759         |   99 +++++++++++++++++++++++++++
>  tests/xfs/759.out     |    2 +
>  tests/xfs/760         |   66 ++++++++++++++++++
>  tests/xfs/760.out     |    9 ++
>  tests/xfs/761         |   42 +++++++++++
>  tests/xfs/761.out     |    1 

"Silence is golden" is missed in 761.out :)

Thanks,
Eryu

>  tests/xfs/763         |  181 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/763.out     |   91 +++++++++++++++++++++++++
>  tests/xfs/915         |  176 ++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/915.out     |  151 +++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/group       |    6 ++
>  20 files changed, 1119 insertions(+), 1 deletion(-)
>  create mode 100755 tests/generic/947
>  create mode 100644 tests/generic/947.out
>  create mode 100755 tests/generic/948
>  create mode 100644 tests/generic/948.out
>  create mode 100755 tests/xfs/758
>  create mode 100644 tests/xfs/758.out
>  create mode 100755 tests/xfs/759
>  create mode 100644 tests/xfs/759.out
>  create mode 100755 tests/xfs/760
>  create mode 100644 tests/xfs/760.out
>  create mode 100755 tests/xfs/761
>  create mode 100644 tests/xfs/761.out
>  create mode 100755 tests/xfs/763
>  create mode 100644 tests/xfs/763.out
>  create mode 100755 tests/xfs/915
>  create mode 100644 tests/xfs/915.out
