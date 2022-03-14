Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F55CC433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Mar 2022 18:07:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235242AbiCNSIu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Mar 2022 14:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbiCNSIu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Mar 2022 14:08:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770FA3AA7A
        for <linux-xfs@vger.kernel.org>; Mon, 14 Mar 2022 11:07:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F293D61006
        for <linux-xfs@vger.kernel.org>; Mon, 14 Mar 2022 18:07:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54CC5C340E9
        for <linux-xfs@vger.kernel.org>; Mon, 14 Mar 2022 18:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647281258;
        bh=ERBmcN2XFVLJoDZ1NxyMd0wz9FlUp1zYxH6DHgVlcw4=;
        h=Date:From:To:Subject:From;
        b=tt8dZsXZBNkAzK+J3DqXnf0V5Ej+O/ZawGxjGaTkwEeQQfUcTAxvszxPHqh3yMCWP
         PAmN0juNApdzJN302wZEH4JJ5GcSC1yF2SaqPu9dussruFjdE8mgvoMtjLHGvvtVbx
         ETO+6dUEzIq5WJ3104/ba3Nb5iDP1pfn9Rl3Ej+lnzjz+kBl3OnEB7mnOSZyNVODbY
         fVKvJGB7nKa7SCEwIZsr3XaqXZ4SinenyxExTJzoLkrUFAdD1M/pqRflIivpbLO+2z
         WgidDqcjc52K4A2E5xwtfhUYmdamo/MPY65d4mD0hF1EdXrpQd7vF6TudkJ/IwnN+/
         3HUUuSTc6aUsA==
Date:   Mon, 14 Mar 2022 11:07:37 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 744e6c8ada5d
Message-ID: <20220314180737.GL8224@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.  At this point we're past -rc8, which means that I'm
only accepting bug fixes.

NOTE: Dave Chinner will be taking over as maintainer for one release
cycle so that I can focus on finishing the design document for online
fsck.  IOWs, please send your patches to Dave (and linux-xfs) from the
day after 5.18-rc1 drops until the day after 5.19-rc1 drops.

The new head of the for-next branch is commit:

744e6c8ada5d xfs: constify xfs_name_dotdot

8 new commits:

Darrick J. Wong (7):
      [eba0549bc7d1] xfs: don't generate selinux audit messages for capability testing
      [e014f37db1a2] xfs: use setattr_copy to set vfs inode attributes
      [dd3b015dd806] xfs: refactor user/group quota chown in xfs_setattr_nonsize
      [871b9316e7a7] xfs: reserve quota for dir expansion when linking/unlinking files
      [41667260bc84] xfs: reserve quota for target dir expansion when renaming files
      [996b2329b20a] xfs: constify the name argument to various directory functions
      [744e6c8ada5d] xfs: constify xfs_name_dotdot

Gao Xiang (1):
      [1a39ae415c1b] xfs: add missing cmap->br_state = XFS_EXT_NORM update

Code Diffstat:

 fs/xfs/libxfs/xfs_dir2.c      |  36 +++++++------
 fs/xfs/libxfs/xfs_dir2.h      |   8 +--
 fs/xfs/libxfs/xfs_dir2_priv.h |   5 +-
 fs/xfs/xfs_fsmap.c            |   4 +-
 fs/xfs/xfs_inode.c            |  85 ++++++++++++++++++------------
 fs/xfs/xfs_inode.h            |   2 +-
 fs/xfs/xfs_ioctl.c            |   2 +-
 fs/xfs/xfs_iops.c             | 118 +++++++++---------------------------------
 fs/xfs/xfs_pnfs.c             |   3 +-
 fs/xfs/xfs_reflink.c          |   5 +-
 fs/xfs/xfs_trace.h            |   4 +-
 fs/xfs/xfs_trans.c            |  86 ++++++++++++++++++++++++++++++
 fs/xfs/xfs_trans.h            |   3 ++
 kernel/capability.c           |   1 +
 14 files changed, 205 insertions(+), 157 deletions(-)
