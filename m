Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920A5442F
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 00:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728950537; cv=none; b=ItM6/S7J6B4v6P68qAaDJgNPwdJNi9Wn6Td8lH/sOaUlxEBw/ZueaukYGD9bPZG9/5s2UZMQntECZhjkyCi5gwzXKS4U6MgkkDc+T7mUv7E6OnSmdvFPObji05e+cwbGHAPCdPd8xWgqc309DwU0pV5PRFZgT5tzv2BEtKwGm2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728950537; c=relaxed/simple;
	bh=B/Aj2ZRWnFIfILP2onkkd/Cm4bRo/6Q1r6K8aFodMJU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mnc4sjOE/lLdsIO7nVvCToh7PAO0QUkfF1NjynnqhOBl5KZiqGE0HNRgZQmCMa5u2dqt9x4zCy0KHcwJKmdElD9gsqM6oWG7qUKm72UDas1uaUJndIOXF1Ry7vXbxsURK1xewKZUouralmCsUIdmwz+Tv0DpG9kOBqgxJXhmX7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lbktKGU4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lbktKGU4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11139C4CEC7;
	Tue, 15 Oct 2024 00:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728950537;
	bh=B/Aj2ZRWnFIfILP2onkkd/Cm4bRo/6Q1r6K8aFodMJU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lbktKGU4MXHl5y3e5W9YF/SqezsX2hBM3UfgAeEegzE7OQvNwDhc3eXiWuKNnToZ9
	 tD7j0OwuplEdAHMJ1XwGd2ik/KFnpcGmwh9YgmrVzbhVi8wWWYy8A15VFh2bS2c3HC
	 sfWs3W+i8y2UCkyxuDQ2UlBf2qhV5NMogjKxlhEn0BRC2zSmcd/jmsLKHgeoCA2d8/
	 Q+lb4mdatqmDPdjCnpyNJJdhnPK3ZrwUyd4dBCwiamnPT1RH40kZ6tVTdmAUvxQP1n
	 KPu2/Jp34ezpsoh4Jr6KJOSwuAf2Ac9n4AAxy15Sd6GOkKc80VyxqQQ12fZsSOtaZx
	 GMSJMHP9Wdbrw==
Date: Mon, 14 Oct 2024 17:02:16 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 15/36] xfs: store rtgroup information with a bmap intent
Message-ID: <20241015000216.GJ21853@frogsfrogsfrogs>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
 <172860644500.4178701.5897856828553646962.stgit@frogsfrogsfrogs>
 <ZwzQcYRPCPAchgjY@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwzQcYRPCPAchgjY@infradead.org>

On Mon, Oct 14, 2024 at 01:04:01AM -0700, Christoph Hellwig wrote:
> The actual intent code looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> but while re-reviewing I noticed a minor thing in the tracing code:
> 
> > +		__entry->dev = mp->m_super->s_dev;
> > +		__entry->type = bi->bi_group->xg_type;
> > +		__entry->agno = bi->bi_group->xg_index;
> > +		switch (__entry->type) {
> > +		case XG_TYPE_RTG:
> > +			/*
> > +			 * Use the 64-bit version of xfs_rtb_to_rgbno because
> > +			 * legacy rt filesystems can have group block numbers
> > +			 * that exceed the size of an xfs_rgblock_t.
> > +			 */
> > +			__entry->gbno = __xfs_rtb_to_rgbno(mp,
> >  						bi->bi_bmap.br_startblock);
> > +			break;
> > +		case XG_TYPE_AG:
> > +			__entry->gbno = XFS_FSB_TO_AGBNO(mp,
> >  						bi->bi_bmap.br_startblock);
> > +			break;
> > +		default:
> > +			/* should never happen */
> > +			__entry->gbno = -1ULL;
> > +			break;
> 
> Maybe just make this an
> 
> 		if (type == XG_TYPE_RTG)
> 			__xfs_rtb_to_rgbno()
> 		else
> 			xfs_fsb_to_gbno()
> 
> ?

Hmmm that *would* get rid of that __entry->gbno = -1ULL ugliness above.

Ok let's do it.

Until we get to patch, the helper looks like:

xfs_agblock_t
xfs_fsb_to_gbno(
	struct xfs_mount	*mp,
	xfs_fsblock_t		fsbno,
	enum xfs_group_type	type)
{
	if (type == XG_TYPE_RTG)
		return xfs_rtb_to_rgbno(mp, fsbno);
	return XFS_FSB_TO_AGBNO(mp, fsbno);
}

and the tracepoint code become:

		__entry->type = bi->bi_group->xg_type;
		__entry->agno = bi->bi_group->xg_index;
		if (bi->bi_group->xg_type == XG_TYPE_RTG &&
		    !xfs_has_rtgroups(mp)) {
			/*
			 * Legacy rt filesystems do not have allocation
			 * groups ondisk.  We emulate this incore with
			 * one gigantic rtgroup whose size can exceed a
			 * 32-bit block number.  For this tracepoint, we
			 * report group 0 and a 64-bit group block
			 * number.
			 */
			__entry->gbno = bi->bi_bmap.br_startblock;
		} else {
			__entry->gbno = xfs_fsb_to_gbno(mp,
						bi->bi_bmap.br_startblock,
						bi->bi_group->xg_type);
		}
		__entry->ino = ip->i_ino;

--D

> >  		  __entry->l_len,
> > 
> > 
> ---end quoted text---
> 
