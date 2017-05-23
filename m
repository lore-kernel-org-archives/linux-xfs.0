Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33072 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752602AbdEWPdy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2017 11:33:54 -0400
Date: Tue, 23 May 2017 08:33:49 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: fix off-by-one on max nr_pages in
 xfs_find_get_desired_pgoff()
Message-ID: <20170523153349.GQ4519@birch.djwong.org>
References: <20170521075939.18071-1-eguan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170521075939.18071-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Sun, May 21, 2017 at 03:59:39PM +0800, Eryu Guan wrote:
> xfs_find_get_desired_pgoff() is used to search for offset of hole or
> data in page range [index, end] (both inclusive), and the max number
> of pages to search should be at least one, if end == index.
> Otherwise the only page is missed and no hole or data is found,
> which is not correct.
> 
> When block size is smaller than page size, this can be demonstrated
> by preallocating a file with size smaller than page size and writing
> data to the last block. E.g. run this xfs_io command on a 1k block
> size XFS on x86_64 host.
> 
>   # xfs_io -fc "falloc 0 3k" -c "pwrite 2k 1k" \
>   	    -c "seek -d 0" /mnt/xfs/testfile
>   wrote 1024/1024 bytes at offset 2048
>   1 KiB, 1 ops; 0.0000 sec (33.675 MiB/sec and 34482.7586 ops/sec)
>   Whence  Result
>   DATA    EOF
> 
> Data at offset 2k was missed, and lseek(2) returned ENXIO.
> 
> This is unconvered by generic/285 subtest 07 and 08 on ppc64 host,

"uncovered", will fix it when I commit and push to testbox.
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> where pagesize is 64k. Because a recent change to generic/285
> reduced the preallocated file size to smaller than 64k.
> 
> Cc: stable@vger.kernel.org # v3.7+
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
>  fs/xfs/xfs_file.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 35703a8..aefa213 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1049,7 +1049,7 @@ xfs_find_get_desired_pgoff(
>  		unsigned	nr_pages;
>  		unsigned int	i;
>  
> -		want = min_t(pgoff_t, end - index, PAGEVEC_SIZE);
> +		want = min_t(pgoff_t, end - index, PAGEVEC_SIZE - 1) + 1;
>  		nr_pages = pagevec_lookup(&pvec, inode->i_mapping, index,
>  					  want);
>  		/*
> -- 
> 2.9.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
