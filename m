Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ED0CC433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Mar 2022 19:22:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237745AbiCITXY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Mar 2022 14:23:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238255AbiCITXK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Mar 2022 14:23:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC16F70F9
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 11:22:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C267B8233F
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 19:22:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC752C340E8;
        Wed,  9 Mar 2022 19:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646853726;
        bh=5Tber86tI8rWylR9Y9+1EZnfgGO0xKSbQUzjnYa45UM=;
        h=Subject:From:To:Cc:Date:From;
        b=ut9RQb921eOHnOTd8OOZ2RqBVMS2ZR7wWVHvA1CyS75E/m3jHbgAGuBJBz0GsrX6R
         VEavn/LY69V95sqApVbe3oWBAAGATO+5oxt5GpTNcuZM6zj/sBgYcF1HL+ZMNsrRgd
         2TcshpbT7dSQ34XqPssCGOYlPTUy7CfjgQ+lXvzoz3GKni/5lRIR84QTq+bgoWehy4
         x4EnDPBOzXe2wGwPEGXKQyjDCLTuiSFJbBjDCRECeAOgtYcH6ICe2e372iY42FL7dD
         GOhyh8q62a6xKvdE4dCKx6lP4cAdipOP0e75KyADNEmXDxQXAZhGUHd3hTC1jiVNRe
         v/Yrvulr8JAGw==
Subject: [PATCHSET 0/2] xfs: use setattr_copy to set VFS file attributes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fdmanana@kernel.org,
        andrey.zhadchenko@virtuozzo.com, brauner@kernel.org,
        david@fromorbit.com, hch@lst.de
Date:   Wed, 09 Mar 2022 11:22:06 -0800
Message-ID: <164685372611.495833.8601145506549093582.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

A few weeks ago, Filipe Manana reported[1] that the new generic/673 test
fails on btrfs because btrfs is more aggressive about dropping the
setgid bit when reflinking into a file.  After some more digging, we
discovered that btrfs calls the VFS helpers to handle updating VFS
inode attributes, whereas XFS has open-coded logic dating from ~1997
that have not been kept up to date.

A few days later, Andrey Zhadchenko reported[2] that XFS can mistakenly
clear S_ISUID and S_ISGID on idmapped mounts.  After further discussion,
it was pointed out that the VFS already handles all these fiddly file
mode changes, and that it was the XFS implementation that is out of
date.

Both of these reports resolve to the same cause, which is that XFS needs
to call setattr_copy to update i_mode instead of doing it directly.
This series replaces all of our bespoke code with VFS calls to fix the
problem and reduce the size of the codebase by ~70 lines.

[1] https://lore.kernel.org/linux-xfs/CAL3q7H47iNQ=Wmk83WcGB-KBJVOEtR9+qGczzCeXJ9Y2KCV25Q@mail.gmail.com/
[2] https://lore.kernel.org/linux-xfs/20220221182218.748084-1-andrey.zhadchenko@virtuozzo.com/

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=setattr-copy-5.18
---
 fs/xfs/xfs_iops.c |  116 +++++++++++------------------------------------------
 fs/xfs/xfs_pnfs.c |    3 +
 2 files changed, 25 insertions(+), 94 deletions(-)

