Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5B621CC54
	for <linux-xfs@vger.kernel.org>; Wed,  9 Jul 2025 16:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752079513; cv=none; b=q3EqIKPer6teeGx2CDrDHWDZcupCm5Cm6hQ2BcY1RDfAfIc3EEZFdCGYZh4AeXwcxYg6F3udJ6putNr3xkar1cW+EoiIJxe8mJIxOjyfdNzUGpzOb5xF7gPJqa/xZFkS0P9WrseWqwNgXozrGD+pBC4X3b3SChbIra68m5rnln0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752079513; c=relaxed/simple;
	bh=iirCZS2AOb57bY8OTMFPR3h/5GVwsLRd6VlHmAe8cgo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dyO757rX+lazN3tIe6GTBh0HOvwibdiwCvhKX94Jeiv0qnhIbG1YKZWDh0vkWmcsXO6Ep8if7o+bBRfwgEKqecKd9A1LGPJDd5cyYtaV6dchPGYEaaVcEnVKr5+MwamKX7lKUJJOs9u0qvW4O4EcDsftRs767URUqK+Z7kGy7O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XH4tEUZg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XH4tEUZg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2809C4CEEF;
	Wed,  9 Jul 2025 16:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752079512;
	bh=iirCZS2AOb57bY8OTMFPR3h/5GVwsLRd6VlHmAe8cgo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XH4tEUZgBXI5iMpqAZRcgdDhEiFv35scKJLgsvtRow6QOXQLMhegYnjSztn6cAWZB
	 bTbsmXLBWML9G3Of8THd6q4O7HLwKYiJwuLqQnjv67rXkWtLr/fub6cqZ8iPiQPaWf
	 1dAvUOb2vng2cy7D5squMB+tVGhiNZCHdBXrWpVrhOQyy7YXJ5HVePKug/MbNMhpGw
	 inn6g/ox7FUUnzRfxLtafa0Tunrx3fyjPRsMQyjzimPdrC/iiDjGx/Neoy8ISVEf2A
	 WAeUAGzOp3O4flWUKn2N9ypvp7DhWyZ44I7l1irHtbA9NLkBAEbnSnPbv3t/09g+pf
	 BibahGpXaN9cA==
Date: Wed, 9 Jul 2025 09:45:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: aalbersh@kernel.org, catherine.hoang@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] mkfs: autodetect log stripe unit for external log
 devices
Message-ID: <20250709164512.GI2672049@frogsfrogsfrogs>
References: <175139303809.916168.13664699895415552120.stgit@frogsfrogsfrogs>
 <175139303929.916168.12779038046139976787.stgit@frogsfrogsfrogs>
 <3d30e443-d4fe-45bc-bd92-fb323d00363c@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d30e443-d4fe-45bc-bd92-fb323d00363c@oracle.com>

On Wed, Jul 09, 2025 at 04:57:49PM +0100, John Garry wrote:
> On 01/07/2025 19:08, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > If we're using an external log device and the caller doesn't give us a
> > lsunit, use the block device geometry (if present) to set it.
> 
> this seems fine, but I am not imitatively familiar with the code. So, FWIW:
> 
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> 
> There is a small question below, though.
> 
> > 
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >   mkfs/xfs_mkfs.c |    4 ++++
> >   1 file changed, 4 insertions(+)
> > 
> > 
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 8b946f3ef817da..6c8cc715d3476b 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> 
> nit: maybe the comment on method of calculation (not shown, but begins
> "check the log sunit is modulo ...") could be updated

Ok.

	/*
	 * check that log sunit is modulo fsblksize; default it to dsunit for
	 * an internal log; or the log device stripe unit if it's external.
	 */

Thanks for the review.

--D

> > @@ -3624,6 +3624,10 @@ _("log stripe unit (%d) must be a multiple of the block size (%d)\n"),
> >   		   cfg->loginternal && cfg->dsunit) {
> >   		/* lsunit and dsunit now in fs blocks */
> >   		cfg->lsunit = cfg->dsunit;
> > +	} else if (cfg->sb_feat.log_version == 2 &&
> > +		   !cfg->loginternal) {
> > +		/* use the external log device properties */
> > +		cfg->lsunit = DTOBT(ft->log.sunit, cfg->blocklog);
> >   	}
> >   	if (cfg->sb_feat.log_version == 2 &&
> > 
> 
> 
