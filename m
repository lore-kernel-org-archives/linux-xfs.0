Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C904C433C1
	for <linux-xfs@archiver.kernel.org>; Sun, 28 Mar 2021 15:15:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4567861972
	for <linux-xfs@archiver.kernel.org>; Sun, 28 Mar 2021 15:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbhC1PPA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 28 Mar 2021 11:15:00 -0400
Received: from out20-110.mail.aliyun.com ([115.124.20.110]:37978 "EHLO
        out20-110.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbhC1POi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Mar 2021 11:14:38 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.09271105|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_social|0.0260151-0.00161558-0.972369;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047187;MF=guan@eryu.me;NM=1;PH=DS;RN=5;RT=5;SR=0;TI=SMTPD_---.JrYxZ-._1616944472;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.JrYxZ-._1616944472)
          by smtp.aliyun-inc.com(10.147.41.137);
          Sun, 28 Mar 2021 23:14:33 +0800
Date:   Sun, 28 Mar 2021 23:14:32 +0800
From:   Eryu Guan <guan@eryu.me>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCHSET 0/3] fstests: add inode btree blocks counters to the
 AGI header
Message-ID: <YGCdWPCGplgCkQPo@desktop>
References: <161647324459.3431131.16341235245632737552.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161647324459.3431131.16341235245632737552.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 22, 2021 at 09:20:44PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> Years ago, Christoph diagnosed a problem where freeing an inode on a
> totally full filesystem could fail due to finobt expansion not being
> able to allocate enough blocks.  He solved the problem by using the
> per-AG block reservation system to ensure that there are always enough
> blocks for finobt expansion, but that came at the cost of having to walk
> the entire finobt at mount time.  This new feature solves that
> performance regression by adding inode btree block counts to the AGI
> header.  The patches in this series amend fstests to handle the new
> metadata fields and to test that upgrades work properly.

I've applied the first two patches, the third one seems need to be
revised.

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
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=inobt-counters
> 
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=inobt-counters
> 
> fstests git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=inobt-counters
> ---
>  common/xfs        |   20 ++++++
>  tests/xfs/010     |    3 +
>  tests/xfs/030     |    2 +
>  tests/xfs/122.out |    2 -
>  tests/xfs/764     |  190 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/764.out |   27 ++++++++
>  tests/xfs/910     |   84 +++++++++++++++++++++++
>  tests/xfs/910.out |   12 +++
>  tests/xfs/group   |    2 +
>  9 files changed, 340 insertions(+), 2 deletions(-)
>  create mode 100755 tests/xfs/764
>  create mode 100644 tests/xfs/764.out
>  create mode 100755 tests/xfs/910
>  create mode 100644 tests/xfs/910.out
