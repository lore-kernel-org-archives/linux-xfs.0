Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5521D88AC;
	Fri, 16 May 2025 06:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747377294; cv=none; b=qmgbFqJGDnDUArFZYCHl6gLtBnYKTO9cbUfgRDxY2h0s7t9oVm9/bcAeMU4+FAmK+55LWS7jP6uDo/A5CZguaGqCW5QjjSc4DTwLHPse7gV9sAdlX/rCIG800noSDm+vh01VpXPM3GU2E/kGFzuvweb1ABwkkO6pFRxkbcXwB/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747377294; c=relaxed/simple;
	bh=TKu5/yJLwlz0W5cl8c+lO8cbA5gUEqmahbihBE2G8QM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZWW1TSsNKmRdV8Hq5iNyPljZsfRO2YpEkOVviSXK4ULz+7ly6gDlwQ6qElwfXTxk5kj/VytK5bHBfaLv4guk1TR90nNVy3L5hM8xIo2zyE+vZ3VtyjYcRPx6TXrffVswLLzM590ezTw8/WfjFdhpzvUKmzPuQB3bEjfgmmivbbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9E4B368AA6; Fri, 16 May 2025 08:34:47 +0200 (CEST)
Date: Fri, 16 May 2025 08:34:47 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org, cen zhang <zzzccc427@gmail.com>,
	lkmm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: mark the i_delayed_blks access in
 xfs_file_release as racy
Message-ID: <20250516063447.GA14632@lst.de>
References: <20250513052614.753577-1-hch@lst.de> <aCO7injOF7DFJGY9@dread.disaster.area> <FezVRpM-CK9-HuEp3IpLjF-tP7zIL0rzKfhspjIkdGvS3giuWzM9eeby5_eQjL5_gNG1YC4Zu0snd2lBHnL0xg==@protonmail.internalid> <20250514042946.GA23355@lst.de> <ymjsjb7ich2s5f7tmhslhlnymjmso5o2lsvdoudy3dtbr7vjwk@moxzvvjdh6zl> <20250514130417.GA21064@lst.de> <aCUlXbEg9wuyPEB6@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCUlXbEg9wuyPEB6@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, May 15, 2025 at 09:21:01AM +1000, Dave Chinner wrote:
> > I'd like to understand that one a bit more.  It might be because the
> > validator doesn't understand a semaphore used as lock is a lock, but
> > I'll follow up there.
> 
> Even so, it's not a race because at that point in time the object
> cannot be seen by anything other than the process that is
> initialising it.

In the current tree after the folio/vmalloc series b_addr is only
assigned during buffer allocation.  But I suspect they tested before that
where b_addr can be set at runtime.  Either way it always happens under
b_sema because that is initialized to locked just after allocating
the memory for the buffer.

> I'm wary of this, because at this point I suspect that there aren't
> a lot of people with sufficient time and knowledge to adequately
> address these issues.

I'm more than happy to address these, because proper documentation
of concurrency helps fixing a huge number of bugs, and also really
helps documenting the code.  I hate having to spend hours trying to
figure out why something can be safely used lockless or not.

> We should have learnt this lesson from lockdep - false positive
> whack-a-mole shut up individual reports but introduced technical
> debt that had to be addressed later because whack-a-mole didn't
> address the underlying issues.

I'm not sure who "we" is, but I've always pushed back to hacks just
to shut up lockdep.  And at the same time I'm immensively grateful
for having lockdep and can't think of working without it anymore.

> We need functions like xfs_vn_getattr(), the allocation AG selection
> alogrithms and object initialisation functions to be marked as
> inherently racy, because they intentionally don't hold locks for any
> of the accesses they make. kcsan provides:

Functions never are racy, specific data access are.  So a function wide
assignment is just the dumbest thing ever, this already badly failed
for things like early Java object-level synchronization.

> 
> For variables like ip->i_delayed_blks, where we intentionally
> serialise modifications but do not serialise readers, we have:
> 
> -	uint64_t                i_delayed_blks; /* count of delay alloc blks */
> +	uint64_t __data_racy    i_delayed_blks; /* count of delay alloc blks */
> 
> This means all accesses to the variable are considered to be racy
> and kcsan will ignore it and not report it. We can do the same for
> lip->li_lsn and other variables.

But not all access are racy.  We rely on proper synchronized accesses
for accounting.  Now for something that has a lot of unsynchronized
access, adding a wrapper for them might be fine, but for i_delayed_blks
I don't think we actually have enough for them to bother.

> IOWs, we do not need to spew data_race() wrappers or random
> READ_ONCE/WRITE_ONCE macros all over the code to silence known false
> positives.  If we mark the variables and functions we know have racy
> accesses, these one-line changes will avoid -all- false positives on
> those variables/from those functions.

And also drop a lot of the actually useful checks. That's exaxctly
the kind of hack you rant about above.

