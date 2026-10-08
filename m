Received: from mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF98D4908A7
	for <linux-xfs@vger.kernel.org>; Thu,  8 Oct 2026 10:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791454932; cv=none; b=lUxBg6ACZBiSRcUmtE2KoWPXFf71TMqzh7VDkxbd1PtEGNl74KGF4lBJ8qV+r8hfrwBZ/NmPSHFHQOsWJscYaMoEqYfIDVm2sJPVXl+cH3oHbOkdCrP93OUAuoA7zGYyynwZvBfAM/U3mfGvbteVh3/yQwjUEwcmoJSA3zdPU2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791454932; c=relaxed/simple;
	bh=NnFhpGGhwKsDqd90QEZdd2mC8ziwmifhoxhpik0HUHc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c7G1rXgtrBQTTzYnJwC2QjRB5/uQupU2IaDHqFFVQi99wqPX3HQAViOfgmrzbkAaf11yYLiRHkIGvgcwHWZlKs/rTH4kE+qSaP5inR9lBQIEnU8n/9abho1WunYH4BV36yeyyuo8ZPgeSp1+EHLQOmJcvNL6JfNQXAPixRe9+wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=X1uzpjFF; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="X1uzpjFF"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=NnFhpGGhwKsDqd90QEZdd2mC8ziwmifhoxhpik0HUHc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791454927; v=1; x=1792059727;
 b=X1uzpjFFSxbnCQJuw8etSHm/4SnP97Ke1AEYeTaVJOTJU290kr27bsffmWP4FxDdyv72C2wE
 ks7S7RzlgxSy8a4eFKZJdJZxzFFiH4psI7Oa7AJcS/2cVwVy+6jsLcvEZvBl2BebehcK9UyVBDe
 GZNGUl1KR3n8KsUT0JzUZm2k=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 2f0541ac974b7176;
	Thu, 08 Oct 2026 10:22:07 +0000
X-Mizu-Trace-ID: 2f0541ac974b7176
X-Migadu-Flow: FLOW_OUT
Date: Thu, 8 Oct 2026 10:21:59 +0000
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>, cem@kernel.org, 
	linux-xfs@vger.kernel.org, John Garry <john.g.garry@oracle.com>, gost.dev@samsung.com
Subject: Re: [PATCH v2] xfs: don't limit software atomic writes by the group
 alignment
Message-ID: <ffuis77pmcaqivjcpy2audxaakqwrbdvrz2enu3tqphjg3ppm6@ynj2mto22zgu>
References: <20261007101425.3741087-1-p.raghav@samsung.com>
 <20261007184050.GL2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007184050.GL2705364@frogsfrogsfrogs>

> > +	if (g->blocks == 0)
> > +		return 0;
> > +	return max_pow_of_two_factor(g->blocks);
> 
> Don't we need to retain the btp && btp->bt_awu_min > 0 test here?
> 
> Hmm.  I guess the caller effectively does this:
> 
> 	const unsigned int	sw_awu_max =
> 		xfs_get_atomic_write_max(ip);
> 
> 	/* if the max is 1x block, then just keep behaviour that opt is 0 */
> 	if (sw_awu_max <= ip->i_mount->m_sb.sb_blocksize)
> 		return 0;
> 
> 	const unsigned int	hw_awu_max =
> 		xfs_inode_buftarg(ip)->bt_awu_max);
> 	const unsigned int	hw_align_max =
> 		xfs_calc_group_awu_align_max(mp,
> 					xfs_inode_group_type(ip));
> 
> 	/*
> 	 * The optimal atomic write size is the minimum of the software
> 	 * fallback, the hardware capability, and the biggest aligned
> 	 * extent that the per-AG allocator can give us.
> 	 */
> 	return min3(sw_awu_max, hw_awu_max, XFS_FSB_TO_B(hw_align_max));
> 
> So no, we really don't need to check bt_awu_min?

Yeah, I don't think so. I think the above checks should take care of all
corner cases.

> 
> I also sorta wish that third assignment had its own helper:
> 
> static inline unsigned int
> xfs_get_atomic_hw_write_align(
> 	const struct xfs_inode	*ip)
> {
> 	struct xfs_mount	*mp = ip->i_mount;
> 
> 	return XFS_FSB_TO_B(mp, xfs_calc_group_awu_align_max(mp,
> 					xfs_inode_group_type(ip)));
> }
> 
> But now I'm really just nitpicking. :P
> 

Thanks a lot for the review. I will send a new version.

-- 
Pankaj
