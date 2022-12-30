Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E99B6C3DA7C
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:17:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235575AbiL3XRM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235506AbiL3XRL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:17:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4054186B6;
        Fri, 30 Dec 2022 15:17:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FAE561C3A;
        Fri, 30 Dec 2022 23:17:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7527C433D2;
        Fri, 30 Dec 2022 23:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442230;
        bh=ncwn3e/CtsoATXTt7J55Q5Gua/8aa4bwUVVsdqz03pc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Xr3UICRUtNAh7tJL6TcIIsQ2CLg5hMFcl4TltWrrsL4FJ1hsNW6ualGbntUrgSWTS
         5nPV6UaXmmWG9PqMh0lqT8M/rMTtvLvMeVCBhl0hqn7vEWteo82cHVXLCTDcP7pP18
         R/INVV1VyuyVZUYamlfz/7/O82IajsI19yeb9pwSTjOMJmD8rMuPtfFxz1eb1mZjSB
         HtGIicY/G7Ye1t03AcrCkYfDGEJiSgKwF5HnPghrYvbv8R18zXrBRFFgQSJFHRmId1
         ZhnbT6l/OdIpj5sy+FwTDq6IrA7hOKHNc9/Jf2LUWoi6a5PHACIayKbeA0sPpceEH8
         jk0wHZLyj2gGg==
Subject: [PATCHSET v24.0 0/1] fstests: online repair of quota counters
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:24 -0800
Message-ID: <167243876462.727185.1053988846654244651.stgit@magnolia>
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

This series uses the inode scanner and live update hook functionality
introduced in the last patchset to implement quotacheck on a live
filesystem.  The quotacheck scrubber builds an incore copy of the
dquot resource usage counters and compares it to the live dquots to
report discrepancies.

If the user chooses to repair the quota counters, the repair function
visits each incore dquot to update the counts from the live information.
The live update hooks are key to keeping the incore copy up to date.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-quotacheck

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-quotacheck

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-quotacheck
---
 tests/xfs/715     |   40 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/715.out |    2 ++
 tests/xfs/812     |   40 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/812.out |    2 ++
 4 files changed, 84 insertions(+)
 create mode 100755 tests/xfs/715
 create mode 100644 tests/xfs/715.out
 create mode 100755 tests/xfs/812
 create mode 100644 tests/xfs/812.out

