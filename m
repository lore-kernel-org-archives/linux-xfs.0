Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE790C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:38:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233159AbjEZAig (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232645AbjEZAif (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:38:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C7D198
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:38:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88BA8615B8
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:38:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA67C433EF;
        Fri, 26 May 2023 00:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061514;
        bh=F93GDTTBXOG/L984nHp9bnlEto2NqAYeZN8qz3DP86Q=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=h0QCxyxdMGTyFotRObxZO3LjFDGDijWLIgliqtvVLiV51hJ9mIUc0EThiUFqM1+/R
         lZAuh/HuaXEz9hLV0wfCG9+VxTd00h5NLwbgrON3bs/sl11ds56DueyhtdUbezotE9
         BBx14yhV6YV5T+SH5oDMkv7LMVNL2BI9Led1yRLbNzRR5e1UluLvJOTsxxKNNbe/Zj
         cf0YniHVoV+vTFPPsAqmUTvppuNmWXfqEFHWnxVZNtBgWgbnK3fK1g4SgiwY3cGLhl
         aFoAtZ6o3AGr+RL5JxpR38VOupqLjl2KOB/lQX+focKsARkPKH9n8r7LjcjT9Qzfp7
         8hDIyTPjY0Oiw==
Date:   Thu, 25 May 2023 17:38:33 -0700
Subject: [PATCHSET v25.0 0/9] xfs_scrub: track data dependencies for repairs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506072015.3743400.5119599474014297677.stgit@frogsfrogsfrogs>
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

Certain kinds of XFS metadata depend on the correctness of lower level
metadata.  For example, directory indexes depends on the directory data
fork, which in turn depend on the directory inode to be correct.  The
current scrub code does not strictly preserve these dependencies if it
has to defer a repair until phase 4, because phase 4 prioritizes repairs
by type (corruption, then cross referencing, and then preening) and
loses the ordering of in the previous phases.  This leads to absurd
things like trying to repair a directory before repairing its corrupted
fork, which is absurd.

To solve this problem, introduce a repair ticket structure to track all
the repairs pending for a principal object (inode, AG, etc).  This
reduces memory requirements if an object requires more than one type of
repair and makes it very easy to track the data dependencies between
sub-objects of a principal object.  Repair dependencies between object
types (e.g.  bnobt before inodes) must still be encoded statically into
phase 4.

A secondary benefit of this new ticket structure is that we can decide
to attempt a repair of an object A that was flagged for a cross
referencing error during the scan if a different object B depends on A
but only B showed definitive signs of corruption.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-repair-data-deps
---
 libfrog/scrub.c       |    1 
 scrub/phase1.c        |    9 -
 scrub/phase2.c        |   46 ++--
 scrub/phase3.c        |   77 ++++---
 scrub/phase4.c        |   17 +-
 scrub/phase5.c        |    9 -
 scrub/phase7.c        |    9 -
 scrub/repair.c        |  530 +++++++++++++++++++++++++++++++++----------------
 scrub/repair.h        |   47 +++-
 scrub/scrub.c         |  136 ++++++-------
 scrub/scrub.h         |  108 ++++++++--
 scrub/scrub_private.h |   37 +++
 12 files changed, 664 insertions(+), 362 deletions(-)

