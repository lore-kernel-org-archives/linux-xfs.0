Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59960C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Jan 2022 22:14:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236894AbiA1WOl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Jan 2022 17:14:41 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56436 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbiA1WOk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jan 2022 17:14:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F82561ED9
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jan 2022 22:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEBCBC340E7;
        Fri, 28 Jan 2022 22:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643408080;
        bh=fRnCUrZw0mcd5QCBkGebOu0aeTclh8+YN59YMbBoeMc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QURjyPKMItkAwqFXJAIloYYAtJcwGRg2E3UntZy2a1lO2h18dIJHzTvguEiYUpdrY
         aWa4skLc6mjU3amLd/gVVTzn3wVmToRIMAyhfK1DBXP1RYbFDgtxJKXwtJlm9gNe3i
         tW2A1VIpcWwqRmt4tH6UggF/I5UOQlFVSJOJXCWVQoFEGOHGmfb0loxibTHk/hrssq
         bdIqv1ucAZb5bGM1QwIJ4RZYHJmg4TRXEXHnG9RGYpu3yXThXNhL8wJalxe0ClczcO
         LIwUqmBOEO+O5fBIbiMJYHP//O26Nf984hy3YzorJa8u7++dGCfG/40Ifyb5XC1Us1
         AnHdxEEh1ksKQ==
Date:   Fri, 28 Jan 2022 14:14:39 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 45/45] libxfs: rename buffer cache index variable b_bn
Message-ID: <20220128221439.GI13540@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
 <164263809120.860211.17519273310381663828.stgit@magnolia>
 <8054cc29-9c05-ebc0-7279-8cc694302509@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8054cc29-9c05-ebc0-7279-8cc694302509@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 28, 2022 at 03:37:17PM -0600, Eric Sandeen wrote:
> On 1/19/22 6:21 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > To stop external users from using b_bn as the disk address of the
> > buffer, rename it to b_rhash_key to indicate that it is the buffer
> > cache index, not the block number of the buffer. Code that needs the
> > disk address should use xfs_buf_daddr() to obtain it.
> > 
> > Do the rename and clean up any of the remaining internal b_bn users.
> 
> Is there a reason this wasn't done in the prior patch? If not, I'm happy
> to move them for consistency as noted below.

IIRC I created this as a separate patch to keep the "libxfs changes from
the kernel" bits separate from the "libxfs changes to keep the build
going".  Usually I do this so that if I have to rebase the libxfs-apply
patches I'll lose fewer pieces along the way.

If you want to combine these in the final product then please go ahead.
:)

--D

> > Also clean up any remaining b_bn cruft that is now unused.
> > 
> > Inspired-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >   libxfs/libxfs_io.h |    4 ++--
> >   libxfs/rdwr.c      |   16 ++++++++--------
> >   2 files changed, 10 insertions(+), 10 deletions(-)
> > 
> > 
> > diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
> > index a4d0a913..8a42f500 100644
> > --- a/libxfs/libxfs_io.h
> > +++ b/libxfs/libxfs_io.h
> > @@ -79,7 +79,7 @@ struct xfs_buf_ops {
> >   struct xfs_buf {
> >   	struct cache_node	b_node;
> >   	unsigned int		b_flags;
> > -	xfs_daddr_t		b_bn;
> > +	xfs_daddr_t		b_cache_key;	/* buffer cache index */
> >   	unsigned int		b_length;
> >   	struct xfs_buftarg	*b_target;
> >   	pthread_mutex_t		b_lock;
> > @@ -122,7 +122,7 @@ static inline xfs_daddr_t xfs_buf_daddr(struct xfs_buf *bp)
> >   static inline void xfs_buf_set_daddr(struct xfs_buf *bp, xfs_daddr_t blkno)
> >   {
> > -	assert(bp->b_bn == XFS_BUF_DADDR_NULL);
> > +	assert(bp->b_cache_key == XFS_BUF_DADDR_NULL);
> >   	bp->b_maps[0].bm_bn = blkno;
> >   }
> > diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> > index a55e3a79..2a9e8c98 100644
> > --- a/libxfs/rdwr.c
> > +++ b/libxfs/rdwr.c
> > @@ -205,7 +205,7 @@ libxfs_bcompare(struct cache_node *node, cache_key_t key)
> >   	struct xfs_bufkey	*bkey = (struct xfs_bufkey *)key;
> >   	if (bp->b_target->bt_bdev == bkey->buftarg->bt_bdev &&
> > -	    bp->b_bn == bkey->blkno) {
> > +	    bp->b_cache_key == bkey->blkno) {
> >   		if (bp->b_length == bkey->bblen)
> >   			return CACHE_HIT;
> >   #ifdef IO_BCOMPARE_CHECK
> > @@ -214,7 +214,7 @@ libxfs_bcompare(struct cache_node *node, cache_key_t key)
> >   	"%lx: Badness in key lookup (length)\n"
> >   	"bp=(bno 0x%llx, len %u bytes) key=(bno 0x%llx, len %u bytes)\n",
> >   				pthread_self(),
> > -				(unsigned long long)bp->b_bn,
> > +				(unsigned long long)xfs_buf_daddr(bp),
> 
> here
> 
> >   				BBTOB(bp->b_length),
> >   				(unsigned long long)bkey->blkno,
> >   				BBTOB(bkey->bblen));
> > @@ -230,7 +230,7 @@ __initbuf(struct xfs_buf *bp, struct xfs_buftarg *btp, xfs_daddr_t bno,
> >   		unsigned int bytes)
> >   {
> >   	bp->b_flags = 0;
> > -	bp->b_bn = bno;
> > +	bp->b_cache_key = bno;
> >   	bp->b_length = BTOBB(bytes);
> >   	bp->b_target = btp;
> >   	bp->b_mount = btp->bt_mount;
> > @@ -256,7 +256,7 @@ __initbuf(struct xfs_buf *bp, struct xfs_buftarg *btp, xfs_daddr_t bno,
> >   	if (bp->b_maps == &bp->__b_map) {
> >   		bp->b_nmaps = 1;
> > -		bp->b_maps[0].bm_bn = bp->b_bn;
> > +		bp->b_maps[0].bm_bn = bno;
> >   		bp->b_maps[0].bm_len = bp->b_length;
> >   	}
> >   }
> > @@ -591,7 +591,7 @@ libxfs_readbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno, struct xfs_buf *bp,
> >   	error = __read_buf(fd, bp->b_addr, bytes, LIBXFS_BBTOOFF64(blkno), flags);
> >   	if (!error &&
> >   	    bp->b_target->bt_bdev == btp->bt_bdev &&
> > -	    bp->b_bn == blkno &&
> > +	    bp->b_cache_key == blkno &&
> >   	    bp->b_length == len)
> >   		bp->b_flags |= LIBXFS_B_UPTODATE;
> >   	bp->b_error = error;
> > @@ -833,14 +833,14 @@ libxfs_bwrite(
> >   			fprintf(stderr,
> >   	_("%s: write verifier failed on %s bno 0x%llx/0x%x\n"),
> >   				__func__, bp->b_ops->name,
> > -				(long long)bp->b_bn, bp->b_length);
> > +				(long long)xfs_buf_daddr(bp), bp->b_length);
> 
> here
> 
> >   			return bp->b_error;
> >   		}
> >   	}
> >   	if (!(bp->b_flags & LIBXFS_B_DISCONTIG)) {
> >   		bp->b_error = __write_buf(fd, bp->b_addr, BBTOB(bp->b_length),
> > -				    LIBXFS_BBTOOFF64(bp->b_bn), bp->b_flags);
> > +				    LIBXFS_BBTOOFF64(xfs_buf_daddr(bp)), bp->b_flags);
> 
> here
> 
> >   	} else {
> >   		int	i;
> >   		void	*buf = bp->b_addr;
> > @@ -861,7 +861,7 @@ libxfs_bwrite(
> >   		fprintf(stderr,
> >   	_("%s: write failed on %s bno 0x%llx/0x%x, err=%d\n"),
> >   			__func__, bp->b_ops ? bp->b_ops->name : "(unknown)",
> > -			(long long)bp->b_bn, bp->b_length, -bp->b_error);
> > +			(long long)xfs_buf_daddr(bp), bp->b_length, -bp->b_error);
> 
> and here
> 
> >   	} else {
> >   		bp->b_flags |= LIBXFS_B_UPTODATE;
> >   		bp->b_flags &= ~(LIBXFS_B_DIRTY | LIBXFS_B_UNCHECKED);
> > 
