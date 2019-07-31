Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56414 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727872AbfGaUd2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 Jul 2019 16:33:28 -0400
Date: Wed, 31 Jul 2019 15:33:24 -0500
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [RFC PATCH 0/7] xfs: add reflink & dedupe support for fsdax.
Message-ID: <20190731203324.7vjwlejmwpghpvqi@fiona>
References: <20190731114935.11030-1-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731114935.11030-1-ruansy.fnst@cn.fujitsu.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Cc: linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org, darrick.wong@oracle.com, linux-kernel@vger.kernel.org, gujx@cn.fujitsu.com, david@fromorbit.com, qi.fuli@fujitsu.com, caoj.fnst@cn.fujitsu.com

On 19:49 31/07, Shiyang Ruan wrote:
> This patchset aims to take care of this issue to make reflink and dedupe
> work correctly in XFS.
> 
> It is based on Goldwyn's patchsets: "v4 Btrfs dax support" and "Btrfs
> iomap".  I picked up some patches related and made a few fix to make it
> basically works fine.
> 
> For dax framework: 
>   1. adapt to the latest change in iomap.
> 
> For XFS:
>   1. report the source address and set IOMAP_COW type for those write
>      operations that need COW.
>   2. update extent list at the end.
>   3. add file contents comparison function based on dax framework.
>   4. use xfs_break_layouts() to support dax.

Shiyang,

I think you used the older patches which does not contain the iomap changes
which would call iomap_begin() with two iomaps. I have it in the btrfs-iomap
branch and plan to update it today. It is built on v5.3-rcX, so it should
contain the changes which moves the iomap code to the different directory.
I will build the dax patches on top of that.
However, we are making a big dependency chain here :(

-- 
Goldwyn

> 
> 
> Goldwyn Rodrigues (3):
>   dax: replace mmap entry in case of CoW
>   fs: dedup file range to use a compare function
>   dax: memcpy before zeroing range
> 
> Shiyang Ruan (4):
>   dax: Introduce dax_copy_edges() for COW.
>   dax: copy data before write.
>   xfs: Add COW handle for fsdax.
>   xfs: Add dedupe support for fsdax.
> 
>  fs/btrfs/ioctl.c      |  11 ++-
>  fs/dax.c              | 203 ++++++++++++++++++++++++++++++++++++++----
>  fs/iomap.c            |   9 +-
>  fs/ocfs2/file.c       |   2 +-
>  fs/read_write.c       |  11 +--
>  fs/xfs/xfs_iomap.c    |  42 +++++----
>  fs/xfs/xfs_reflink.c  |  84 +++++++++--------
>  include/linux/dax.h   |  15 ++--
>  include/linux/fs.h    |   8 +-
>  include/linux/iomap.h |   6 ++
>  10 files changed, 294 insertions(+), 97 deletions(-)
> 
> -- 
> 2.17.0
> 
> 
> 

-- 
Goldwyn
