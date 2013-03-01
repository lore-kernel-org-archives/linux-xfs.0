Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0FA1B7FAF
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 03:21:24 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E3448304039
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 01:21:23 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	br7wrChJRftS8q9F for <xfs@oss.sgi.com>;
	Fri, 01 Mar 2013 01:21:22 -0800 (PST)
Date: Fri, 1 Mar 2013 20:21:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: use right path in _require_defrag()
Message-ID: <20130301092118.GA23616@dastard>
References: <1362129959-4504-1-git-send-email-wenqing.lz@taobao.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1362129959-4504-1-git-send-email-wenqing.lz@taobao.com>
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
Cc: Zheng Liu <wenqing.lz@taobao.com>, xfs@oss.sgi.com

On Fri, Mar 01, 2013 at 05:25:59PM +0800, Zheng Liu wrote:
> In _require_defrag defragmentation command path is fixed.  That will
> cause that this test case is skipped in some distributions.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
>  common.defrag | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/common.defrag b/common.defrag
> index ea6c14c..7be8ad9 100644
> --- a/common.defrag
> +++ b/common.defrag
> @@ -24,10 +24,10 @@ _require_defrag()
>  {
>      case "$FSTYP" in
>      xfs)
> -        DEFRAG_PROG=/usr/sbin/xfs_fsr
> +        DEFRAG_PROG=`which xfs_fsr`
>  	;;
>      ext4|ext4dev)
> -        DEFRAG_PROG=/usr/bin/e4defrag
> +        DEFRAG_PROG=`which e4defrag`
>  	;;
>      btrfs)
>  	DEFRAG_PROG="$BTRFS_UTIL_PROG filesystem defragment"
> @@ -38,7 +38,7 @@ _require_defrag()
>      esac
>  
>      _require_command $DEFRAG_PROG
> -    _require_command /usr/sbin/filefrag
> +    _require_command `which filefrag`
>  }

$DEFRAG_PROG and $FILEFRAG_PROG should be set up in common.config
with set_prog_path, not in _require_defrag.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
