Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7942F7445;
	Thu, 19 Feb 2026 07:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771485961; cv=none; b=SfaD30lvffU8KkmbMwdT0pfMEz0FWoUCfJvddEhE94VH4s/futQX0VEc72nuaIuoXHnOQzG8GlCwH0JT2VEG5unhDnnJ6UwSdydr2uXvVP9WlMi51gLV0FfWDtMlpib5YRb5HU+28x36Jmv7MHwTAXc7Xu/N3GSFay0jR2LN3qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771485961; c=relaxed/simple;
	bh=hq125wGVJ1A0FyZibloMk6x1IWUt0i8kzCEWEF1WQBI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HK4ZS5EBn3Fq0EK+TZcqp7Mdrk9PQyR20RuHvPNBE9OoGbqZQScMKJoEm9nnAuhKTpB1KGZkl23ZeZ9GGds2mxHv9RNuKp+DiKKDdIQvnO3SganYcLI7vSRyQBk1KbsusL20xGvp+b4siKaM2gJwOEvHWrqb7P2Y7NVs/uYHhXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=O3M+CYrK; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=vYQdr0Ek; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="O3M+CYrK";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="vYQdr0Ek"
Date: Thu, 19 Feb 2026 08:25:56 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1771485958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YV0dDK3S7+qCe6c7VOgA9THe1EPr8PlEWCYZ7QQDyPU=;
	b=O3M+CYrK6XQZEVs3YtkKyuFuPx0KiRJR07oYA8GCH8m6d1JMXdRdOCAHMX9yPvDqDB9lqP
	6qH5RrYZm48jrDFwVkSNstPuxntCZrO71tTZxf1mTk1BDKk3Jpt+gtRDghjV2BHjEjaWEz
	JOOkNZrSbgX7ls5mgTvmwAGeB+rvYhDkF53MYzdlYZoMH4wjx09vVAS73ucaQGXPYDu05Z
	1r+MVDPlT44JnnXBxr6fD13e4kKnsf0bBPDAnqNjsmJPQSGbyQ59WP7+qPnE/i5CEdKX65
	AxPljBEeU3GZk5oize0B5f+aAyVQP6cwy7/0VlpaHHfZdrYzMml+8tCjz0LUsw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1771485958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YV0dDK3S7+qCe6c7VOgA9THe1EPr8PlEWCYZ7QQDyPU=;
	b=vYQdr0EkaYan2jWY8iv9nyRJWuaD+zUNh+xkculVCOZaGrLYtGyEKKKGnygNbPcJYqkoTG
	umop35BrYD8xUnBA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Dave Chinner <dgc@kernel.org>
Cc: Marco Crivellari <marco.crivellari@suse.com>,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Anthony Iliopoulos <ailiopoulos@suse.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: Re: [PATCH] xfs: convert alloc_workqueue users to WQ_UNBOUND
Message-ID: <20260219072556.Bpnr4F5x@linutronix.de>
References: <20260218165609.378983-1-marco.crivellari@suse.com>
 <aZZmVuY6C8PJMh_F@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aZZmVuY6C8PJMh_F@dread>

On 2026-02-19 12:24:38 [+1100], Dave Chinner wrote:
> > The changes from per-cpu to unbound will help to improve situations where
> > CPU isolation is used, because unbound work can be moved away from
> > isolated CPUs.
> 
> If you are running operations through the XFS filesystem on isolated
> CPUs, then you absolutely need some of these the per-cpu workqueues
> running on those isolated CPUs too.
> 
> Also, these workqueues are typically implemented these ways to meet
> performancei targets, concurrency constraints or algorithm
> requirements. Changes like this need a bunch of XFS metadata
> scalability benchmarks on high end server systems under a variety of
> conditions to at least show there aren't any obvious any behavioural
> or performance regressions that result from the change.

So all of those (below) where you say "performance critical", those
work items are only enqueued from an interrupt? Never origin from a user
task?

Sebastian
