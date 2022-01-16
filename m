Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18D95C433F5
	for <linux-xfs@archiver.kernel.org>; Sun, 16 Jan 2022 07:16:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbiAPHQ5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 16 Jan 2022 02:16:57 -0500
Received: from out20-1.mail.aliyun.com ([115.124.20.1]:53471 "EHLO
        out20-1.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbiAPHQ4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 16 Jan 2022 02:16:56 -0500
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.09859663|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.0283917-0.00100899-0.970599;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047203;MF=guan@eryu.me;NM=1;PH=DS;RN=6;RT=6;SR=0;TI=SMTPD_---.Mdoksve_1642317414;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.Mdoksve_1642317414)
          by smtp.aliyun-inc.com(10.147.40.26);
          Sun, 16 Jan 2022 15:16:54 +0800
Date:   Sun, 16 Jan 2022 15:16:53 +0800
From:   Eryu Guan <guan@eryu.me>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, xuyang2018.jy@fujitsu.com,
        Theodore Ts'o <tytso@mit.edu>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCHSET 0/8] fstests: random fixes
Message-ID: <YePGZTllSm3d/Xy1@desktop>
References: <164193780808.3008286.598879710489501860.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164193780808.3008286.598879710489501860.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 11, 2022 at 01:50:08PM -0800, Darrick J. Wong wrote:
> Hi all,
> 
> Here is a pile of random fstests fixes: a couple to fix xfs_scrub
> unicode detection; one to fix xfs/220 so that it tests QUOTARM again;
> the usual adjustments to fstests to accomodate behavior changes added to
> 5.17; a regression test for CVE-2021-4155; and cleanups to make fstests
> less dependent on XFS_IOC_ALLOCSP/FREESP since those are going away for
> 5.17.

Thanks for all the fixes and new test! I've applied all but the changes
to iogen.c. (9/8 included).

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
>  .gitignore        |    1 
>  common/rc         |   19 ++++++---
>  common/xfs        |   12 +++++
>  ltp/fsx.c         |  110 +++++++++++++++++++++++++++++++++++++++++++++++++-
>  ltp/iogen.c       |   32 ++++++++++----
>  src/Makefile      |    2 -
>  src/alloc.c       |   66 +++++++++++++++++++++++++-----
>  src/allocstale.c  |  117 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/130     |    6 ++-
>  tests/xfs/130.out |    1 
>  tests/xfs/220     |   30 ++++++++++----
>  tests/xfs/308     |    5 --
>  tests/xfs/308.out |    2 -
>  tests/xfs/832     |   56 +++++++++++++++++++++++++
>  tests/xfs/832.out |    2 +
>  15 files changed, 418 insertions(+), 43 deletions(-)
>  create mode 100644 src/allocstale.c
>  create mode 100755 tests/xfs/832
>  create mode 100644 tests/xfs/832.out
