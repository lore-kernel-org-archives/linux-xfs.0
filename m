Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5CB777F37
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 11:20:39 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D78F4AC001
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 09:20:35 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0AXaSEFgPkITgcKQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Feb 2015 09:20:34 -0800 (PST)
Date: Thu, 19 Feb 2015 12:20:28 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH RFC] fs: xfs: Fix xfs_trans_read_buf event tracing
Message-ID: <20150219172028.GC2291@laptop.bfoster>
References: <7fb3278485ca5d8b48cd1ba980be6cc11dafc11b.1424352124.git.panand@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <7fb3278485ca5d8b48cd1ba980be6cc11dafc11b.1424352124.git.panand@redhat.com>
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
To: Pratyush Anand <panand@redhat.com>
Cc: ddutile@redhat.com, jbastian@redhat.com, xfs@oss.sgi.com

On Thu, Feb 19, 2015 at 06:54:33PM +0530, Pratyush Anand wrote:
> My root file system is xfs. As soon as I enable event for
> xfs_trans_read_buf `echo xfs:xfs_trans_read_buf >>
> /sys/kernel/debug/tracing/set_event`, I see a kernel panic.
> 
> A little bit of debugging shows that bp->b_fspriv is NULL many a time
> when trace_xfs_trans_read_buf(bp->b_fspriv) is called.
> 
> I do not have any idea about xfs filesystem. So, I am not sure, if it
> is expected to have bp->b_fspriv = NULL at this location.
> 
> This patch fixes the issue, until we have a better fix.
> 
> Signed-off-by: Pratyush Anand <panand@redhat.com>
> ---

A fix for this has been posted here:

http://oss.sgi.com/archives/xfs/2015-02/msg00101.html

Brian

>  fs/xfs/xfs_trans_buf.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index 0a4d4ab6d9a9..0b67a20643bf 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -329,7 +329,8 @@ xfs_trans_read_buf_map(
>  
>  	if (tp)
>  		_xfs_trans_bjoin(tp, bp, 1);
> -	trace_xfs_trans_read_buf(bp->b_fspriv);
> +	if (bp->b_fspriv)
> +		trace_xfs_trans_read_buf(bp->b_fspriv);
>  	*bpp = bp;
>  	return 0;
>  
> -- 
> 2.1.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
