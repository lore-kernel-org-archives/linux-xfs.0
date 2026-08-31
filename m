Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DBF469842
	for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 15:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788189168; cv=none; b=Qub+85h0a2+AanPWQwV4U7KIjisZu0R9cbZ5HAEFJBqEpCxIO4cLSkSBgE2Q7NFLx5Do3ePybrazp2T0DgpNfF8Gg2i6SP+z919ginGaLEX9Ms/2A8AVbJGBmfmvcKIc6hI99pvVYJv9C4z5xFTnYsBOFeX1Ml6ETiJ5upTKWpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788189168; c=relaxed/simple;
	bh=Iqz6lL4Tse6uGr1eu2rrdgt+G9i/p8FZxxs0MOvCj3M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JxuU7IPd9vR16AOvBIFSyulxqoIZ1ok95fV2dkjElITCaeGp/JVqBrPBH/KWWYTHwZHmTmIj1wP9wdcXxZwwrj4iuaxZF2f+XlR3vh6tZdKoTSkHP80JpNRZM1y1DC8hf+bdzsKPnq2X2mCLnspFjTC8GFbTCPLHUZoIHUvMup8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kTBw5M6n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kTBw5M6n"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B72541F000E9;
	Mon, 31 Aug 2026 15:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788189166;
	bh=u2DKwyzqgpx3ofMOYh7DIHsiLvPJHepg5MwDErmAlkw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kTBw5M6nV0eOkmV0gh8TH3c+SV9JKrcahqLyOl/IMKtimP8U1QCXx7NPR+GgVOivq
	 CBPdmB8aqVfvqiUiayKJlpQR5eFf3oxJCJLKryvze14aKcCBQID58GQOCrU5LlpVzJ
	 DswpGQKb4NUXjEMinQL8rHLfkUgiSV5LsINRQa2J8vHuYFm8Fc7L83SpSke1qjbLWo
	 3UI2MRcPeo1Kf38zmotGBN4c3bDyVR4cuUaLbl6eIrwgwXuVb10eokIhaiTf7NKwaN
	 wtRATPbhSlmazgT50bNLdLl4E+XqeH8BVhS2pS6C2oC5RGrELSMGNtlRWiboTQIeuK
	 iH+D2s8bpC1yg==
Date: Mon, 31 Aug 2026 08:12:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: port healthmon event list to list_head
Message-ID: <20260831151246.GG6072@frogsfrogsfrogs>
References: <178780640541.3528467.13867917797753503580.stgit@frogsfrogsfrogs>
 <178780640625.3528467.15741375660976356976.stgit@frogsfrogsfrogs>
 <20260831065826.GC24602@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831065826.GC24602@lst.de>

On Mon, Aug 31, 2026 at 08:58:26AM +0200, Christoph Hellwig wrote:
> On Wed, Aug 26, 2026 at 10:32:59PM -0700, Darrick J. Wong wrote:
> >  struct xfs_healthmon_event {
> > -	struct xfs_healthmon_event	*next;
> > +	struct list_head		list;
> 
> Call this entry to make clear it's a list entry and not the list?
> 
> > +static inline struct xfs_healthmon_event *xfs_healthmon_alloc_event(void)
> > +{
> > +	struct xfs_healthmon_event		*event =
> > +		kzalloc_obj(struct xfs_healthmon_event, GFP_NOFS);
> > +
> > +	if (event)
> > +		INIT_LIST_HEAD(&event->list);
> > +	return event;
> 
> There is no need to initialize a list_head only used as an entry.
> 
> > +}
> > +
> > +static inline struct xfs_healthmon_event *
> > +xfs_healthmon_dup_event(
> > +	const struct xfs_healthmon_event	*template)
> > +{
> > +	struct xfs_healthmon_event		*event =
> > +		kmemdup(template, sizeof(struct xfs_healthmon_event),
> > +				GFP_NOFS);
> > +
> > +	if (event)
> > +		INIT_LIST_HEAD(&event->list);
> > +	return event;
> 
> Same here.

Will address these, thanks. :)

--D
