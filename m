Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AEB1C0015E
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:20:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbjG0WUJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjG0WUI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:20:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB48187
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:20:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62F6A61F50
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:20:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEED7C433C8;
        Thu, 27 Jul 2023 22:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690496406;
        bh=fx1Y+osgK1kD1kEfnBWpvU4mwWaEjdQkpdZuiV2chJM=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=jh+hmxTkYODKCqFCMj/2aCtsTgegAoAxUfkwwacbPlmVEXTWkLsvdYf30Z1eDGmO7
         Dejq1UzBt5XiPrRoXF+YFhXDz9k7ABYF8PMTL3GXmKvD4CoztcBnqxvckQdmG4BHbe
         c8RoPZzRclrkAKs2o/FqZx2B2kPaLH3fQAbMwQGfJILPsHJhCl/nIwb9A/ryA5zTk6
         H+q55GQPIDQw6FbrFf9W4MAF8ALTEAQMfczYZnIvxP7w8AdrDEyFP2op54XUzncjQm
         BsumzbX8GIaXvqaaEl3tKcbZMhpiWTbIVgEtQoC6o5Kl01RrFM09wfby0wKOLptWya
         /0OfZ9FltjL5Q==
Date:   Thu, 27 Jul 2023 15:20:06 -0700
Subject: [PATCHSET v26.0 0/2] xfs: force rebuilding of metadata
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <169049625018.922058.9081185927358791336.stgit@frogsfrogsfrogs>
In-Reply-To: <20230727221158.GE11352@frogsfrogsfrogs>
References: <20230727221158.GE11352@frogsfrogsfrogs>
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

