Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6B6907F3F
	for <xfs@oss.sgi.com>; Tue,  7 Jan 2014 05:21:20 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EDD36AC003
	for <xfs@oss.sgi.com>; Tue,  7 Jan 2014 03:21:16 -0800 (PST)
Message-ID: <52CBE321.4050906@oracle.com>
Date: Tue, 07 Jan 2014 19:21:05 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3] xfs: Calling destroy_work_on_stack() to pair with
	INIT_WORK_ONSTACK()
References: <1389084605.3650.66.camel@cliu38-desktop-build>
	<1389084814.3650.70.camel@cliu38-desktop-build>
In-Reply-To: <1389084814.3650.70.camel@cliu38-desktop-build>
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
To: Chuansheng Liu <chuansheng.liu@intel.com>, dchinner@fromorbit.com, bpm@sgi.com
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Chuansheng,

On 01/07 2014 16:53 PM, Chuansheng Liu wrote:
> 
> In case CONFIG_DEBUG_OBJECTS_WORK is defined, it is needed to
> call destroy_work_on_stack() which frees the debug object to pair
> with INIT_WORK_ONSTACK().
> 
> Signed-off-by: Liu, Chuansheng <chuansheng.liu@intel.com>
> ---
>  fs/xfs/xfs_bmap_util.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 1394106..82e0dab 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -287,6 +287,7 @@ xfs_bmapi_allocate(
>  	INIT_WORK_ONSTACK(&args->work, xfs_bmapi_allocate_worker);
>  	queue_work(xfs_alloc_wq, &args->work);
>  	wait_for_completion(&done);
> +	destroy_work_on_stack(&args->work);
>  	return args->result;
>  }

Thanks for your patch and it work fine for my testing.  I missed this in an
old commit: [ 3b876c8f2a xfs: fix debug_object WARN at xfs_alloc_vextent() ] 

Just out of curious, do you notice memory leaks or other hints which help you
finding out this problem?   

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
