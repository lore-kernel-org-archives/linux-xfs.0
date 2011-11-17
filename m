Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAHKoHN9071958 for <xfs@oss.sgi.com>; Thu, 17 Nov 2011 14:50:17 -0600
Date: Thu, 17 Nov 2011 14:50:33 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] change fallocate to xfs_io falloc
Message-ID: <20111117205033.GK29840@sgi.com>
References: <4EB20505.7070005@cn.fujitsu.com> <4EC4989D.9080107@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4EC4989D.9080107@cn.fujitsu.com>
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
To: WuBo <wu.bo@cn.fujitsu.com>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Hey Wu Bo,

On Thu, Nov 17, 2011 at 01:16:13PM +0800, WuBo wrote:
> Thanks to Ben for pointing it that the fallocate maybe uninstall 
> without checking it, and change fallocate to xfs_io as Christoph
> suggested.
> 
> Signed-off-by: Wu Bo <Wu.Bo@cn.fujitsu.com>

Nice!  It works great for me.  ;)

Reviewed-by: Ben Myers <bpm@sgi.com>

Thanks,
	Ben

> ---
>  274 |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/274 b/274
> index b658004..bcf5a11 100755
> --- a/274
> +++ b/274
> @@ -46,6 +46,7 @@ _cleanup()
>  _supported_fs generic
>  _supported_os IRIX Linux
>  _require_scratch
> +_require_xfs_io_falloc
>  
>  echo "------------------------------"
>  echo "preallocation test"
> @@ -67,7 +68,7 @@ then
>  	exit
>  fi
>  
> -fallocate -n -o 4K -l 1M test >/dev/null 2>&1
> +$XFS_IO_PROG -F -f -c 'falloc 4096 1m' test >/dev/null
>  if [ $? -ne 0 ]
>  then
>  	echo "fallocate file err"
> -- 
> 1.7.3.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
