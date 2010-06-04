Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o54IPQaF238694 for <xfs@oss.sgi.com>; Fri, 4 Jun 2010 13:25:26 -0500
Subject: Re: [PATCH V3] xfstests: use stat not lstat when examining devices
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <4C093F22.1010006@sandeen.net>
References: <4C091B4E.5030503@sandeen.net> <4C0939B9.9000109@sandeen.net>
	<4C093F22.1010006@sandeen.net>
Date: Fri, 04 Jun 2010 13:26:50 -0500
Message-ID: <1275676010.2317.53.camel@doink>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, 2010-06-04 at 13:00 -0500, Eric Sandeen wrote:
> If you try running xfstests on lvm volumes which are symlinks,
> it'll fail to run several tests because our _require_scratch 
> framework ultimately uses lstat not stat, and does not think 
> the lvm device (which is usually a symlink to a dm-X device) 
> is a block device.  Sigh.
> 
> Just calling stat(1) with -L to follow the link should
> suffice.

I wonder whether we'll find stat(1) output ever varies
enough to affect this.

But otherwise this looks good to me.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
> 
> diff --git a/common.rc b/common.rc
> index 6bf1e12..db18884 100644
> --- a/common.rc
> +++ b/common.rc
> @@ -584,7 +584,7 @@ _is_block_dev()
>  	exit 1
>      fi
>  
> -    [ -b $1 ] && src/lstat64 $1 | $AWK_PROG '/Device type:/ { print $9 }'
> +    [ -b $1 ] && stat -L $1 | $AWK_PROG '/Device type:/ { print $9 }'
>  }
>  
>  # Do a command, log it to $seq.full, optionally test return status
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
