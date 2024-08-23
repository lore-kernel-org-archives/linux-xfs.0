Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B9018BBB9
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 17:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724435516; cv=none; b=mVDsRciqDZTdVsBdb1H8Kb9w+ucZA1FMj1JTrUEBrWPdetQeTsaTV/LotKyz7eTen//qKLigsSheZqJdEkOELshd8kS6W5BMYvVRgFpmYS9OJ1QI52Kp+i61G4PK/JykkeG584SxUdYKo+K4bXU7UZhZuW+1g/oDQPgERX4ORHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724435516; c=relaxed/simple;
	bh=joZDJdmEiiwHWm+RTppkBY9q/B6483QdjhR9OXYXTp0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tSf8hmHvIX0zabLvbWIE/SrTLjl2zAyWcLiJvUW7jyfSevXcTYOYeHI9PI5TeEvQ1wXchGQMa1l4hs+PkjXAB2u6fvPTE5IaPY/V+7jpldU+SiIUnakhzU9IRh0SPbxFfRAZLJlEXP0GnW5jsl3ZLtPIEAqpy1GOB7L+q89zYbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uc9U2vU2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uc9U2vU2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80884C32786;
	Fri, 23 Aug 2024 17:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724435515;
	bh=joZDJdmEiiwHWm+RTppkBY9q/B6483QdjhR9OXYXTp0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Uc9U2vU2z2FMSDPWvVB/IFkZQqE8y0qcM3N08yF8daCTc3gZSw9TADlYccN1UPRoW
	 qHicDvO/ih5y45MEXmIIDRs6tZVxch/wvJDUsQlZCWcmtrkh5943mlfyE3tacYqU6S
	 g/DyJz4Os71ZwejhWtizKDiPfCevgjq5HSO8UHA/yx3JW0rJcYtsXrcRJUCV8MfhqN
	 KMXdOhnX8GJBMzasltaDyyYCB7MLYPFefSitdshKJOFh7b/5gWdfjnOpDosaeaZ5b7
	 c1RgE+jcqhGHKBPI7oVYUdjSBEAu3JValXxynJ1rmyHGZJOo45BepFApR1wQu/F+ml
	 xHjzcUUGTRFag==
Date: Fri, 23 Aug 2024 10:51:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/26] xfs: refactor loading quota inodes in the regular
 case
Message-ID: <20240823175155.GK865349@frogsfrogsfrogs>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
 <172437085206.57482.3726157833898843274.stgit@frogsfrogsfrogs>
 <ZsgQvof8gWadH7Hf@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZsgQvof8gWadH7Hf@infradead.org>

On Thu, Aug 22, 2024 at 09:31:58PM -0700, Christoph Hellwig wrote:
> > +	xfs_ino_t		ino = NULLFSINO;
> > +
> > +	switch (type) {
> > +	case XFS_DQTYPE_USER:
> > +		ino = mp->m_sb.sb_uquotino;
> > +		break;
> > +	case XFS_DQTYPE_GROUP:
> > +		ino = mp->m_sb.sb_gquotino;
> > +		break;
> > +	case XFS_DQTYPE_PROJ:
> > +		ino = mp->m_sb.sb_pquotino;
> > +		break;
> > +	default:
> > +		ASSERT(0);
> > +		return -EFSCORRUPTED;
> > +	}
> 
> I'd probably split this type to ino lookup into a separate helper,
> but that doesn't really matter.

I tried that, but left it embedded here because I didn't want to write a
helper function that then had to return a magic value for "some
programmer f*cked up, let's just bail out" that also couldn't have been
read in from disk.  In theory 0 should work because
xfs_sb_quota_from_disk should have converted that to NULLFSINO for us,
but that felt like a good way to introduce a subtle bug that will blow
up later.

I suppose 0 wouldn't be the worst magic value, since xfs_iget would just
blow up noisily for us.  OTOH all this gets deleted at the other end of
the metadir series anyway so I'd preferentially fix xfs_dqinode_load.

Thanks for the review!

--D

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> 
