Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAQFqtkC209917 for <xfs@oss.sgi.com>; Mon, 26 Nov 2012 09:52:55 -0600
Date: Mon, 26 Nov 2012 09:55:11 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: Remove the description about nodelaylog mount
	option from, the xfs document.
Message-ID: <20121126155511.GF27055@sgi.com>
References: <50B30B41.8040400@jp.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50B30B41.8040400@jp.fujitsu.com>
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
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: xfs ML <xfs@oss.sgi.com>

On Mon, Nov 26, 2012 at 03:25:05PM +0900, Satoru Takeuchi wrote:
> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> 
> nodelaylog mount option is removed by commit 93b8a585. But there still be
> the description about it in the xfs document. This patch removes it.
> 
> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> ---
>  Documentation/filesystems/xfs.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
> index 3fc0c31..860b845 100644
> --- a/Documentation/filesystems/xfs.txt
> +++ b/Documentation/filesystems/xfs.txt
> @@ -43,7 +43,7 @@ When mounting an XFS filesystem, the following options are accepted.
>         Issue command to let the block device reclaim space freed by the
>         filesystem.  This is useful for SSD devices, thinly provisioned
>         LUNs and virtual machine images, but may have a performance
> -       impact.  This option is incompatible with the nodelaylog option.
> +       impact.

Looks good.

Reviewed-by: Ben Myers <bpm@sgi.com>

Thanks Satoru!

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
