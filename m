Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EBA3C433EF
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Sep 2021 15:04:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2100F60F51
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Sep 2021 15:04:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233015AbhIEPFl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Sep 2021 11:05:41 -0400
Received: from out20-73.mail.aliyun.com ([115.124.20.73]:32871 "EHLO
        out20-73.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbhIEPFk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Sep 2021 11:05:40 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.1976061|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0301213-0.00271824-0.96716;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047212;MF=guan@eryu.me;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.LFuKDC9_1630854273;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.LFuKDC9_1630854273)
          by smtp.aliyun-inc.com(10.147.42.22);
          Sun, 05 Sep 2021 23:04:34 +0800
Date:   Sun, 5 Sep 2021 23:04:33 +0800
From:   Eryu Guan <guan@eryu.me>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCHSET v2 0/3] fstests: exercise code refactored in 5.14
Message-ID: <YTTcgUw8/EwxYxU1@desktop>
References: <163045510470.770026.14067376159951420121.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163045510470.770026.14067376159951420121.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 31, 2021 at 05:11:44PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> Add new tests to exercise code that got refactored in 5.14.  The
> nested shutdown test simulates the process of recovering after a VM host
> filesystem goes down and the guests have to recover.
> 
> v2: fix some bugs pointed out by the maintainer, add cpu offlining stress test

Thanks for the revision! I've applied patch 2 and 3 for the update.

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
> fstests git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=new-tests-for-5.14
> ---
>  common/rc             |   24 +++++++++
>  tests/generic/725     |  136 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/725.out |    2 +
>  tests/generic/726     |   69 +++++++++++++++++++++++++
>  tests/generic/726.out |    2 +
>  tests/xfs/449         |    2 -
>  6 files changed, 234 insertions(+), 1 deletion(-)
>  create mode 100755 tests/generic/725
>  create mode 100644 tests/generic/725.out
>  create mode 100755 tests/generic/726
>  create mode 100644 tests/generic/726.out
