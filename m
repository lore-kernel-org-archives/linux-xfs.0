Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEF00C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:04:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379571AbiEEQIK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233041AbiEEQIJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:08:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126055712C
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:04:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2D3361D76
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:04:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A8D1C385A4;
        Thu,  5 May 2022 16:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766669;
        bh=AyGLmM0D+3vPOBQsgIj7DksjruJrPQWLFsTvkTL1uJc=;
        h=Subject:From:To:Cc:Date:From;
        b=kcQ8S/sEA5NAmG/gIt0Iup819PNUOc+H5IpQQOePpDqMQ88ArEJe83LeFmGdp5hm3
         oRhhTJ/mHRlSrLsgSWKMK/l44piAkuCcpkPMIIHigPG7XRK4zag9R5aUBpBWUaWIit
         JizgrO472pf26zdkci0+aE3MbpNhkkumZygGJX7o0qLB/Y1MQL0LfHqlPYEKZboEQu
         irF2pjekrW7HfIQwlyfLdIsXsXQBpNZK8VyiyqkMxFBKAFmCbmTZAWU94z1UinE2MT
         5VmiSLO7rPtemULMFeBPMUgVvsSmQfWWpecevU0UZzuM6XG8mpn2L1rOEy1LYTtSCW
         DmiRo4qOXY3QA==
Subject: [PATCHSET 0/2] xfs_db: tweaks to btheight command
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 09:04:28 -0700
Message-ID: <165176666861.247073.17043246723787772129.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series adds a couple new features to the btheight command so that
we can print the max height for each cursor type for the given
filesystem, or the maximum possible height for any filesystem.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=db-btheight-tweaks
---
 db/btheight.c            |   99 ++++++++++++++++++++++++++++++++++++++++------
 libxfs/libxfs_api_defs.h |    5 ++
 man/man8/xfs_db.8        |    8 +++-
 3 files changed, 98 insertions(+), 14 deletions(-)

