Return-Path: <xfs-bounces@oss.sgi.com>
Subject: Re: [PATCH] xfs: linux-2.6: xfs_ioctl: fix information leak to
	userland
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1288448778-5373-1-git-send-email-segooon@gmail.com>
References: <1288448778-5373-1-git-send-email-segooon@gmail.com>
Date: Fri, 05 Nov 2010 12:19:49 -0500
Message-ID: <1288977589.2295.27.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Christoph@oss.sgi.com, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, Dave Chinner <dchinner@redhat.com>, Hellwig <hch@lst.de>

On Sat, 2010-10-30 at 18:26 +0400, Vasiliy Kulikov wrote:
> al_hreq is copied from userland.  If al_hreq.buflen is not properly aligned then
> xfs_attr_list will ignore the last bytes of kbuf.  These bytes are unitialized.
> It leads to leaking of contents of kernel stack memory.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
>  Compile tested.
> 
>  fs/xfs/linux-2.6/xfs_ioctl.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_ioctl.c b/fs/xfs/linux-2.6/xfs_ioctl.c
> index 2ea238f..ad442d9 100644
> --- a/fs/xfs/linux-2.6/xfs_ioctl.c
> +++ b/fs/xfs/linux-2.6/xfs_ioctl.c
> @@ -416,7 +416,7 @@ xfs_attrlist_by_handle(
>  	if (IS_ERR(dentry))
>  		return PTR_ERR(dentry);
>  
> -	kbuf = kmalloc(al_hreq.buflen, GFP_KERNEL);
> +	kbuf = kzalloc(al_hreq.buflen, GFP_KERNEL);
>  	if (!kbuf)
>  		goto out_dput;
>  

Looks good.  I will take this in and will send
it to Linus for 2.6.37.  Thanks.

Reviewed-by: Alex Elder <aelder@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
