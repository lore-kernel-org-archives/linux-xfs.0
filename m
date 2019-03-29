Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:56184 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729906AbfC2UP4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Mar 2019 16:15:56 -0400
Subject: Re: [PATCH 2/2] xfs: shutdown after buf release in iflush cluster
 abort path
References: <20190329134059.12723-1-bfoster@redhat.com>
 <20190329134059.12723-3-bfoster@redhat.com>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <d5299dcc-ed5b-944d-a56a-9a9ef1b60456@oracle.com>
Date: Fri, 29 Mar 2019 13:15:50 -0700
MIME-Version: 1.0
In-Reply-To: <20190329134059.12723-3-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

Ok, thanks again for the explanation!  You can add my review:

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

On 3/29/19 6:40 AM, Brian Foster wrote:
> If xfs_iflush_cluster() fails due to corruption, the error path
> issues a shutdown and simulates an I/O completion to release the
> buffer. This code has a couple small problems. First, the shutdown
> sequence can issue a synchronous log force, which is unsafe to do
> with buffer locks held. Second, the simulated I/O completion does not
> guarantee the buffer is async and thus is unlocked and released.
> 
> For example, if the last operation on the buffer was a read off disk
> prior to the corruption event, XBF_ASYNC is not set and the buffer
> is left locked and held upon return. This results in a memory leak
> as shown by the following message on module unload:
> 
>   BUG xfs_buf (...): Objects remaining in xfs_buf on __kmem_cache_shutdown()
> 
> Fix both of these problems by setting XBF_ASYNC on the buffer prior
> to the simulated I/O error and performing the shutdown immediately
> after ioend processing when the buffer has been released.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>   fs/xfs/xfs_inode.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index f643a9295179..4591598ca04d 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3614,7 +3614,6 @@ xfs_iflush_cluster(
>   	 * inode buffer and shut down the filesystem.
>   	 */
>   	rcu_read_unlock();
> -	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
>   
>   	/*
>   	 * We'll always have an inode attached to the buffer for completion
> @@ -3624,11 +3623,14 @@ xfs_iflush_cluster(
>   	 * xfs_buf_submit().
>   	 */
>   	ASSERT(bp->b_iodone);
> +	bp->b_flags |= XBF_ASYNC;
>   	bp->b_flags &= ~XBF_DONE;
>   	xfs_buf_stale(bp);
>   	xfs_buf_ioerror(bp, -EIO);
>   	xfs_buf_ioend(bp);
>   
> +	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +
>   	/* abort the corrupt inode, as it was not attached to the buffer */
>   	xfs_iflush_abort(cip, false);
>   	kmem_free(cilist);
> 
