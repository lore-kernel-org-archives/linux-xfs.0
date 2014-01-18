Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D7C1629E16
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 22:16:50 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7F42CAC003
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 20:16:47 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 8N1rqFhxVvmUU09x (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Jan 2014 20:16:46 -0800 (PST)
Message-ID: <52DA0022.90601@oracle.com>
Date: Sat, 18 Jan 2014 12:16:34 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: use tr_growrtalloc for growing rt files
References: <1389989370-12159-1-git-send-email-bfoster@redhat.com>
In-Reply-To: <1389989370-12159-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On 01/18 2014 04:09 AM, Brian Foster wrote:
> This is a regression from the following commit:
> 
> 3d3c8b5222b9 xfs: refactor xfs_trans_reserve() interface
> 
> Use the tr_growrtalloc log reservation for growing the
> bitmap/summary files.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_rtalloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index a6a76b2..ec5ca65 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -842,7 +842,7 @@ xfs_growfs_rt_alloc(
>  		/*
>  		 * Reserve space & log for one extent added to the file.
>  		 */
> -		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_growdata,
> +		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_growrtalloc,
>  					  resblks, 0);
My previous mistake, thank you and Eric for catching up this.

Reviewed-by: Jie Liu <jeff.liu@oracle.com>

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
