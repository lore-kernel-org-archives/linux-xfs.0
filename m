Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5266E2EC54C;
	Thu, 19 Feb 2026 22:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771539754; cv=none; b=TwJE9C6XybTTgSZ5kTCkaLOJ5MDbPeMVTUiAShubPikxHq736XPFR7iQFc/4twj4iLm0IbnppGxIodr1sHgWBEQU5WfstCVYjG/hpb3hHqZueCdJkq3w6H6FbIDE+ABq//yTeePWkLThYTuaSiF1IQWuvDtPJiHYbyqAYHs/Ui0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771539754; c=relaxed/simple;
	bh=z0X+87ggXZ+XeyFA7zxW8pTADc6+0oEq07ZVS2xYfDw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GW6cr/qMfRybdy34JHUkKVogrIbTHIdGQGVFmfO7T74r8xyyjsl/JXH5Lck5mrqXApvp6OwPjUXskU9/RbEh4CeOXtC2PGSBAX+dC3l96cDsTnsDdF5JOjJwW+TBljCyLqQXADUpyWyKftwQyDVfaF6WxPQHfZLWh9b5WkbJDUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=REz8w9tG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="REz8w9tG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF85CC4CEF7;
	Thu, 19 Feb 2026 22:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771539754;
	bh=z0X+87ggXZ+XeyFA7zxW8pTADc6+0oEq07ZVS2xYfDw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=REz8w9tG75raD7zZbTx3tcShfxRm8eipLuuslrdhVK5A3wy1X1+9/PMLXBMojNG+r
	 yVmm1mmJPPuHF30woUqUtvMK6PPO7/h/LvlP0mGhIsaC3iI3WvLfCHC5Icy1qr/KNI
	 3shnLEaeydE0l1BqdYO1koS4LW2LgwVnTiO7hOVLUu+QLk41uRdLoZFAn+/VqG3Ip3
	 yAK+6Hy8TI9KVUy1obf8rtUffByvJfUYeIdV0nWhFm2CqSMk/C7bQe6ZUo+Duc2uWZ
	 flM5b+zMRADXx+4JWjdnEzu5S+CZ7WVqaKTY2WZ2jXUlIWPUHBju3wCMK1x0/7ecse
	 N5OHjeOhNFAmA==
Date: Fri, 20 Feb 2026 09:22:19 +1100
From: Dave Chinner <dgc@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Marco Crivellari <marco.crivellari@suse.com>,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Anthony Iliopoulos <ailiopoulos@suse.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: Re: [PATCH] xfs: convert alloc_workqueue users to WQ_UNBOUND
Message-ID: <aZeNG4CcIGtmy5Fx@dread>
References: <20260218165609.378983-1-marco.crivellari@suse.com>
 <aZZmVuY6C8PJMh_F@dread>
 <aZbV9tqatNGbKRqF@tiehlicka>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZbV9tqatNGbKRqF@tiehlicka>

On Thu, Feb 19, 2026 at 10:20:54AM +0100, Michal Hocko wrote:
> On Thu 19-02-26 12:24:38, Dave Chinner wrote:
> > On Wed, Feb 18, 2026 at 05:56:09PM +0100, Marco Crivellari wrote:
> > > Recently, as part of a workqueue refactor, WQ_PERCPU has been added to
> > > alloc_workqueue() users that didn't specify WQ_UNBOUND.
> > > The change has been introduced by:
> > > 
> > >   69635d7f4b344 ("fs: WQ_PERCPU added to alloc_workqueue users")
> > > 
> > > These specific workqueues don't use per-cpu data, so change the behavior
> > > removing WQ_PERCPU and adding WQ_UNBOUND.
> > 
> > Your definition for "doesn't need per-cpu workqueues" is sadly
> > deficient.
> 
> I believe Marco wanted to say they do not require strict per-cpu
> guarantee of WQ_PERCPU for correctness. I.e. those workers do not
> operate on per-cpu data.

Which I've already pointed out was an incorrect statement w.r.t to
the code being changed (e.g. inodegc use lockless per-cpu queues
and a per-cpu worker to process those queues). I've also pointed out
that it is a fundamentally incorrect statement when considering
bound concurrency algorithms in general, too.

> > > Even if these workqueue are
> > > marked unbound, the workqueue subsystem maintains cache locality by
> > > default via affinity scopes.
> > > 
> > > The changes from per-cpu to unbound will help to improve situations where
> > > CPU isolation is used, because unbound work can be moved away from
> > > isolated CPUs.
> > 
> > If you are running operations through the XFS filesystem on isolated
> > CPUs, then you absolutely need some of these the per-cpu workqueues
> > running on those isolated CPUs too.
> 
> The usecase is that isolated workload needs to perform fs operations at
> certain stages of the operation. Then it moves over to "do not disturb"
> mode when it operates in the userspace and shouldn't be disrupted by the
> kernel. We do observe that those workers trigger at later time and
> disturb the workload when not appropriate.

Define "later time".

Also, please explain how the XFS work gets queued to run on these
isolated CPUs?  If there's nothing fs, storage or memory reclaim
related running on the isolated CPU, then none of the XFS workqueues
should ever trigger on those CPUs. 

IOWs, if you are getting unexpected work triggers on isolated CPUs,
then you need to first explain how those unexpected triggers are
occurring. Once you can explain how the per-cpu workqueues are
responsible for the unexpected behaviour rather than just being the
visible symptom of something else going wrong (e.g. a scheduler or
workqueue bug), then we can discussion changing the XFS code....

> > Also, these workqueues are typically implemented these ways to meet
> > performancei targets, concurrency constraints or algorithm
> > requirements. Changes like this need a bunch of XFS metadata
> > scalability benchmarks on high end server systems under a variety of
> > conditions to at least show there aren't any obvious any behavioural
> > or performance regressions that result from the change.
> 
> This is a fair ask. We do not want to regress non-isolated workloads by
> any means and if there is a risk of regression for those, and from your
> more detailed explanation it seems so, then we might need to search for
> a different approach. Would be an opt in - i.e. tolerate performance
> loss by loosing the locality via a kernel cmd line an option?

No, this is still just hacking around an unexpected behaviour
without first understanding the cause of it. We can discuss how to
fix whatever the problem is once the root cause has been identified
and understood.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
