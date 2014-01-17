Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 81B7D7F53
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 14:52:44 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 02A98AC004
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 12:52:43 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 5E9D3yxrkUhT08y6 for <xfs@oss.sgi.com>;
	Fri, 17 Jan 2014 12:52:42 -0800 (PST)
Message-ID: <52D99819.2090405@sandeen.net>
Date: Fri, 17 Jan 2014 14:52:41 -0600
From: Eric Sandeen <sandeen@sandeen.net>
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

On 1/17/14, 2:09 PM, Brian Foster wrote:
> This is a regression from the following commit:
> 
> 3d3c8b5222b9 xfs: refactor xfs_trans_reserve() interface
> 
> Use the tr_growrtalloc log reservation for growing the
> bitmap/summary files.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks right to me.  :)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

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
>  		if (error)
>  			goto error_cancel;
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
