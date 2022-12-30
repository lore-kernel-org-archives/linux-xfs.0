Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98A0FC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:01:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235440AbiL3XBS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:01:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiL3XBQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:01:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 914D9193DB
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:01:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3082461BA9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:01:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 834F3C433EF;
        Fri, 30 Dec 2022 23:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441273;
        bh=fx1Y+osgK1kD1kEfnBWpvU4mwWaEjdQkpdZuiV2chJM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=t/d1JVgNygi4FkFMXhx8QJOEfqhr+GVTn31QlcuayUZpgUSLW6ZpUYejOfhUFa3BE
         ZwecOfNphVna0Pm0xMu9t6BDl8x1pJRFm6JihqidMU8lc+b7kD3hwxOud/U/i6autG
         pbi0EHMpPlyXmbOKROwMKopAPlgUMTxJzZQJgPvd+Fh/ZCjVlkhH92nvvlOsKg5vHs
         ZsU9HN3UAmvU9ApW8X9HcHw6dh6sMw3wTrSEIbSgScmcPVIrp2RLF5dsEA00y7HQSP
         vOHp/gbOIzp6NxCuAvOSzxS4F2G2s6bdjzjhHxSvh33hLClIGTye7AoGpNJKnrJLnt
         vifTqW5CIT6Pg==
Subject: [PATCHSET v24.0 0/2] xfs: force rebuilding of metadata
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:45 -0800
Message-ID: <167243836537.692955.2878906942781441773.stgit@magnolia>
In-Reply-To: <Y69Unb7KRM5awJoV@magnolia>
References: <Y69Unb7KRM5awJoV@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patchset adds a new IFLAG to the scrub ioctl so that userspace can
force a rebuild of an otherwise consistent piece of metadata.  This will
eventually enable the use of online repair to relocate metadata during a
filesystem reorganization (e.g. shrink).  For now, it facilitates stress
testing of online repair without needing the debugging knobs to be
enabled.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-force-rebuild

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-force-rebuild

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-force-rebuild
---
 fs/xfs/libxfs/xfs_fs.h |    6 +++++-
 fs/xfs/scrub/common.h  |   12 ++++++++++++
 fs/xfs/scrub/scrub.c   |   18 ++++++++++++------
 fs/xfs/scrub/trace.h   |    3 ++-
 4 files changed, 31 insertions(+), 8 deletions(-)

