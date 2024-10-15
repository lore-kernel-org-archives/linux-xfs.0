Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B57170828
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 03:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728963226; cv=none; b=aG7/8czLuT/Eg06/mlm2xVzmp7pJimCLOFd2pxseuvMR7ixBds93KnsTmDB/E3sNsZq02BOpioPxL0exZ3upkfi0jAJhGoADHLcWLfR5H+HB69FGXBjc/3yEuGsF5GIE9rRUU2I0NuQEC66XqC9czxSrF0K4nk0eUTN5aOZ4Q/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728963226; c=relaxed/simple;
	bh=vVmaaZHx6wCXSYs6OXfQm4PqIGcUw7LLcQ4qZgSJnO0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LkGyvwvVr+91WhVSDpcA/EHHbvZ0y3Kjrfi06bBuzd3A93cNxpZW+a957I2pCN5lQYiT2KHN3H0ye3tljIVF2S8hbgLW1AGpyEsJFOh2QgR1rTP5GcszKA1WVCYFlReNTrUR8gKkN3QJi6NQGKtf+Vqeh3fxhRJI2A7sdF77/lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 72C84227AA8; Tue, 15 Oct 2024 05:33:39 +0200 (CEST)
Date: Tue, 15 Oct 2024 05:33:39 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 12/16] xfs: add a generic group pointer to the btree
 cursor
Message-ID: <20241015033339.GA15911@lst.de>
References: <172860641207.4176300.780787546464458623.stgit@frogsfrogsfrogs> <172860641471.4176300.17811783731579673565.stgit@frogsfrogsfrogs> <Zw3b9lD12fK0Y6Pn@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zw3b9lD12fK0Y6Pn@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 15, 2024 at 02:05:26PM +1100, Dave Chinner wrote:
> > +		cur->bc_ops->name, cur->bc_group->xg_index, fa);
>                                    ^^^^^^^^^^^^^^^^^^^^^^^
> 
> Reading through this patch, I keep wanting to this to read as "group
> number" as a replacement for AG number. i.e. pag_agno(pag) ->
> group_num(grp) as the nice, short helper function.
> 
> We're kinda used to this with terminology with agno, agbno, fsbno,
> ino, agino, etc all refering to the "number" associated with an
> object type.  Hence it seems kinda natural to refer to these as
> group numbers rather than an index into something....
> 
> Just an observation, up to you whether you think it's worthwhile or
> not.

Or just rename xg_index to xg_gno.  I though I was smart about the
index when I did this a while ago, but in hinsight it might not have
been the best choice.

> >  STATIC struct xfs_btree_cur *
> > @@ -36,29 +36,29 @@ xfs_cntbt_dup_cursor(
> >  	struct xfs_btree_cur	*cur)
> >  {
> >  	return xfs_cntbt_init_cursor(cur->bc_mp, cur->bc_tp, cur->bc_ag.agbp,
> > -			cur->bc_ag.pag);
> > +			to_perag(cur->bc_group));
> >  }
> 
> Huh. Less than ideal code will be generated for these (group on old
> cursor -> perag -> back to group in new cursor) code, but converting
> every single bit of the btree cursor code over to groups doesn't
> need to be done here...

We've actually done the cursor init cleanup for the RT rmap and reflink
btrees (not in this patchbomb yet), and I though about doing it for
the classic per-AG btrees as well.  I can do that as a follow up.

