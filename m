Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EE18C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:06:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235623AbiL3XGq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:06:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235580AbiL3XGp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:06:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9984E2DC7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:06:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5630FB81D94
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:06:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F84C433D2;
        Fri, 30 Dec 2022 23:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441602;
        bh=oowxIHdEkHFEzruV9akIHrV7BkNHtjt5B6Q++mr3BXA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lNaXQ1tATDRtmEx3+KbxFVAxyWmWHF05TcBylV92TH2B39ZYwWAjX4p64P+17JUUr
         a0V0/KpWfU7fo1703n2RerlNBNmmOa0GTQ6mzJTa9+toeLFn2cBvccXMa+m9xBYnht
         8QlayDqP86fHPChn6OUflZAA83SsMop/g1psSOevnLfMcPByJEwdba0uvejLMwIKHy
         +BmmXuyuEVj3328NEKwv5QB2H3JH+45twpToigPmUkVJwAe0kct86CXFmvMYYlLcq/
         JBoRx/g1ZPxR7GZnmIy18cNTcT2cWw1tu+cr796FtOEVyALROv1bw993xmOLWwU2fM
         7HusRcaxkTPJg==
Subject: [PATCHSET v24.0 0/3] xfs: online repair of realtime summaries
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:14:04 -0800
Message-ID: <167243844474.700124.6546659007531232200.stgit@magnolia>
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

We now have all the infrastructure we need to repair file metadata.
We'll begin with the realtime summary file, because it is the least
complex data structure.  To support this we need to add three more
pieces to the temporary file code from the previous patchset --
preallocating space in the temp file, formatting metadata into that
space and writing the blocks to disk, and swapping the fork mappings
atomically.

After that, the actual reconstruction of the realtime summary
information is pretty simple, since we can simply write the incore
copy computed by the rtsummary scrubber to the temporary file, swap the
contents, and reap the old blocks.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-rtsummary

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-rtsummary

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-rtsummary
---
 fs/xfs/Makefile                 |    1 
 fs/xfs/scrub/common.c           |    1 
 fs/xfs/scrub/repair.h           |   14 +
 fs/xfs/scrub/rtsummary.c        |   18 +-
 fs/xfs/scrub/rtsummary.h        |   14 +
 fs/xfs/scrub/rtsummary_repair.c |  169 +++++++++++++++++
 fs/xfs/scrub/scrub.c            |    7 +
 fs/xfs/scrub/scrub.h            |    1 
 fs/xfs/scrub/tempfile.c         |  388 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/tempfile.h         |   15 ++
 fs/xfs/scrub/tempswap.h         |   21 ++
 fs/xfs/scrub/trace.h            |   40 ++++
 12 files changed, 683 insertions(+), 6 deletions(-)
 create mode 100644 fs/xfs/scrub/rtsummary.h
 create mode 100644 fs/xfs/scrub/rtsummary_repair.c
 create mode 100644 fs/xfs/scrub/tempswap.h

