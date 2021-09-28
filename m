Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76239C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Sep 2021 00:33:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53D2160FF2
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Sep 2021 00:33:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238352AbhI1AfG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Sep 2021 20:35:06 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:48229 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238236AbhI1AfF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Sep 2021 20:35:05 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 37D1DA9EE;
        Tue, 28 Sep 2021 10:33:25 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mV13k-00HVNh-Gq; Tue, 28 Sep 2021 10:33:24 +1000
Date:   Tue, 28 Sep 2021 10:33:24 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V3 12/12] xfs: Define max extent length based on on-disk
 format definition
Message-ID: <20210928003324.GN1756565@dread.disaster.area>
References: <20210916100647.176018-1-chandan.babu@oracle.com>
 <20210916100647.176018-13-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916100647.176018-13-chandan.babu@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=7QKq2e-ADPsA:10 a=7-415B0cAAAA:8
        a=Lg7D5mDAIUrzhamEM1YA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 16, 2021 at 03:36:47PM +0530, Chandan Babu R wrote:
> The maximum extent length depends on maximum block count that can be stored in
> a BMBT record. Hence this commit defines MAXEXTLEN based on
> BMBT_BLOCKCOUNT_BITLEN.
> 
> While at it, the commit also renames MAXEXTLEN to XFS_MAX_EXTLEN.

hmmmm. So you reimplemented:

#define BMBT_BLOCKCOUNT_MASK    ((1ULL << BMBT_BLOCKCOUNT_BITLEN) - 1)

and defined it as XFS_MAX_EXTLEN?

One of these two defines needs to go away. :)

Also, this macro really defines the maximum extent length a BMBT
record can hold, not the maximum XFS extent length supported. I
think it should be  named XFS_BMBT_MAX_EXTLEN and also used to
replace BMBT_BLOCKCOUNT_MASK.

The counter example are free space btree records - they can hold
extents lengths up to 2^31 blocks long:

typedef struct xfs_alloc_rec {
        __be32          ar_startblock;  /* starting block number */
        __be32          ar_blockcount;  /* count of free blocks */
} xfs_alloc_rec_t, xfs_alloc_key_t;

So, yes, I think MAXEXTLEN needs cleaning up, but it needs some more
work to make it explicit in what it refers to.

Also:

> -/*
> - * Max values for extlen and disk inode's extent counters.
> - */
> -#define	MAXEXTLEN		((xfs_extlen_t)0x1fffff)	/* 21 bits */
> -#define XFS_IFORK_EXTCNT_MAXU48	((xfs_extnum_t)0xffffffffffff)	/* Unsigned 48-bits */
> -#define XFS_IFORK_EXTCNT_MAXU32	((xfs_aextnum_t)0xffffffff)	/* Unsigned 32-bits */
> -#define XFS_IFORK_EXTCNT_MAXS32 ((xfs_extnum_t)0x7fffffff)	/* Signed 32-bits */
> -#define XFS_IFORK_EXTCNT_MAXS16 ((xfs_aextnum_t)0x7fff)		/* Signed 16-bits */
> -
> -
>  /*
>   * Inode minimum and maximum sizes.
>   */
> @@ -1701,6 +1691,16 @@ typedef struct xfs_bmbt_rec {
>  typedef uint64_t	xfs_bmbt_rec_base_t;	/* use this for casts */
>  typedef xfs_bmbt_rec_t xfs_bmdr_rec_t;
>  
> +/*
> + * Max values for extlen and disk inode's extent counters.
> + */
> +#define XFS_MAX_EXTLEN		((xfs_extlen_t)(1 << BMBT_BLOCKCOUNT_BITLEN) - 1)
> +#define XFS_IFORK_EXTCNT_MAXU48	((xfs_extnum_t)0xffffffffffff)	/* Unsigned 48-bits */
> +#define XFS_IFORK_EXTCNT_MAXU32	((xfs_aextnum_t)0xffffffff)	/* Unsigned 32-bits */
> +#define XFS_IFORK_EXTCNT_MAXS32 ((xfs_extnum_t)0x7fffffff)	/* Signed 32-bits */
> +#define XFS_IFORK_EXTCNT_MAXS16 ((xfs_aextnum_t)0x7fff)		/* Signed 16-bits */

At the end of the patch series, I still really don't like these
names. Hungarian notation is ugly, and they don't tell me what type
they apply to. Hence I don't know what limit is the correct one to
apply to which fork and which format....

These would be much better as

#define XFS_MAX_EXTCNT_DATA_FORK	((1ULL < 48) - 1)
#define XFS_MAX_EXTCNT_ATTR_FORK	((1ULL < 32) - 1)

#define XFS_MAX_EXTCNT_DATA_FORK_OLD	((1ULL < 31) - 1)
#define XFS_MAX_EXTCNT_ATTR_FORK_OLD	((1ULL < 15) - 1)

The name tells me what object/format they apply to, and the
implementation tells me the exact size without needing a comment
to make it readable. And it doesn't need casts that just add noise
to the implementation...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
