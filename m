Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82C3BC77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:35:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236327AbjEZAfR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236413AbjEZAfN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:35:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5555819D
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:35:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFA9260B6C
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2250EC433EF;
        Fri, 26 May 2023 00:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061311;
        bh=vTxxf2gIuYk2472lgQsgK7US1uJLWmp1DwsoRJnkp8o=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=lP/fWKwenmCcu+HOTSRzk8uPq6dhPH2BInPN/i5FjtFCxvzzeZTK07rrRVoNvQ9L0
         uA2vYycyLdE4b0iyt9FRuLJrkS97wlJtmC9NPF1zjh+ll6lUs9u8/n8VSHcZyYYCsf
         aTh3DnZjdXj/4Po999Rfizx/qn002nROrOYnOxryAdjOff2LFQ1vmgxlgBj8kgMLwn
         2Lwag9YoMWBkEEWRfxM2bYsJB1I/FRRwCSx+SpI0wdaZFnIDVwEmZZpZw2rdj/wQGE
         K7AjeuvEQ2Qqfqywq0pmg0LOT46FdXaxVWf5XYNYSa6aBVxWYBVOT0cbyIC7N2c+bZ
         /75X/1KXZzfqA==
Date:   Thu, 25 May 2023 17:35:10 -0700
Subject: [PATCHSET v25.0 0/3] xfs: online repair of realtime summaries
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506066008.3735250.5566316565558388079.stgit@frogsfrogsfrogs>
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
 fs/xfs/scrub/scrub.c            |   14 +
 fs/xfs/scrub/scrub.h            |    7 +
 fs/xfs/scrub/tempfile.c         |  392 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/tempfile.h         |   15 +
 fs/xfs/scrub/tempswap.h         |   21 ++
 fs/xfs/scrub/trace.h            |   40 ++++
 12 files changed, 697 insertions(+), 9 deletions(-)
 create mode 100644 fs/xfs/scrub/rtsummary.h
 create mode 100644 fs/xfs/scrub/rtsummary_repair.c
 create mode 100644 fs/xfs/scrub/tempswap.h

