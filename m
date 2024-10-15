Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B17D5223
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 00:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728951493; cv=none; b=j0tkstxGSVyPC0Ms2j+jKV8xKZSNHSLXC8hLEsb63g8KuiDlBGI0opZ+RC402sChl3BU0EuezIPwPiLkt766Zv6SH8hAm+3XAV9fe1+BefOGkILjVeD+oT/+4YMPjJjEepHC/jzZziCgRSVVE+W4SJ53/KLWXH1anq0oSKlqR5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728951493; c=relaxed/simple;
	bh=ApPJu06K2Np21hXKG8gC/Ckh5wEcfiAJ2WYYvnx0THA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=osCb4YWM4X+EJbRBrbIbFnWVJ4QVSwZ27sekzGvzHrhiW3GNAPaa81tVrAMyj6dTj8+5bec2xVksuDOVu2VFJvtvLObNvvYanJU3LoNWzZB5xBXg4vxtkQTLWbkjNlB7I3yodoisLgpJod259KJHcUfVdyuvDLSX7VG91Jy4THw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f851owpq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f851owpq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA39EC4CEC3;
	Tue, 15 Oct 2024 00:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728951492;
	bh=ApPJu06K2Np21hXKG8gC/Ckh5wEcfiAJ2WYYvnx0THA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f851owpqrG053HnFxYL7Bz+3ZEY2A/gE/jiX+1AUlz3FTGwt6ONgivh6joAwL2E+H
	 yxR4rlfw51YTSzy3mUHHMoqDO8siZybC6tu9mvuBB0UyHc5uYUl39ZPzILUmnWS56f
	 infWb2FCsDlMLu7KnzHNia4VTUTtHIpwfLXczotxWwWh2SV5yUgM8LWdBrPp0rE9r/
	 ci40JPro2JhbssLYD2FjD9cpdyTXoj07JPuhDrcGqMcEmT9cyNy7ygJ8QJ1zABJXBE
	 E5VZyL1cMU6sceHgSzfXwPitGdDyATK+OvDtC/B67TZjtqFATOlJ0cQ8GaNEh7nCaN
	 pt9cNm49URYWA==
Date: Mon, 14 Oct 2024 17:18:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 34/36] xfs: port the perag discard code to handle generic
 groups
Message-ID: <20241015001812.GL21853@frogsfrogsfrogs>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
 <172860644830.4178701.10909954990936352067.stgit@frogsfrogsfrogs>
 <ZwzSeG0MA9ejlqSR@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwzSeG0MA9ejlqSR@infradead.org>

On Mon, Oct 14, 2024 at 01:12:40AM -0700, Christoph Hellwig wrote:
> On Thu, Oct 10, 2024 at 06:10:31PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Port xfs_discard_extents and its tracepoints to handle generic groups
> > instead of just perags.  This is needed to enable busy extent tracking
> > for rtgroups.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_discard.c |   35 ++++++++++++++++++++++++++---------
> >  fs/xfs/xfs_trace.h   |   19 +++++++++++--------
> >  2 files changed, 37 insertions(+), 17 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> > index bcc904e749b276..2200b119e55b6b 100644
> > --- a/fs/xfs/xfs_discard.c
> > +++ b/fs/xfs/xfs_discard.c
> > @@ -101,6 +101,24 @@ xfs_discard_endio(
> >  	bio_put(bio);
> >  }
> >  
> > +static inline struct block_device *
> > +xfs_group_bdev(
> > +	const struct xfs_group	*xg)
> > +{
> > +	struct xfs_mount	*mp = xg->xg_mount;
> > +
> > +	switch (xg->xg_type) {
> > +	case XG_TYPE_AG:
> > +		return mp->m_ddev_targp->bt_bdev;
> > +	case XG_TYPE_RTG:
> > +		return mp->m_rtdev_targp->bt_bdev;
> > +	default:
> > +		ASSERT(0);
> > +		break;
> > +	}
> > +	return NULL;
> > +}
> 
> I wonder if this should be in xfs_group.h as there is nothing
> discard-specific about it.

In userspace, mp->m_ddev_targp->bt_bdev is a type dev_t, so this can't
be hoisted to libxfs as-is.  If we ever grow a second caller then the
hoisted version would need to return the xfs_buftarg.  For now I'll
leave this as a static inline in the one file that needs it.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
