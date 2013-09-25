Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 788447F4E
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 16:32:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 66B3E8F8073
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 14:32:31 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	nkUqhHf8zPU6ftXZ for <xfs@oss.sgi.com>;
	Wed, 25 Sep 2013 14:32:29 -0700 (PDT)
Date: Thu, 26 Sep 2013 07:32:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 RESEND] xfs: fix dead loop at xfs_vm_writepage() on
	32bit machine
Message-ID: <20130925213224.GG26872@dastard>
References: <52429A6C.3050908@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52429A6C.3050908@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Sep 25, 2013 at 04:10:20PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Write a file with an offset greater than 16TB on 32-bit system and
> then trigger page write-back via sync(1) as below will cause the
> task hang in a little while:

[snip]

> This patch just fixed both issues.
> 
> Reported-by: Michael L. Semon <mlsemon35@gmail.com>
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---
> v2: don't reset the s_max_bytes to MAX_LFS_FILESIZE, instead, revise the page offset
>     check up strategy to avoid the potential overflow.
> v1: http://oss.sgi.com/archives/xfs/2013-07/msg00154.html
> 
>  fs/xfs/xfs_aops.c |   11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 41a6950..6059d00 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -969,7 +969,9 @@ xfs_vm_writepage(
>  	offset = i_size_read(inode);
>  	end_index = offset >> PAGE_CACHE_SHIFT;
>  	last_index = (offset - 1) >> PAGE_CACHE_SHIFT;
> -	if (page->index >= end_index) {
> +	if (page->index < end_index)
> +		end_offset = (xfs_off_t)(page->index + 1) << PAGE_CACHE_SHIFT;
> +	else {
>  		unsigned offset_into_page = offset & (PAGE_CACHE_SIZE - 1);

The logic here is already difficult to understand, and the fact that
the code that has 32 bit overflow issues is not obvious . Can you
add a comment noting the overflow issue being handled here?

>  
>  		/*
> @@ -978,7 +980,8 @@ xfs_vm_writepage(
>  		 * page so that reclaim stops reclaiming it. Otherwise
>  		 * xfs_vm_releasepage() is called on it and gets confused.
>  		 */
> -		if (page->index >= end_index + 1 || offset_into_page == 0)
> +		if (page->index > end_index ||
> +		    (page->index == end_index && offset_into_page == 0))
>  			goto redirty;

And again here? 

That means in future we will be aware of the problem when reading
the code...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
