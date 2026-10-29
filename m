Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793276237;
	b=WuBYyFZ4sGQz7bby3AKaWrUho7sXN7+aEXF9UCHmvNiOOx9j0T31X1xb0MsdDibonvC1
	 crWRFbSV+r3Hj7z9242xt99s+yzcWTJvcIcjI2NjHkzv5kNuINIDNB1ni6FquPLOVd65J
	 S0AVFV4vtguud+qY7ir+RwSvzVojB/dzCYfV57pEqn07u+3qXWm6JOg4FnbtUiek6z/7S
	 fMA7p4HZMYz/KCz/W8Jr/wIuYkpPFR5WI3Nf4FgApKnxtz+VIQwQZsNdmYxsXQMp8uRuv
	 ZVuX3hUlira7R8D6jJee+xcT85/8M4Sc6yfWH3v2nGKyKLkl/C+Bzh9DgPrQbScCZ1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793276237;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=rdj4FDEy6WzQ7Loxo6AfInFROqOgDeI/IwQhhy4RHXE=;
	b=uG24FPk/SwjtOtaK6DKAEN5D54SoK3XhJ10X9EmgFQ08hYIOo6d0+Eqty1LqMPXxLc/r
	 sw3Mf2yz/5lS7yxu41ZUHujF26OWq6g/oYhKDIkWpTV3BBx5k/pPccpKfGziJWCY3Qebq
	 A24x6ZGkNr6wbDsprgV2yOyUrTTB85WFKNqFg4fPYTOcAVWirQzdIWOO4Ghj4vnEdLc8W
	 zHFO/WlT2x1PEK5JystRCqG4EuCycR8ThAfUm+LuxcP58A0Mr9vfm5E0zCnR36Cs1WsmQ
	 6uF78fkSgdjpt26lkWoWuZirtm/AhpvJvlUoLP/3gS6twmvzoiqnHvhhHjcIgMmLxEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F9C606A326;
	Thu, 29 Oct 2026 12:17:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 03F9C606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6026368BEB; Thu, 29 Oct 2026 13:17:11 +0100 (CET)
Date: Thu, 29 Oct 2026 13:17:10 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>, Salvatore Dipietro <dipiets@amazon.it>,
	hannes@cmpxchg.org, abuehaze@amazon.com, alisaidi@amazon.com,
	blakgeof@amazon.com, brauner@kernel.org, brendan.jackman@linux.dev,
	david@redhat.com, dgc@kernel.org, dipietro.salvatore@gmail.com,
	djwong@kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, matt@readmodwrite.com, mhocko@suse.com,
	ritesh.list@gmail.com, rvvandan@amazon.com, stable@vger.kernel.org,
	surenb@google.com, vbabka@kernel.org, willy@infradead.org,
	ziy@nvidia.com
Subject: Re: [PATCH 1/2] mm: page_alloc: do not give all non-blocking
 requests reserve access
Message-ID: <20261029121710.GB24651@lst.de>
References: <arFBr22V60BMmVpl@cmpxchg.org> <20261027150002.318916-1-dipiets@amazon.it> <20261028144148.GA14023@lst.de> <20261028225517.75e13881be22461a8c94e07d@linux-foundation.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028225517.75e13881be22461a8c94e07d@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 28, 2026 at 10:55:17PM -0700, Andrew Morton wrote:
> > It would be really important to get some fix for this into 7.3.
> > We can still perfect it later.
> 
> What is "this"?  You're referring to the performance regression which
> Salvatore's "mm/page_alloc: avoid direct reclaim and compaction for
> costly __GFP_NORETRY allocations" addresses?

As in I don't really care how the xfs/iomap performance issue gets fixed,
I just want it fixed yesterday.

