Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 01:17:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m398HTXr029367
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 01:17:30 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F3CFA128A19C
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2008 01:18:07 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id VU2zqmLrnbRP2sgS for <xfs@oss.sgi.com>; Wed, 09 Apr 2008 01:18:07 -0700 (PDT)
Date: Wed, 9 Apr 2008 04:17:36 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [REVIEW] cleanup - refactor xfs_dir2_leafn_lookup_int()
Message-ID: <20080409081736.GA18976@infradead.org>
References: <op.t9b29ska3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.t9b29ska3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Wed, Apr 09, 2008 at 06:02:06PM +1000, Barry Naujok wrote:
> +	if (curbp) {
> +		/* For addname, giving back a free block. */

Given the function is only for addname anymore the first half of the
comment doesn't make sense anymore.

> +		if (dep->namelen == args->namelen && memcmp(dep->name,
> +					args->name, args->namelen) == 0) {
> +			args->inumber = be64_to_cpu(dep->inumber);
> +			*indexp = index;
> +			state->extravalid = 1;
> +			state->extrablk.bp = curbp;
>  			state->extrablk.blkno = curdb;
> +			state->extrablk.index = (int)((char *)dep -
> +							(char *)curbp->data);
>  			state->extrablk.magic = XFS_DIR2_DATA_MAGIC;
> +			return XFS_ERROR(EEXIST);
>  		}
>  	}
>  	/*
> +	 * Didn't find a match.
> +	 * If we are holding a buffer, give it back in case our caller
> +	 * finds it useful.
> +	 */
> +	if (curbp) {
> +		/* Giving back a data block. */
> +		state->extravalid = 1;
> +		state->extrablk.bp = curbp;
> +		state->extrablk.index = -1;
> +		state->extrablk.blkno = curdb;
> +		state->extrablk.magic = XFS_DIR2_DATA_MAGIC;

Might be worth factoring these two out using a goto

Otherwise the patch looks good.
