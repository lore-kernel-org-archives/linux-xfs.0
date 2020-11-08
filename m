Return-Path: <SRS0=Jdan=EO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BEF2C388F9
	for <linux-xfs@archiver.kernel.org>; Sun,  8 Nov 2020 10:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1ADFC20719
	for <linux-xfs@archiver.kernel.org>; Sun,  8 Nov 2020 10:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgKHKFh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 8 Nov 2020 05:05:37 -0500
Received: from out20-111.mail.aliyun.com ([115.124.20.111]:56885 "EHLO
        out20-111.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgKHKFh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Nov 2020 05:05:37 -0500
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.09129193|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0182243-0.0046172-0.977159;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047212;MF=guan@eryu.me;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.Iu3W0ke_1604829932;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.Iu3W0ke_1604829932)
          by smtp.aliyun-inc.com(10.147.40.233);
          Sun, 08 Nov 2020 18:05:32 +0800
Date:   Sun, 8 Nov 2020 18:05:32 +0800
From:   Eryu Guan <guan@eryu.me>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 0/9] xfstests: random fixes
Message-ID: <20201108100532.GI3853@desktop>
References: <160382528936.1202316.2338876126552815991.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160382528936.1202316.2338876126552815991.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darric,

On Tue, Oct 27, 2020 at 12:01:29PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> This series contains random fixes to fstests.

I applied patch 2-7 in this patchset, which were reviewed by Christoph,
and seems other patches need rework.

And regarding to your other patchsets, I'm a bit lost, it seems some of
them need rework as well. So I'd wait for your refresh version :)

Thanks,
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
>  check             |   21 ++++++++++++++++++++-
>  common/populate   |    5 +++++
>  common/rc         |   13 ++++++++++---
>  common/repair     |    1 +
>  common/xfs        |   20 ++++++++++++++++++++
>  tests/xfs/030     |    1 +
>  tests/xfs/272     |    3 +++
>  tests/xfs/276     |    8 +++++++-
>  tests/xfs/327     |   18 ++++++++++++++++--
>  tests/xfs/327.out |   13 +++++++------
>  tests/xfs/328     |    2 +-
>  tests/xfs/341     |    8 +++++---
>  tests/xfs/520     |    3 +++
>  13 files changed, 99 insertions(+), 17 deletions(-)
