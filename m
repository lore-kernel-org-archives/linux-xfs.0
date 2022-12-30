Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 709CBC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:01:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235827AbiLaBBT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:01:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235809AbiLaBBR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:01:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D5261DDE4
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:01:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE5F761D6A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:01:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA68C433EF;
        Sat, 31 Dec 2022 01:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448475;
        bh=UhILdOgbr2hXCu72FwF61cuoJevzgYUdlFs2jbj15Ng=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=m4nyZQQvoLaanFV5XoJh1moObT8ehZ7F1wWscGrSqowB/nYHhaQBXUFAUhgTcOt1O
         Ke/HIGaJSYjCrO/DBXas3aMXbI26yBkQUgUROKTFFUrceC81TKYcFLWuqxoH7P0SxQ
         e4VXtrXcoCho+ReReUiHnzKXg0ErRERLZ7l3HdH0B4lir00XVOFZgO4yR2gN5Jhj+Y
         6wm+eo0oTvQ51CI645OWUsgvndBcqKkBah8taBeDV99eSPBc7hR0m0TD+P6IGigVEX
         EDOxpVwb16rN2hwhWQDCPfDEjGccJHwrjJ0w3BTW2jXZtZEFJ2VkIzlm+PNW9jKzs4
         NsKiLcDpWhSjQ==
Subject: [PATCHSET v1.0 0/5] xfs_metadump: support external devices
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:39 -0800
Message-ID: <167243877981.730695.7761889719607533776.stgit@magnolia>
In-Reply-To: <Y69UsO7tDT3HcFri@magnolia>
References: <Y69UsO7tDT3HcFri@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series augments the xfs_metadump and xfs_mdrestore utilities to
capture the contents of an external log in a metadump, and restore it on
the other end.  This will enable better debugging analysis of broken
filesystems, since it will now be possible to capture external log data.
This is a prequisite for the rt groups feature, since we'll also need to
capture the rt superblocks written to the rt device.

This also means we can capture the contents of external logs for better
analysis by support staff.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=metadump-external-devices

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=metadump-external-devices
---
 db/block.c                |  103 ++++++++++++++++++++++++
 db/io.c                   |   18 ++++
 db/io.h                   |    2 
 db/metadump.c             |   98 +++++++++++++++++++++++
 db/xfs_metadump.sh        |    5 +
 include/xfs_metadump.h    |    3 +
 man/man8/xfs_db.8         |   17 ++++
 man/man8/xfs_mdrestore.8  |    8 ++
 man/man8/xfs_metadump.8   |   13 ++-
 mdrestore/xfs_mdrestore.c |  190 ++++++++++++++++++++++++++++++++-------------
 10 files changed, 393 insertions(+), 64 deletions(-)

