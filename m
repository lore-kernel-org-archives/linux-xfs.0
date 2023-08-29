Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DECA5C6FA8F
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Aug 2023 23:04:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236506AbjH2XED (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 19:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239754AbjH2XDg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 19:03:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE6CE9;
        Tue, 29 Aug 2023 16:03:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A29663EF8;
        Tue, 29 Aug 2023 23:03:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE36EC433C8;
        Tue, 29 Aug 2023 23:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693350212;
        bh=7FWLSdEbXMQlsNdLNNhsTgpQ1bL6RqvXV48hne+LioA=;
        h=Subject:From:To:Cc:Date:From;
        b=fSWXsamEXyhm3oz9EHdX68icJh+UrJ09lqxHazQevAtiYuPebxAcIBpUyu9YWBBSJ
         knuGCNC/hmHw/ZnLg+xNevWGceCNYdWpn8GC7JSKBUC0nVXZEVouFAEoYX78qVlJI0
         39QkyMQkPJ6VwS522T7Ht9JAtGonFA0dDROaNnQ4YWGHRmAyxZQZjducU57NimQSN/
         1bKNZHxH8C5k2HRxcyIPN5Um0ai4pGtjp192en702SakgQO3467P5PsS2wHamPXViv
         h+7zFev1CKOWJnPxLOrC8MeTrT9F65zZiIYWCZLhGnlXDxIcqrdlJLpFHFIIexj3RX
         njOIZC+pI/f1A==
Subject: [PATCHSET 0/3] fstests: updates for Linux 6.6
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 29 Aug 2023 16:03:32 -0700
Message-ID: <169335021210.3517899.17576674846994173943.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Pending fixes for things that are going to get merged in 6.6.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=xfs-merge-6.6
---
 common/btrfs      |    2 +-
 common/filter     |    2 +-
 common/rc         |   19 +++++++++++--------
 common/verity     |    2 +-
 tests/btrfs/049   |    2 +-
 tests/btrfs/106   |    2 +-
 tests/btrfs/173   |    4 ++--
 tests/btrfs/174   |    2 +-
 tests/btrfs/175   |    4 ++--
 tests/btrfs/176   |    4 ++--
 tests/btrfs/192   |    2 +-
 tests/btrfs/215   |    2 +-
 tests/btrfs/251   |    2 +-
 tests/btrfs/271   |    2 +-
 tests/btrfs/274   |    2 +-
 tests/btrfs/293   |    2 +-
 tests/ext4/003    |    2 +-
 tests/ext4/022    |    2 +-
 tests/ext4/306    |    2 +-
 tests/generic/413 |    1 +
 tests/generic/416 |    2 +-
 tests/generic/472 |    2 +-
 tests/generic/495 |    2 +-
 tests/generic/496 |    2 +-
 tests/generic/497 |    2 +-
 tests/generic/574 |    2 +-
 tests/generic/605 |    1 +
 tests/generic/636 |    2 +-
 tests/generic/641 |    2 +-
 tests/xfs/513     |    2 +-
 tests/xfs/552     |    2 +-
 tests/xfs/559     |   29 ++++++++++++++++++++++++++++-
 32 files changed, 72 insertions(+), 40 deletions(-)

