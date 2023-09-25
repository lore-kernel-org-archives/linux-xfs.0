Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 369F1CE7A97
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Sep 2023 21:58:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbjIYV6v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 17:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjIYV6v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2023 17:58:51 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2856B116
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2023 14:58:45 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D2BC433C7;
        Mon, 25 Sep 2023 21:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695679124;
        bh=3oA1Ae4zf3WEFp6d8GpLZ6NBn7d0IgfFLJs8N/1pjPQ=;
        h=Subject:From:To:Cc:Date:From;
        b=DWnnfjA56Hkt51Zvj6itfLkaGQLfrCYYssSuskHBcxpPCtHYIwNmpBviagdpSnEip
         lrNcEEA/LxsDQiSuE6v/1vpzLjd1LJrY9r5K+tH+J3ZJtSOaXkYVYXYwD2lLkI+ZJm
         7KqxGcpu4LNDqEQRkMdXG2WrADg/4oDymc2Hu6/vfFRLrfTFCiayjGwS+Id6hyGlbP
         rRXGgsJ3yoWnn/h9r2nNq2TI3C59JAwx6eoaRGJr+Cow3hwdWETDLUw/zz8vPn4dTe
         Bn8wFCrYh6TQAiSbhWc+C3OvKGyl/ilRNo2zD/f05++i3RAT73gjVTFzn5uoXQyRLG
         wP4mtok7aJDeA==
Subject: [PATCHSET v26.2 0/3] xfsprogs: force rebuilding of metadata
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 25 Sep 2023 14:58:44 -0700
Message-ID: <169567912436.2320149.9404820627184014976.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patchset adds a new IFLAG to the scrub ioctl so that userspace can
force a rebuild of an otherwise consistent piece of metadata.  This will
eventually enable the use of online repair to relocate metadata during a
filesystem reorganization (e.g. shrink).  For now, it facilitates stress
testing of online repair without needing the debugging knobs to be
enabled.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-force-rebuild

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-force-rebuild

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-force-rebuild
---
 io/scrub.c        |   24 ++++++++++++++-------
 man/man8/xfs_io.8 |    3 +++
 scrub/phase1.c    |   28 ++++++++++++++++++++++++
 scrub/scrub.c     |   61 ++++++++++++++++++++++++++++-------------------------
 scrub/scrub.h     |    1 +
 scrub/xfs_scrub.c |    3 +++
 scrub/xfs_scrub.h |    1 +
 7 files changed, 84 insertions(+), 37 deletions(-)

