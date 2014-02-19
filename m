Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 54E5E8001
	for <xfs@oss.sgi.com>; Wed, 19 Feb 2014 00:31:04 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D14B0AC00A
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 22:31:00 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	xkVG3QJU4qUapNcc for <xfs@oss.sgi.com>;
	Tue, 18 Feb 2014 22:30:57 -0800 (PST)
Date: Wed, 19 Feb 2014 17:30:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 7/9] xfs: add xfs_verifier_error()
Message-ID: <20140219063037.GN13647@dastard>
References: <1392767549-25574-1-git-send-email-sandeen@redhat.com>
	<1392767549-25574-8-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1392767549-25574-8-git-send-email-sandeen@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 18, 2014 at 05:52:27PM -0600, Eric Sandeen wrote:
> We want to distinguish between corruption, CRC errors,
> etc.  In addition, the full stack trace on verifier errors
> seems less than helpful; it looks more like an oops than
> corruption.
> 
> Create a new function to specifically alert the user to
> verifier errors, which can differentiate between
> EFSCORRUPTED and CRC mismatches.  It doesn't dump stack
> unless the xfs error level is turned up high.
> 
> Define a new error message (EFSBADCRC) to clearly identify
> CRC errors.  (Defined to EILSEQ, bad byte sequence)

I think we decided the other best candidates were:

EBADE: Invalid exchange
EPROTO: Protocol error
EBADMSG: Bad message
EKEYREJECTED: Key was rejected by service

because of the silly glibc translation of EILSEQ:

EILSEQ: Invalid or incomplete multibyte or wide character

I'm leaning towards EBADMSG as the one to use here.

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  fs/xfs/xfs_error.c |   26 ++++++++++++++++++++++++++
>  fs/xfs/xfs_error.h |    1 +
>  fs/xfs/xfs_linux.h |    1 +
>  3 files changed, 28 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 9995b80..8733c59 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -178,3 +178,29 @@ xfs_corruption_error(
>  	xfs_error_report(tag, level, mp, filename, linenum, ra);
>  	xfs_alert(mp, "Corruption detected. Unmount and run xfs_repair");
>  }
> +
> +/*
> + * Warnings specifically for verifier errors.  Differentiate CRC vs. invalid
> + * values, and omit the stack trace unless the error level is tuned high.
> + */
> +void
> +xfs_verifier_error(
> +	struct xfs_buf		*bp)
> +{
> +	struct xfs_mount *mp = bp->b_target->bt_mount;
> +
> +	xfs_alert(mp, "Metadata %s detected at %pF, block 0x%llx",
> +		  bp->b_error == EFSBADCRC ? "CRC error" : "corruption",
> +		  __return_address, bp->b_bn);
> +
> +	xfs_alert(mp, "Unmount and run xfs_repair");
> +
> +	/* XXX handle page-mapped buffers too? */
> +	if (xfs_error_level >= XFS_ERRLEVEL_LOW && bp->b_addr) {
> +		xfs_alert(mp, "First 64 bytes of corrupted metadata buffer:");
> +		xfs_hex_dump(bp->b_addr, 64);
> +	}

Just use xfs_buf_offset(bp, 0) here, and you don't have to care
about how the buffer is mapped or allocated.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
