Return-Path: <SRS0=yY6+=BX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0FB4C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Aug 2020 02:16:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1B7A20774
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Aug 2020 02:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597284987;
	bh=EBGg19Dd5MD4+6AJhMuxHc3UP6Y5FAwxWp4vmDw6Tmg=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=rEL9wYU97mNRt4yPIrEU+5NaFmW2+BDkYU53xmsZRxigl9/5JVa+lIxfFnLvDIQS3
	 EEslXgb3gO4ZzX5+SOULnZSRo4gLJLGYe2zGJ4/BD0RLOhZ2xQmIir66YJYd+9N6ei
	 kLDt72LCboHLoIWFUaEJmXb4iOhzpQNDpz17JfXQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgHMCQ1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Aug 2020 22:16:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726419AbgHMCQ1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Aug 2020 22:16:27 -0400
Received: from localhost (c-67-169-218-210.hsd1.or.comcast.net [67.169.218.210])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67301206B2;
        Thu, 13 Aug 2020 02:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597284986;
        bh=EBGg19Dd5MD4+6AJhMuxHc3UP6Y5FAwxWp4vmDw6Tmg=;
        h=Date:From:To:Cc:Subject:From;
        b=mtyMKpksD488aOzLUTr5VzuTI2sgURzC6JZ7lxqDVoL76bLdIOZJgPRG3NOx1amAf
         8/KC6yGXERk25XftDjQ+bEJdDL7V68Wfgwozwj3H3x6npI7tvLCkRjVVBcpbxA2qTU
         R2kyDffpo52RpoPGM9FiezZm6lchH6ndNcdyh6zM=
Date:   Wed, 12 Aug 2020 19:16:24 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        sandeen@sandeen.net, hch@lst.de
Subject: [GIT PULL] xfs: small fixes for 5.9-rc1
Message-ID: <20200813021624.GH6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Linus,

Please pull these two small fixes that have come in during the past
week.  The branch merges cleanly with upstream as of a few minutes ago,
so please let me know if anything strange happens.

--D

The following changes since commit 818d5a91559ffe1e1f2095dcbbdb96c13fdb94ec:

  fs/xfs: Support that ioctl(SETXFLAGS/GETXFLAGS) can set/get inode DAX on XFS. (2020-07-28 20:28:20 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.9-merge-8

for you to fetch changes up to 96cf2a2c75567ff56195fe3126d497a2e7e4379f:

  xfs: Fix UBSAN null-ptr-deref in xfs_sysfs_init (2020-08-07 11:50:17 -0700)

----------------------------------------------------------------
Fixes for 5.9-rc1:
- Fix duplicated words in comments.
- Fix an ubsan complaint about null pointer arithmetic.

----------------------------------------------------------------
Eiichi Tsukata (1):
      xfs: Fix UBSAN null-ptr-deref in xfs_sysfs_init

Randy Dunlap (1):
      xfs: delete duplicated words + other fixes

 fs/xfs/libxfs/xfs_sb.c        | 2 +-
 fs/xfs/xfs_attr_list.c        | 2 +-
 fs/xfs/xfs_buf_item.c         | 2 +-
 fs/xfs/xfs_buf_item_recover.c | 2 +-
 fs/xfs/xfs_dquot.c            | 2 +-
 fs/xfs/xfs_export.c           | 2 +-
 fs/xfs/xfs_inode.c            | 4 ++--
 fs/xfs/xfs_inode_item.c       | 4 ++--
 fs/xfs/xfs_iomap.c            | 2 +-
 fs/xfs/xfs_log_cil.c          | 2 +-
 fs/xfs/xfs_log_recover.c      | 2 +-
 fs/xfs/xfs_refcount_item.c    | 2 +-
 fs/xfs/xfs_reflink.c          | 2 +-
 fs/xfs/xfs_sysfs.h            | 6 ++++--
 fs/xfs/xfs_trans_ail.c        | 4 ++--
 15 files changed, 21 insertions(+), 19 deletions(-)
