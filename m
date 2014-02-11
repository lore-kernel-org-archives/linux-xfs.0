Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4D7E07F50
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 13:54:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2865B8F806F
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 11:54:28 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id GlRL21y82Lxav9mR for <xfs@oss.sgi.com>;
	Tue, 11 Feb 2014 11:54:23 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 30D8C61B1F71
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 13:54:23 -0600 (CST)
Message-ID: <52FA7FEE.7040307@sandeen.net>
Date: Tue, 11 Feb 2014 13:54:22 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 6/7] xfs: add xfs_verifier_error()
References: <52F99426.3010409@sandeen.net> <52F9957A.4050301@sandeen.net>
In-Reply-To: <52F9957A.4050301@sandeen.net>
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
To: xfs-oss <xfs@oss.sgi.com>

On 2/10/14, 9:14 PM, Eric Sandeen wrote:
> We want to distinguish between corruption and CRC errors.
> In addition, the full stack trace on verifier errors
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

So, this now looks like:

[259116.148375] XFS (loop0): Metadata corruption detected at xfs_sb_read_verify+0x118/0x150 [xfs], block 0x0. Unmount and run xfs_repair
[259116.160345] ffff88022bab0000: 58 46 53 42 00 00 10 00 00 00 00 00 00 04 00 00  XFSB............
[259116.169109] ffff88022bab0010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[259116.177872] ffff88022bab0020: 73 df 07 64 a6 50 4d 5b 8d eb 2c 06 a1 ed e3 5c  s..d.PM[..,....\
[259116.186638] ffff88022bab0030: 00 00 00 00 00 02 00 04 00 00 00 00 00 00 00 80  ................
[259116.195413] XFS (loop0): SB validate failed with error 117.

when something fails.

We should probably put a period after "xfs_repair" and also print one more line about what the hex spew means - "XFS (loop0): first 64 bytes of corrupted metadata buffer:" or something similar.

-Eric

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  fs/xfs/xfs_error.c |   22 ++++++++++++++++++++++
>  fs/xfs/xfs_error.h |    1 +
>  fs/xfs/xfs_linux.h |    1 +
>  3 files changed, 24 insertions(+), 0 deletions(-)
> 
> V2: Use __builtin_return_address(0) to avoid the macro
> with __func__; this can eventually be pushed into the verifiers
> themselves to issue a specific warning for each failure.
> 
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 9995b80..db19133 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -178,3 +178,25 @@ xfs_corruption_error(
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
> +	xfs_alert(mp,
> +"Metadata %s detected at %pF, block 0x%llx. Unmount and run xfs_repair",
> +		  bp->b_error == EFSBADCRC ? "CRC error" : "corruption",
> +		  __builtin_return_address(0), bp->b_bn);
> +
> +	if (xfs_error_level >= XFS_ERRLEVEL_LOW)
> +		xfs_hex_dump(bp->b_addr, 64);
> +
> +	if (xfs_error_level >= XFS_ERRLEVEL_HIGH)
> +		xfs_stack_trace();
> +}
> diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
> index 079a367..c1c57d4 100644
> --- a/fs/xfs/xfs_error.h
> +++ b/fs/xfs/xfs_error.h
> @@ -34,6 +34,7 @@ extern void xfs_error_report(const char *tag, int level, struct xfs_mount *mp,
>  extern void xfs_corruption_error(const char *tag, int level,
>  			struct xfs_mount *mp, void *p, const char *filename,
>  			int linenum, inst_t *ra);
> +extern void xfs_verifier_error(struct xfs_buf *bp);
>  
>  #define	XFS_ERROR_REPORT(e, lvl, mp)	\
>  	xfs_error_report(e, lvl, mp, __FILE__, __LINE__, __return_address)
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index e8fed74..016ea8d 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -179,6 +179,7 @@ typedef __uint64_t __psunsigned_t;
>  #define ENOATTR		ENODATA		/* Attribute not found */
>  #define EWRONGFS	EINVAL		/* Mount with wrong filesystem type */
>  #define EFSCORRUPTED	EUCLEAN		/* Filesystem is corrupted */
> +#define EFSBADCRC	EILSEQ		/* Bad CRC detected */
>  
>  #define SYNCHRONIZE()	barrier()
>  #define __return_address __builtin_return_address(0)
> -- 1.7.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
