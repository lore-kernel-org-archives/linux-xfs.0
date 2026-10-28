Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793198515;
	b=i2xxr20ekIMYlLVHJncvL7AW9CNqsswN1RuGUBLFHsUQikYpUQUYFv9Ri6he0cmstaOp
	 UPoEi8y7OWhKZHFl1xl+kZL4KqQ6jMVNUfICTISPsNs3lO5bdwBw/kpVmxSQRzYtJhyfb
	 /vuG3amTK8zyg/BEPZ4C2tg4cRO7P8X/cAaDQBl1i7frjD2JeOnMq+pQscXIs1396nae7
	 FvjXj9VyhpTg4kSzorHdgdZeVeq9PPYomVsvuJ9IVzAJf+9P8JUbQw9jYdUEyU8bVlG1C
	 kJdt/U4d4cLwXNFbh5zxW8CieYPilUXD0aAk0KjAcu/tm+7dlSkuLPFUV8LPaiXZyUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793198515;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=8RJ2Yn7WpwUCye9rkv6tfQ0zZ5Kyo7robmi/5qT0aAk=;
	b=LRevH982gKLUHz2Z9MHT8uglZHTOQ1uWhgEzsc4Wmdn/h3o12I6hpZ7BQh8JQoFOaLGQ
	 1SvdmcXqX9ZGq+naddLYRIhTrmujHOUaNO3UAxITMAquBAAH6DkWhswSFJXxyDf+hrZBz
	 U4R9vJDTxrB1o+cd4p22wIX5A/GsI67bx/1oM6mAnQsQtttZdqXNm0GW+c6kVYck91Dht
	 PfjBNk0dmb8NaU2Hrin7TanQmSaYcBe1JJmfc6+NqmlJWyVc1g/4QnLafgRYoUbmrcHtD
	 7GNVzQthJZddGrUFFPr1c3EQfDLmpj+9d1ndZXVb8nxgl0+WGsZ8dih7GiKpghpLCYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254E6606A31E;
	Wed, 28 Oct 2026 14:41:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 254E6606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C578F68AFE; Wed, 28 Oct 2026 15:41:48 +0100 (CET)
Date: Wed, 28 Oct 2026 15:41:48 +0100
From: Christoph Hellwig <hch@lst.de>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: hannes@cmpxchg.org, abuehaze@amazon.com, akpm@linux-foundation.org,
	alisaidi@amazon.com, blakgeof@amazon.com, brauner@kernel.org,
	brendan.jackman@linux.dev, david@redhat.com, dgc@kernel.org,
	dipietro.salvatore@gmail.com, djwong@kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org,
	matt@readmodwrite.com, mhocko@suse.com, ritesh.list@gmail.com,
	rvvandan@amazon.com, stable@vger.kernel.org, surenb@google.com,
	vbabka@kernel.org, willy@infradead.org, ziy@nvidia.com
Subject: Re: [PATCH 1/2] mm: page_alloc: do not give all non-blocking
 requests reserve access
Message-ID: <20261028144148.GA14023@lst.de>
References: <arFBr22V60BMmVpl@cmpxchg.org> <20261027150002.318916-1-dipiets@amazon.it>
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
In-Reply-To: <20261027150002.318916-1-dipiets@amazon.it>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 27, 2026 at 03:00:02PM +0000, Salvatore Dipietro wrote:
> 
> Hi Johannes,
> 
> Vlastimil asked that v6 of my page_alloc patch [1] not go to mainline
> before these two patches land, so Andrew parked v6 at the tail of
> mm-unstable and dropped its Cc: stable until then.
> 
> Are you still planning to work on 1/2 and 2/2, and if so, do you have
> a rough ETA? Or would you rather post them as a separate series as
> they are? If anything is needed on my side to move them forward, I'm
> happy to help.
> 
> For what it's worth, I ran both stacked under v6 on v7.3-rc1 and saw
> no performance difference on my benchmark with or without them.

It would be really important to get some fix for this into 7.3.
We can still perfect it later.

