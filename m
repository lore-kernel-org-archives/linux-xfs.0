Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3790BC77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:01:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjEZCBW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbjEZCBV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:01:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A4EE7
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:01:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 770CD64C49
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:01:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA32EC433D2;
        Fri, 26 May 2023 02:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066479;
        bh=VXwrxz34XBvsTn+SAeG3L4HL+BozGUl0iGAhUSBN9gg=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=EZOHFoLOVxcwwuj5/L2HIv4PSVol9dNoQcjtSe/L+T9LHe5ZTrQ6y1/w4xQlKgXpy
         gsbnkLdLtY+QPgdI1gH36L/l1s9Wdfo29D9W0wJcPOjvJQoJGfIIWhcz3wIAwLTZME
         V4KGO+7J+hXRWCOpv4ft9K+teVhuUx+IWWmUHnWhNl8gPSVt3j3m1ibRT1O1GQgel+
         Q9NpH5Lx2wq159Io6phOEfWVme5nEpfZ7oiZh3Dv6RwCSEBz96k7UtHcEKDo8uBgJU
         PvkluvtT6SnIJLqGdCniOaiq3CDQ5MA0OrIilxbNahkvjFTQp93hDvy0r8B/KlBYdh
         qk/+6HuJXs2Mg==
Date:   Thu, 25 May 2023 19:01:19 -0700
Subject: [PATCHSET v12.0 0/1] xfsprogs: retain ILOCK during directory updates
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506077122.3749047.6539176730750408418.stgit@frogsfrogsfrogs>
In-Reply-To: <20230526000710.GG11642@frogsfrogsfrogs>
References: <20230526000710.GG11642@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series changes the directory update code to retain the ILOCK on all
files involved in a rename until the end of the operation.  The upcoming
parent pointers patchset applies parent pointers in a separate chained
update from the actual directory update, which is why it is now
necessary to keep the ILOCK instead of dropping it after the first
transaction in the chain.

As a side effect, we no longer need to hold the IOLOCK during an rmapbt
scan of inodes to serialize the scan with ongoing directory updates.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=retain-ilock-during-dir-ops

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=retain-ilock-during-dir-ops
---
 libxfs/libxfs_priv.h |    2 ++
 libxfs/xfs_defer.c   |    6 +++++-
 libxfs/xfs_defer.h   |    8 +++++++-
 3 files changed, 14 insertions(+), 2 deletions(-)

