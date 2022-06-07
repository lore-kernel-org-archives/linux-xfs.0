Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CAAECCA47B
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jun 2022 03:17:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236827AbiFHDRa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jun 2022 23:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356269AbiFHDQw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jun 2022 23:16:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F2420E17D
        for <linux-xfs@vger.kernel.org>; Tue,  7 Jun 2022 14:03:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B6E1617D1
        for <linux-xfs@vger.kernel.org>; Tue,  7 Jun 2022 21:03:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696CCC3411E;
        Tue,  7 Jun 2022 21:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654635783;
        bh=XQfE142NgK3apIGAf7mufwgpUJiTxP6kDjxTDh7EX2E=;
        h=Subject:From:To:Cc:Date:From;
        b=KEDKIC1tekZg3J9lHrYQpzV0bymz2W80G8R/k8tpSF2bJ0JO3jf86FsLTrkiVvnfY
         ZtoibK6xx0BR0XkutjDMMUYMiAChOuNebqMhIL9hu47MUckhEMFtRoa1uj6rsG4UbV
         rflZusUWmuhM5wt8dSsXotGGoM//WUM1XSPIq/5YBWrGHlsyEzIa3ELvelNurT2+DD
         K2+OccNaa/zTDve5n4GZ9gX+bVQkMysEgct7wtn5FWfw1UecgUKi9srkUsJUvnmhw1
         3xF0ZGvhReLkxRIH3plDbRQkgCt6X4gA+ZsC4K6dFrCKvUjp0IfPsArJWzJqOimgeX
         +ACMfAC65TJ6g==
Subject: [PATCHSET v2 0/3] xfs: random fixes for 5.19-rc2
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, allison.henderson@oracle.com,
        chandan.babu@oracle.com
Date:   Tue, 07 Jun 2022 14:03:02 -0700
Message-ID: <165463578282.417102.208108580175553342.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's a quick rollup of all the fixes I've queued for the new LARP and
NREXT64 features.  This time you all get a nice patchset instead of
hand-mailed patches.

v2: Fix a bug with XFS_DA_OP_LOGGED masking, don't get ambitious with
#idef cleanups.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-fixes-5.19
---
 fs/xfs/libxfs/xfs_attr.c      |    9 +++++----
 fs/xfs/libxfs/xfs_attr.h      |   12 +-----------
 fs/xfs/libxfs/xfs_attr_leaf.c |    2 +-
 fs/xfs/libxfs/xfs_da_btree.h  |    4 +++-
 fs/xfs/xfs_attr_item.c        |   15 +++++++++------
 fs/xfs/xfs_ioctl.c            |    3 ++-
 fs/xfs/xfs_xattr.c            |   17 ++++++++++++++++-
 7 files changed, 37 insertions(+), 25 deletions(-)

