Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:4160 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751099AbeENETL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 May 2018 00:19:11 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fI4x0-0002us-1f
        for linux-xfs@vger.kernel.org; Mon, 14 May 2018 14:19:06 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fI4wz-0002xK-Ub
        for linux-xfs@vger.kernel.org; Mon, 14 May 2018 14:19:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/10 v3] xfs: refactor and tablise growfs
Date: Mon, 14 May 2018 14:18:54 +1000
Message-Id: <20180514041904.11140-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

THis is the third version of the growfs tablisation patchset,
addressing the changes that Darrick raised. I've reposted the
entire patchset because changes in early patches cascaded throw
several others and it was just easier to repost the lot.

Version 3:
- fix agno variable to use xfs_agnumber_t
- change ag header table to use expanded definitions
- dropped numrecs from tables as they are always either zero or hard
  coded by type specific block initialisers.

Version 2:
- rebase on current for-next
- add oneshot cached buffer support
- clean up more of the typedef usage.
- move id->nfree calc to per-ag hdr init function from the freespace
  btree root initialisation.
- only use id->type and id->numrecs for the generic btree root block
  init calls.
- only call xfs_growfs_data_private() if the size is actually being
  changed.
- make sure we still update secondary superblocks if physical grow
  fails with ENOSPC.
- change secondary superblock updates to use cached one-shot
  buffers.
- moved the core code to libxfs so it can be shared easily with
  userspace.

Version 1:
https://marc.info/?l=linux-xfs&m=151746732826277&w=2


