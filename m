Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 722CAC77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:29:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240535AbjEZA3x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236574AbjEZA3s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:29:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 088B41BF
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:29:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 923B4608CC
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:29:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C23C433D2;
        Fri, 26 May 2023 00:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685060952;
        bh=SjIVGmrNzEInVdBf/pPvvGbi90BmfM00MSNdVlqeW28=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=cro862eyGRqnLse/emxoAKwR5CcN0VV0YvOmtvxAHNAT9cg1JyiJR+g6FA4StWRL3
         cApcDmNiWqB+aLmUQa9OMtgKLJ27g2mbznDpSAhlI2mnwnob4I++Zq2PHW3yn6MRpO
         bJ67VjRXfBzNv7jBw/h/exCalE1NTET7llZQULsmqfj/1f+syAcb1QcKz2X9FvvfHm
         Isfb2Uf1pKJI4X1FDePUzLOiUCTFrwCpMu5fOhZ38Cio+qnnqPE938peZ0+2QOQ+yF
         jVpMl3g6NbIuHjt81iCDfN7BHUMTFD0I5GSkQyOv3MiairF6Yoiff/Vto4CBPcbIum
         tSsk0jbIe7T3Q==
Date:   Thu, 25 May 2023 17:29:11 -0700
Subject: [PATCHSET v25.0 0/4] xfs: online scrubbing of realtime summary files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506056859.3729869.14765688109434520098.stgit@frogsfrogsfrogs>
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

This patchset implements an online checker for the realtime summary
file.  The first few changes are some general cleanups -- scrub should
get its own references to all inodes, and we also wrap the inode lock
functions so that we can standardize unlocking and releasing inodes that
are the focus of a scrub.

With that out of the way, we move on to constructing a shadow copy of
the rtsummary information from the rtbitmap, and compare the new copy
against the ondisk copy.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-rtsummary

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=scrub-rtsummary
---
 fs/xfs/Makefile          |    6 +
 fs/xfs/scrub/bmap.c      |    9 +-
 fs/xfs/scrub/common.c    |   63 +++++++++--
 fs/xfs/scrub/common.h    |   16 ++-
 fs/xfs/scrub/inode.c     |   11 +-
 fs/xfs/scrub/parent.c    |    4 -
 fs/xfs/scrub/quota.c     |   15 +--
 fs/xfs/scrub/rtbitmap.c  |   48 +-------
 fs/xfs/scrub/rtsummary.c |  262 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c     |   17 ++-
 fs/xfs/scrub/scrub.h     |    4 +
 fs/xfs/scrub/trace.h     |   34 ++++++
 fs/xfs/xfs_trace.h       |    3 +
 13 files changed, 410 insertions(+), 82 deletions(-)
 create mode 100644 fs/xfs/scrub/rtsummary.c

