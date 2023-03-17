Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4F29C74A5B
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Mar 2023 15:51:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbjCQPvi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Mar 2023 11:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231372AbjCQPvf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2023 11:51:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BFAB6D25
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 08:51:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5997260A48
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 15:51:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D45C433D2;
        Fri, 17 Mar 2023 15:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679068290;
        bh=+vuURwi8E+J4YVvIx0lpe8awE9PTGZLGPMpwAcykm5I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t7CH1Tr+LGrcRttCIYGzThm7ag9oJFilvX2BYDmGZINNPURgViy9OqsoXUSQdbSfY
         +iYhBe3yKYC0dh4bg8Rb0KrhS4695oeje3ZtnwXPOXvzryPcepFVY/YU3QxjtA9LrC
         lhy4jImJOaNEv3u425jWQYxKCK5hATlMnGfdaU5dr7W1e30L7KECHIwIn7cjsWhedD
         RJyq/5ZWy7ynYoAkFpZQUckyQbed3yIUWnLH4aX8IVRQQz7Eruim4Oz04vH9/PznPU
         4RpRXJPxfAErxC083ryDuQksDLyXcCv8bqGArsqZHkQB5yTILLcNF4fojKOgiXZ47d
         0f2googO323tw==
Date:   Fri, 17 Mar 2023 08:51:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5.10 CANDIDATE 00/15] xfs backports for 5.10.y (from
 v5.15.103)
Message-ID: <20230317155130.GP11376@frogsfrogsfrogs>
References: <20230317110817.1226324-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317110817.1226324-1-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 17, 2023 at 01:08:02PM +0200, Amir Goldstein wrote:
> Darrick,
> 
> Following backports catch up with recent 5.15.y backports.
> 
> Patches 1-3 are the backports from the previous 5.15 round
> that Chandan requested for 5.4 [1].
> 
> Patches 4-14 are the SGID fixes that I collaborated with Leah [2].
> Christian has reviewed the backports of his vfs patches to 5.10.
> 
> Patch 15 is a fix for a build warning caused by one of the SGID fixes.
> 
> This series has gone through the usual kdevops testing routine.
> 
> Thanks,
> Amir.

Looks good to me, with the same caveat I gave Leah wherein I'm assuming
Christian's ok with his setgid changes ending up in 5.10 too. :)

Acked-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> [1] https://lore.kernel.org/linux-xfs/874jrtzlgp.fsf@debian-BULLSEYE-live-builder-AMD64/
> [2] https://lore.kernel.org/linux-xfs/20230307185922.125907-1-leah.rumancik@gmail.com/
> 
> Amir Goldstein (4):
>   attr: add in_group_or_capable()
>   fs: move should_remove_suid()
>   attr: add setattr_should_drop_sgid()
>   attr: use consistent sgid stripping checks
> 
> Christian Brauner (1):
>   fs: use consistent setgid checks in is_sxid()
> 
> Darrick J. Wong (3):
>   xfs: purge dquots after inode walk fails during quotacheck
>   xfs: don't leak btree cursor when insrec fails after a split
>   xfs: use setattr_copy to set vfs inode attributes
> 
> Dave Chinner (4):
>   xfs: don't assert fail on perag references on teardown
>   xfs: remove XFS_PREALLOC_SYNC
>   xfs: fallocate() should call file_modified()
>   xfs: set prealloc flag in xfs_alloc_file_space()
> 
> Gaosheng Cui (1):
>   xfs: remove xfs_setattr_time() declaration
> 
> Yang Xu (2):
>   fs: add mode_strip_sgid() helper
>   fs: move S_ISGID stripping into the vfs_*() helpers
> 
>  Documentation/trace/ftrace.rst |  2 +-
>  fs/attr.c                      | 70 ++++++++++++++++++++++++++---
>  fs/inode.c                     | 80 +++++++++++++++++++---------------
>  fs/internal.h                  |  6 +++
>  fs/namei.c                     | 80 ++++++++++++++++++++++++++++------
>  fs/ocfs2/file.c                |  4 +-
>  fs/ocfs2/namei.c               |  1 +
>  fs/open.c                      |  6 +--
>  fs/xfs/libxfs/xfs_btree.c      |  8 ++--
>  fs/xfs/xfs_bmap_util.c         |  9 ++--
>  fs/xfs/xfs_file.c              | 24 +++++-----
>  fs/xfs/xfs_iops.c              | 56 ++----------------------
>  fs/xfs/xfs_iops.h              |  1 -
>  fs/xfs/xfs_mount.c             |  3 +-
>  fs/xfs/xfs_pnfs.c              |  9 ++--
>  fs/xfs/xfs_qm.c                |  9 +++-
>  include/linux/fs.h             |  5 ++-
>  17 files changed, 229 insertions(+), 144 deletions(-)
> 
> -- 
> 2.34.1
> 
