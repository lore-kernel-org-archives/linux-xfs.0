Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21817 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750888AbdBREus (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Feb 2017 23:50:48 -0500
Date: Fri, 17 Feb 2017 20:50:35 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [xfs-linux:xfs-4.11-merge 38/39] fs/xfs/xfs_bmap_util.c:161:35:
 error: macro "xfs_rtallocate_extent" requires 9 arguments, but only 8 given
Message-ID: <20170218045035.GM6813@birch.djwong.org>
References: <201702181018.SEkBmT5z%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201702181018.SEkBmT5z%fengguang.wu@intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild-all@01.org, linux-xfs@vger.kernel.org

On Sat, Feb 18, 2017 at 10:47:19AM +0800, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git xfs-4.11-merge
> head:   c7016e9a73f1f8a8a21a8fdfc84f556fb8f14583
> commit: ec48023e05afbd7e04269306b814bcaf86e1e047 [38/39] xfs: simplify xfs_rtallocate_extent
> config: i386-randconfig-x006-201707 (attached as .config)
> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
> reproduce:
>         git checkout ec48023e05afbd7e04269306b814bcaf86e1e047
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> All errors (new ones prefixed by >>):
> 
>    fs/xfs/xfs_bmap_util.c: In function 'xfs_bmap_rtalloc':
> >> fs/xfs/xfs_bmap_util.c:161:35: error: macro "xfs_rtallocate_extent" requires 9 arguments, but only 8 given
>         &ralen, ap->wasdel, prod, &rtb);

Bleh, I fixed the patch and pushed out a new branch.

--D

>                                       ^
> >> fs/xfs/xfs_bmap_util.c:160:10: error: 'xfs_rtallocate_extent' undeclared (first use in this function)
>      error = xfs_rtallocate_extent(ap->tp, ap->blkno, 1, ap->length,
>              ^~~~~~~~~~~~~~~~~~~~~
>    fs/xfs/xfs_bmap_util.c:160:10: note: each undeclared identifier is reported only once for each function it appears in
> 
> vim +/xfs_rtallocate_extent +161 fs/xfs/xfs_bmap_util.c
> 
>    154		/*
>    155		 * Realtime allocation, done through xfs_rtallocate_extent.
>    156		 */
>    157		do_div(ap->blkno, mp->m_sb.sb_rextsize);
>    158		rtb = ap->blkno;
>    159		ap->length = ralen;
>  > 160		error = xfs_rtallocate_extent(ap->tp, ap->blkno, 1, ap->length,
>  > 161					&ralen, ap->wasdel, prod, &rtb);
>    162		if (error)
>    163			return error;
>    164	
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation


