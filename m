Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4282C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:13:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235702AbiL3XNf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:13:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235698AbiL3XNe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:13:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C31DE81
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:13:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46446B81D67
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:13:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C4EC433D2;
        Fri, 30 Dec 2022 23:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442011;
        bh=WSfTfXo/uGP2gMsbeczKTJpCyiPbugK1fSN6KVPlSbc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MQtFVVgpkQzGCVwmfVh4CQRP7vh98H/hUxhqcHG+2I/VMrMmIfyIg1KcVRai2kFgp
         YPCfWrz8LFcqU0g1wxbQAfo9BjIoxOF5bzDbU6mIJYmXrZOc02ZNbJ7zlaq66MApWU
         6hLMHZAdrpXdwRIPhLMtboIWwr6AamCLC9Y2lhTtmIfqgm1vYo8c1VOdlF2thvPqJ4
         ApldTkugGVQzHWrh5uuxQ9O9coJ2XDWh/cAoYfIgoQ1gchEg73i7ftcyOJj2Scmh3q
         8A6P3EKU3dmKe3FDwh522oD1hKHkKO3dngXh0U56dPFOfe7t5s7bKItl3AbelviFdF
         H0uZPT2bO1gzg==
Subject: [PATCHSET v24.0 0/9] xfs_scrub: track data dependencies for repairs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:17 -0800
Message-ID: <167243869711.715746.14725730988345960302.stgit@magnolia>
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
 scrub/repair.c        |  529 +++++++++++++++++++++++++++++++++----------------
 scrub/repair.h        |   47 +++-
 scrub/scrub.c         |  136 ++++++-------
 scrub/scrub.h         |  108 ++++++++--
 scrub/scrub_private.h |   37 +++
 12 files changed, 663 insertions(+), 362 deletions(-)

