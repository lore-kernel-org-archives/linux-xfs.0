Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44260C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 02:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbiKICFq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 21:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiKICFp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2022 21:05:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A18627D1
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 18:05:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AABFB617E1
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 02:05:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15597C433C1;
        Wed,  9 Nov 2022 02:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667959543;
        bh=gmVdETZs8PfGwIA2h4aqUEEIMs9zzHAujvAX0dS+bJ4=;
        h=Subject:From:To:Cc:Date:From;
        b=mnRiCZ74SQhVrjRxkQhlaMnmRWVs2YPRvqGKloRQbNMpcGd0wXahH42+ch++djlSH
         AW5gxpqKHUSL4+CHk5ZcxVvFEZyWsdxo2eCkRZCa9a1jYwUIWBNgMrThOh+5po/MHz
         mHqGfMPKw5DXmL2r0QIe5QSZfjBUAqxpHVhldW4Lo0OAG2A5i0lDfDYGn5FU+7+LWn
         MfQJf+hCwHBtIN8NDGsLE5qQuiyDW11CWRLiGiURRTOwq9jIf1V1S9VN3bYjAXLCmD
         M8TrpONpV0M+SvwbGQLcW57iHcufzDI2S4TjEfmtJyDqjy+Nse/ppKWCV1m6wnc8gE
         I8A60UMXjvHpw==
Subject: [PATCHSET 00/24] xfsprogs: sync with 6.1
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        =?utf-8?q?Christoph_B=C3=B6hmwalder?= 
        <christoph.boehmwalder@linbit.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Kees Cook <keescook@chromium.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        KP Singh <kpsingh@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Helge Deller <deller@gmx.de>,
        Hou Tao <houtao1@huawei.com>,
        Yury Norov <yury.norov@gmail.com>,
        Zeal Robot <zealci@zte.com.cn>,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Shida Zhang <zhangshida@kylinos.cn>,
        Zeng Heng <zengheng4@huawei.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        ye xingchen <ye.xingchen@zte.com.cn>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Guo Xuenan <guoxuenan@huawei.com>,
        Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
        linux-xfs@vger.kernel.org
Date:   Tue, 08 Nov 2022 18:05:42 -0800
Message-ID: <166795954256.3761583.3551179546135782562.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Synchronize with libxfs changs in kernel 6.1 and fix anything that
breaks as a result.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libxfs-sync-6.1
---
 db/check.c                  |    4 -
 db/namei.c                  |    2 
 include/kmem.h              |   10 ++
 libxfs/libxfs_priv.h        |    6 -
 libxfs/xfs_ag.h             |   15 ++
 libxfs/xfs_alloc.c          |    8 -
 libxfs/xfs_bmap.c           |    2 
 libxfs/xfs_da_btree.c       |    2 
 libxfs/xfs_dir2.c           |   50 +++++---
 libxfs/xfs_dir2.h           |    4 -
 libxfs/xfs_dir2_leaf.c      |    9 +
 libxfs/xfs_dir2_sf.c        |    4 -
 libxfs/xfs_format.h         |   22 ---
 libxfs/xfs_ialloc.c         |    4 -
 libxfs/xfs_inode_fork.c     |    4 -
 libxfs/xfs_log_format.h     |   60 ++++++++-
 libxfs/xfs_refcount.c       |  286 ++++++++++++++++++++++++++++++-------------
 libxfs/xfs_refcount.h       |   40 +++++-
 libxfs/xfs_refcount_btree.c |   15 ++
 libxfs/xfs_rmap.c           |    9 -
 libxfs/xfs_trans_resv.c     |    4 -
 libxfs/xfs_types.h          |   30 +++++
 logprint/log_redo.c         |   12 +-
 mkfs/Makefile               |    3 
 mkfs/lts_6.1.conf           |   14 ++
 repair/phase6.c             |    4 -
 repair/rmap.c               |   18 ++-
 repair/scan.c               |   22 ++-
 28 files changed, 469 insertions(+), 194 deletions(-)
 create mode 100644 mkfs/lts_6.1.conf

