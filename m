Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE6D52D2CB;
	Fri, 18 Sep 2026 21:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789766897; cv=none; b=Oe0qbcNt3VGNPSefpmCch4/jvZS/9rbqvkwAWUwk5aVrCbR2Xp3lQpUAW6zjtPFrgYMKY4pHO6VWCFdqM/TLZKLjvSk6Th0WBlyReCjqpaupzq0O6OHj1enKmnhMR7zrtruXLO21t0vzLJm+u2iROCm2ATqaXqohzoxiQg4BeC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789766897; c=relaxed/simple;
	bh=pRnjo+WgwNgWQqFxqCWSOFsXjxPdUHZkvUJSol2SWnQ=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=H+OmYMF+TezJtkbQ7iPBZaAshoJHhbpLdku6b+qrtbgGlbYhLL9uhBcsA1NTrdU0wpoqLE73jF9i1yy3H6Z/4ER/QPb3w7ECdRx62V87Vn/UtNb9MSgr8eZCl7zbDGmzkchV2PljmotUy+59QXYi12/1rZg4i5zCoDL07EcaSqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iJ7aqB7O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iJ7aqB7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773F81F000FF;
	Fri, 18 Sep 2026 21:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789766894;
	bh=xUD1CoilTyY9WAB6kCA8b05x+K7MhrdQmU4wDQmtJ2I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=iJ7aqB7OZFQufH+CMobT4fEU9lGENwdZXjnprTZlRkPkAZjOY8zO/DYATxCWw2+f9
	 B7dsDZXjshgnoX7GZBLntgEF5CkhdvqGE7fPfnfeUctY+PbXPrhY14O0OIqwgmxVJd
	 +ABbeyqCB/iab+QoBwueJHhnADDXb9/kp93upYaM=
Date: Fri, 18 Sep 2026 14:28:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Matt Fleming
 <matt@readmodwrite.com>, Salvatore Dipietro <dipiets@amazon.it>,
 abuehaze@amazon.com, alisaidi@amazon.com, blakgeof@amazon.com,
 brauner@kernel.org, brendan.jackman@linux.dev, david@redhat.com,
 dgc@kernel.org, dipietro.salvatore@gmail.com, djwong@kernel.org,
 hch@infradead.org, hch@lst.de, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-xfs@vger.kernel.org, mhocko@suse.com, ritesh.list@gmail.com,
 rvvandan@amazon.com, stable@vger.kernel.org, surenb@google.com,
 willy@infradead.org, ziy@nvidia.com
Subject: Re: [PATCH v4] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
Message-Id: <20260918142813.6ea628dfcc32baf57ba70220@linux-foundation.org>
In-Reply-To: <9f415dc7-adad-4161-b20d-7c3173f50ff3@kernel.org>
References: <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
	<20260910114602.926944-1-dipiets@amazon.it>
	<aqQlUr-1h07G8JWM@cmpxchg.org>
	<8d6a8a63-4adc-458a-b548-a47bf5ff8eb7@kernel.org>
	<aqq8pWI0u1IZNWHT@cmpxchg.org>
	<9f415dc7-adad-4161-b20d-7c3173f50ff3@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 18 Sep 2026 09:05:40 +0200 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:

> >> Unless I'm mistaken about that MIGRATE_HIGHATOMIC part, it seems all sashiko
> >> concerns can be dismissed and then indeed v4 is the better version.
> > 
> > It looks like a real issue to me, but one that already exists
> > independent of Salvatore's change.
> 
> But Salvatore's change (v4, not v5 IIUC) will make it worse because
> __GFP_DIRECT_RECLAIM + __GFP_NORETRY costly order opportunistic attempts
> with fallback will start eating the highatomic reserves too?
> 
> In that case the fix for this should probably be part of the same PR to
> Linus and be also stable with Fixes: 281dd25c1a01

Oh.  I thought this was settled.

I've removed "mm/page_alloc: avoid direct compaction for costly
__GFP_NORETRY allocations" v4 from mm-hotfixes-stable and re-added it
to mm-hotfixes-unstable and I'll await developments.
