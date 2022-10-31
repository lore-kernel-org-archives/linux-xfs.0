Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BA81FA3741
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Oct 2022 16:13:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiJaQNN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Oct 2022 12:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiJaQNM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Oct 2022 12:13:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62DFEDF61
        for <linux-xfs@vger.kernel.org>; Mon, 31 Oct 2022 09:13:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01BA8612DC
        for <linux-xfs@vger.kernel.org>; Mon, 31 Oct 2022 16:13:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1B2C433C1
        for <linux-xfs@vger.kernel.org>; Mon, 31 Oct 2022 16:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667232790;
        bh=vFv1zi3p3fw1d6baiM/Aj/yM0erQHF+DTafx7PAC1Qg=;
        h=Date:From:To:Subject:From;
        b=e7za5f7FjaWmHWWD3viyEqIRGFYB+u+O6JmKATvCfYVdh7ZIK0jdQc4lG1kYe5gAj
         Mj8w7xMXOyYv1LcGNMupphrD6k/47aDQur34jm8TXa6jpUESPdr1EvU7Ap234mhoH9
         r2pgYHDOObJMKXUVHYw1LSN3ZBSU9GZ2yz2FM0h3u2pQ5jEaNPwjwtDg66natTgEtw
         qkcIM/bYNGWKZWEAwLEZwIgV7Zk575swDGrLwbkIekiG08uNvxhDylsU22VcLPWXJt
         lOyQR+CcTUHjNN2SB5bsSS45uAmvHozJIE7t/ueGSbKyC2E5BGM8I8t4Q2N7Wj339k
         QD5h4vuBq6KsA==
Date:   Mon, 31 Oct 2022 09:13:09 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [GIT PULL] xfs: fix various problems with log intent item recovery
Message-ID: <Y1/0FdFUhgr8fd9B@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi me,

Please pull the final versions of the log item recovery bugfixes into
for-next.

--D
------
The following changes since commit 47ba8cc7b4f82c927cec3ad7c7392e4c45c81c56:

  xfs: fix incorrect return type for fsdax fault handlers (2022-10-31 08:51:45 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/fix-log-recovery-misuse-6.1_2022-10-31

for you to fetch changes up to 950f0d50ee7138d7e631aefea8528d485426eda6:

  xfs: dump corrupt recovered log intent items to dmesg consistently (2022-10-31 08:58:20 -0700)

----------------------------------------------------------------
xfs: fix various problems with log intent item recovery

Starting with 6.1-rc1, CONFIG_FORTIFY_SOURCE checks became smart enough
to detect memcpy() callers that copy beyond what seems to be the end of
a struct.  Unfortunately, gcc has a bug wherein it cannot reliably
compute the size of a struct containing another struct containing a flex
array at the end.  This is the case with the xfs log item format
structures, which means that -rc1 starts complaining all over the place.

Fix these problems by memcpying the struct head and the flex arrays
separately.  Although it's tempting to use the FLEX_ARRAY macros, the
structs involved are part of the ondisk log format.  Some day we're
going to want to make the ondisk log contents endian-safe, which means
that we will have to stop using memcpy entirely.

While we're at it, fix some deficiencies in the validation of recovered
log intent items -- if the size of the recovery buffer is not even large
enough to cover the flex array record count in the head, we should abort
the recovery of that item immediately.

The last patch of this series changes the EFI/EFD sizeof functions names
and behaviors to be consistent with the similarly named sizeof helpers
for other log intent items.

v2: fix more inadequate log intent done recovery validation and dump
    corrupt recovered items

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (8):
      xfs: fix validation in attr log item recovery
      xfs: fix memcpy fortify errors in BUI log format copying
      xfs: fix memcpy fortify errors in CUI log format copying
      xfs: fix memcpy fortify errors in RUI log format copying
      xfs: fix memcpy fortify errors in EFI log format copying
      xfs: refactor all the EFI/EFD log item sizeof logic
      xfs: actually abort log recovery on corrupt intent-done log items
      xfs: dump corrupt recovered log intent items to dmesg consistently

 fs/xfs/libxfs/xfs_log_format.h | 60 ++++++++++++++++++++++++---
 fs/xfs/xfs_attr_item.c         | 67 +++++++++++++++---------------
 fs/xfs/xfs_bmap_item.c         | 54 ++++++++++++------------
 fs/xfs/xfs_extfree_item.c      | 94 ++++++++++++++++++++----------------------
 fs/xfs/xfs_extfree_item.h      | 16 +++++++
 fs/xfs/xfs_ondisk.h            | 23 +++++++++--
 fs/xfs/xfs_refcount_item.c     | 57 +++++++++++++------------
 fs/xfs/xfs_rmap_item.c         | 70 ++++++++++++++++---------------
 fs/xfs/xfs_super.c             | 12 ++----
 9 files changed, 266 insertions(+), 187 deletions(-)
