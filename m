Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 225A1C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:08:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235627AbiL3XIE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:08:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235643AbiL3XIC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:08:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F4812DC7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:08:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25FA361C16
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:08:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F992C433EF;
        Fri, 30 Dec 2022 23:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441680;
        bh=q73T5vTepw6bciFTyYuJIBFW8P0u9KkGjih6f0knHqQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UbIlMvvLvMYL/sWTThieBYbx6j2gF0vqs5uhiW6nmHhfZsAUSlAcJGkXzeLB0ELC4
         kn6d3Omz/usQsIDuKPz3PfgUYmm3ylBEWd77KbNHaN9Q0iRSUrZSzwfqh8fHnXIqf6
         AGeQ1i2JyzKoNGe/E3Le2U6qsBMZkhUnnDXF22M8r+U30uUJK+NlqobhiB2Cq8KWJN
         KJnov+zIaevJY2wJ5xpmz9gmQ294rAps9k6q3/xk6qcYWPO50rOvOZW5hjqoMSLYqp
         pVnRTahIyNvooTDDAJquC3LJUaLzszAMQ5gVNzciBuSNVkpmwDgB4MNmyXO9gLqGm7
         RpfDZdGa2miZg==
Subject: [PATCHSET v24.0 0/1] xfs: online repair of symbolic links
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:14:23 -0800
Message-ID: <167243846301.700901.2906379875397268733.stgit@magnolia>
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

The sole patch in this set adds the ability to repair the target buffer
of a symbolic link, using the same salvage, rebuild, and swap strategy
used everywhere else.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-symlink

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-symlink
---
 fs/xfs/Makefile                    |    1 
 fs/xfs/libxfs/xfs_bmap.c           |   11 -
 fs/xfs/libxfs/xfs_bmap.h           |    6 
 fs/xfs/libxfs/xfs_symlink_remote.c |    9 -
 fs/xfs/libxfs/xfs_symlink_remote.h |   22 +-
 fs/xfs/scrub/repair.h              |    8 +
 fs/xfs/scrub/scrub.c               |    2 
 fs/xfs/scrub/symlink.c             |   13 +
 fs/xfs/scrub/symlink_repair.c      |  452 ++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/tempfile.c            |    5 
 fs/xfs/scrub/trace.h               |   46 ++++
 11 files changed, 560 insertions(+), 15 deletions(-)
 create mode 100644 fs/xfs/scrub/symlink_repair.c

