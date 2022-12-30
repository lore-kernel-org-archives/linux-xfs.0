Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECD61C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:04:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbiLaBE4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:04:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbiLaBE4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:04:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887031DDF0;
        Fri, 30 Dec 2022 17:04:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49DDBB81DF9;
        Sat, 31 Dec 2022 01:04:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ACAFC433EF;
        Sat, 31 Dec 2022 01:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448693;
        bh=YLpyW0eDj5KLa+i5rgCk6GfBdLas2y2WY+BzQCwSv8M=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hXhsCYyJCq7birdGjijLh094vwym5MsFSTdW6b6SeoVeMhN0pbWybKmaDbMhStNa1
         ffxaXPXQjOCnW8CgQVlh7D5wd2C19OR+XyTAiy9lPXPn48RKEXE3CvqN54s7wW74Pi
         N8oGieTaIRNcRTqUVGEg99mFqpmITkd1QMEGt1pACU3GDoDGRxiQyikplBW4mECgWL
         SBt684Sl0FLFAcYT2e2xZvtZhtdjb3m9nd5KXsHeLyGbkL+sUcc5hEPwxWk+9f4hm5
         efjbIiHbTSRnN9aMsOQ09xTOyhGe8zxBomaQ8HrRjiy1J6zMekXapR10eeJ8dNt1rH
         q52mZWVUfX12w==
Subject: [PATCHSET v1.0 0/4] fstests: reflink with large realtime extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:52 -0800
Message-ID: <167243885270.740527.7129374192035439232.stgit@magnolia>
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

Now that we've landed support for reflink on the realtime device for
cases where the rt extent size is the same as the fs block size, enhance
the reflink code further to support cases where the rt extent size is a
power-of-two multiple of the fs block size.  This enables us to do data
block sharing (for example) for much larger allocation units by dirtying
pagecache around shared extents and expanding writeback to write back
shared extents fully.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-reflink-extsize

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-reflink-extsize

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-reflink-extsize
---
 common/rc         |   23 +++++++
 common/reflink    |   27 +++++++++
 tests/generic/145 |    1 
 tests/generic/147 |    1 
 tests/generic/261 |    1 
 tests/generic/262 |    1 
 tests/generic/303 |    8 ++-
 tests/generic/331 |    1 
 tests/generic/353 |    3 +
 tests/generic/517 |    1 
 tests/generic/657 |    1 
 tests/generic/658 |    1 
 tests/generic/659 |    1 
 tests/generic/660 |    1 
 tests/generic/663 |    1 
 tests/generic/664 |    1 
 tests/generic/665 |    1 
 tests/generic/670 |    1 
 tests/generic/672 |    1 
 tests/xfs/1212    |    1 
 tests/xfs/180     |    1 
 tests/xfs/182     |    1 
 tests/xfs/184     |    1 
 tests/xfs/192     |    1 
 tests/xfs/200     |    1 
 tests/xfs/204     |    1 
 tests/xfs/208     |    1 
 tests/xfs/315     |    1 
 tests/xfs/326     |    6 ++
 tests/xfs/420     |    3 +
 tests/xfs/421     |    3 +
 tests/xfs/919     |  163 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/919.out |   84 +++++++++++++++++++++++++++
 33 files changed, 342 insertions(+), 2 deletions(-)
 create mode 100755 tests/xfs/919
 create mode 100644 tests/xfs/919.out

