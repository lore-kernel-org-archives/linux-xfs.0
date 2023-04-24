Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E98BEC7618E
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Apr 2023 10:48:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbjDXKs5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Apr 2023 06:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjDXKs4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Apr 2023 06:48:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78BCCB7
        for <linux-xfs@vger.kernel.org>; Mon, 24 Apr 2023 03:48:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1285C611B5
        for <linux-xfs@vger.kernel.org>; Mon, 24 Apr 2023 10:48:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E5AC433EF
        for <linux-xfs@vger.kernel.org>; Mon, 24 Apr 2023 10:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682333334;
        bh=quMidFXQUhXL6+bpUV1SmCPb3fMmlXP51puoun+/1xk=;
        h=Date:From:To:Subject:From;
        b=eybQXol74WPrZlczpME8t7FJoVMNQFOiubXjtMs0/YLfZV0Na+getjiy05+owq2/q
         cgRGjHfuONBprmLCCmVnSuBC5gmB3Trk2aNhOqdF67r3sninNcYqDsMA+ckSsP6J8T
         0M3iuOgCxggKfZjePFK2r+D2oV0h51w+EpaK4LX1LIoOJCsyjIBS9/s/jsrc+gH4xH
         j3wk8e3bcIbGFTyh0o3GrjLyFCzOSEikBxywQEFxq8v/zZL5YbxqwJ4YKURyMHaDwd
         xWij6qiJ+oczL7teekXJndQ5gnPS0xJy8/NS1E0SIrgkGtgthnGhpC8usTzBSydH6T
         ASoRUseLOgygA==
Date:   Mon, 24 Apr 2023 12:48:50 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs: for-next updated to 364cc9546
Message-ID: <20230424104850.ctqyp2crom3du2tm@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello.

The xfsprogs for-next branch, located at:

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/refs/?h=for-next

Has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed on
the list and not included in this update, please let me know.

The new head of the for-next branch is commit:

364cc95468f737725b90a91bf11b8e0452aa0122

3 new commits:

Darrick J. Wong (2):
      [d8a19f298] libfrog: move crc32c selftest buffer into a separate file
      [b9d29568e] misc: test the dir/attr hash before formatting or repairing fs

Eric Sandeen (1):
      [364cc9546] xfsprogs: nrext64 option should be in [inode] section of mkfs conf files

Code Diffstat:

 libfrog/Makefile         |   7 +-
 libfrog/crc32cselftest.h | 533 +----------------------------------------------
 libfrog/dahashselftest.h | 172 +++++++++++++++
 libfrog/randbytes.c      | 527 ++++++++++++++++++++++++++++++++++++++++++++++
 libfrog/randbytes.h      |  11 +
 mkfs/lts_4.19.conf       |   2 +-
 mkfs/lts_5.10.conf       |   2 +-
 mkfs/lts_5.15.conf       |   2 +-
 mkfs/lts_5.4.conf        |   2 +-
 mkfs/lts_6.1.conf        |   2 +-
 mkfs/xfs_mkfs.c          |   8 +
 repair/init.c            |   5 +
 12 files changed, 743 insertions(+), 530 deletions(-)
 create mode 100644 libfrog/dahashselftest.h
 create mode 100644 libfrog/randbytes.c
 create mode 100644 libfrog/randbytes.h

-- 
Carlos Maiolino
