Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03EBDC77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:36:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240779AbjEZAgq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241012AbjEZAgp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:36:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D20DFE4C
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:36:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95FFD64C03
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:36:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F3EC433D2;
        Fri, 26 May 2023 00:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061389;
        bh=q73T5vTepw6bciFTyYuJIBFW8P0u9KkGjih6f0knHqQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=E8kmuFmlsUyqjr7GQHQW9y/cN5gGJRCV08Msrn5buiQZVz69o6oRTNLWpYbZCDOVv
         x4SVQhhRspNVckXuztijyXKBgVlJ9tPZExEviCefvzQhJ41KBMXlxRj+mGF7ibvCAm
         MEpkzrZsHtWOyjPfd+qyoO53PY4AkllIBjZzCIaSaJ4ci9xJaBJ0ZyTPTegNjlPEsO
         +0rmzyHVWBECUbXht8UIa0QZ/pW4HA5PcGAz/jQpmlIn2ab0rm9YQeskJcaR6HQi9D
         O6u+IhHveiNWVa7lJjLqNwSv8/ydXBzfmyLS7XL0qRrad5P0F+38d4fFhUSdw3adDX
         GBeA1TQ0goJ4w==
Date:   Thu, 25 May 2023 17:36:28 -0700
Subject: [PATCHSET v25.0 0/1] xfs: online repair of symbolic links
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506067997.3737907.11606822392124518390.stgit@frogsfrogsfrogs>
In-Reply-To: <20230526000020.GJ11620@frogsfrogsfrogs>
References: <20230526000020.GJ11620@frogsfrogsfrogs>
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

