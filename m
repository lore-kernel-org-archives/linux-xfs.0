Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Jun 2008 02:36:23 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5N9aJL3001694
	for <xfs@oss.sgi.com>; Mon, 23 Jun 2008 02:36:21 -0700
Date: Mon, 23 Jun 2008 05:37:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: REVIEW: Fix CI lookup in leaf-form directories
Message-ID: <20080623093718.GA21251@infradead.org>
References: <op.uc6088qm3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.uc6088qm3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Jun 23, 2008 at 06:44:58PM +1000, Barry Naujok wrote:
> Along the same lines as the node-form directory patch last week,
> the leaf-form is not handling directory buffers properly and
> locks up.
>
> Instead of comparing buffer pointers, compare buffer block numbers
> and don't keep buffers hanging around.

Which might be a small performance penalty, but I think that's fine
for the CI lookup case.

The patch looks good to me.

But one things in the original xfs_dir2_leaf_lookup_int that barely
touched by your patch really irks me:

> -	cbp = NULL;
> -	for (lep = &leaf->ents[index], dbp = NULL, curdb = -1;
> +	for (lep = &leaf->ents[index], dbp = NULL, curdb = -1, cidb = -1;
>  				index < be16_to_cpu(leaf->hdr.count) &&
>  				be32_to_cpu(lep->hashval) == args->hashval;
>  				lep++, index++) {

I'd really prefer to have not too much rather unrelated bits in the
for loop.  In fact the use of the for construct here is more than odd
because there is no such things as a loop variable at all.  I think
we'd be much better of in terms of readability with a simple while
loop with where all the initialization is moved out of the loop.

Probably not for this patch, though..
