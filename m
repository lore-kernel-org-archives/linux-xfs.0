Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n38DNYZx091757 for <xfs@oss.sgi.com>; Wed, 8 Apr 2009 08:23:50 -0500
Date: Wed, 8 Apr 2009 09:22:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/6] xfs: use memdup_user()
Message-ID: <20090408132254.GA5957@infradead.org>
References: <49DC4CC0.9050805@cn.fujitsu.com> <49DC4D54.3020001@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49DC4D54.3020001@cn.fujitsu.com>
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
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Wed, Apr 08, 2009 at 03:08:04PM +0800, Li Zefan wrote:
> Remove open-coded memdup_user()
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  fs/xfs/linux-2.6/xfs_ioctl.c   |   23 +++++++----------------
>  fs/xfs/linux-2.6/xfs_ioctl32.c |   12 ++++--------
>  2 files changed, 11 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_ioctl.c b/fs/xfs/linux-2.6/xfs_ioctl.c
> index d0b4994..34eaab6 100644
> --- a/fs/xfs/linux-2.6/xfs_ioctl.c
> +++ b/fs/xfs/linux-2.6/xfs_ioctl.c
> @@ -489,17 +489,12 @@ xfs_attrmulti_attr_set(
>  	if (len > XATTR_SIZE_MAX)
>  		return EINVAL;
>  
> -	kbuf = kmalloc(len, GFP_KERNEL);
> -	if (!kbuf)
> -		return ENOMEM;
> -
> -	if (copy_from_user(kbuf, ubuf, len))
> -		goto out_kfree;
> +	kbuf = memdup_user(ubuf, len);
> +	if (IS_ERR(kbuf))
> +		return PTR_ERR(kbuf);

wouldn't NULL be a better error return for this kind of interface,
matching kmalloc?


Otherwise the patch looks good to me.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
