Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE1D4EB64D9
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Jul 2023 07:30:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbjGLHaP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jul 2023 03:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231693AbjGLHaN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jul 2023 03:30:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 209C21BD5
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 00:29:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A556616E4
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 07:29:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE64C433C8
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 07:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689146987;
        bh=wRyBLnH0VEVkodVNU58UjI3207eKhwo5CjwXzkyg+m8=;
        h=Date:From:To:Subject:From;
        b=jvpx5heF3pIbAg73uXe/xkxqZvghexxvKHjJ3W15U85qWSr51fHmgfeft3RW+93fV
         ChGJxoQAJtfh3ATxKDEL4iSNxZtuDW7sjjkyDgwgCRExWW6xTB601Nfn3UYjqxd/BW
         9ljWXwrX4pY/3/vnxtE0zj63zL4zywjAFJOefZmJ1FpwyCgCxqD1cEWSr07kjez6mz
         LGkaFhGl2dUoAAx/d0QV11j+lZtLdG+twxgp987hHZKWfDwaZqhytgmWzrtfquIg+E
         bXKytCGVjb3K9BTGrLiynH9rCUUsKRBS8se189HMgRDrBg+U5+HMukiSUUu4270bNC
         wB4Zgy0g2Be1Q==
Date:   Wed, 12 Jul 2023 09:29:42 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs: for-next **rebased** to 10139046b
Message-ID: <20230712072942.z63jycdjr6lp24dr@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello.

The xfsprogs for-next branch, located at:

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/refs/?h=for-next

Has just been **REBASED**.

Patches often get missed, so if your outstanding patches are properly reviewed on
the list and not included in this update, please let me know.

This rebase get rid of a mistakenly applied patch, the content of all remaining
patches remain unchanged (except for their hashes).

The new head of the for-next branch is commit:

10139046b4b95c53befd409f7ea91e3c7777771e

12 new commits:

Darrick J. Wong (10):
      [67f541056] xfs_repair: don't spray correcting imap all by itself
      [2618b37ae] xfs_repair: don't log inode problems without printing resolution
      [d159552bb] xfs_repair: fix messaging when shortform_dir2_junk is called
      [beb78d755] xfs_repair: fix messaging in longform_dir2_entry_check_data
      [1e12a0751] xfs_repair: fix messaging when fixing imap due to sparse cluster
      [aca026248] xfs_repair: don't add junked entries to the rebuilt directory
      [dafa78c9a] xfs_repair: always perform extended xattr checks on uncertain inodes
      [4a16ce683] xfs_repair: check low keys of rmap btrees
      [ad662cc17] xfs_repair: warn about unwritten bits set in rmap btree keys
      [10139046b] xfs_db: expose the unwritten flag in rmapbt keys

Pavel Reichl (1):
      [965f91091] mkfs: fix man's default value for sparse option

Weifeng Su (1):
      [0babf94ff] libxcmd: add return value check for dynamic memory function

Code Diffstat:

 tests/xfs/999     | 66 -------------------------------------------------------
 tests/xfs/999.out | 15 -------------
 2 files changed, 81 deletions(-)
 delete mode 100755 tests/xfs/999
 delete mode 100644 tests/xfs/999.out

-- 
Carlos
