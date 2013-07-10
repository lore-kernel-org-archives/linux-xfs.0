Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 820387F37
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 01:28:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F292CAC005
	for <xfs@oss.sgi.com>; Tue,  9 Jul 2013 23:28:15 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id JLcdO7cbreoy2D7a (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 09 Jul 2013 23:28:11 -0700 (PDT)
Message-ID: <51DCFF04.9070606@oracle.com>
Date: Wed, 10 Jul 2013 14:28:20 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix s_max_bytes to MAX_LFS_FILESIZE if needed
References: <5167E160.3020800@oracle.com>
In-Reply-To: <5167E160.3020800@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Cc: "Michael L. Semon" <mlsemon35@gmail.com>

Could anyone help to review this patch?

Thanks,
-Jeff
On 04/12/2013 06:26 PM, Jeff Liu wrote:

> From: Jie Liu <jeff.liu@oracle.com>
> 
> On 32-bit machine, the s_maxbytes is larger than the MAX_LFS_FILESIZE limits if CONFIG_LBDAF is
> not enabled.  Hence it's possible to create a huge file via buffered-IO write with a given offset
> beyond this limitation. e.g.
> 
> # block_size=4096
> # offset=$(((2**32 - 1) * $block_size))
> # xfs_io -f -c "pwrite $offset $block_size" /storage/test_file
> 
> In this case, xfs_io will hang at the page writeback stage soon since the given offset would
> cause an overflow at xfs_vm_writepage():
> 
> end_index = offset >> PAGE_CACHE_SHIFT;
> last_index = (offset - 1) >> PAGE_CACHE_SHIFT;
> if (page->index >= end_index) {
>                 unsigned offset_into_page = offset & (PAGE_CACHE_SIZE - 1);
> 
>                 /*
>                  * Just skip the page if it is fully outside i_size, e.g. due
>                  * to a truncate operation that is in progress.
>                  */
>                 if (page->index >= end_index + 1 || offset_into_page == 0) {
> 		^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>                         unlock_page(page);
>                         return 0;
>                 }
> end_index is unsigned long so that the max value is '2^32-1 = 4294967295', and it
> would be evaluated to the max value with the given offset(when writing the page offset
> up to s_max_bytes) for above test case.  As a result, (page->index >= end_index + 1) is
> ok as (end_index + 1) is overflowed to ZERO.
> 
> Actually, create a file as above on 32-bit machine should be failed with EFBIG error returned
> because there has strict check up at generic_write_checks() against the given offset with a
> *correct* s_max_bytes.
> 
> This patch fix the s_max_bytes to MAX_LFS_FILESIZE if the pre-calculated value is greater
> than it.
> 
> Reported-by: Michael L. Semon <mlsemon35@gmail.com>
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> 
> ---
>  fs/xfs/xfs_super.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index ea341ce..0644d61 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -585,6 +585,7 @@ xfs_max_file_offset(
>  {
>  	unsigned int		pagefactor = 1;
>  	unsigned int		bitshift = BITS_PER_LONG - 1;
> +	__uint64_t		offset;
>  
>  	/* Figure out maximum filesize, on Linux this can depend on
>  	 * the filesystem blocksize (on 32 bit platforms).
> @@ -610,7 +611,10 @@ xfs_max_file_offset(
>  # endif
>  #endif
>  
> -	return (((__uint64_t)pagefactor) << bitshift) - 1;
> +	offset = (((__uint64_t)pagefactor) << bitshift) - 1;
> +
> +	/* Check against VM & VFS exposed limits */
> +	return (offset > MAX_LFS_FILESIZE) ? MAX_LFS_FILESIZE : offset;
>  }
>  
>  xfs_agnumber_t


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
