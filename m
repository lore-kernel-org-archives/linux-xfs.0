Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01299C04A6A
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Aug 2023 15:29:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236144AbjHJP3H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Aug 2023 11:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236039AbjHJP3G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Aug 2023 11:29:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E5426BD
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2023 08:29:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DFBC66023
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2023 15:29:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9683CC433C7;
        Thu, 10 Aug 2023 15:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691681344;
        bh=YGJsYv1hlOtEd//MpmP88+SCU+uebj4SRC16rzptV0E=;
        h=Date:From:To:Cc:Subject:From;
        b=TGjDK24SbmQWYm4+eRHABgvfCJwUURANXhrd9mPaqbeA2m9AF9qph0yY+Hy7y0Pt4
         dvhJimmfEDAl77d604af+5i9cxRI1a1acrJGrSIFI0i1YHYRVh/0MVGKd1vM7Qgo0t
         W8rrHlbXG92xXl0C8iuGL2HL9PT611GT2sYXw3EiW5extTTi4GE393Wfwq5KGkrh5j
         0tt7jLfr022EHYlaD4nXBYc0A2tOCIoufbnKwPH8QgKilrjGIOreWOgzxy55sNFtAS
         DMNmQqvudodu/HyKDIEn8GEcBKBFgJHS3+Rb4BwHhDunyT1zXj4WiNaHe3MRq9bd+R
         Xxz9uBHDQoU5g==
Date:   Thu, 10 Aug 2023 08:29:04 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandan.babu@oracle.com, djwong@kernel.org
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org
Subject: [GIT PULL 4/9] xfs: add usage counters for scrub
Message-ID: <169168056493.1060601.12487501225706532899.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Chandan,

Please pull this branch with changes for xfs for 6.6-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 764018caa99f7629cefc92257a26b83289a674f3:

xfs: improve xfarray quicksort pivot (2023-08-10 07:48:07 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/scrub-usage-stats-6.6_2023-08-10

for you to fetch changes up to d7a74cad8f45133935c59ed0adf949f85238624b:

xfs: track usage statistics of online fsck (2023-08-10 07:48:07 -0700)

----------------------------------------------------------------
xfs: add usage counters for scrub [v26.1]

This series introduces simple usage and performance counters for the
online fsck subsystem.  The goal here is to enable developers and
sysadmins to look at summary counts of how many objects were checked and
repaired; what the outcomes were; and how much time the kernel has spent
on these operations.  The counter file is exposed in debugfs because
that's easier than cramming it into the device model, and debugfs
doesn't have rules against complex file contents, unlike sysfs.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
xfs: create scaffolding for creating debugfs entries
xfs: track usage statistics of online fsck

fs/xfs/Kconfig        |  17 +++
fs/xfs/Makefile       |   1 +
fs/xfs/scrub/repair.c |  11 +-
fs/xfs/scrub/repair.h |   7 +-
fs/xfs/scrub/scrub.c  |  11 +-
fs/xfs/scrub/stats.c  | 405 ++++++++++++++++++++++++++++++++++++++++++++++++++
fs/xfs/scrub/stats.h  |  59 ++++++++
fs/xfs/xfs_linux.h    |   1 +
fs/xfs/xfs_mount.c    |   9 +-
fs/xfs/xfs_mount.h    |   4 +
fs/xfs/xfs_super.c    |  53 ++++++-
fs/xfs/xfs_super.h    |   2 +
12 files changed, 569 insertions(+), 11 deletions(-)
create mode 100644 fs/xfs/scrub/stats.c
create mode 100644 fs/xfs/scrub/stats.h
