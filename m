Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F2E8C3DA6F
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Aug 2023 23:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244068AbjHXXVo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238161AbjHXXVR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2023 19:21:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D35FB
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 16:21:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97815655CA
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 23:21:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3FFAC433C8;
        Thu, 24 Aug 2023 23:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692919275;
        bh=M8ndhhRhsLt8+YMsAK/8gwJWwchW7q4P1lQCZNHf3EA=;
        h=Subject:From:To:Cc:Date:From;
        b=B2suqsp9ho3FskCuOAhqDhZMZF6wW7lyMfoZPytLpmcznEApHo+1/whOzxNYn7rpP
         6vp+lvab7P8ZPWnLd7yoNqCn3vxcbPW5TgcbaXhZQL22nPMIF/xriTjiKUPpZF1hH/
         k9uGyTwrUA8bh8e14/fbU33E9Wope6D+dBQwHm29FhO/Y5Yn/uh8/KqbMY5IPhoj3U
         7FLNOKpoiN6A4LH0p+V9mrXIMJmgTFsAhENZOjPp0cbydBWvrDwhr3/ubuJLEHkjEZ
         VtovhyHmkSfIZKtkwDEg+ba8nXYqH8WTF7QSXhRGPI2SaqWu0F6e5B7WmcGxlWoPmc
         39uVO2u8Dg5Uw==
Subject: [PATCHSET 0/3] xfs: fix cpu hotplug mess
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandan.babu@gmail.com, djwong@kernel.org
Cc:     peterz@infradead.org, ritesh.list@gmail.com, sandeen@sandeen.net,
        tglx@linutronix.de, linux-xfs@vger.kernel.org, david@fromorbit.com,
        ritesh.list@gmail.com, sandeen@sandeen.net
Date:   Thu, 24 Aug 2023 16:21:14 -0700
Message-ID: <169291927442.219974.9654062191833512358.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Ritesh and Eric separately reported crashes in XFS's hook function for
CPU hot remove if the remove event races with a filesystem being
mounted.  I also noticed via generic/650 that once in a while the log
will shut down over an apparent overrun of a transaction reservation;
this turned out to be due to CIL percpu list aggregation failing to pick
up the percpu list items from a dying CPU.

Either way, the solution here is to eliminate the need for a CPU dying
hook by using a private cpumask to track which CPUs have added to their
percpu lists directly, and iterating with that mask.  This fixes the log
problems and (I think) solves a theoretical UAF bug in the inodegc code
too.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fix-percpu-lists-6.6
---
 fs/xfs/xfs_icache.c        |   60 ++++++++++----------------------------------
 fs/xfs/xfs_icache.h        |    1 -
 fs/xfs/xfs_log_cil.c       |   50 +++++++++++--------------------------
 fs/xfs/xfs_log_priv.h      |   14 ++++------
 fs/xfs/xfs_mount.h         |    6 +++-
 fs/xfs/xfs_super.c         |   55 +---------------------------------------
 include/linux/cpuhotplug.h |    1 -
 7 files changed, 40 insertions(+), 147 deletions(-)

