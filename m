Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA7E1C64EC4
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Mar 2023 16:51:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbjCCQv0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Mar 2023 11:51:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbjCCQv0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Mar 2023 11:51:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C5C555B4
        for <linux-xfs@vger.kernel.org>; Fri,  3 Mar 2023 08:51:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 041AB6187A
        for <linux-xfs@vger.kernel.org>; Fri,  3 Mar 2023 16:51:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60112C433D2;
        Fri,  3 Mar 2023 16:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677862262;
        bh=p9iiBL3b3or8ncGz7o2RRP4HzSqL4lLyEWc2j29tWH0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OamBWYlW/x9nNfe3/ktcSbypzzAgzbx05FHIjHFHV4tz8fDALQ7bDZOPBD0h9fXra
         L+7tzeVfhEilsHwcOQPCuaxtEz7M8EPhL7XaPHe9Lli1xuf1+9rPco0hkGa4JEDHn3
         ymsMpUR3lnRcA1Bn5KUhLvpYseaQjreGA4rIKp/9MncArWpJ5vAI4VNu0Qr2f9ANcO
         6gZlx3wxsOgIdZSQZlMAaXNavfNlu4Be9zUGENgwll3F74IzjGY+npwM4mUlwJdKct
         61BQim/RFjIkZ2QfF9xJEci65cA6GgNoLgiZFJecbzFSSx5JfzAqYZ9NniFocab58Z
         0fPAvTpWKXcAw==
Date:   Fri, 3 Mar 2023 08:51:01 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com
Subject: Re: [PATCH 5.15 CANDIDATE 00/11] 5.15.y sgid fixes
Message-ID: <ZAIldWNxBWIazAuP@magnolia>
References: <20230302203504.2998773-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230302203504.2998773-1-leah.rumancik@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 02, 2023 at 12:34:53PM -0800, Leah Rumancik wrote:
> Hello,
> 
> I finished testing the sgid fixes which Amir graciously backported to
> 5.15. This series fixes the previously failing generic/673 and
> generic/68[3-7]. No regressions were seen in the 25 runs of the auto
> group x 8 configs. I also did some extra runs on the perms group and
> no regressions there either. The corresponding fixes are already in
> 6.1.y.

If Christian is ok with backporting all the setgid changes to 5.15,

Acked-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> - Leah
> 
> Christian Brauner (5):
>   attr: add in_group_or_capable()
>   fs: move should_remove_suid()
>   attr: add setattr_should_drop_sgid()
>   attr: use consistent sgid stripping checks
>   fs: use consistent setgid checks in is_sxid()
> 
> Darrick J. Wong (1):
>   xfs: use setattr_copy to set vfs inode attributes
> 
> Dave Chinner (3):
>   xfs: remove XFS_PREALLOC_SYNC
>   xfs: fallocate() should call file_modified()
>   xfs: set prealloc flag in xfs_alloc_file_space()
> 
> Yang Xu (2):
>   fs: add mode_strip_sgid() helper
>   fs: move S_ISGID stripping into the vfs_*() helpers
> 
>  Documentation/trace/ftrace.rst |  2 +-
>  fs/attr.c                      | 72 +++++++++++++++++++++++++--
>  fs/fuse/file.c                 |  2 +-
>  fs/inode.c                     | 90 ++++++++++++++++++++--------------
>  fs/internal.h                  | 10 +++-
>  fs/namei.c                     | 82 ++++++++++++++++++++++++++-----
>  fs/ocfs2/file.c                |  4 +-
>  fs/ocfs2/namei.c               |  1 +
>  fs/open.c                      |  8 +--
>  fs/xfs/xfs_bmap_util.c         |  9 ++--
>  fs/xfs/xfs_file.c              | 24 +++++----
>  fs/xfs/xfs_iops.c              | 56 ++-------------------
>  fs/xfs/xfs_pnfs.c              |  9 ++--
>  include/linux/fs.h             |  6 ++-
>  14 files changed, 235 insertions(+), 140 deletions(-)
> 
> -- 
> 2.40.0.rc0.216.gc4246ad0f0-goog
> 
