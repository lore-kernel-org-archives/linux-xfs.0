Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E1529B79B;
	Thu, 19 Feb 2026 23:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771542320; cv=none; b=Pfldey5QvnGSMOLwGOMZaijpHzaiBQUoGNyh8nt5CI2jMWvSWNZgo+EMciDRLpjnASVM4m5hTPnwqqq0occ2htXkghEzeqTWygZcv5NAYOd0jzKUcZBYDmqUm3yjUnSwvRZ1rmcky6Ex8EgPFQeZkW1kfUPPppn6OEoEK66XxwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771542320; c=relaxed/simple;
	bh=bI4Yb2IT7Ni7DXcco5nk8FJsv6H+/QURbfd1gAkobzA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NOEwkNSHbY9Lyu8AWvENeqoFarFwgv/EVnQcCSpzOGELoD2zcS0Q2JR9G/JtoKb15QUuiJQJA7uaOvLiNnOnBEbMsfOjJDAiAXtNtsMmIsE3ZXUuSP1+2/Nv+JHUcsEgcqz36VyMEza3pPkSe92byXno6HaLc5dkBZLuV0Xw/hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yaq/H62i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yaq/H62i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 138F0C4CEF7;
	Thu, 19 Feb 2026 23:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771542320;
	bh=bI4Yb2IT7Ni7DXcco5nk8FJsv6H+/QURbfd1gAkobzA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Yaq/H62iw//9ogfc04dvsbbAutxbViW0EJ/LBx3sBpODYQKKJu79Q2nha9Lx5dac2
	 0sJPKlP6ORNgxw1z9OiVZYJxTtKFEyRo46suy4NHZ0PfiweWmUrXTml79rvwkgyAzT
	 9/xs0+5F7v9kg9jamS8EA92jgFyi8dQEisq+bmo7DT34g5IHybWHtFxp+H8/y3m9BQ
	 my0gOSsFQdQfu9GEQyZfjl19L5kmoUgGd8phqPZag+TNjaCqV0HpaB4ShrCgWiWWsm
	 8tlmVQ3vfrVXUByrOC7C7uJZmI1MMu1376FWlxzo0tAn1SLoO9sbnzFczxEaFW9skz
	 +9hSr2W1VTNKg==
Date: Fri, 20 Feb 2026 10:05:09 +1100
From: Dave Chinner <dgc@kernel.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Marco Crivellari <marco.crivellari@suse.com>,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Anthony Iliopoulos <ailiopoulos@suse.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: Re: [PATCH] xfs: convert alloc_workqueue users to WQ_UNBOUND
Message-ID: <aZeXJeV_EfmOzCxh@dread>
References: <20260218165609.378983-1-marco.crivellari@suse.com>
 <aZZmVuY6C8PJMh_F@dread>
 <20260219072556.Bpnr4F5x@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260219072556.Bpnr4F5x@linutronix.de>

On Thu, Feb 19, 2026 at 08:25:56AM +0100, Sebastian Andrzej Siewior wrote:
> On 2026-02-19 12:24:38 [+1100], Dave Chinner wrote:
> > > The changes from per-cpu to unbound will help to improve situations where
> > > CPU isolation is used, because unbound work can be moved away from
> > > isolated CPUs.
> > 
> > If you are running operations through the XFS filesystem on isolated
> > CPUs, then you absolutely need some of these the per-cpu workqueues
> > running on those isolated CPUs too.
> > 
> > Also, these workqueues are typically implemented these ways to meet
> > performancei targets, concurrency constraints or algorithm
> > requirements. Changes like this need a bunch of XFS metadata
> > scalability benchmarks on high end server systems under a variety of
> > conditions to at least show there aren't any obvious any behavioural
> > or performance regressions that result from the change.
> 
> So all of those (below) where you say "performance critical", those
> work items are only enqueued from an interrupt?

No. 

> Never origin from a user task?

Inode GC is most definitely driven from user tasks with unbound
concurrency (e.g. unlink(), close() and other syscalls that can drop
a file reference). It can also be driven by the kernel through
direct reclaim (again, from user task context with unbound
concurrency), and from pure kernel context via reclaim from kswapd
(strictly bound concurrency in this case).

The lockless per-cpu queuing and processing algorithm was added
because the inode eviction path from user context is performance
critical. The original version using unbound workqueues had major
performance regressions.  There's discussion of the reasons for
those performance regressions and numbers around those in the
original discussions and prototypes:

https://lore.kernel.org/linux-xfs/20210802103559.GH2757197@dread.disaster.area/
https://lore.kernel.org/linux-xfs/20210804032030.GT3601443@magnolia/

-Dave.
-- 
Dave Chinner
dgc@kernel.org
