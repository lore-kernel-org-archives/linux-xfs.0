Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 487B5C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:38:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjEZAiM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234348AbjEZAiL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:38:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF5E1BD
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:38:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AAFF64AFD
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:38:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEAA8C433EF;
        Fri, 26 May 2023 00:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061482;
        bh=tdDpedzyG4mNocSKaxPVbScz2A8tHYu63cIDPMH6MwE=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=dRg/mXkTZcTuYashGF20Ts5Isz2Dy+0pSsTg3n44hP2f06pnOsIOhRUPNu9E3EnTw
         rqyUO4Ncep8M3ramTcFZWhAtl4SA19yyySwJguUNicvoVxQ1zb2Yel43Uhy7rQjVI4
         yGbDE+xnhxihVCFwWP+wgpSR+nsSVUBvBnU/fMW40Z6RuCl/bAoUFtm6Qv1TOZA5qE
         Ti6z1ZT2EsSXqFYYfQWSt7UFkd8syI8DII45Cjao5+3ubuhVTaYvGvvXSUyi3Xahyp
         PL6kGq7DdNGGkeX+RPt5PqsaPYlWdtb/ql3EUPrPzZ9rWdGiYtYAGy5V9ZgfqWWTM8
         GOlKlMaGEP1lw==
Date:   Thu, 25 May 2023 17:38:02 -0700
Subject: [PATCHSET v25.0 0/7] xfs_scrub: fixes to the repair code
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506071314.3742205.8114181660121831202.stgit@frogsfrogsfrogs>
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

Now that we've landed the new kernel code, it's time to reorganize the
xfs_scrub code that handles repairs.  Clean up various naming warts and
misleading error messages.  Move the repair code to scrub/repair.c as
the first step.  Then, fix various issues in the repair code before we
start reorganizing things.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-repair-fixes
---
 scrub/phase1.c        |    2 
 scrub/phase2.c        |    3 -
 scrub/phase3.c        |    2 
 scrub/phase4.c        |   22 ++++-
 scrub/phase5.c        |    2 
 scrub/phase6.c        |   13 +++
 scrub/phase7.c        |    2 
 scrub/repair.c        |  177 ++++++++++++++++++++++++++++++++++++++++++-
 scrub/repair.h        |   16 +++-
 scrub/scrub.c         |  204 +------------------------------------------------
 scrub/scrub.h         |   16 ----
 scrub/scrub_private.h |   55 +++++++++++++
 scrub/xfs_scrub.c     |    2 
 13 files changed, 283 insertions(+), 233 deletions(-)
 create mode 100644 scrub/scrub_private.h

