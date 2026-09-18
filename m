Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE1F38AC6A;
	Fri, 18 Sep 2026 21:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789767304; cv=none; b=hu3dlsm4FGD1N8Tsdk1QAGTV7A3reP6UBBiII4b3zdPPorixRj1bTEGKQK5Ehfpkld6cP/8zYK1N9JgwC4JgdJ3OQhA7EuxKIzO35f2kqNMleuilXbcp3GgXuAjiwmQr3FgRoZqo+X09w5PpSpxoYgjeWLKuZChj/oLbJhYFfiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789767304; c=relaxed/simple;
	bh=NIMK8UH78gzW0ExsqRycQX21cVR/xFMXkxs3i+XwKkA=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=eSCBQ6SMp+DsInrfpsdkImDsC7SLK4RrHYsyak6T/iduZUR/sYsyK6HCoh+wVswgoxbDasvLxP+kcFgAiyJ/hjgBoxVp6vhuOXzfxBCzKUYw2F9M6Zln+cwZSX37gTyBm9pOV6Emm+e0zt1p1cZb/9zqrV4CoSvO2ToS2BqPqew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YaJzyj12; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YaJzyj12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE40B1F000FF;
	Fri, 18 Sep 2026 21:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789767303;
	bh=LzrOWb7USfc3PFDPqWSCCytYQOmFmHMArNmcS4CbPM4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=YaJzyj12zdYNf/Sp38pmFEguIVwlNkjfuCugKp+g1uMkq72x92tnb3Et0wjp9U07l
	 DUbSRVJH/CR+z0Ecq4e/rcWN+XMiqAWAEyRnYEN/5gbxIlIEAGgaMT3Zii8mPQdvlb
	 g6kBbv+wBsEiBEwDI5r0bdsPAAJ3zEJj47RpGvAY=
Date: Fri, 18 Sep 2026 14:35:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Salvatore Dipietro <dipiets@amazon.it>, hannes@cmpxchg.org,
 abuehaze@amazon.com, alisaidi@amazon.com, blakgeof@amazon.com,
 brauner@kernel.org, brendan.jackman@linux.dev, david@redhat.com,
 dgc@kernel.org, dipietro.salvatore@gmail.com, djwong@kernel.org,
 hch@infradead.org, hch@lst.de, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-xfs@vger.kernel.org, mhocko@suse.com, ritesh.list@gmail.com,
 rvvandan@amazon.com, stable@vger.kernel.org, surenb@google.com,
 willy@infradead.org, ziy@nvidia.com
Subject: Re: [PATCH v5] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
Message-Id: <20260918143502.b4fb3587b64e260e14485348@linux-foundation.org>
In-Reply-To: <23676471-d90c-40cd-a357-e71b3d426425@kernel.org>
References: <aqlvnm8AKp5f_UhG@cmpxchg.org>
	<20260918063203.2802342-1-dipiets@amazon.it>
	<23676471-d90c-40cd-a357-e71b3d426425@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 18 Sep 2026 08:40:05 +0200 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:

> On 9/18/26 08:32, Salvatore Dipietro wrote:
> > 
> > On Tue, Sep 15, 2026 at 04:17:00PM +0000, Johannes Weiner wrote:
> >> It would be possible to remove the costly_order gate here and just
> >> bail on __GFP_NORETRY. But no strong feelings.
> > 
> > Will do, I'll drop the costly_order gate and bail on __GFP_NORETRY.
> > 
> > Andrew, since you dropped v5 and restored v4 in mm-unstable, I'll send a
> > v6 (v4 plus the above change) unless you'd rather have an incremental
> > patch on top of v4. Let me know if anything else is needed on my side.
> 
> v4 is in mm-hotfixes-stable now, so an incremental fix will be easier now I
> think.
> 

I just demoted it into mm-hotfixes-unstable.

So a clean v6 would be best now, please.
