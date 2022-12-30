Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1D97C3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:04:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235964AbiLaBE1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:04:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235955AbiLaBEZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:04:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4161DF10;
        Fri, 30 Dec 2022 17:04:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4717BB81DE6;
        Sat, 31 Dec 2022 01:04:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7208C433D2;
        Sat, 31 Dec 2022 01:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448662;
        bh=qnAwUDmrpu77SUHWkqtHLQytX9/85ucSuhO0+0RPtzA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=aOVZAxG9KpWN4mim4ndCiXLPID5Kxo7LcQfMq91/7IBX8VtYPzwVGpHkRrN6f4uaP
         Ec85ZTqsShdToPX5dGZ23dTuPLMRvqygRD75+92u9HhED/LnoCzX0q/AhX7/kdrS/c
         rfws/CP2MhnOw6zBgh0N3J4VAvDpK1zC0YrzTP/y6zHyFKUeOrOjOWwKxf9tQ0s4lW
         FuygUzztm06/PimOI6oQUq1bp1dpF5xAcLYVTAkA9hm2G7scL8FP65eEayUDFJCyLS
         ZK0UYCE3H27kL1WqlhRlGaLSW4NCO7bJJk9T4gdIc13QfYp3G1/ll3eDGcXMJ6kjNs
         eBbPeQQKZhXLA==
Subject: [PATCHSET v1.0 00/13] fstests: fixes for realtime rmap
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:43 -0800
Message-ID: <167243884390.739669.13524725872131241203.stgit@magnolia>
In-Reply-To: <Y69UsO7tDT3HcFri@magnolia>
References: <Y69UsO7tDT3HcFri@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Fix a few regressions in fstests when rmap is enabled on the realtime
volume.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-rmap

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-rmap

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-rmap

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=realtime-rmap
---
 common/populate    |   36 +++++++++++++++++++++++++++++++++++-
 common/xfs         |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/104      |    1 +
 tests/xfs/122.out  |    5 ++---
 tests/xfs/1528     |   41 +++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1528.out |    4 ++++
 tests/xfs/1529     |   40 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1529.out |    4 ++++
 tests/xfs/272      |    2 +-
 tests/xfs/276      |    2 +-
 tests/xfs/277      |    2 +-
 tests/xfs/291      |    3 ++-
 tests/xfs/332      |    6 +-----
 tests/xfs/332.out  |    2 --
 tests/xfs/333      |   45 ---------------------------------------------
 tests/xfs/333.out  |    6 ------
 tests/xfs/337      |    2 +-
 tests/xfs/338      |   21 ++++++++++++++++-----
 tests/xfs/339      |    5 +++--
 tests/xfs/340      |   15 ++++++++++-----
 tests/xfs/341      |   12 ++++--------
 tests/xfs/341.out  |    1 -
 tests/xfs/342      |    4 ++--
 tests/xfs/343      |    2 ++
 tests/xfs/406      |    6 ++++--
 tests/xfs/407      |    6 ++++--
 tests/xfs/408      |    7 +++++--
 tests/xfs/409      |    7 +++++--
 tests/xfs/443      |    9 +++++----
 tests/xfs/481      |    6 ++++--
 tests/xfs/482      |    7 +++++--
 tests/xfs/769      |   29 ++++++++++++++++++++++++++++-
 tests/xfs/781      |   42 ++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/781.out  |    2 ++
 tests/xfs/817      |   42 ++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/817.out  |    2 ++
 tests/xfs/821      |   42 ++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/821.out  |    2 ++
 38 files changed, 414 insertions(+), 107 deletions(-)
 create mode 100755 tests/xfs/1528
 create mode 100644 tests/xfs/1528.out
 create mode 100755 tests/xfs/1529
 create mode 100644 tests/xfs/1529.out
 delete mode 100755 tests/xfs/333
 delete mode 100644 tests/xfs/333.out
 create mode 100755 tests/xfs/781
 create mode 100644 tests/xfs/781.out
 create mode 100755 tests/xfs/817
 create mode 100644 tests/xfs/817.out
 create mode 100755 tests/xfs/821
 create mode 100644 tests/xfs/821.out

