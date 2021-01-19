Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABD28C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 19:44:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6585823138
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 19:44:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730025AbhASToh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 14:44:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:48868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729920AbhASToZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Jan 2021 14:44:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A9FA22E01;
        Tue, 19 Jan 2021 19:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611085418;
        bh=FH1rEzG06KAEra3v3qdb67Hc2s9TGBl0wq2Z6aSPgjM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vHyolb2iyRksd6kLsmoprTDThfthOPhZxsig0PFQyXripm/qgARII21J/q79iSBBF
         BObLAGNwnIb/C6oY4roybJTJsww3KNII5q+YukIFKPkbT0LtQI2Rd5Kn0e389OoPUh
         Dt3SwWmD1UPAb9IR/FBp3M4uxB2mhOl3XprKx8J5JBK36rjikahXlhIIbdCcR5Iu19
         L4XP8WV2Gl4glIw9TB/vr8FszBjXeOxOqkAD1kY+zdNt9rRPJnq3R9Z3WKgc1KGEco
         cmyGTEwZHt39fnS2+33OYQh1Pn4Vofz08sDtz6OSwZ89MWhn1MXtAYDF5KQyo5svsS
         CHYEvyhuuL7DQ==
Date:   Tue, 19 Jan 2021 11:43:37 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/11] xfs: flush eof/cowblocks if we can't reserve quota
 for file blocks
Message-ID: <20210119194337.GQ3134581@magnolia>
References: <161100791789.88816.10902093186807310995.stgit@magnolia>
 <161100795124.88816.6644776235251695171.stgit@magnolia>
 <YAaFfUxZjXAabnoV@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAaFfUxZjXAabnoV@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 19, 2021 at 08:08:45AM +0100, Christoph Hellwig wrote:
> > @@ -351,13 +351,14 @@ xfs_reflink_allocate_cow(
> >  	bool			convert_now)
> >  {
> >  	struct xfs_mount	*mp = ip->i_mount;
> > +	struct xfs_trans	*tp;
> >  	xfs_fileoff_t		offset_fsb = imap->br_startoff;
> >  	xfs_filblks_t		count_fsb = imap->br_blockcount;
> > -	struct xfs_trans	*tp;
> > -	int			nimaps, error = 0;
> > -	bool			found;
> >  	xfs_filblks_t		resaligned;
> >  	xfs_extlen_t		resblks = 0;
> > +	bool			found;
> > +	bool			quota_retry = false;
> > +	int			nimaps, error = 0;
> 
> Any good reason for reshuffling the declarations here?
> 
> > +	if (error) {
> > +		/* This function must return with the ILOCK held. */
> > +		xfs_ilock(ip, *lockmode);
> > +		return error;
> > +	}
> 
> Ugg.

Yeah.  I can't think of a good (as in non-brain-straining) way to fix
this unusual locking -- this function can be called with the ILOCK held,
and it's possible that we then find what we are looking for due to a
speculative preallocation and can exit without cycling the lock.

I think what we really want is for xfs_direct_write_iomap_begin to call
xfs_find_trim_cow_extent and xfs_reflink_convert_cow_locked directly,
and if the first call doesn't find a cow staging extent then drop the
ILOCK, call xfs_reflink_allocate_cow, and re-take the ILOCK after.

> > +	if (error) {
> > +		xfs_trans_cancel(*tpp);
> > +		*tpp = NULL;
> > +		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > +	}
> > +
> > +	/* We only allow one retry for EDQUOT/ENOSPC. */
> > +	if (*retry || (error != -EDQUOT && error != -ENOSPC)) {
> > +		*retry = false;
> > +		return error;
> > +	}
> 
> Id really don't like the semantics where this wrapper unlocks the
> ilock.  Keeping all the locking at one layer, which is the callers
> makes the code much easier to reason about
> 
> > +
> > +	/* Try to free some quota for this file's dquots. */
> > +	err2 = xfs_blockgc_free_quota(ip, 0, retry);
> > +	if (err2)
> > +		return err2;
> > +	return *retry ? 0 : error;
> >  }
> 
> Why not have a should_retry helper for the callers and let them call
> xfs_blockgc_free_quota?  That is a little more boilerplate code, but
> a lot less obsfucated.

The previous version of this patchset did that, but Dave complained that
spread the retry calls and error/retry branching all over the code base
and asked for the structure that's in this version:

https://lore.kernel.org/linux-xfs/161040735389.1582114.15084485390769234805.stgit@magnolia/T/#mfcd6786f99791adf771697416fc51d168d3050f8

--D
