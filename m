Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D91F632
	for <linux-xfs@vger.kernel.org>; Sun, 27 Sep 2026 00:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790467308; cv=none; b=QCs4K52ZtYTI8/z+x9msvaf/fYslrmlkKyPU2doIdJG/nV3ojrHg/3wsDC5ZzscQlRQQm+KHfgN2aH0c/MG5zXx8X7eHqaUNsAYSAfNqTr+FXwdJQnNAxysJOOWEuHhp2xp58NyjuBAl8FusSSFGChF96SRoGr33/FG4uQow9us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790467308; c=relaxed/simple;
	bh=ihEbRmXmWUrIBR5WQPN6fWmOUgG5VvxbGzxWy7q1Ivw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hyz6qvvr4olKctiPK2B2863WoErOPIVNx0Iqw4ICxUJzp43TkwZy///cMSuDE8+XJBcKBRGXjCXsgLBJJY9iqAlZ12hP0hruNgl9XLPcdcv3bopK3Fk31mi9VpGt9ijEJvM6lGI4d5BiN83D4GHjmP1UWNmz/cdZ+BCMTe16HDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yd8qFS/5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yd8qFS/5"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 10EF81F000FF;
	Sun, 27 Sep 2026 00:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790467307;
	bh=sB79F/cdv6nh6VXxboKTR2m3GWUy/YrJv8QZxlyzVY8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Yd8qFS/5YECz1FT8rVP2hL3XDmBRhQhmHtL02ICpu+L1zJQbkiyos4UicuhkBEJXj
	 /WOmy4MiqVx5ScK0yJ8ewgaaN63bYc2eRKy8Rpcfx5b7npfPMrnVUcLs93XisBwspy
	 04o9y1OsgYsmrpkePz39AFIiemiNwJ0ORZc7muF/bbJJruoYIz93stxk1sYoKCWOMS
	 QWUpfUbt9zfzs4yP3GGcNH9JTLcJYgdDD8w9eZNyhbbdQ/fKxoLrvmqd9vxmqBQ/PY
	 prR+Wr8chWjRbuQUbPmKy/gDrVyQafV4k+DhuXX/Qx18jVqjyLRN2cwde03R5jkFP4
	 wBY3wohUbbVVg==
Date: Sat, 26 Sep 2026 17:01:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 31/32] repair: support RT data checksums
Message-ID: <20260927000146.GS2705364@frogsfrogsfrogs>
References: <20260924100512.2733748-1-hch@lst.de>
 <20260924100512.2733748-32-hch@lst.de>
 <20260925235435.GR2705364@frogsfrogsfrogs>
 <20260926062313.GM20636@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260926062313.GM20636@lst.de>

On Sat, Sep 26, 2026 at 08:23:13AM +0200, Christoph Hellwig wrote:
> On Fri, Sep 25, 2026 at 04:54:35PM -0700, Darrick J. Wong wrote:
> > > +		}
> > > +		ip = rtg->rtg_inodes[XFS_RTGI_CSUM];
> > > +		error = -xfs_rtcsum_alloc_blocks(rtg);
> > 
> > Does this need the usual -libxfsification macros?
> 
> Probably.  Or I should go for another attempt to kill them everywhere...
> 
> > > +		xfs_csum_seed(mp, &csum);
> > > +		xfs_csum_gen(mp, data_buf + XFS_FSB_TO_B(mp, i),
> > > +				 mp->m_sb.sb_blocksize, &csum);
> > > +		if (i == 0)
> > > +			printf("calculated checksum 0x%x\n", csum.crc32c);
> > 
> > Debug code?
> 
> Yes.
> 
> > > +
> > > +		nr_blocks = min(DATA_BLOCKS_PER_BUF, rtg_blocks(rtg) - rgbno);
> > > +		error = read_data(mp->m_rtdev_targp,
> > > +				xfs_gbno_to_daddr(rtg_group(rtg), rgbno),
> > > +				XFS_FSB_TO_BB(mp, nr_blocks),
> > > +				data_buf);
> > > +		if (error) {
> > > +			do_warn(
> > > +_("Reading data at RG %u/%u failed, error %d"),
> > > +				rtg_rgno(rtg), rgbno, error);
> > > +			continue;
> > 
> > Er... so a read failure means we just leave broken checksums?
> 
> A zero-initialized one to be exact, yes.  I don't think there is
> much more we can do here?

I can't see anything that we can do about it either, but xfs_repair
ought to warn the user that they're going to get read errors.

--D
