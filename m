Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3H0XUIS259811 for <xfs@oss.sgi.com>; Mon, 16 Apr 2012 19:33:30 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	JJ5ZBRfcCMO1RGUZ for <xfs@oss.sgi.com>;
	Mon, 16 Apr 2012 17:33:29 -0700 (PDT)
Date: Tue, 17 Apr 2012 10:33:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mkfs: Set a clean output in case of invalid inode size
Message-ID: <20120417003327.GD6734@dastard>
References: <1334609816-8473-1-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1334609816-8473-1-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Apr 16, 2012 at 05:56:56PM -0300, Carlos Maiolino wrote:
> Remove an unnecessary usage() call after a mkfs failure due an invalid inode
> size.
> A call to usage() at this point confuses the output message which may cause the
> user to think it used wrong arguments to mkfs, instead of an invalid inode size.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  mkfs/xfs_mkfs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 5445b6f..19d4815 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1898,7 +1898,7 @@ _("block size %d cannot be smaller than logical sector size %d\n"),
>  			fprintf(stderr,
>  	_("allowable inode size with %d byte blocks is between %d and %d\n"),
>  				blocksize, XFS_DINODE_MIN_SIZE, maxsz);
> -		usage();
> +		exit(1);
>  	}

Looks like a good idea to me - no need to spam with usage
information.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
