Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DD8DC7F47
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 19:55:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C9BC28F8049
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 17:55:02 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	kBlWs6mAcmkfR3j9 for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 17:55:00 -0700 (PDT)
Date: Wed, 26 Aug 2015 10:54:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/11] xfs_repair: force not-so-bad bmbt blocks back
	through the verifier
Message-ID: <20150826005447.GS714@dastard>
References: <20150826003220.23973.59731.stgit@birch.djwong.org>
	<20150826003305.23973.65768.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150826003305.23973.65768.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

On Tue, Aug 25, 2015 at 05:33:05PM -0700, Darrick J. Wong wrote:
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
> index 1de3ec0..77d29c8 100644
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
> +	if (bp->b_error == -EFSBADCRC)
> +		bp->b_flags |= LIBXFS_B_UNCHECKED;

This is because the next read of the buffer clears bp->b_error,
right?

So, while I think this is necessary, I also think the prefetch on
this btree should stop as we can't trust the contents of the buffer
to be correct. Hence I'd suggest that:

	/*
	 * If the verfier flagged a problem with the buffer, we
	 * can't trust it's contents for the purposes of readahead.
	 * Stop prefetching the tree, and mark this buffer as
	 * unchecked so that the next read of the buffer by the
	 * repair code will retain the error status and hence be
	 * acted on appropriately.
	 */
	if (bp->b_error) {
		bp->b_flags |= LIBXFS_B_UNCHECKED;
		libxfs_putbuf(bp);
		return 0;
	}

Cheers,

Dave.


-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
