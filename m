Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95A64C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Oct 2022 15:49:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiJDPtE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Oct 2022 11:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiJDPtD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Oct 2022 11:49:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6675F7CC
        for <linux-xfs@vger.kernel.org>; Tue,  4 Oct 2022 08:49:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0860D614C9
        for <linux-xfs@vger.kernel.org>; Tue,  4 Oct 2022 15:49:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EAA6C433D6;
        Tue,  4 Oct 2022 15:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664898541;
        bh=gCP+au+DbR0ydwvSffx+UM9PBaXn9TZGC5t/RSN86JI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bNUChAQhD6Udr5ie776GyjOb9uy3b22unScTQYNmQ9xyrD63kDspArgAdCoxXa3Ai
         +RrXRiiTfAArZVLEXSgZ3eifY9wzeo1C0AFLDbWn8+KDaQzqjbZ1OhMVCXtmPngYLZ
         CPnX/ooCt2JsdJRyc4aOQ8W0xznzHI3BVYvzETMLQ6SlALsjM1mXqAvn/+n5gAlA5z
         icTYPv/V7jrMMVwf5MkwbZkUCKWBTLlYbI327ONj6ngfKBYm4hqKVQfU2Tm+DlkWHf
         D0whWAoJIK9eloa1ZsbycUXPl/jKgAvImd7VuQ4+8OsdYB2OTWvkkJBzQCmZQTSazR
         CenfZFtbvzy7w==
Date:   Tue, 4 Oct 2022 08:49:00 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 5.4 CANDIDATE 00/11] xfs stable candidate patches for
 5.4.y (from v5.6)
Message-ID: <YzxV7CK4Q30ZRJdv@magnolia>
References: <20221004102823.1486946-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221004102823.1486946-1-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 04, 2022 at 03:58:12PM +0530, Chandan Babu R wrote:
> Hi Darrick,
> 
> This 5.4.y backport series contains fixes from v5.6 release.
> 
> This patchset has been tested by executing fstests (via kdevops) using
> the following XFS configurations,
> 
> 1. No CRC (with 512 and 4k block size).
> 2. Reflink/Rmapbt (1k and 4k block size).
> 3. Reflink without Rmapbt.
> 4. External log device.
> 
> The following lists patches which required other dependency patches to
> be included,
> 1. 4bbb04abb4ee2e1f7d65e52557ba1c4038ea43ed
>    xfs: truncate should remove all blocks, not just to the end of the page cache
>    - a5084865524dee1fe8ea1fee17c60b4369ad4f5e
>      xfs: introduce XFS_MAX_FILEOFF
> 2. e8db2aafcedb7d88320ab83f1000f1606b26d4d7
>    xfs: fix memory corruption during remote attr value buffer invalidation
>    - 8edbb26b06023de31ad7d4c9b984d99f66577929
>      xfs: refactor remote attr value buffer invalidation
> 3. 54027a49938bbee1af62fad191139b14d4ee5cd2
>    xfs: fix uninitialized variable in xfs_attr3_leaf_inactive
>    - a39f089a25e75c3d17b955d8eb8bc781f23364f3
>      xfs: move incore structures out of xfs_da_format.h
>    - 0bb9d159bd018b271e783d3b2d3bc82fa0727321
>      xfs: streamline xfs_attr3_leaf_inactive

This batch looks good to go,
Acked-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> Christoph Hellwig (3):
>   xfs: fix misuse of the XFS_ATTR_INCOMPLETE flag
>   xfs: fix IOCB_NOWAIT handling in xfs_file_dio_aio_read
>   xfs: move incore structures out of xfs_da_format.h
> 
> Darrick J. Wong (7):
>   xfs: introduce XFS_MAX_FILEOFF
>   xfs: truncate should remove all blocks, not just to the end of the
>     page cache
>   xfs: fix s_maxbytes computation on 32-bit kernels
>   xfs: refactor remote attr value buffer invalidation
>   xfs: fix memory corruption during remote attr value buffer
>     invalidation
>   xfs: streamline xfs_attr3_leaf_inactive
>   xfs: fix uninitialized variable in xfs_attr3_leaf_inactive
> 
> YueHaibing (1):
>   xfs: remove unused variable 'done'
> 
>  fs/xfs/libxfs/xfs_attr.c        |   2 +-
>  fs/xfs/libxfs/xfs_attr_leaf.c   |   4 +-
>  fs/xfs/libxfs/xfs_attr_leaf.h   |  26 ++++--
>  fs/xfs/libxfs/xfs_attr_remote.c |  85 +++++++++++++------
>  fs/xfs/libxfs/xfs_attr_remote.h |   2 +
>  fs/xfs/libxfs/xfs_da_btree.h    |  17 +++-
>  fs/xfs/libxfs/xfs_da_format.c   |   1 +
>  fs/xfs/libxfs/xfs_da_format.h   |  59 -------------
>  fs/xfs/libxfs/xfs_dir2.h        |   2 +
>  fs/xfs/libxfs/xfs_dir2_priv.h   |  19 +++++
>  fs/xfs/libxfs/xfs_format.h      |   7 ++
>  fs/xfs/xfs_attr_inactive.c      | 146 +++++++++-----------------------
>  fs/xfs/xfs_file.c               |   7 +-
>  fs/xfs/xfs_inode.c              |  25 +++---
>  fs/xfs/xfs_reflink.c            |   3 +-
>  fs/xfs/xfs_super.c              |  48 +++++------
>  16 files changed, 212 insertions(+), 241 deletions(-)
> 
> -- 
> 2.35.1
> 
