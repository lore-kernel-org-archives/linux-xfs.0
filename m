Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 900C9C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:41:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbjEZAlP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbjEZAlL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:41:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A31194
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:41:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C924161B68
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:41:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33179C433D2;
        Fri, 26 May 2023 00:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061670;
        bh=fMVJG0z/akYDkOXH9fi90YrbreneFdu+t1Riex7vx64=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=O4DK+Cx9oELGICp8hq3FFKk61U7vjnaOV+WO548cULpEFFVwHE85rqZIF2OjtFjCQ
         /+qD9s9ecr3CsrA4FNjDeXFzY8WMfmUO076tC7pmHZQvh8NiUzTLh5QiZ60Sf02d69
         vT/N2ZMUQH7AXJCG3NbjU3mXEADADsCbgWR3CnBBXwLqKYb45hJ7qpTm9iyVR38hyP
         0jGaNLx6/m6kqmISboSp0szNowjwN7h7n0RZoiLQ6nAnB8/FiDbnQMpBYqRU4Ew1sb
         PHxmAYg/qqJiqXHdVG9s1xhdqtU7LFuulmTYlqp5QM5bL2kVd9kAEahhxFdsRqzY2G
         k+7JZfezxFPBA==
Date:   Thu, 25 May 2023 17:41:09 -0700
Subject: [PATCHSET v25.0 0/3] xfs_scrub: automatic optimization by default
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506075558.3746649.11825051260686897396.stgit@frogsfrogsfrogs>
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

This final patchset in the online fsck series enables the background
service to optimize filesystems by default.  This is the first step
towards enabling repairs by default.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-optimize-by-default

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=scrub-optimize-by-default
---
 debian/rules         |    2 +-
 man/man8/xfs_scrub.8 |    6 +++++-
 scrub/Makefile       |    2 +-
 scrub/phase1.c       |   13 +++++++++++++
 scrub/phase4.c       |    6 ++++++
 scrub/repair.c       |   37 ++++++++++++++++++++++++++++++++++++-
 scrub/repair.h       |    2 ++
 scrub/scrub.c        |    4 ++--
 scrub/xfs_scrub.c    |   21 +++++++++++++++++++--
 scrub/xfs_scrub.h    |    1 +
 10 files changed, 86 insertions(+), 8 deletions(-)

