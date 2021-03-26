Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E372C433E2
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 02:49:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 507BB61A43
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 02:49:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbhCZCsw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 22:48:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:34914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230334AbhCZCsb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 22:48:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE50961A36;
        Fri, 26 Mar 2021 02:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616726910;
        bh=sI6CdpcIX5I8oY0CzNDg2Ocypb/1j5kzSdoueEYl0KY=;
        h=Subject:From:To:Cc:Date:From;
        b=t45OUIOr2cYZyTOMJ+eV4eoGBEf0omWzH8EP7eqPg1fOK2F2tFSehfoYCiJS+Sh1p
         0KzXJUWfd9C2Yb+h9IU6j/qsh4QmH61f5SqOG/reH3hOjj2T52N3vs1rl027IpDgUW
         1zl0HIJtxkQ6C5zQkTi1UCYPYTtMxtMxM1djBPU5rw/1erIc8iWuGiIVLdC16/xEbM
         GsVKTcvAr3FUi/XuALAn2e5KjQoY0J2OUUWVWi12Byt40f+/yzAX+bOZhp+F7h94md
         gYl5UmXWykwawGYwZ2ENEq48dk2v3ZGvytYSNE/YVsqNX0pQgtbeBpIg/xiLAQfS4b
         D0NREFx+KO9ew==
Subject: [PATCHSET 0/2] xfs-documentation: format updates for 5.10
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 25 Mar 2021 19:48:29 -0700
Message-ID: <161672690975.721010.3851165011742824524.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This quick series contains all the updates to the ondisk documentation that
were applied in 5.10.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=xfsdocs-5.10
---
 .../allocation_groups.asciidoc                     |   27 ++++++++
 design/XFS_Filesystem_Structure/docinfo.xml        |   14 ++++
 .../internal_inodes.asciidoc                       |    5 ++
 .../XFS_Filesystem_Structure/ondisk_inode.asciidoc |    4 +
 .../XFS_Filesystem_Structure/timestamps.asciidoc   |   65 ++++++++++++++++++++
 .../xfs_filesystem_structure.asciidoc              |    2 +
 6 files changed, 117 insertions(+)
 create mode 100644 design/XFS_Filesystem_Structure/timestamps.asciidoc

