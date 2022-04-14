Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26C68C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Apr 2022 18:49:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbiDNSv1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Apr 2022 14:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiDNSv0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Apr 2022 14:51:26 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65968DBD0E
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 11:49:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BA9A4CE289E
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 18:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D09C385A1;
        Thu, 14 Apr 2022 18:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649962138;
        bh=UamvCMwhRtkjtDSx7zUrHiWyxn6vW5btUAVYyFLoVmM=;
        h=Subject:From:To:Cc:Date:From;
        b=AyFJExGkevmtKDucsur7wnjTZV3fOnWAt5T5JdPQ5CeTk4QNfU/3fopdtSX4uzy4U
         +F5BuyNIfPnSsRC+5wY6PgTFvNq4j219VTKH2AZC3aXy9sN0dnrWl83JG0ARhXubjp
         PcqZ6x41BqSHsDRunvaji6eBSRF5pAyP/xRfSvXwjqso//mqI6fO/qbRTxTBm3t17A
         7wryrLWo4HRMgAT0dtd0OsDSvFR2ftepA0RDfphqaB81VGCqJU0DCCB7aM+MaKQTl9
         0U61Kh4GNG/YuYGcusZmKTHKeDjb/xLn2PEQUJ1NtgrBNkulOtr1AEIPEH+7E+dz83
         1ixuUiRN9NPRw==
Subject: [PATCHSET 0/4] mkfs: various bug fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
Date:   Thu, 14 Apr 2022 11:48:57 -0700
Message-ID: <164996213753.226891.14458233911347178679.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series fixes numerous bugs in mkfs with the validation and stripe
aligning behavior of internal log size computations.  After this, we
don't allow overly large logs to bump the root inode chunk into AG 1,
nor do we allow stripe unit roundup to cause the format to fail.
There's also a fix for mkfs ignoring the gid in the user's protofile
when the parent is setgid.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=mkfs-fixes
---
 include/xfs_inode.h |   11 ++++--
 libxfs/util.c       |    3 +-
 mkfs/proto.c        |    3 +-
 mkfs/xfs_mkfs.c     |  102 ++++++++++++++++++++++++++++++++++++++++-----------
 4 files changed, 91 insertions(+), 28 deletions(-)

