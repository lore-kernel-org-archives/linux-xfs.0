Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79383A9635;
	Fri, 21 Aug 2026 22:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787350817; cv=none; b=HU9KRQxtqnbDcjPUu0HR+0l2/6zpfk2eF0nzQmb0tIFPcUnEzW78PEnL7zFTxnxs9Y/cFaIDi/2sxieh1KxXWkpvTRs6CGHrh9mgYi+5VbM05BoM7uQWHO9NguNtlpwThGbkdynHOToHU6cGDBH1Y2GFbPFALbp3ueiRxRSihP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787350817; c=relaxed/simple;
	bh=RUvF+1ZQvjubaa5vPe7qI4BVpNavFri+/1Rsr8o9Zck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PIcGdFint9taUQq1kSlxE8VyH0EQFgrvg+fyhbOXBgumS+wRFP8bcUMYY1Lox8j50b77Irm1Qe+pLAfGlVDGD/ftHSHk4dRbuUa6JSYL8VhmzlQo3Mrd4bVJCgAmVGia7inM1uZJZQolXgpillD71obGOeSuW/H8cx+Hh/EGi9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kYhBnCNE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kYhBnCNE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FCD41F000E9;
	Fri, 21 Aug 2026 22:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787350814;
	bh=uK2hKM9vaLjBixO/WCDlJAXWhYvcTU7mSMuiKUtfzFo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kYhBnCNERk+J4lROvqtSW0Jrx+9dwe3BACWpwtns1sH0+RVe9AEr/u9hGFm/7doJR
	 kzbOohtKjJbHGOaS3UEl3FclkITGFZ9dEAtXC+HyKdj8yEXPUo72zM/MZBnP1jjNie
	 Rm4rS3IDHmirZ1guUs6MlA4amMIOESUmzcd61XtIeiVTBx96g4SqY8q2qLv6Y853XJ
	 Vbnuc2gfRWX7husdsn3Cl0IZNxNdRkOU0TINWzVLEBNPBYV0xTLeOUq7szvCqk5a8V
	 wP4SIyqxWy0dVQ6OG5q8bUtDDufsLE1IJMhkIKaglWOHS+HbRNFViSbFYeVm4Q7vZ8
	 44K0z/cZ9+EBQ==
Date: Sat, 22 Aug 2026 08:20:05 +1000
From: Dave Chinner <dgc@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: "Anthony Vardaro (Anthropic)" <me@anthonyvardaro.com>,
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: revalidate cached COW fork mappings during writeback
Message-ID: <aojPFYhD4SNPv30o@dread>
References: <20260820-b4-xfs-cow-wb-revalidate-v1-1-8a19080799ea@anthonyvardaro.com>
 <20260820161123.GH6072@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260820161123.GH6072@frogsfrogsfrogs>

On Thu, Aug 20, 2026 at 09:11:23AM -0700, Darrick J. Wong wrote:
> On Thu, Aug 20, 2026 at 12:21:38AM +0000, Anthony Vardaro (Anthropic) wrote:
> > Writeback can write a folio through a cached COW fork mapping after the
> > blocks behind it have been freed. Since commit d9252d526ba6 ("xfs:
> > validate writeback mapping using data fork seq counter") a cached data
> > fork mapping is dropped when the fork changes, but a COW fork mapping is
> > accepted on range alone, and since commit 3b3508980730 ("xfs: remove
> > superfluous writeback mapping eof trimming") nothing trims it to EOF. So
> > when close() or truncate frees the post-EOF COW blocks and the file is
> > then appended, the same writeback pass writes the new folio into blocks
> > the inode no longer owns. fsync() returns 0 and the range reads back as
> > zeroes, or the data lands in another file.

Have you reproduced this and tested that it the change actually
fixes the supposed bug?

> > Check cow_seq against the COW fork if_seq for COW mappings as well, and
> > only sample cow_seq where the mapping is built so a failed conversion
> > cannot pair a stale mapping with a fresh sequence number.
> > 
> > This costs one extent lookup and one cancelled transaction per
> > invalidation: about 5% more fsync time on random 4k overwrites of a
> > reflinked file, nothing measurable on sequential writeback.
> > 
> > Fixes: d9252d526ba6 ("xfs: validate writeback mapping using data fork seq counter")
> > Cc: stable@vger.kernel.org # v5.1
> > Assisted-by: Claude:unspecified
> > Signed-off-by: Anthony Vardaro (Anthropic) <me@anthonyvardaro.com>
> > ---
> > An fstests case for this, using the wb_delay_ms error injection knob,
> > follows separately.
> > 
> > Backport note: kernels before v6.2 do not have
> > trace_xfs_wb_cow_iomap_invalid() (added by commit c2beff99eb03), so
> > drop that call there. Kernels before v5.5 test wpc->fork ==
> > XFS_COW_FORK instead of IOMAP_F_SHARED and have no XFS_WPC().
> > ---
> >  fs/xfs/xfs_aops.c | 29 ++++++++++++++++++-----------
> >  1 file changed, 18 insertions(+), 11 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > index 2a0c54256..c043e5bad 100644
> > --- a/fs/xfs/xfs_aops.c
> > +++ b/fs/xfs/xfs_aops.c
> > @@ -304,12 +304,22 @@ xfs_imap_valid(
> >  	    offset >= wpc->iomap.offset + wpc->iomap.length)
> >  		return false;
> >  	/*
> > -	 * If this is a COW mapping, it is sufficient to check that the mapping
> > -	 * covers the offset. Be careful to check this first because the caller
> > -	 * can revalidate a COW mapping without updating the data seqno.
> > +	 * A COW mapping is only valid while the COW fork is unchanged. After a
> > +	 * change, the blocks behind the mapping can already be freed, for
> > +	 * example by the post-EOF trim on close. Do this check before the
> > +	 * data fork check, because the caller can revalidate a COW mapping
> > +	 * without updating the data seqno.
> >  	 */
> > -	if (wpc->iomap.flags & IOMAP_F_SHARED)
> > +	if (wpc->iomap.flags & IOMAP_F_SHARED) {
> > +		if (!ip->i_cowfp)
> > +			return false;
> > +		if (XFS_WPC(wpc)->cow_seq != READ_ONCE(ip->i_cowfp->if_seq)) {
> 
> The buffered write path has similar data/cow fork sequence counter
> revalidation code, so would it be a better idea to adapt the writeback
> path to sample the sequence counter via xfs_iomap_inode_sequence in
> xfs_map_blocks, and re-check that in xfs_imap_valid()?

Hmmmm - looking at the rest of the function, I think that using
xfs_iomap_inode_sequence() will potentially introduce a new bug...

The code 10 lines below for non-shared iomap validity
unconditionally checks the COW fork sequence number  if
xfs_inode_has_cow_data() returns true.

The code above is essentially makes it:

	if (IOMAP_F_SHARED) {
		if (!xfs_inode_has_cow_data())
			return false;
		/* check cow sequence */
		return ....
	}

	/* check data sequence */

	if (xfs_inode_has_cow_data())
		/* check cow sequence */

	return ...

IOWs, adding the seqeunce check to the SHARED iomap means we
-always- check the COW_FORK sequence number now if
xfs_inode_has_cow_data() returns true. i.e.

	if (xfs_inode_has_cow_data()) {
		/* check cow sequence */
	}
	if (IOMAP_F_SHARED)
		return false;

	/* check data sequence */

And with this, it should be obvious now why using I suspect
xfs_iomap_inode_sequence() could introduce new problems - it only
encodes the cow fork sequence number if IOMAP_F_SHARED is set.

However, looking at the reworked logic above, I think this uncovers
another bug, this one in xfs_map_blocks(). That is, xfs_map_blocks()
never samples the COW fork sequence number on pure data fork
writeback on xfs_inode_has_cow_data() inodes. Hence the "always
check the cow-fork sequence" on pure data overwrites -always- fails
on inodes with mixed data/cow overwrites, even when the cached
extent is still valid.....

So, before a fix is made, we need to decide what the correct
behaviour is for writeback on mixed mode inodes. Given the imapct of
getting this wrong, I think that should be unconditionally tossing
the cached iomap if either the cow fork or data fork changes. That
makes for simple logic, and it covers all cases where a racing
change could potentially cause an issue....

-Dave.
-- 
Dave Chinner
dgc@kernel.org
