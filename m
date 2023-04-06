Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEB51C76196
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:14:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240518AbjDFTON (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjDFTON (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:14:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A798C1
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:14:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA980643F3
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:14:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16EF0C433EF;
        Thu,  6 Apr 2023 19:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680808451;
        bh=bCVCoGnYrZrMf7NnF8BuTsj91NYPGu7eUg3TGBXGsIQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=kSg1ineJjg3i2qmvrzN7DK+1Hd71E7U6RAPeGz4XdtvtYRFQkW+tN2xym/vmIvxgM
         FdD7HL1IcbswZS0vHzCYNclPUp3GLReuiXzlbQFW7iBq8VhNWBz0cM8amgF3iWDBMF
         XsYB9afD5VN9QB6M47AdhQ/KvMlDceHxcnnSR+X3s62lxE1MAYFey5qFDa1wRPUurB
         bg3TSVoFijQgn0Tz1CS+ZgTmjMcOYSF/aH5VyB6436CDfKE2ozp5edFC2UwAuWOmAq
         kdmrfM6hXpq86apg9N2xumLVuVoG2g18shUIfHfq52ViYhS3+wkqwbG/kyRwwEqUwp
         5OzpgAmuSTtYA==
Date:   Thu, 06 Apr 2023 12:14:10 -0700
Subject: [PATCHSET v11 0/3] xfs: hold ILOCK during deferred dir ops
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080824260.615105.7346122486674782401.stgit@frogsfrogsfrogs>
In-Reply-To: <20230406181038.GA360889@frogsfrogsfrogs>
References: <20230406181038.GA360889@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Currently, directory updates (link, unlink, rename) only hold the ILOCK
for the first transaction in the chain.  The first transaction is where
we perform all the directory updates, so this has sufficed to coordinate
access to the directory itself.

With parent pointers, we need to hold both directories and children
ILOCKed across the entire directory update transaction chain so that
other threads never see an inconsistent edge state (parent -> child and
parent <- child).  Prepare for this by making the directory update code
hold all the ILOCKs.

There's a subtle issue with online rmapbt repair that gets fixed here.
Space allocations performed as part of a directory update result in
deferred rmap updates later in the chain.  With the current code, the
directory ILOCK (but not the IOLOCK) is dropped before the rmapbt
updates are performed.  As a result, the online rmapbt repair scanner
has to hold each directory's IOLOCK and ILOCK to coordinate with writer
threads correctly.  This change makes it so that online repair no longer
has to hold the directory IOLOCK, which makes the locking model here
consistent with the other repair scanners.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.
kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-hold-ilocks
---
 fs/xfs/xfs_inode.c   |   65 ++++++++++++++++++++++++++++++++++++++------------
 fs/xfs/xfs_qm.c      |    4 ++-
 fs/xfs/xfs_symlink.c |    2 ++
 fs/xfs/xfs_trans.c   |    9 +++++--
 4 files changed, 61 insertions(+), 19 deletions(-)

