Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2437E4B44BE;
	Mon, 12 Oct 2026 16:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791822652; cv=none; b=NDgw/GfMzvZFFSqPyN88O7KYfxIxwuhbog5x0K0vnCN5MqiITeufGwAtR4R14UVPWZKN+qS5WbiF1Wyj+UJE4YD6fT4huD94ZARVhpHtUlY8qMbbKfVi9Zjb3GCffJPrVeoZNYPXP+zO56HBdBihyQO7NmspOmwAC4yTTUT4UVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791822652; c=relaxed/simple;
	bh=O1k/MYcOgo6+fwCu0IDGxog82ZGOYsgQ/f6tfFf+rOM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c8mzFQqsmgghf14JaSAeG0tP92Vl2zORKlHk6pwIJZ3em/4UVUzz/6utHegmcGLK0A2VYqy5Ez0cA8qhMqiYXf120os0IKcFHm+KSQBnEVntU4gWN9engWhJUnMGgZ97JRh4wjMGjcoOXqUHCkAoQ3Sv/f2b0gh+gH2yFHemlpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GRkCliNL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GRkCliNL"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DB9061F0089B;
	Mon, 12 Oct 2026 16:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791822651;
	bh=HEeH2yvRX/sNUV4Lag8n4UoGfunL/MqLyLwT8T2efgI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GRkCliNLOq8W7xMh7InRRUtnO98YYyjTc/leX1JoljotIq/tktxhnIx/PkTkSXL+L
	 R5ueObgg8eEiv9QcijaYjq+B0ii1wooAMAaTDc2FkSD6kcZiwD+NsHpIA5cFsMU2Zq
	 EH8GthvAouObADJ6bMB+garUrGa6AO0lXQ+3n9v+cyX3tqZIt+OWJdOqvQMCl66Rhe
	 RERhnTHu52hMaj5RG+C1s+KXkWHWwuDnPJoc8CouBmObO4v2V5cXbUzfH4YyMAcCgn
	 hHWYbfwpUxUl6xgCrdodFLsco6wfu9DRIHw32f+NsXxEHm+Yu/VtPRazd7TT6aEwUy
	 +/dhdjJl6xLsg==
Date: Mon, 12 Oct 2026 09:30:50 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/12] xfs: update quota flags on secondary supers when
 metadir enabled
Message-ID: <20261012163050.GD2705364@frogsfrogsfrogs>
References: <179178065713.1058822.6886680430162106741.stgit@frogsfrogsfrogs>
 <179178065902.1058822.9213708539877630364.stgit@frogsfrogsfrogs>
 <aszd-kWFK1cCJ2oR@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aszd-kWFK1cCJ2oR@infradead.org>

On Mon, Oct 12, 2026 at 06:17:46AM -0700, Christoph Hellwig wrote:
> On Sun, Oct 11, 2026 at 11:00:09PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > xfs/085 exposes an interesting bug when metadir is enabled, quotas are
> > enabled via mount option, and the primary superblock crc fails
> > validation:
> 
> The code looks ok, but I think the Sashiko complaints about non-metadir
> fses at least are valid.

Yep, I'll fix that.

> Handling the errors seems fine, but maybe the
> comments shouldn't mislead it that the update is purely opportunistic?

Yeah.  As written this patch makes secondary sb update failures block
mount, but on second thought I decided that since the secondaries only
come into play for xfs_repair, and only if the primary gets clobbered,
this all can get backed down to a warning:


/*
 * For metadir filesystems, quota flag state persists across mounts, so
 * update secondary superblocks in case xfs_repair ever has to recover
 * the primary from a secondary.  growfs also updates backup supers so
 * lock against that.  Note that the secondary backups are
 * opportunistic, so we log but do not return write errors.
 */
void
__xfs_qm_update_secondary_metadir_sb(
	struct xfs_mount	*mp,
	const char		*func)
{
	int			error;

	if (!xfs_has_metadir(mp))
		return;

	mutex_lock(&mp->m_growlock);
	error = xfs_update_secondary_sbs(mp);
	mutex_unlock(&mp->m_growlock);

	if (error)
		xfs_alert(mp, "%s: Secondary super update failed, err=%d!",
				func, error);
}

And this sole helper can get called from the three places that need it.

--D
