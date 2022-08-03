Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56455C19F2B
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Aug 2022 04:22:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235527AbiHCEW3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Aug 2022 00:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233637AbiHCEW2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Aug 2022 00:22:28 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB088564DD;
        Tue,  2 Aug 2022 21:22:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6EA1ECE2256;
        Wed,  3 Aug 2022 04:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E032C433C1;
        Wed,  3 Aug 2022 04:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659500544;
        bh=wz23+o8B9wvUCjKs4uwLhysHpVMZJwg+ieucfXW78ZU=;
        h=Subject:From:To:Cc:Date:From;
        b=ZuewhqpLu/mjGlEuMiCRHWn+hW4IsrkAqUmzRiSyoGcqLlOfVD6j9pnDvUfOcR/74
         ObsNmHKzIVgkXzMUmqpCTpbsEa3GKcsiIxqY7w2Z6aIS1SDZ40FFv4HqAL4t6Cdvom
         QXke6KM7SiUH/N3PL3ToSY6q2em9geklZDcoJYepys8JxgbFTZrwCfaIccrbuE42Ds
         fTWnMFB3RXujF0hozkVgFkF98/hjMXSmG1D7FcSBf8rnaEzgI00ifV3Lh6ijb3wIsv
         FT7cX/McPmilD3bE6kSpuRZ9WrBpdqgepp1dtrMhXGhJRF1umga9eZUxtlkcx610rJ
         yXUOVuTBATEZg==
Subject: [PATCHSET v2 0/3] fstests: fix some hangs in crash recovery
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 02 Aug 2022 21:22:24 -0700
Message-ID: <165950054404.199222.5615656337332007333.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

There are several tests in fstests (generic/019, generic/388,
generic/475, xfs/057, etc.) that test filesystem crash recovery by
starting a loop that kicks off a filesystem exerciser, waits a few
seconds, and offlines the filesystem somehow.  Some of them use the
block layer's error injector, some use dm-error, and some use the
shutdown ioctl.

The crash tests that employ error injection have the unfortunate trait
of causing occasional livelocks when tested against XFS because XFS
allows administrators to configure the filesystem to retry some failed
writes indefinitely.  If the offlining races with a full log trying to
update the filesystem, the fs will hang forever.  Fix this by allowing
XFS to go offline immediately.

While we're at it, fix the dmesg scrapers so they don't trip over XFS
reporting these IO errors as internal errors.

v2: add hch reviews

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fix-shutdown-test-hangs
---
 check                    |    1 +
 common/dmerror           |    4 ++++
 common/fail_make_request |    1 +
 common/rc                |   50 +++++++++++++++++++++++++++++++++++++++++-----
 common/xfs               |   38 ++++++++++++++++++++++++++++++++++-
 tests/xfs/006.out        |    6 +++---
 tests/xfs/264.out        |   12 ++++++-----
 7 files changed, 97 insertions(+), 15 deletions(-)

