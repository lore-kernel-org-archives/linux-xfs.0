Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423731FC7EC
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 18:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729015879; cv=none; b=tDlKaSzh9w1PvRBPnheL7FqakK4xQ7SRdVdfGh4UXxsf9vA70ND3zI8uPJZG6V5Fy6Gaux6pf9Qna2svazgoiwREGUJy7927DZCXkVdSOut8EXJ3a4tOpthgOR6m9+5fJLyt6ow3Oy4EuXce9e2Z8BKIovFOE+xZpnLmVKJQnUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729015879; c=relaxed/simple;
	bh=o70Vzthl8EBZUjF8j/q9GpWvbIh1QqBCIou9wbgLbEk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FxPdl1agfPhQA8NqKltZX069CGaDEMD7AE4ttUj82pNrHigQHkGegaSNEnDie3a7LG4B4BN+StCe728MSWZfW8TnEf4IKLnNFYEmDP6weO9srNJgomV6yJUUnlCZVOzTrnA1935qE0ASealx+c8b4uO8UEcNt8b0f2Al8Avr2T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QIgATkUS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QIgATkUS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9775C4CEC6;
	Tue, 15 Oct 2024 18:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729015878;
	bh=o70Vzthl8EBZUjF8j/q9GpWvbIh1QqBCIou9wbgLbEk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QIgATkUSYxmEAjUBevQbMwF58XHxyHrHe7+N+7M11g70IKRJom6hP8M/FDxBUa5iz
	 stY1GhjnMzVw/rf6sRa4lJ777kI8B3Rnr8wS4bK6Pjc54TxtHjKGMsJ63BAkNg5YFx
	 zEkG/L73A8lAVUEPFfHVmKcLoMspAX3Ht1NPJyqTQurhxt4CKNUvLUHkzPgVw8NShm
	 TvPImNr/4eez1T75aT8uxn+WICVgRzyfbApkfwP4sj8VJR5GNJDwsHrDOyEAxa3K3f
	 o/kzNpKTskRW3Pn4p3hHiOaI/zUPDS86hdIvgs17a2KC0/tOudSxRpvcN6Qt00tvqJ
	 TwbZzMPPSI81A==
Date: Tue, 15 Oct 2024 11:11:18 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/16] xfs: add a generic group pointer to the btree
 cursor
Message-ID: <20241015181118.GD21853@frogsfrogsfrogs>
References: <172860641207.4176300.780787546464458623.stgit@frogsfrogsfrogs>
 <172860641471.4176300.17811783731579673565.stgit@frogsfrogsfrogs>
 <Zw3b9lD12fK0Y6Pn@dread.disaster.area>
 <20241015033339.GA15911@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241015033339.GA15911@lst.de>

On Tue, Oct 15, 2024 at 05:33:39AM +0200, Christoph Hellwig wrote:
> On Tue, Oct 15, 2024 at 02:05:26PM +1100, Dave Chinner wrote:
> > > +		cur->bc_ops->name, cur->bc_group->xg_index, fa);
> >                                    ^^^^^^^^^^^^^^^^^^^^^^^
> > 
> > Reading through this patch, I keep wanting to this to read as "group
> > number" as a replacement for AG number. i.e. pag_agno(pag) ->
> > group_num(grp) as the nice, short helper function.
> > 
> > We're kinda used to this with terminology with agno, agbno, fsbno,
> > ino, agino, etc all refering to the "number" associated with an
> > object type.  Hence it seems kinda natural to refer to these as
> > group numbers rather than an index into something....
> > 
> > Just an observation, up to you whether you think it's worthwhile or
> > not.
> 
> Or just rename xg_index to xg_gno.  I though I was smart about the
> index when I did this a while ago, but in hinsight it might not have
> been the best choice.

It's probably easier to change it to xg_gno along with all the other
patch sedding.

--D

> > >  STATIC struct xfs_btree_cur *
> > > @@ -36,29 +36,29 @@ xfs_cntbt_dup_cursor(
> > >  	struct xfs_btree_cur	*cur)
> > >  {
> > >  	return xfs_cntbt_init_cursor(cur->bc_mp, cur->bc_tp, cur->bc_ag.agbp,
> > > -			cur->bc_ag.pag);
> > > +			to_perag(cur->bc_group));
> > >  }
> > 
> > Huh. Less than ideal code will be generated for these (group on old
> > cursor -> perag -> back to group in new cursor) code, but converting
> > every single bit of the btree cursor code over to groups doesn't
> > need to be done here...
> 
> We've actually done the cursor init cleanup for the RT rmap and reflink
> btrees (not in this patchbomb yet), and I though about doing it for
> the classic per-AG btrees as well.  I can do that as a follow up.
> 
> 
