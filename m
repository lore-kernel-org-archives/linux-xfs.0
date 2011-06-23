Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5NFXtao197435 for <xfs@oss.sgi.com>; Thu, 23 Jun 2011 10:33:55 -0500
Message-ID: <4E035CDE.5090304@gmail.com>
Date: Thu, 23 Jun 2011 17:33:50 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: Silence bounds checking compiler warning
References: <4E0356E6.30104@gmail.com>
In-Reply-To: <4E0356E6.30104@gmail.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs-masters@oss.sgi.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On 06/23/2011 05:08 PM, Maarten Lankhorst wrote:
> gcc with -Warray-bounds generates a false positive on this
> since xfs defines the struct with u8 name[1]; to be able to
> add a tag at the end.
>
> Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
> ---
>  fs/xfs/xfs_dir2_block.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
> index 580d99c..09b4aed 100644
> --- a/fs/xfs/xfs_dir2_block.c
> +++ b/fs/xfs/xfs_dir2_block.c
> @@ -1148,7 +1148,7 @@ xfs_dir2_sf_to_block(
>  		((char *)block + XFS_DIR2_DATA_DOTDOT_OFFSET);
>  	dep->inumber = cpu_to_be64(xfs_dir2_sf_get_inumber(sfp, &sfp->hdr.parent));
>  	dep->namelen = 2;
> -	dep->name[0] = dep->name[1] = '.';
> +	dep->name[0] = ((__u8 *)dep->name)[1] = '.';
>  	tagp = xfs_dir2_data_entry_tag_p(dep);
>  	*tagp = cpu_to_be16((char *)dep - (char *)block);
>  	xfs_dir2_data_log_entry(tp, bp, dep);
Oops, that still gives a warning, I used (u8*) first which works, but it seems the type
conversion was what made it shut up. Is there any type I can cast __u8 to safely,
or is memset preferred? gcc was too smart and saw through my __u8 cast.

~Maarten

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
