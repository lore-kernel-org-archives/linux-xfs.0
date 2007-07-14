Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 14 Jul 2007 09:44:13 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6EGi8bm000327
	for <xfs@oss.sgi.com>; Sat, 14 Jul 2007 09:44:09 -0700
Message-ID: <4698FD5C.60900@sandeen.net>
Date: Sat, 14 Jul 2007 11:44:12 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fix sparse shadowed variable warnings
References: <20070714160825.GD7768@lst.de>
In-Reply-To: <20070714160825.GD7768@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
>  - in xfs_probe_cluster rename the inner len to pg_len.  There's no harm
>    here because the utter len isn't used after the inner len comes into
>    existance but it keeps the code clean.
>  - in xfs_da_do_buf remove the inner i because both useage don't overlap
>    and they are the same type.
> 

Looks fine

-Eric

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2007-07-14 16:02:19.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c	2007-07-14 16:03:09.000000000 +0200
> @@ -652,7 +652,7 @@ xfs_probe_cluster(
>  
>  		for (i = 0; i < pagevec_count(&pvec); i++) {
>  			struct page *page = pvec.pages[i];
> -			size_t pg_offset, len = 0;
> +			size_t pg_offset, pg_len = 0;
>  
>  			if (tindex == tlast) {
>  				pg_offset =
> @@ -665,16 +665,16 @@ xfs_probe_cluster(
>  				pg_offset = PAGE_CACHE_SIZE;
>  
>  			if (page->index == tindex && !TestSetPageLocked(page)) {
> -				len = xfs_probe_page(page, pg_offset, mapped);
> +				pg_len = xfs_probe_page(page, pg_offset, mapped);
>  				unlock_page(page);
>  			}
>  
> -			if (!len) {
> +			if (!pg_len) {
>  				done = 1;
>  				break;
>  			}
>  
> -			total += len;
> +			total += pg_len;
>  			tindex++;
>  		}
>  
> Index: linux-2.6-xfs/fs/xfs/xfs_da_btree.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_da_btree.c	2007-07-14 16:01:43.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_da_btree.c	2007-07-14 16:02:01.000000000 +0200
> @@ -1975,7 +1975,6 @@ xfs_da_do_buf(
>  		error = mappedbno == -2 ? 0 : XFS_ERROR(EFSCORRUPTED);
>  		if (unlikely(error == EFSCORRUPTED)) {
>  			if (xfs_error_level >= XFS_ERRLEVEL_LOW) {
> -				int	i;
>  				cmn_err(CE_ALERT, "xfs_da_do_buf: bno %lld\n",
>  					(long long)bno);
>  				cmn_err(CE_ALERT, "dir: inode %lld\n",
> 
> 
