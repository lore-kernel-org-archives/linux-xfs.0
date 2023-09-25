Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2212CCE7A97
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Sep 2023 21:59:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbjIYV71 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 17:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbjIYV70 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2023 17:59:26 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480AF11C
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2023 14:59:20 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D95CCC433C7;
        Mon, 25 Sep 2023 21:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695679159;
        bh=pm+ngWWCgZXLz3gNtGxpgvjDmPt0uN38Sc+Tb21ojL0=;
        h=Subject:From:To:Cc:Date:From;
        b=Pq3smlNhH5WOMlQtFIfzvPUlGcESXJby1V+CTzPXk2i61fMSQRgGvP6VE/zbk2Yam
         x97GxYqwwbhAkiaw9Lcisu7T2FKb3wBOBnYataaSZWq7sWD3zHHiqZAFz2tGN9JR9F
         wZ9CctE2zfpgFFd/OOr0Gjs6mJiVstkEdfwLCzMPwfiIKKgJGPodm3hgaXoJyFgXys
         ZqM7RVmjBh74UrO/2w1eh57B9rkIkM/XDKQ33xXo3iIlU8zYaM9TFz/eSCusrkQETM
         gXgDKNOm++wdcwmkzCZF83R4f9zTRVkaiebcrZkZMvickw1dJiBAmKcUB51woXoBxn
         CzEXWfOvkE1+Q==
Subject: [PATCHSET 0/3] xfsprogs: adjust defaults for 6.6 LTS kernels
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 25 Sep 2023 14:59:19 -0700
Message-ID: <169567915945.2320343.12838353246024459529.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series enables reverse mapping and 64-bit extent counts by default.
These features are stable enough now, and with online fsck finished,
there's a compelling reason to start enabling it on customer systems.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=lts-6.6-stuff
---
 man/man8/mkfs.xfs.8.in |   11 ++++++-----
 mkfs/Makefile          |    3 ++-
 mkfs/lts_6.6.conf      |   14 ++++++++++++++
 mkfs/xfs_mkfs.c        |    4 ++--
 4 files changed, 24 insertions(+), 8 deletions(-)
 create mode 100644 mkfs/lts_6.6.conf

