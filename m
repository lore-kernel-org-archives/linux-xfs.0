Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45135 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730509AbfHBKUs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Aug 2019 06:20:48 -0400
Received: by mail-wr1-f66.google.com with SMTP id f9so76574055wre.12
        for <linux-xfs@vger.kernel.org>; Fri, 02 Aug 2019 03:20:46 -0700 (PDT)
Date: Fri, 2 Aug 2019 12:20:43 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 0/9 V4] New ->fiemap infrastructure and ->bmap removal
Message-ID: <20190802102042.7oepvmqteh6jcxdq@pegasus.maiolino.io>
References: <20190731141245.7230-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731141245.7230-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: hch@lst.de, adilger@dilger.ca, jaegeuk@kernel.org, darrick.wong@oracle.com, miklos@szeredi.hu, rpeterso@redhat.com, linux-xfs@vger.kernel.org

On Wed, Jul 31, 2019 at 04:12:36PM +0200, Carlos Maiolino wrote:
> Hi.

Please, disconsider this patchset, I wrongly rebased it and there are many
missing changes that should be done to properly rebase it agains 5.3

> 
> This is the 4th version of the complete series with the goal to deprecate and
> eventually remove ->bmap() interface, in lieu of FIEMAP.
> 
> Besides the rebase of the patchset against latest Linus's tree, the only changes
> in this patchset regarding to the previous version, are concentrated in patches
> 4/9 and 8/9.
> 
> In patch 4  (fibmap: Use bmap instead of ->bmap method in ioctl_fibmap), the
> difference compared with previous version, is a change in ioclt_fibmap() return
> value, I spotted while testing this new version with filesystems using data
> inlined in inodes. It now returns 0 in case of error instead an error value,
> otherwise it would be an user interface change.
> 
> 
> In patch 8 (Use FIEMAP for FIBMAP calls), there are minor changes regarding V3.
> It just contains a coding style fix pointed by Andreas in the previous version,
> but now, it also include changes to all filesystems which supports both FIEMAP
> and FIBMAP, and need some sort of special handling (like inlined data, reflinked
> inodes, etc).
> 
> Again, Patch 9 is xfs-specific removal of ->bmap() interface, without any
> changes compared to the previous version.
> 
> 
> 
> I do apologize for taking so long to rework this patchset, I've got busy with
> other stuff.
> 
> Comments are appreciated, specially regarding if the error values returned by
> ioctl_fibmap() make sense.
> 
> 
> Cheers
> 
> Carlos Maiolino (9):
>   fs: Enable bmap() function to properly return errors
>   cachefiles: drop direct usage of ->bmap method.
>   ecryptfs: drop direct calls to ->bmap
>   fibmap: Use bmap instead of ->bmap method in ioctl_fibmap
>   fs: Move start and length fiemap fields into fiemap_extent_info
>   iomap: Remove length and start fields from iomap_fiemap
>   fiemap: Use a callback to fill fiemap extents
>   Use FIEMAP for FIBMAP calls
>   xfs: Get rid of ->bmap
> 
>  drivers/md/md-bitmap.c |  16 ++++--
>  fs/bad_inode.c         |   3 +-
>  fs/btrfs/inode.c       |   5 +-
>  fs/cachefiles/rdwr.c   |  27 ++++-----
>  fs/ecryptfs/mmap.c     |  16 ++----
>  fs/ext2/ext2.h         |   3 +-
>  fs/ext2/inode.c        |   6 +-
>  fs/ext4/ext4.h         |   3 +-
>  fs/ext4/extents.c      |  15 +++--
>  fs/f2fs/data.c         |  15 ++++-
>  fs/f2fs/f2fs.h         |   3 +-
>  fs/gfs2/inode.c        |   9 ++-
>  fs/hpfs/file.c         |   4 +-
>  fs/inode.c             | 105 +++++++++++++++++++++++++++++----
>  fs/ioctl.c             | 128 ++++++++++++++++++++++++++---------------
>  fs/iomap.c             |  40 ++-----------
>  fs/jbd2/journal.c      |  22 ++++---
>  fs/nilfs2/inode.c      |   5 +-
>  fs/nilfs2/nilfs.h      |   3 +-
>  fs/ocfs2/extent_map.c  |  13 ++++-
>  fs/ocfs2/extent_map.h  |   3 +-
>  fs/overlayfs/inode.c   |   5 +-
>  fs/xfs/xfs_aops.c      |  24 --------
>  fs/xfs/xfs_iops.c      |  19 +++---
>  fs/xfs/xfs_trace.h     |   1 -
>  include/linux/fs.h     |  33 +++++++----
>  include/linux/iomap.h  |   2 +-
>  mm/page_io.c           |  11 ++--
>  28 files changed, 320 insertions(+), 219 deletions(-)
> 
> -- 
> 2.20.1
> 

-- 
Carlos
