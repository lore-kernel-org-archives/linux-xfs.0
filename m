Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F01767FCD
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 09:48:32 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CE0D5304059
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 07:48:32 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Pol2U1G2boWAe3wh for
	<xfs@oss.sgi.com>; Fri, 01 Mar 2013 07:48:30 -0800 (PST)
Message-ID: <5130CDC1.8060704@redhat.com>
Date: Fri, 01 Mar 2013 09:48:17 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfstests: use right defrag program path
References: <1362147433-5788-1-git-send-email-wenqing.lz@taobao.com>
In-Reply-To: <1362147433-5788-1-git-send-email-wenqing.lz@taobao.com>
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
To: Zheng Liu <gnehzuil.liu@gmail.com>
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>, xfs@oss.sgi.com

On 3/1/13 8:17 AM, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> In _require_defrag defragmentation command path is fixed.  That will
> cause that this test case is skipped in some distributions.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> Cc: Dave Chinner <david@fromorbit.com>
> ---
> [*NOTE*: this patch is Cc'ed to linux-ext4 mailing list because after
> applied it xfstests #218 will fail against 3.8 and dev branch.]
> 
> v2 <- v1:
>  * Define 'E4DEFRAG_PROG' and 'FILEFRAG_PROG' in common.config with
>    set_prog_path

Looks good to me, thanks.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

>  common.config |  2 ++
>  common.defrag | 10 +++++-----
>  2 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/common.config b/common.config
> index 7174127..9c99bfe 100644
> --- a/common.config
> +++ b/common.config
> @@ -160,6 +160,8 @@ export INDENT_PROG="`set_prog_path indent`"
>  export XFS_COPY_PROG="`set_prog_path xfs_copy`"
>  export FSTRIM_PROG="`set_prog_path fstrim`"
>  export DUMPE2FS_PROG="`set_prog_path dumpe2fs`"
> +export FILEFRAG_PROG="`set_prog_path filefrag`"
> +export E4DEFRAG_PROG="`set_prog_path e4defrag`"
>  
>  # Generate a comparable xfsprogs version number in the form of
>  # major * 10000 + minor * 100 + release
> diff --git a/common.defrag b/common.defrag
> index ea6c14c..9c9eb9b 100644
> --- a/common.defrag
> +++ b/common.defrag
> @@ -24,10 +24,10 @@ _require_defrag()
>  {
>      case "$FSTYP" in
>      xfs)
> -        DEFRAG_PROG=/usr/sbin/xfs_fsr
> +        DEFRAG_PROG="$XFS_FSR_PROG"
>  	;;
>      ext4|ext4dev)
> -        DEFRAG_PROG=/usr/bin/e4defrag
> +        DEFRAG_PROG="$E4DEFRAG_PROG"
>  	;;
>      btrfs)
>  	DEFRAG_PROG="$BTRFS_UTIL_PROG filesystem defragment"
> @@ -38,13 +38,13 @@ _require_defrag()
>      esac
>  
>      _require_command $DEFRAG_PROG
> -    _require_command /usr/sbin/filefrag
> +    _require_command $FILEFRAG_PROG
>  }
>  
>  _extent_count()
>  {
> -	filefrag $1 | awk '{print $2}'
> -	filefrag -v $1  >> $seq.full 2>&1
> +	$FILEFRAG_PROG $1 | awk '{print $2}'
> +	$FILEFRAG_PROG -v $1  >> $seq.full 2>&1
>  }
>  
>  # Defrag file, check it, and remove it.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
