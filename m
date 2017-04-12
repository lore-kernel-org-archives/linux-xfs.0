Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:34215 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754116AbdDLQMx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2017 12:12:53 -0400
Received: by mail-wr0-f173.google.com with SMTP id z109so20685354wrb.1
        for <linux-xfs@vger.kernel.org>; Wed, 12 Apr 2017 09:12:53 -0700 (PDT)
Subject: Re: Deadlock between block allocation and block truncation
References: <800468eb-3ded-9166-20a4-047de8018582@gmail.com>
 <20170412161017.GA16590@infradead.org>
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Message-ID: <7459d8b3-81fe-875c-1b14-b30089365d8d@gmail.com>
Date: Wed, 12 Apr 2017 19:12:50 +0300
MIME-Version: 1.0
In-Reply-To: <20170412161017.GA16590@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org



On 12.04.2017 19:10, Christoph Hellwig wrote:
> Hi Nikolay,
> 
> I guess the culprit is that truncate can free up to two extents in
> the same transaction and thus try to lock two different AGs without
> requiring them to be in increasing order.
> 
> Does the one liner below fix the problem for you?
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 7605d8396596..29f2cd5afb04 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -58,7 +58,7 @@ kmem_zone_t *xfs_inode_zone;
>   * Used in xfs_itruncate_extents().  This is the maximum number of extents
>   * freed from a file in a single transaction.
>   */
> -#define	XFS_ITRUNC_MAX_EXTENTS	2
> +#define	XFS_ITRUNC_MAX_EXTENTS	1
>  
>  STATIC int xfs_iflush_int(struct xfs_inode *, struct xfs_buf *);
>  STATIC int xfs_iunlink(struct xfs_trans *, struct xfs_inode *);
> 


I will apply this to 3.12 and 4.4 and run tests since I can reproduce
fairly reliably on those. You don't expect any fallout on older kernel,
yes ?
