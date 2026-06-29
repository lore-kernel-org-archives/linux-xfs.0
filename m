Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75ABD36EAA7;
	Mon, 29 Jun 2026 12:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782737041; cv=none; b=KMX8h0vrdESgW39jsuLntvbc8EXyybdUt/6D2gA6SC1KV21nGf0XihX3gO3q5a+hrdouMU8T8O3RjKZSlZ8hYB2VK5NY6dQZNbOZTWgi+Xv5GrT34n2s12tNphlr9howTqupjvA4hNyq3G60N9wsop5np6KRup4Micm/ezF9xP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782737041; c=relaxed/simple;
	bh=6r09yQz7NUq/4qBAtZQdA2gBPKnNaBl9hAWZRPWwwKA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HHv35wXCEb9IhDRylECuCWQBVQ1jsvnWj7OjMT8c0bKYjxFcVntJuz5nQLOD3KMCx/xP/Ba6yjiUQznKnuMAc5R4XxzoYzfEE2plVkPwVkVs+E1bCDrsw/WAJ/PeDtLpvtM7PRoyZtJ8GCteStBQrSlIJMo0utqtqU8Y/Qz2ydo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4C67368B05; Mon, 29 Jun 2026 14:43:57 +0200 (CEST)
Date: Mon, 29 Jun 2026 14:43:56 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Yingjie Gao <gaoyingjie@uniontech.com>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH] xfs: retry dqpurge when dquot buffer is busy
Message-ID: <20260629124356.GA22595@lst.de>
References: <20260626095253.3445540-1-gaoyingjie@uniontech.com> <20260626205257.GA6078@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626205257.GA6078@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jun 26, 2026 at 01:52:57PM -0700, Darrick J. Wong wrote:
> On Fri, Jun 26, 2026 at 05:52:53PM +0800, Yingjie Gao wrote:
> > xfs_qm_dqpurge() marks a zero-reference dquot dead before trying to flush
> > a dirty dquot. If the attached buffer is busy, xfs_dquot_use_attached_buf()
> > returns -EAGAIN.
> > 
> > The error path restores q_lockref.count but then jumps to out_funlock,
> > which continues into the successful purge tail and destroys the dquot.  At
> > that point the attached buffer has not been detached and the dquot log item
> > may still be in the AIL.
> > 
> > Restore the retry behavior by dropping the locks and returning -EAGAIN
> > after resurrecting the lockref.
> > 
> > Link: https://lore.kernel.org/linux-xfs/20260625175519.GF6078@frogsfrogsfrogs/
> > Fixes: 0c5e80bd579f ("xfs: use a lockref for the xfs_dquot reference count")
> > Cc: stable@vger.kernel.org # v6.19+
> > Signed-off-by: Yingjie Gao <gaoyingjie@uniontech.com>
> 
> Yeah, that's more like what we did before 0c5e80bd579f.  I think the
> lockref resurrection part still looks ok, but maybe hch has an opinion?

But is it the right thing?  In dqpurge we really want to kill of the
dquot, so doing a trylock is not very useful, so we really should not
do a trylock here but just lock the buffer.

Darrick, do you remember if there's any lock order inversions we need
to care about here?

