Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 52DFD7F3F
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2014 07:41:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 31B128F8033
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2014 05:40:59 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AX9wKtSoM7wt2XwB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 16 Oct 2014 05:40:58 -0700 (PDT)
Date: Thu, 16 Oct 2014 08:40:48 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: fix deadlock on failure path in xfs_setattr_nonsize()
Message-ID: <20141016124047.GA42623@bfoster.bfoster>
References: <1413408168-3086-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1413408168-3086-1-git-send-email-khoroshilov@ispras.ru>
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
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: spruce-project@linuxtesting.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Oct 15, 2014 at 11:22:48PM +0200, Alexey Khoroshilov wrote:
> If xfs_trans_reserve() fails, xfs_setattr_nonsize() does not deallocate
> the transaction and does not release "freeze" lock. That leads to the
> following warning from lockdep:
>   [ BUG: lock held when returning to user space! ]
>   ------------------------------------------------
>   fs-driver-tests/7127 is leaving the kernel with locks still held!
>   1 lock held by fs-driver-tests/7127:
>    #0:  (sb_internal){.+.+.+}, at: [<ffffffffa0389a44>] xfs_trans_alloc+0x24/0x40 [xfs]
> 
> The patch adds xfs_trans_cancel() on the failure path.
> 
> Found by Linux File System Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---

Looks good, thanks for the patch.

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_iops.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 72129493e9d3..e2e785eec831 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -599,8 +599,10 @@ xfs_setattr_nonsize(
>  
>  	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
>  	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ichange, 0, 0);
> -	if (error)
> +	if (error) {
> +		xfs_trans_cancel(tp, 0);
>  		goto out_dqrele;
> +	}
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  
> -- 
> 1.9.1
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
