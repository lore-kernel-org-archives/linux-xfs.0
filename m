Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72592C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:00:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjEZCAU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbjEZCAT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:00:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690A918D
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EED2464C1F
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595F9C433EF;
        Fri, 26 May 2023 02:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066417;
        bh=xAZuG00JZz3OK5uiJizH2/zUq20rXO7XaU7v/YK1dco=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Gsd2IFwTY34keoDwof61etWD2Jiwm37kq3Q61vt/wkNtqOhg3MmJegO4gZwL+D/Dm
         zyuMmoeW1EKRrLRr+cmuLA+A9HVduto1Zp0nz++w32gJsWtJVMWh02Q0122yxxzKBZ
         0ZzwnpDKWC6xvxHm9tIy6+Lex5qbVnskpwLX4q2Ts6vpK5Exae6VUKKBM6EbEUzLBC
         XT+V8jj0SbW1l9bF6rb7WL3ityHgp/CubFzy6xx5Ho3ZB4AUxqEo37/3+JsHy2UYUn
         9ePcO8SAQgyeX7TbdhiFOkcH3d6ZmYvPRrePNCwuF53KJLS08IRDThyOFF0LYni6ql
         l3OD0wrdJOA7A==
Date:   Thu, 25 May 2023 19:00:16 -0700
Subject: [PATCHSET v12.0 0/7] xfs: retain ILOCK during directory updates
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506071753.3743141.6199971931108916142.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_defer.c  |    6 ++-
 fs/xfs/libxfs/xfs_defer.h  |    8 +++-
 fs/xfs/scrub/rmap_repair.c |   16 -------
 fs/xfs/scrub/tempfile.c    |    2 +
 fs/xfs/xfs_dquot.c         |   38 +++++++++++++++++
 fs/xfs/xfs_dquot.h         |    1 
 fs/xfs/xfs_inode.c         |   98 ++++++++++++++++++++++++++++++++------------
 fs/xfs/xfs_inode.h         |    2 +
 fs/xfs/xfs_qm.c            |    4 +-
 fs/xfs/xfs_qm.h            |    2 -
 fs/xfs/xfs_symlink.c       |    6 ++-
 fs/xfs/xfs_trans.c         |    9 +++-
 fs/xfs/xfs_trans_dquot.c   |   15 ++++---
 13 files changed, 153 insertions(+), 54 deletions(-)

