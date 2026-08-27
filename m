Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DEA3AE6E9
	for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2026 14:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787842110; cv=none; b=KzX45gd0nKglU0+cZvOnipSQCCfK64DcKQa0P4S+RtMjuXZC1Y7+ygCNXUnK5pX1U+DAvm8v9xOSaOyfCMwyipSOzeX53QG6/WnMIr+kTav5YaypL0CzqRlN0OzlCwD0DI72ILDPrezj4XWsWxgVyqxUpKq/D0hKT7bEfH0JSZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787842110; c=relaxed/simple;
	bh=gYb5jGXU55LUG5UUR75d7Dp9pzSvu3uDj+YjUeKWpqs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UKw8fRFjN9x4jZauGcIpNirrtqANL3WRH44vcICSq7ZIKJHf96TUSVkn1SuaZcBHPC742HOll7wQPCYdCek64xAmIDNoAmal3E310KVWQ1tq3oB2cmNCgDzLeAvM6vweArel5LiJh6tb18L9LqICfNxXo0wZQzYsYArvIT1t0L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mWNaZqTP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mWNaZqTP"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 42CD71F000E9;
	Thu, 27 Aug 2026 14:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787842080;
	bh=CIB27XpF9yTyWbW/Ex5Hd0sf8yLVimWNrEjzI2YB0bQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mWNaZqTP8XZl6/ea07HVG04EQsbyU6hPiBsTfrG3F6A8ptIGb3f9CAO51S0rECiSE
	 DzUdK0C5xvZGjS1EjM6P4HrRGVEyNbI7DGp1xOyB0YLW1A4HnMIW/aKvbL0w9ljnee
	 KOAMRMk4pRZ0ZODXEqdtHSJ135ZJdBTjIzZO2TWq9sna1YH7dKf+/bSLukEom5vcDJ
	 Jiq+/z6//STaBgSjb8M+pNk6H6dvhMjQdMs3NfWDVmY4pmKJLbQTuiEx/WSVbBCggR
	 vPDOBFM8e89NPAzL65mNry4TC/Ns1VsyOdD01neoq0DDtg24vgs/mGXeX35uRCyUn8
	 egDJg3VHNT54A==
Date: Thu, 27 Aug 2026 07:47:59 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Anuj Gupta <anuj1072538@gmail.com>
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: port healthmon event list to list_head
Message-ID: <20260827144759.GC6072@frogsfrogsfrogs>
References: <178780640541.3528467.13867917797753503580.stgit@frogsfrogsfrogs>
 <178780640625.3528467.15741375660976356976.stgit@frogsfrogsfrogs>
 <mut2xsmp77543bjkmrzpmx6cbbua7gjt7sty4kg7zuf7lwudfp@33ksdiowtxwm>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mut2xsmp77543bjkmrzpmx6cbbua7gjt7sty4kg7zuf7lwudfp@33ksdiowtxwm>

On Thu, Aug 27, 2026 at 03:03:46PM +0530, Anuj Gupta wrote:
> > -	if (xfs_healthmon_merge_events(hm->last_event, &lost_event)) {
> > -		trace_xfs_healthmon_merge(hm, hm->last_event);
> > +	if (xfs_healthmon_merge_events(hm, &lost_event)) {
> > +		trace_xfs_healthmon_merge(hm, &lost_event);
> 
> This traces the lost_event now, but the merge updates existing tail
> event. Is the change in behaviour intentional?
> 
> >  	/* Try to merge with the newest event */
> > -	if (xfs_healthmon_merge_events(hm->last_event, template)) {
> > -		trace_xfs_healthmon_merge(hm, hm->last_event);
> > +	if (xfs_healthmon_merge_events(hm, template)) {
> > +		trace_xfs_healthmon_merge(hm, template);
> 
> Same: the merge updates the existing tail event, but this traces the
> incoming template/event. Before this patch, surviving post-merge tail
> was traced.

Oops, that should become list_last_entry() for both.

--D
