Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAFC8C433ED
	for <linux-xfs@archiver.kernel.org>; Sat, 10 Apr 2021 00:16:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89C6B61105
	for <linux-xfs@archiver.kernel.org>; Sat, 10 Apr 2021 00:16:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235287AbhDJARD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Apr 2021 20:17:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235293AbhDJARC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Apr 2021 20:17:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F413261105
        for <linux-xfs@vger.kernel.org>; Sat, 10 Apr 2021 00:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618013809;
        bh=DiXKTw5orqxYU6VVg17ReEy4TE1ZUaaKXFmcD+rbnW8=;
        h=Date:From:To:Subject:From;
        b=hWm/1CyQlWhH45xVjvETyOxXFYRisC24Hk4G6lB8QQIE4xmI9l0jOdDrLiwGhjEAk
         Qu5CM231niXbbBgRTNQA4n+FYpPTZZS+PH5XSe4FR8go6nB67NWXZth/z1VeW67sKV
         gGncn019CSA6Jjh8ogPL1PKeK/oSDRQjEjzFayZ3NTwRhVErOC/C4uHzuDP0BUtlry
         Sr0Q17DhXWaeu8ICP7LSD8QEpPalimUXIuXZU8uMqV1rSouwpKscZgSwymlXQYPhJe
         wnDbTxiHjhvYT0dTMllZq1LK7ohk59RbPmT656lzXdFUywm87UrKFA/gtmq7JceYvX
         T5Rq4HputPdVQ==
Date:   Fri, 9 Apr 2021 17:16:48 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-documentation: master updated to 11ab62f
Message-ID: <20210410001648.GJ3957620@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The master branch of the xfs-documentation repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-documentation.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the master branch is commit:

11ab62f design: document changes for the bigtime feature

New Commits:

Darrick J. Wong (2):
      [be855b3] design: document the new inode btree counter feature
      [11ab62f] design: document changes for the bigtime feature

Lukas Herbolt (1):
      [e01cf48] xfsdocs: Small fix to correct first free inode to be 5847 not 5856.


Code Diffstat:

 .../allocation_groups.asciidoc                     | 33 ++++++++++-
 design/XFS_Filesystem_Structure/docinfo.xml        | 14 +++++
 .../internal_inodes.asciidoc                       |  5 ++
 .../XFS_Filesystem_Structure/ondisk_inode.asciidoc |  4 ++
 .../XFS_Filesystem_Structure/timestamps.asciidoc   | 65 ++++++++++++++++++++++
 .../xfs_filesystem_structure.asciidoc              |  2 +
 6 files changed, 122 insertions(+), 1 deletion(-)
 create mode 100644 design/XFS_Filesystem_Structure/timestamps.asciidoc
