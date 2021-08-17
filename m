Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 394C7C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 23:56:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F6FF600D4
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 23:56:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236871AbhHQX4o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Aug 2021 19:56:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236831AbhHQX4n (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Aug 2021 19:56:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA57A600D4;
        Tue, 17 Aug 2021 23:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629244569;
        bh=+TBE+Ra4CSJMZoZ1LSQckuicRLbC3IHUR6GYCKeVpTY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uAam8PGqGkAe+9LHDLtrlEtBLbGjdMYd7suApKXJvDdoQqK89BFPSPe8/EI7Jih89
         2l9+q3cWzOM0OePm5hj0sjfE8ypy5rFJYT9Mfc9KVsZccieqUGICSqj+ZbEhsxFyje
         4cUArjpzZNMcwHTH2SYiTBvARikoNcLEDczcg6VgmuPYHTg7eT0F1N8nF7G3O5wQcZ
         heti0faUVHvc5QDFKq4FsdJ/BEM2yS3qb5vUUi5KowRLypu59ps8/pEpxzIk7dC4QC
         ub5q5TuxTONLTF1bhnGS+Tsr73avtcsBHhql3ZZUh2NmHYQEH9oU9cnlob+2Bn0NCd
         toXYCxVADaU8A==
Date:   Tue, 17 Aug 2021 16:56:09 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: rename buffer cache index variable b_bn
Message-ID: <20210817235609.GF12640@magnolia>
References: <20210810052851.42312-1-david@fromorbit.com>
 <20210810052851.42312-4-david@fromorbit.com>
 <20210811004632.GA3601443@magnolia>
 <20210817234827.GK3657114@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210817234827.GK3657114@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 18, 2021 at 09:48:27AM +1000, Dave Chinner wrote:
> On Tue, Aug 10, 2021 at 05:46:32PM -0700, Darrick J. Wong wrote:
> > On Tue, Aug 10, 2021 at 03:28:51PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > TO stop external users from using b_bn as the disk address of the
> > > buffer, rename it to b_index to indicate that it is the buffer cache
> > > index, not the block number of the buffer. Code that needs the disk
> > > address should use xfs_buf_daddr() to obtain it.
> > > 
> > > Do the rename and clean up any of the remaining b_bn cruft that is
> > > left over and is now unused.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/xfs_buf.c | 19 +++++++++++--------
> > >  fs/xfs/xfs_buf.h | 18 +-----------------
> > >  2 files changed, 12 insertions(+), 25 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > > index c1bb6e41595b..6f6c6937baaa 100644
> > > --- a/fs/xfs/xfs_buf.c
> > > +++ b/fs/xfs/xfs_buf.c
> > > @@ -251,7 +251,7 @@ _xfs_buf_alloc(
> > >  		return error;
> > >  	}
> > >  
> > > -	bp->b_bn = map[0].bm_bn;
> > > +	bp->b_index = map[0].bm_bn;
> > >  	bp->b_length = 0;
> > >  	for (i = 0; i < nmaps; i++) {
> > >  		bp->b_maps[i].bm_bn = map[i].bm_bn;
> > > @@ -459,7 +459,7 @@ _xfs_buf_obj_cmp(
> > >  	 */
> > >  	BUILD_BUG_ON(offsetof(struct xfs_buf_map, bm_bn) != 0);
> > >  
> > > -	if (bp->b_bn != map->bm_bn)
> > > +	if (bp->b_index != map->bm_bn)
> > >  		return 1;
> > >  
> > >  	if (unlikely(bp->b_length != map->bm_len)) {
> > > @@ -481,7 +481,7 @@ static const struct rhashtable_params xfs_buf_hash_params = {
> > >  	.min_size		= 32,	/* empty AGs have minimal footprint */
> > >  	.nelem_hint		= 16,
> > >  	.key_len		= sizeof(xfs_daddr_t),
> > > -	.key_offset		= offsetof(struct xfs_buf, b_bn),
> > > +	.key_offset		= offsetof(struct xfs_buf, b_index),
> > 
> > I would've called this field b_rhash_key, since "index" is a kind of
> > vague.
> 
> Ok.
> 
> > > @@ -875,7 +877,7 @@ xfs_buf_read_uncached(
> > >  
> > >  	/* set up the buffer for a read IO */
> > >  	ASSERT(bp->b_map_count == 1);
> > > -	bp->b_bn = XFS_BUF_DADDR_NULL;  /* always null for uncached buffers */
> > > +	bp->b_index = XFS_BUF_DADDR_NULL;
> > >  	bp->b_maps[0].bm_bn = daddr;
> > >  	bp->b_flags |= XBF_READ;
> > >  	bp->b_ops = ops;
> > > @@ -1513,7 +1515,7 @@ _xfs_buf_ioapply(
> > >  						   SHUTDOWN_CORRUPT_INCORE);
> > >  				return;
> > >  			}
> > > -		} else if (bp->b_bn != XFS_BUF_DADDR_NULL) {
> > > +		} else if (bp->b_index != XFS_BUF_DADDR_NULL) {
> > >  			struct xfs_mount *mp = bp->b_mount;
> > >  
> > >  			/*
> > > @@ -1523,7 +1525,8 @@ _xfs_buf_ioapply(
> > >  			if (xfs_has_crc(mp)) {
> > >  				xfs_warn(mp,
> > >  					"%s: no buf ops on daddr 0x%llx len %d",
> > > -					__func__, bp->b_bn, bp->b_length);
> > > +					__func__, xfs_buf_daddr(bp),
> > > +					bp->b_length);
> > >  				xfs_hex_dump(bp->b_addr,
> > >  						XFS_CORRUPTION_DUMP_LEN);
> > >  				dump_stack();
> > > @@ -1793,7 +1796,7 @@ xfs_buftarg_drain(
> > >  				xfs_buf_alert_ratelimited(bp,
> > >  					"XFS: Corruption Alert",
> > >  "Corruption Alert: Buffer at daddr 0x%llx had permanent write failures!",
> > > -					(long long)bp->b_bn);
> > > +					(long long)xfs_buf_daddr(bp));
> > 
> > These belong in the previous patch, right?
> 
> Depends on your POV. This patch cleans up all the internal (mis)uses of
> b_bn, while the previous patches addressed all the external uses.
> The mods could be in either, I just chose to split internal/external
> modification based on the file rather than on the specific (ab)use
> being corrected....

<nod> Ok then.  Would you mind noting that in the commit message with
something along the lines of "...and convert internal users."?  My brain
is likely to fall out before you repost this patch. :/

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
