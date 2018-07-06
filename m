Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:51000 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753934AbeGFDvN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Jul 2018 23:51:13 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w663mUh4164738
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 03:51:12 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2k0dnjr2ne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 06 Jul 2018 03:51:12 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w663pB8O025007
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 03:51:12 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w663pBfq030154
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 03:51:11 GMT
Date: Thu, 5 Jul 2018 20:51:10 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH RFC 0/8] xfs: introduce inode data inline feature
Message-ID: <20180706035110.GS32415@magnolia>
References: <1530846750-6686-1-git-send-email-shan.hai@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1530846750-6686-1-git-send-email-shan.hai@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Shan Hai <shan.hai@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jul 06, 2018 at 11:12:21AM +0800, Shan Hai wrote:
> 
> This series implements xfs inode data inlining feature.
> 
> Refered below link during development:
> https://marc.info/?l=linux-xfs&m=120493585731509&w=2
> 
> 
> How it works:
> - the data inlining happens at:
>   write_iter: for DIO/DAX write
>   writeback: for buffered write
> - extents to local format conversion is done in writeback but not in write_iter
> - local to extents format conversion is done in the write_iter and writeback
> - log the whole inode (core/data) on extents to local conversion
> - add a new mkfs.xfs option to enable data inline feature
> 
> How to test:
> mkfs.xfs -f -i size=2048,inline=1 -m crc=1,finobt=1,rmapbt=1,reflink=1 /dev/sdX
> mount /dev/sdX mnt_pnt
> 
> Test results:
> mkfs.xfs -f -i size=2048,inline=1 -m crc=1,finobt=1,rmapbt=1,reflink=1 /dev/sdb
> mkfs.xfs -f -i size=2048          -m crc=1,finobt=1,rmapbt=1,reflink=1 /dev/sdd
> mount /dev/sdb /mnt/sdb
> mount /dev/sdd /mnt/sdd
> 
> Copy the linux v4.18-rc3 source code to /mnt/sdb and /mnt/sdd respectively:
> Filesystem                        Size  Used Avail Use% Mounted on
> /dev/sdb                           10G  2.4G  7.7G  24% /mnt/sdb
> /dev/sdd                           10G  3.1G  6.9G  31% /mnt/sdd
> 
> mkfs.xfs -f -i size=2048,inline=1 -m crc=1,finobt=1,rmapbt=1,reflink=1 /dev/sdc
> mkfs.xfs -f -i size=2048          -m crc=1,finobt=1,rmapbt=1,reflink=1 /dev/sde
> mount /dev/sdc /mnt/sdc
> mount /dev/sde /mnt/sde
> 
> Build the v4.18-rc3 kernel on /dev/sdc and /dev/sde respectively:
> make x86_64_defconfig
> 
> Filesystem                        Size  Used Avail Use% Mounted on
> /dev/sdc                           10G  689M  9.4G   7% /mnt/sdc
> /dev/sde                           10G  694M  9.4G   7% /mnt/sde

Not much of a savings... but I'll give this a preliminary review anyway.

Also, I am probably going to merge hch's bufferhead killing series for
4.19, which will rip right through a lot of this. :)

--D

> 
> Kernel part:
> 0001-xfs-introduce-inline-data-superblock-feature-bit.patch
> 0002-xfs-introduce-extents-to-local-conversion-helper.patch
> 0003-xfs-convert-inode-from-extents-to-local-format.patch
> 0004-xfs-implement-inline-data-read-write-code.patch
> 0005-xfs-consider-the-local-format-inode-in-misc-operatio.patch
> 0006-xfs-fix-imbalanced-locking.patch
> 0007-xfs-return-non-zero-blocks-for-inline-data.patch
> 0008-xfs-skip-local-format-inode-for-reflinking.patch
> 
>  fs/xfs/libxfs/xfs_bmap.c      |  78 +++++++++++++++++++++++++++++++-----
>  fs/xfs/libxfs/xfs_bmap.h      |   4 ++
>  fs/xfs/libxfs/xfs_format.h    |  10 ++++-
>  fs/xfs/libxfs/xfs_fs.h        |   1 +
>  fs/xfs/libxfs/xfs_inode_buf.c |   6 ---
>  fs/xfs/libxfs/xfs_sb.c        |   2 +
>  fs/xfs/scrub/inode.c          |   2 +-
>  fs/xfs/xfs_aops.c             |  60 ++++++++++++++++++++++++++++
>  fs/xfs/xfs_bmap_util.c        |  11 +++++-
>  fs/xfs/xfs_file.c             | 244 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_inode.c            |  20 +++++++---
>  fs/xfs/xfs_inode_item.c       |   5 ++-
>  fs/xfs/xfs_ioctl.c            |   5 ++-
>  fs/xfs/xfs_iomap.c            |   5 ++-
>  fs/xfs/xfs_iops.c             |   8 +++-
>  fs/xfs/xfs_log_recover.c      |   3 +-
>  fs/xfs/xfs_reflink.c          |   6 +++
>  17 files changed, 437 insertions(+), 33 deletions(-)
> 
> xfsprogs part:
> 0001-xfsprogs-add-inode-inline-data-support.patch 
> 
>  growfs/xfs_growfs.c | 14 +++++++++-----
>  libxfs/xfs_format.h |  4 +++-
>  libxfs/xfs_fs.h     |  1 +
>  mkfs/xfs_mkfs.c     | 20 +++++++++++++++++---
>  4 files changed, 30 insertions(+), 9 deletions(-)
> 
> 
> Thanks
> Shan Hai
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
