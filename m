Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9633415539A;
	Thu, 19 Feb 2026 21:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771537710; cv=none; b=jBE2QWfwgyMTR8iTydHZC+1a3fkiw1aD8QIxYPzOu2h7JZcRTCAZUGE+iCtqwhL2XHSTmhFXS2/n3Be6ZUpcLUyc3Tm+taO1lcTLqACrep3XbT2Seq33juy1p7J17XauZz659iMMzx+tZ/jrZx3nK3c2dLbxe0nb9Rr1lZrG9Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771537710; c=relaxed/simple;
	bh=8IzYi1GTKamw1JxtWcrzryVfp90QSU2vSBowbZev+OI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oGPyAjIqU9QQRsEPEi7BcvsEHQfWoCwm9UBo0GLKpQotl40KgSpDQFqMkUPIUT5ALWv+3eRXHVMN20W/LwRmy3xhR/fvChVO/7hKhuo3NWQfat5tI16wDYJC554bBFepaE9DbWcSsJlj0f8jeERVat5cVQAvo43PYn/pkp9+/XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gZe75CNf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gZe75CNf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD0EC4CEF7;
	Thu, 19 Feb 2026 21:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771537710;
	bh=8IzYi1GTKamw1JxtWcrzryVfp90QSU2vSBowbZev+OI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gZe75CNfoeGRnLX7D8Q2EDdhYYvoW4ynIGekmYmbg4GeJG+g8FCmxY8ySocSl/2hv
	 wlDtJeWIbiYEn/nYmgsI5q4xEs9El9bK23z78Pk7k8jD0SKIZ6eee/L+B9rdHBP1A7
	 QkjyH8MPmRNvVpGDG55Oup9Z9oxvxplPGgEtOyxWKCQ4R4sg+xRq6FU3SocZDPdTfS
	 kPM7M59tFBtZZlVbPCsb7fNHYxUmhew3ZhCJ1PVXvuUreuGIRCGuqq39i3NQjL5LUe
	 hOxR30TaJ2YhMkR3FFE9RSGwhGVfDGTICAG4huWHsL0F3wGHthykPwtyMy5ZMFAxz6
	 P5E3KUAwmqcgQ==
Date: Thu, 19 Feb 2026 13:48:29 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: fix xfs_group release bug in
 xfs_verify_report_losses
Message-ID: <20260219214829.GQ6490@frogsfrogsfrogs>
References: <177145925377.401799.10773940743454980308.stgit@frogsfrogsfrogs>
 <177145925473.401799.4192737708449778278.stgit@frogsfrogsfrogs>
 <aZcJEu9PjdfXPwIG@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZcJEu9PjdfXPwIG@nidhogg.toxiclabs.cc>

On Thu, Feb 19, 2026 at 02:02:06PM +0100, Carlos Maiolino wrote:
> On Wed, Feb 18, 2026 at 10:01:30PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Chris Mason reports that his AI tools noticed that we were using
> > xfs_perag_put and xfs_group_put to release the group reference returned
> > by xfs_group_next_range.  However, the iterator function returns an
> > object with an active refcount, which means that we must use the correct
> > function to release the active refcount, which is _rele.
> 
> The subject looks a copy/paste from the previous one, ditto for the
> description.
> 
> The description matches the patch, but the subject doesn't.

Sorry about that.  Yes, the subject should have referenced
xfs_dax_notify_dev_failure.

> If you're going to send me a PR with this series, please fix it. If I'm
> pulling this series straight from the list, I'll fix it here.
> 
> Other than the description problems, the patch looks fine:
> 
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

I'll fix it before I send you a PR.

--D

> > 
> > Cc: <stable@vger.kernel.org> # v6.0
> > Fixes: 6f643c57d57c56 ("xfs: implement ->notify_failure() for XFS")
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_notify_failure.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
> > index 6be19fa1ebe262..64c8afb935c261 100644
> > --- a/fs/xfs/xfs_notify_failure.c
> > +++ b/fs/xfs/xfs_notify_failure.c
> > @@ -304,7 +304,7 @@ xfs_dax_notify_dev_failure(
> >  
> >  			error = xfs_alloc_read_agf(pag, tp, 0, &agf_bp);
> >  			if (error) {
> > -				xfs_perag_put(pag);
> > +				xfs_perag_rele(pag);
> >  				break;
> >  			}
> >  
> > @@ -340,7 +340,7 @@ xfs_dax_notify_dev_failure(
> >  		if (rtg)
> >  			xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
> >  		if (error) {
> > -			xfs_group_put(xg);
> > +			xfs_group_rele(xg);
> >  			break;
> >  		}
> >  	}
> > 
> > 
> 
