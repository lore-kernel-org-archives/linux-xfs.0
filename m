Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 641887CBE
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 05:10:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 34F75304070
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 03:10:26 -0700 (PDT)
Message-ID: <520CA923.4060409@oracle.com>
Date: Thu, 15 Aug 2013 18:10:43 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [patch] xfs: check for underflow in xfs_iformat_fork()
References: <20130815055338.GC23580@elgon.mountain>
In-Reply-To: <20130815055338.GC23580@elgon.mountain>
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
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On 08/15/2013 01:53 PM, Dan Carpenter wrote:

> The "di_size" variable comes from the disk and it's a signed 64 bit.
> We check the upper limit but we should check for negative numbers as
> well.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/fs/xfs/xfs_inode_fork.c b/fs/xfs/xfs_inode_fork.c
> index 123971b..849fc70 100644
> --- a/fs/xfs/xfs_inode_fork.c
> +++ b/fs/xfs/xfs_inode_fork.c
> @@ -167,7 +167,8 @@ xfs_iformat_fork(
>  			}
>  
>  			di_size = be64_to_cpu(dip->di_size);
> -			if (unlikely(di_size > XFS_DFORK_DSIZE(dip, ip->i_mount))) {
> +			if (unlikely(di_size < 0 ||

But the di_size is initialized to ZERO while allocating a new inode on disk.
I wonder if that is better to ASSERT in this case because the current check
is used to make sure that the item is inlined, or we don't need it at all.

> +				     di_size > XFS_DFORK_DSIZE(dip, ip->i_mount))) {
>  				xfs_warn(ip->i_mount,
>  			"corrupt inode %Lu (bad size %Ld for local inode).",
>  					(unsigned long long) ip->i_ino,
>

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
