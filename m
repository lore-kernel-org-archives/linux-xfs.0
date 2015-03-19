Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4BDBD7F37
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 09:55:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B437BAC001
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 07:55:28 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 5ssaqRCoW0UVtfZ7 for <xfs@oss.sgi.com>;
	Thu, 19 Mar 2015 07:55:26 -0700 (PDT)
Message-ID: <550AE35D.40006@sandeen.net>
Date: Thu, 19 Mar 2015 09:55:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] mkfs: default to CRC enabled filesystems
References: <1426720967-8215-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1426720967-8215-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 3/18/15 6:22 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It's time to change the mkfs defaults to enable CRCs for all new
> filesystems. While there, also enable the free inode btree by
> default, too, as that functioanlity has also had long enough to make

"functionality" ;)

> it into distro kernels, too.

> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

> ---
>  mkfs/xfs_mkfs.c | 21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 484e7a8..d7e70fa 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1024,8 +1024,8 @@ main(
>  	force_overwrite = 0;
>  	worst_freelist = 0;
>  	lazy_sb_counters = 1;
> -	crcs_enabled = 0;
> -	finobt = 0;
> +	crcs_enabled = 1;
> +	finobt = 1;
>  	memset(&fsx, 0, sizeof(fsx));
>  
>  	memset(&xi, 0, sizeof(xi));
> @@ -1866,15 +1866,14 @@ _("V2 attribute format always enabled on CRC enabled filesytems\n"));
>  _("32 bit Project IDs always enabled on CRC enabled filesytems\n"));
>  			usage();
>  		}
> -	}
> -
> -	/*
> -	 * The kernel doesn't currently support crc=0,finobt=1 filesystems.
> -	 * Catch it here, disable finobt and warn the user.
> -	 */
> -	if (finobt && !crcs_enabled) {
> -		fprintf(stderr,
> -_("warning: finobt not supported without CRC support, disabled.\n"));
> +	} else {
> +		/*
> +		 * The kernel doesn't currently support crc=0,finobt=1
> +		 * filesystems. If crcs are not enabled, the user has
> +		 * explicitly turned them off, so just silently turn off finobt
> +		 * so that we don't issue unnecessary warnings when non-default
> +		 * options are selected.
> +		 */
>  		finobt = 0;
>  	}

Problem here is that if both are explicitly specified, one is ignored, rather
than letting the user know they've selected an invalid set of options:

# mkfs/mkfs.xfs -dfile,name=fsfile,size=1g -m crc=0,finobt=1
meta-data=fsfile                 isize=256    agcount=4, agsize=65536 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=0        finobt=0
...

This might require a "finobtflag" to keep track of whether it's user-specified,
as we do with other options?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
