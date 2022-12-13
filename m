Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1B3DC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Dec 2022 19:45:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236527AbiLMTpH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 14:45:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235584AbiLMTpF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 14:45:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A41DFF6;
        Tue, 13 Dec 2022 11:45:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2FD1B810AA;
        Tue, 13 Dec 2022 19:45:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3F3C433D2;
        Tue, 13 Dec 2022 19:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670960701;
        bh=fLO/aEyAZP5BV+eNKcDJjXGXUpSK6d7TkDk5Xia2OPA=;
        h=Subject:From:To:Cc:Date:From;
        b=Eoo0qwIx5DKpPqo/G04f1y+Gvop65J5syLTVHC0ea1TZleyInXlvWJJBORjwZ3UdJ
         VPX+GxdCz/2FDb+0SntQKLIIcRyzUulnfiJMjvLE5jM42P0LCH2PGLnQ1vtxky60kj
         3OvsFxE+g7kaJVlUC7+LXlNdV0KyAwTJer8UvDyJvA1XlmG1/YaPVBj5DYGdukQpc8
         rTrscCX4OuUWtKD8n7G+9Indf3Zo6EB9Goobmg+TwB/qytBVzZNe0vXP72YPLKiwXc
         eMBP0fFAgZElbiyOLLWnGQaZyP8TYNvTxtI9If0XsS8lCoi6UbjLwrLfzby7AYcu9g
         sikXBcfgmqzZQ==
Subject: [PATCHSET 0/1] fstests: random fixes for v2022.11.27
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 13 Dec 2022 11:45:00 -0800
Message-ID: <167096070077.1750295.8747848396576357881.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's the usual odd fixes for fstests.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
 tests/xfs/018     |   17 +++++++++++++++--
 tests/xfs/018.out |   42 +++++++++++++++++++++++++++++++-----------
 2 files changed, 46 insertions(+), 13 deletions(-)

