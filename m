Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D596C76196
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:15:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240558AbjDFTPQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240537AbjDFTPP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:15:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75792C1
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:15:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 103B460C99
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:15:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76447C433EF;
        Thu,  6 Apr 2023 19:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680808513;
        bh=gDpmR0qdjSITSKGr8yHVnHuUJqkQAD/0nxsDiwxpyjg=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=NGxXkoNmzu7pJ0PMSr7kRHwAlsV2yYv40pZxCVKeXzCtZloHb9o0hIqZw7MLrWvO9
         liLthxOzeI5O/AIolf5ZaHLWlJfkTTvE3+IfjalyQ0NJVpDcKBDrSCu37IJB1x2Bow
         iSHq1umbqpwQYorD7Fz/DcUP/Vu+sxEH7W78LjbMECtqJRmBJxYAbd8ykKRvZFJUK6
         q9rqj5qLwGYELR+dYWLd8U+l8eFvLa4emKBHO9FBiQnAyMVEfIODyyAXvyZ8tjI7/F
         rF4Jr5gx/FJOQbEVWWrVX8dTjv9noNyqFYuhwcQupW4xAPiqXR0N4TaDgSvDPsc90z
         uSX/BoSbQN2PQ==
Date:   Thu, 06 Apr 2023 12:15:13 -0700
Subject: [PATCHSET v11 0/3] xfs: online checking of parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080825953.616003.8753146482699125345.stgit@frogsfrogsfrogs>
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

With this patchset, we implement online repairs for parent pointers.
This is structured similarly to the directory repair code in that we
scan the entire filesystem looking for dirents and use them to
reconstruct the parent pointer information.

Note that the atomic swapext and block reaping code is NOT ported for
this PoC, so we do not commit any repairs.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.
kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-online-parent-repair

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-online-parent-repair
---
 fs/xfs/Makefile              |    1 
 fs/xfs/libxfs/xfs_parent.c   |   37 ++
 fs/xfs/libxfs/xfs_parent.h   |    8 
 fs/xfs/scrub/parent.c        |   10 +
 fs/xfs/scrub/parent_repair.c |  739 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h        |    4 
 fs/xfs/scrub/scrub.c         |    2 
 fs/xfs/scrub/trace.c         |    2 
 fs/xfs/scrub/trace.h         |   74 ++++
 9 files changed, 876 insertions(+), 1 deletion(-)
 create mode 100644 fs/xfs/scrub/parent_repair.c

