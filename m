Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C08397B1B
	for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 14:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788187988; cv=none; b=WZSwsthMyqTJO+KGWKua3ajRvs2Spo8PTzB/IPJ9h4QPJ1+aiYqPBDg8lsFqRGK+8nU4ui+DjFVSIXtIs0RGGVIBxSlFrka5UW55RfDdIlkm6RN+l2S15k6k06+8EfXfr7BqPHkrrkT7GmfRsDk6UhZNNUC1taIj7whAksbe4ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788187988; c=relaxed/simple;
	bh=D+Kgyc3s0jeZbdbiE8RuiiQSh3W7Ha0ADaDWBMCngTg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LFJJMxEdn5BbbaDeV4pVkV9Y0jsRURBGgVd9pM+S4ytswLSZB1H7lZ8RoDQG3oYmEsLptTKiq5FNWxUxQoN7LgSv0lxYZQvMSPeTKu8BXzFcdO5/rL/M/Iz09GUmACJaNVnDTGqF3FKTPIZCLYrGL1ijVL/Dgj3eZyaWwDpSn0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GkjPbALg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GkjPbALg"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C9C551F000E9;
	Mon, 31 Aug 2026 14:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788187986;
	bh=Yj08zovLDizeIfJI+DJJZ1h4sMmXrAECRLVMVU4iYwk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GkjPbALg9utSAU5VI1nsH5gzAEdj1my14BBYZRDhc0dloXCwD0QaQ+jKRIZ0UTRub
	 EHFUukEza6ffWndkHCKhDfczd5zX2WL2wEdMn/Qi+q5H3+/4mxGQ+YMJOZbgjxr/eH
	 wL4OIkWru/ocVMLrccGY4gVx0x7MYY8U1g67UDAugdywuF1jWNJ883NksSSLmtK+a0
	 nbnno3IYJtiX7uwNyuiNsajQcXUAWbtvjJqJOC3kOdQOCf3+rVByl5Ga6GM8AM1iuu
	 Gd8oN8ul1WtChdN4X1tdtld5d4FxCFyRzz/mMMCwHz3jMC/K00vad8QdGNJvtvbF+V
	 w60EThKb8Q3mw==
Date: Mon, 31 Aug 2026 07:53:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Anuj Gupta <anuj1072538@gmail.com>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: port healthmon event list to list_head
Message-ID: <20260831145306.GF6072@frogsfrogsfrogs>
References: <178780640541.3528467.13867917797753503580.stgit@frogsfrogsfrogs>
 <178780640625.3528467.15741375660976356976.stgit@frogsfrogsfrogs>
 <mut2xsmp77543bjkmrzpmx6cbbua7gjt7sty4kg7zuf7lwudfp@33ksdiowtxwm>
 <20260827144759.GC6072@frogsfrogsfrogs>
 <20260831065841.GD24602@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831065841.GD24602@lst.de>

On Mon, Aug 31, 2026 at 08:58:41AM +0200, Christoph Hellwig wrote:
> On Thu, Aug 27, 2026 at 07:47:59AM -0700, Darrick J. Wong wrote:
> > On Thu, Aug 27, 2026 at 03:03:46PM +0530, Anuj Gupta wrote:
> > > > -	if (xfs_healthmon_merge_events(hm->last_event, &lost_event)) {
> > > > -		trace_xfs_healthmon_merge(hm, hm->last_event);
> > > > +	if (xfs_healthmon_merge_events(hm, &lost_event)) {
> > > > +		trace_xfs_healthmon_merge(hm, &lost_event);
> > > 
> > > This traces the lost_event now, but the merge updates existing tail
> > > event. Is the change in behaviour intentional?
> > > 
> > > >  	/* Try to merge with the newest event */
> > > > -	if (xfs_healthmon_merge_events(hm->last_event, template)) {
> > > > -		trace_xfs_healthmon_merge(hm, hm->last_event);
> > > > +	if (xfs_healthmon_merge_events(hm, template)) {
> > > > +		trace_xfs_healthmon_merge(hm, template);
> > > 
> > > Same: the merge updates the existing tail event, but this traces the
> > > incoming template/event. Before this patch, surviving post-merge tail
> > > was traced.
> > 
> > Oops, that should become list_last_entry() for both.
> 
> Maybe move the trace inside the helper to make it more
> clear?

Will do.

--D
