Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEAFDCDB474
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Oct 2023 10:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbjJNKrM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 14 Oct 2023 06:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232937AbjJNKrL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Oct 2023 06:47:11 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35307A2
        for <linux-xfs@vger.kernel.org>; Sat, 14 Oct 2023 03:47:10 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050DDC433C9;
        Sat, 14 Oct 2023 10:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697280429;
        bh=K8+V7FWxdT9L4O6+ISUBpWcW58PEeLUuct1AVTE49ms=;
        h=From:To:Cc:Subject:Date:From;
        b=jTBaXtvS43dLj06a22gOXIjBiXGQFOamq44d4e6fHNwVuy1jdthI+IXaG1CNR/dO+
         P0ld17UEtpRgQCBTHPTEuiYzs4Q7HLEIEwycYwEN+zAj7lI1aAKlbbYhsJSdP8F95i
         IYasuHU7uehH8OkLU+n797n6JQMYlGqymUDtFqlpUIK2gONxThHghMqQh/w84Ss9o+
         9DIq2PaZ2nyBXf2Ol9/9zZQWIFsw2lyvuX5FM/GtrMyr6QMQKTssBtmmoUMyN0f3vR
         5FpKhyeE/v7d/p627C3sqa9yOjfoYzFNmuqprYp8dJUQs5S3FedE/uhUgUhUlmFWo5
         lnLeVGaoeCaPA==
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandanbabu@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     abaci@linux.alibaba.com, djwong@kernel.org,
        jiapeng.chong@linux.alibaba.com, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, ruansy.fnst@fujitsu.com
Subject: [GIT PULL] xfs: bug fixes for 6.6
Date:   Sat, 14 Oct 2023 16:14:27 +0530
Message-ID: <87o7h1eb12.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Linus,

Please pull this branch with changes for xfs for 6.6-rc6. The changes are
limited to only bug fixes whose summary is provided below.

I did a test-merge with the main upstream branch as of a few minutes ago and
didn't see any conflicts.  Please let me know if you encounter any problems.

The following changes since commit 94f6f0550c625fab1f373bb86a6669b45e9748b3:

  Linux 6.6-rc5 (2023-10-08 13:49:43 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git xfs-6.6-fixes-5

for you to fetch changes up to cbc06310c36f73a5f3b0c6f0d974d60cf66d816b:

  xfs: reinstate the old i_version counter as STATX_CHANGE_COOKIE (2023-10-12 10:17:03 +0530)

----------------------------------------------------------------
Bug fixes for 6.6-rc6:

* Fix calculation of offset of AG's last block and its length.

* Update incore AG block count when shrinking an AG.

* Process free extents to busy list in FIFO order.

* Make XFS report its i_version as the STATX_CHANGE_COOKIE.

Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>

----------------------------------------------------------------
Chandan Babu R (1):
      Merge tag 'random-fixes-6.6_2023-10-11' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-6.6-fixesD

Darrick J. Wong (2):
      xfs: adjust the incore perag block_count when shrinking
      xfs: process free extents to busy list in FIFO order

Jeff Layton (1):
      xfs: reinstate the old i_version counter as STATX_CHANGE_COOKIE

Jiapeng Chong (1):
      xfs: Remove duplicate include

Shiyang Ruan (1):
      xfs: correct calculation for agend and blockcount

 fs/xfs/libxfs/xfs_ag.c      | 6 ++++++
 fs/xfs/scrub/xfile.c        | 1 -
 fs/xfs/xfs_extent_busy.c    | 3 ++-
 fs/xfs/xfs_iops.c           | 5 +++++
 fs/xfs/xfs_notify_failure.c | 6 +++---
 5 files changed, 16 insertions(+), 5 deletions(-)
