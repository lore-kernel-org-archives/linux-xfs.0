Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58CC4C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Mar 2022 03:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353456AbiCPDbV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Mar 2022 23:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353450AbiCPDbT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Mar 2022 23:31:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7DAA3981F;
        Tue, 15 Mar 2022 20:30:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61F12B81A07;
        Wed, 16 Mar 2022 03:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D1FC340E8;
        Wed, 16 Mar 2022 03:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647401404;
        bh=gJox348fFbqD14fj+Atr3eK/yGu1ypC6i3G/KgzIU/c=;
        h=Subject:From:To:Cc:Date:From;
        b=nSjEqrwH8S5chNecMCLiazoIGls9JdzOjEl8dfS5cUzikzrp5mtrEjc0ngIcU/eMn
         gN1vMiwVrXdTko5T/syexniruhYY24IUatujOzeSR8hthHLseJSReBAr2KkrSh20Ew
         Quf39yVz8/OQcP7/6rS+CKKzPxE3FW1bt32yUdJC9Mv3LaSLTk+ZrpPzMV8XlpH4VH
         VT/rs83Oidy5gdF/X10gx7EUFQFqTEgnBEeMDisn2olQwVSmPvhdcwd4J1BGYaZDfr
         oQGkDsVeuQJ95RVUYxAOo9ZFqgR/k71SDIRRw5upn6xMgiQDjTA+zFo+sGTg5FD18g
         pdb6bSpOmKD4Q==
Subject: [PATCHSET 0/4] fstests: random fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 15 Mar 2022 20:30:03 -0700
Message-ID: <164740140348.3371628.12967562090320741592.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's the usual batch of odd fixes for fstests.

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
 common/xfs            |    6 +++---
 tests/generic/459     |    1 +
 tests/generic/673.out |    4 ++--
 tests/xfs/420         |   33 +++++++++++++++++++++------------
 4 files changed, 27 insertions(+), 17 deletions(-)

