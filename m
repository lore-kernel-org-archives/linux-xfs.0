Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C103BB131
	for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 06:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788159529; cv=none; b=IT5NJtkAjNGT8kMySjFOcpV8usK0pAcLpbyz00Wcnj6dEUFfWpUopmHWdvfVY2hMuOhdvMv20foxwcRCZZ8j9OyMzt6FhcheBuNH2pc/xbQB7iZIK0TY4DC3+RXXzeMSXelKGFFox/7dVXAvgeDuXD8/lJlaQR71DyjTLVImVEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788159529; c=relaxed/simple;
	bh=7KsWZYBRgaZ8DzVJZSXRQx6O7uqF83/Hiz/gutw0rb4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M8IqXas6N91kocHlHYH6fgJCdQsRZ24QJ6nIZzCKZuFoGSK9kmfQxKrpqs12Gq+8MsfupP5X7JnWdl+ciUpB3Vp/qoh5X9rAQDgx12ocdCXfofliLtiUQpJ40hwc9LZy79eOYC6YFcnkAWCG4PWKMvoozdizNoCX6KcLFVHr6bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 95FD868BEB; Mon, 31 Aug 2026 08:58:41 +0200 (CEST)
Date: Mon, 31 Aug 2026 08:58:41 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Anuj Gupta <anuj1072538@gmail.com>, cem@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: port healthmon event list to list_head
Message-ID: <20260831065841.GD24602@lst.de>
References: <178780640541.3528467.13867917797753503580.stgit@frogsfrogsfrogs> <178780640625.3528467.15741375660976356976.stgit@frogsfrogsfrogs> <mut2xsmp77543bjkmrzpmx6cbbua7gjt7sty4kg7zuf7lwudfp@33ksdiowtxwm> <20260827144759.GC6072@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827144759.GC6072@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Aug 27, 2026 at 07:47:59AM -0700, Darrick J. Wong wrote:
> On Thu, Aug 27, 2026 at 03:03:46PM +0530, Anuj Gupta wrote:
> > > -	if (xfs_healthmon_merge_events(hm->last_event, &lost_event)) {
> > > -		trace_xfs_healthmon_merge(hm, hm->last_event);
> > > +	if (xfs_healthmon_merge_events(hm, &lost_event)) {
> > > +		trace_xfs_healthmon_merge(hm, &lost_event);
> > 
> > This traces the lost_event now, but the merge updates existing tail
> > event. Is the change in behaviour intentional?
> > 
> > >  	/* Try to merge with the newest event */
> > > -	if (xfs_healthmon_merge_events(hm->last_event, template)) {
> > > -		trace_xfs_healthmon_merge(hm, hm->last_event);
> > > +	if (xfs_healthmon_merge_events(hm, template)) {
> > > +		trace_xfs_healthmon_merge(hm, template);
> > 
> > Same: the merge updates the existing tail event, but this traces the
> > incoming template/event. Before this patch, surviving post-merge tail
> > was traced.
> 
> Oops, that should become list_last_entry() for both.

Maybe move the trace inside the helper to make it more
clear?
