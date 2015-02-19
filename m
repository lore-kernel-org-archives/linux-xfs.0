Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1B6997F50
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 10:39:29 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0A85B304043
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 08:39:25 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id U1PEFOFGEswcpoED for <xfs@oss.sgi.com>;
	Thu, 19 Feb 2015 08:39:23 -0800 (PST)
Message-ID: <54E611BA.7010806@sandeen.net>
Date: Thu, 19 Feb 2015 10:39:22 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH RFC] fs: xfs: Fix xfs_trans_read_buf event tracing
References: <7fb3278485ca5d8b48cd1ba980be6cc11dafc11b.1424352124.git.panand@redhat.com>
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
To: Pratyush Anand <panand@redhat.com>, david@fromorbit.com, xfs@oss.sgi.com
Cc: jbastian@redhat.com, ddutile@redhat.com

On 2/19/15 7:24 AM, Pratyush Anand wrote:
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

What kernel did you hit this on?  What did the backtrace look like?

I've been unable to reproduce the problem so far.

Thanks,
-Eric

> Signed-off-by: Pratyush Anand <panand@redhat.com>
> ---
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
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
