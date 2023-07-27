Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5905EB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:20:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbjG0WUY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjG0WUY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:20:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D261187
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:20:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0282261F6A
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C121C433C9;
        Thu, 27 Jul 2023 22:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690496422;
        bh=F2C3Et+3+Ue1Ld2951yDqds+YZFSdQwlKR9mJhjaaUI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=U6s17RVWvomx7Wz0FOqpyjgWM119L2PCzh0cTD2EDRlu4KW73GDbP8Sv+8jlIZAdw
         zAdQ+6b0nmx7JlwXlcPQH8ttpxEzD5WVrGHEp7C8eYh8jk1urmE2G5F8zHEOlaIO/F
         atsXC+xhhnDuvmJULv2w8vouz1iyLT9UCV2fng65TjG9AC96FHzJwH4X3srD3eYatP
         EfKE/1N6DIVagMQ4Z2O+GXiVqxYQSksmtjOELekQBqOFSYYM6rNrsKRfdLH7jruDrR
         TzPPuoRWr6xsat1RDcQJWeaMcnj1dD/huR17DnhrfrJgrcztAXVgZ93n/wpDBYh8Ox
         cHDzwmWCmE/AQ==
Date:   Thu, 27 Jul 2023 15:20:21 -0700
Subject: [PATCHSET v26.0 0/2] xfs: fixes to the AGFL repair code
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <169049625352.922161.1455328433828521501.stgit@frogsfrogsfrogs>
In-Reply-To: <20230727221158.GE11352@frogsfrogsfrogs>
References: <20230727221158.GE11352@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series contains a couple of bug fixes to the AGFL repair code that
came up during QA.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-agfl-fixes
---
 fs/xfs/scrub/agheader_repair.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

