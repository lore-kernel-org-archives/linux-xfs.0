Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 16 Nov 2006 13:54:50 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAGLseaG017898
	for <xfs@oss.sgi.com>; Thu, 16 Nov 2006 13:54:41 -0800
Message-ID: <455CD6C8.5030907@agami.com>
Date: Thu, 16 Nov 2006 13:23:20 -0800
From: Shailendra Tripathi <stripathi@agami.com>
MIME-Version: 1.0
Subject: Re: [PATCH][RFC][resend] potential NULL pointer deref in XFS on failed
 mount
References: <200611162218.26945.jesper.juhl@gmail.com>
In-Reply-To: <200611162218.26945.jesper.juhl@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, nathans@sgi.com, Andrew Morton <akpm@osdl.org>

Hey Jesper,
                Rather,  it can be done as below. Nothing to say that 
your code wouldn't work. Just that catch it early, so that potential 
function call overhead to call xfs_free_buftarg can be avoided.

void
xfs_unmountfs_close(xfs_mount_t *mp, struct cred *cr)
{
       if (mp->m_logdev_targp && (mp->m_logdev_targp != mp->m_ddev_targp))
                xfs_free_buftarg(mp->m_logdev_targp, 1);
        if (mp->m_rtdev_targp)
                xfs_free_buftarg(mp->m_rtdev_targp, 1);
        xfs_free_buftarg(mp->m_ddev_targp, 0);
}


Jesper Juhl wrote:
> (got no reply on this when I originally send it on 20061031, so resending
>  now that a bit of time has passed.  The patch still applies cleanly to
>  Linus' git tree as of today.)
>
>
> The Coverity checker spotted a potential problem in XFS.
>
> The problem is that if, in xfs_mount(), this code triggers:
>
> 	...
> 	if (!mp->m_logdev_targp)
> 		goto error0;
> 	...
>
> Then we'll end up calling xfs_unmountfs_close() with a NULL 
> 'mp->m_logdev_targp'. 
> This in turn will result in a call to xfs_free_buftarg() with its 'btp' 
> argument == NULL. xfs_free_buftarg() dereferences 'btp' leading to
> a NULL pointer dereference and crash.
>
> I think this can happen, since the fatal call to xfs_free_buftarg() 
> happens when 'm_logdev_targp != m_ddev_targp' and due to a check of
> 'm_ddev_targp' against NULL in xfs_mount() (and subsequent return if it is 
> NULL) the two will never both be NULL when we hit the error0 label from 
> the two lines cited above.
>
> Comments welcome (please keep me on Cc: on replies).
>
> Here's a proposed patch to fix this by testing 'btp' against NULL in 
> xfs_free_buftarg().
>
>
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> ---
>
>  fs/xfs/linux-2.6/xfs_buf.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
> index db5f5a3..6ef1860 100644
> --- a/fs/xfs/linux-2.6/xfs_buf.c
> +++ b/fs/xfs/linux-2.6/xfs_buf.c
> @@ -1450,6 +1450,9 @@ xfs_free_buftarg(
>  	xfs_buftarg_t		*btp,
>  	int			external)
>  {
> +	if (unlikely(!btp))
> +		return;
> +
>  	xfs_flush_buftarg(btp, 1);
>  	if (external)
>  		xfs_blkdev_put(btp->bt_bdev);
>
>
>
>   
