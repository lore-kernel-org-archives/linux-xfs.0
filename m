Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1D0E729DFB
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 14:11:23 -0500 (CDT)
Date: Thu, 1 Aug 2013 14:11:22 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 27/48] xfs_db: disable modification for CRC enabled
	filessytems.
Message-ID: <20130801191122.GA3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-28-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370564771-4929-28-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Jun 07, 2013 at 10:25:50AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_db does not have the IO infrastructure to calculate metadata
> CRCs after modifying metadata. Hence xfs_db can only run in
> read-only mode on filesystems with version 5 superblocks.
> 
> To fix this, xfs_db needs to have it's IO engine converted to use
> the buffer based IO provided by libxfs rather than rolling it's own
> IO routines. That is future work, so until this conversion is done,
> only allow xfs_db to run in read-only mode on v5 filesystems.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Another one for the TODO list.

Reviewed-by: Ben Myers <bpm@sgi.com>

> ---
>  db/init.c |   15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/db/init.c b/db/init.c
> index 0e9e1a2..1033f3a 100644
> --- a/db/init.c
> +++ b/db/init.c
> @@ -132,6 +132,21 @@ init(
>  			exit(EXIT_FAILURE);
>  	}
>  
> +	/*
> +	 * Don't allow modifications to CRC enabled filesystems until we support
> +	 * CRC recalculation in the IO path. Unless, of course, the user is in
> +	 * the process of hitting us with a big hammer.
> +	 */
> +	if (XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_5 &&
> +	    !(x.isreadonly & LIBXFS_ISREADONLY)) {
> +		fprintf(stderr, 
> +	_("%s: modifications to %s are not supported in thi version.\n"
							this

> +	"Use \"-r\" to run %s in read-only mode on this filesystem .\n"),
								  ^ extra space

> +			progname, fsdevice, progname);
> +		if (!force)
> +			exit(EXIT_FAILURE);
> +	}
> +
>  	mp = libxfs_mount(&xmount, sbp, x.ddev, x.logdev, x.rtdev,
>  				LIBXFS_MOUNT_ROOTINOS | LIBXFS_MOUNT_DEBUGGER);
>  	if (!mp) {
> -- 
> 1.7.10.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
