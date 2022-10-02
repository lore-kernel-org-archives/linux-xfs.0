Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1101AC433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:23:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbiJBSXb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiJBSX3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:23:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F25286E7
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:23:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF85660EFD
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:23:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568FBC433D7;
        Sun,  2 Oct 2022 18:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735008;
        bh=W0svHjXCbcXP+WTHe2fHXK7yOKJAXmrJwmA+h5l+MEk=;
        h=Subject:From:To:Cc:Date:From;
        b=rKJzeWSsOP/hZnan8mqGM/cEWfmkitdq/I1PobU3FPezYsTQklN5eGZKMoXhDEUE7
         irOP8n9G3xiHDFGHmg+RnBFpcDK2ivAtNn/DuIdUN8IIc2oZoCnUV9xvmqC0i+If/O
         1uE72cB49WqEJ33PRcsTVgtlXUhjwLPUK2MbT5zcm+c9Osj6nyRX6eEx8EoTuywbba
         aZR8nZknmVxMag+dYMWRVXu6JMWW5Zr3xLmEmjuYfQ5JMautSXQP0FMnE+9wiNkJLI
         Lc1RbnowhqmhJEdWX8QRBrTG2G27sAbB4KkfvGBBCN9smTvXTSLI2miNc45mYA0xLk
         hvyK68ELIMjkA==
Subject: [PATCHSET v23.1 0/4] xfs: fix handling of AG[IF] header buffers
 during scrub
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:19:48 -0700
Message-ID: <166473478844.1083155.9238102682926048449.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

While reading through the online fsck code, I noticed that the setup
code for AG metadata scrubs will attach the AGI, the AGF, and the AGFL
buffers to the transaction.  It isn't necessary to hold the AGFL buffer,
since any code that wants to do anything with the AGFL will need to hold
the AGF to know which parts of the AGFL are active.  Therefore, we only
need to hold the AGFL when scrubbing the AGFL itself.

The second bug fixed by this patchset is one that I observed while
testing online repair.  When a buffer is held across a transaction roll,
its buffer log item will be detached if the bli was clean before the
roll.  If we are holding the AG headers to maintain a lock on an AG, we
then need to set the buffer type on the new bli to avoid confusing the
logging code later.

There's also a bug fix for uninitialized memory in the directory scanner
that didn't fit anywhere else.

Ths patchset finishes off by teaching the AGFL repair function to look
for and discard crosslinked blocks instead of putting them back on the
AGFL.  Is this a bug fix?  Or merely an enhancement?

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-fix-ag-header-handling
---
 fs/xfs/scrub/agheader.c        |   47 +++++++++++++++---------
 fs/xfs/scrub/agheader_repair.c |   79 +++++++++++++++++++++++++++++++++-------
 fs/xfs/scrub/common.c          |    8 ----
 fs/xfs/scrub/dir.c             |   10 +++--
 fs/xfs/scrub/repair.c          |   29 +++++++++++----
 fs/xfs/scrub/scrub.h           |    1 -
 6 files changed, 122 insertions(+), 52 deletions(-)

