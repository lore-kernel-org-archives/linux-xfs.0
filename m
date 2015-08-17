Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 973567F47
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 16:14:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7822C8F8052
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 14:14:29 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 8VMU61z0yZPqpj0B for <xfs@oss.sgi.com>;
	Mon, 17 Aug 2015 14:14:27 -0700 (PDT)
Message-ID: <55D24EB3.2040506@sandeen.net>
Date: Mon, 17 Aug 2015 16:14:27 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 05/10] xfs_repair: force not-so-bad bmbt blocks back
	through the verifier
References: <20150815014338.1839.37405.stgit@birch.djwong.org>
	<20150815014410.1839.33268.stgit@birch.djwong.org>
In-Reply-To: <20150815014410.1839.33268.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <djwong@alder.djwong.org>, david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

On 8/14/15 8:44 PM, Darrick J. Wong wrote:
> If during prefetch we encounter a bmbt block that fails the CRC check
> due to corruption in the unused part of the block, force the buffer
> back through the non-prefetch verifiers later so that the CRC is
> updated.  Otherwise, the bad checksum goes unfixed and the kernel will
> still flag the bmbt block as invalid.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  repair/prefetch.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> 
> diff --git a/repair/prefetch.c b/repair/prefetch.c
> index 8b261ae..fc7097f 100644
> --- a/repair/prefetch.c
> +++ b/repair/prefetch.c
> @@ -276,6 +276,14 @@ pf_scan_lbtree(
>  
>  	XFS_BUF_SET_PRIORITY(bp, isadir ? B_DIR_BMAP : B_BMAP);
>  
> +	/*
> +	 * Make this bmbt buffer go back through the verifiers later so that
> +	 * we correct checksum errors stemming from bitflips in the unused
> +	 * parts of the bmbt block.
> +	 */
> +	if (bp->b_error == -EFSBADCRC || bp->b_error == -EFSCORRUPTED)
> +		bp->b_flags |= LIBXFS_B_UNCHECKED;

Hm, so why check EFSCORRUPTED?  If you're doing what the comment says, why
not just EFSBADCRC?  EFSCORRUPTED means that in-use portions are bad, no?

-Eric

> +
>  	rc = (*func)(XFS_BUF_TO_BLOCK(bp), level - 1, isadir, args);
>  
>  	libxfs_putbuf(bp);
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
