Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072BF3644C6
	for <linux-xfs@vger.kernel.org>; Fri,  6 Feb 2026 10:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770372474; cv=none; b=rKmLEueLCcPRcbgmh8V+sIq5SZvtVyLHcKyroNKwz4yOgB8dV+C09fsV9ZHMgLDDO1txjoTWVhz2sLymWwkFir4oIsUQYUwEpwREkr2uYg/WQ/TwcbTLg9kD7QMVqd2sTthkuFZKupLM9cm2iyCZueuPD8ZxdqifjViSAYNfNAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770372474; c=relaxed/simple;
	bh=zkisYpju7OIVNmeQIv2g+Pbt/1RHOnflWi27WX6FIbs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=g/ArwfjvqlSnM+H4+o0oLnbnJcqcr5g26eBciK7cz2CaZgFgyEu758GrKFg60Wp9W7BdwxdC5gBb8Ol9PLOxzV6R75uhaG6tXOqfTr7t70bfoop1ZmN+oh1SC16Eq0mz+OuRxQ6F1YBD8yv30o71KX5UhfviaeEIIcnPJvzdsvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Lp9qnYZy; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Lp9qnYZy"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260206100746epoutp0379c87cbb826ee608faab7e5b4893eeaa~RoGDHjLk30168301683epoutp036
	for <linux-xfs@vger.kernel.org>; Fri,  6 Feb 2026 10:07:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260206100746epoutp0379c87cbb826ee608faab7e5b4893eeaa~RoGDHjLk30168301683epoutp036
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1770372466;
	bh=n7zGrdaEsDLLJ1RJqF9wbK0puJiQDIqXQjEhB/FWJOs=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=Lp9qnYZyS/FOrAKEvlub8fB/7fa23huJqbR8aJ8rjt//kmImjmiwttvfHAtF8vGcw
	 025P1oRLexJoBjEU5wuKKRT0yL2vK5FCszdVdHe471lw8tpaUIh9CLLedurJJpEK5i
	 hMuCTCvd3VXpq/cpAMSGx+A4WDxShwV8WzexJkFM=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260206100745epcas5p3a8327b1297e84e90ffb34615103a4773~RoGCMjuIl1568815688epcas5p3Q;
	Fri,  6 Feb 2026 10:07:45 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.94]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4f6qXJ0LDnz6B9m4; Fri,  6 Feb
	2026 10:07:44 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260206100743epcas5p1a70b6c71343aa9c1ebd818d70b3dceee~RoGAgY7uA0598805988epcas5p1W;
	Fri,  6 Feb 2026 10:07:43 +0000 (GMT)
Received: from [107.111.86.57] (unknown [107.111.86.57]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260206100739epsmtip183b7d9978cef2ff67102e2bc7008cce0~RoF9acq2q1596515965epsmtip1z;
	Fri,  6 Feb 2026 10:07:39 +0000 (GMT)
Message-ID: <28bfd5b4-0c97-46dd-9579-b162e44873a2@samsung.com>
Date: Fri, 6 Feb 2026 15:37:38 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/6] AG aware parallel writeback for XFS
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, djwong@kernel.org
Cc: Brian Foster <bfoster@redhat.com>, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, willy@infradead.org, mcgrof@kernel.org,
	clm@meta.com, david@fromorbit.com, amir73il@gmail.com, axboe@kernel.dk,
	ritesh.list@gmail.com, dave@stgolabs.net, cem@kernel.org,
	wangyufei@vivo.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, gost.dev@samsung.com, anuj20.g@samsung.com,
	vishak.g@samsung.com, joshi.k@samsung.com
From: Kundan Kumar <kundan.kumar@samsung.com>
In-Reply-To: <20260206062527.GA25841@lst.de>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260206100743epcas5p1a70b6c71343aa9c1ebd818d70b3dceee
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260116101236epcas5p12ba3de776976f4ea6666e16a33ab6ec4
References: <CGME20260116101236epcas5p12ba3de776976f4ea6666e16a33ab6ec4@epcas5p1.samsung.com>
	<20260116100818.7576-1-kundan.kumar@samsung.com> <aXEvAD5Rf5QLp4Ma@bfoster>
	<ca048ecf-5aec-4a0d-8faf-ad9fcd310e21@samsung.com>
	<aXN3EtxKFXX8DEbl@bfoster>
	<e7413e3b-3fae-4aab-90a1-4a6695156b2e@samsung.com>
	<20260206062527.GA25841@lst.de>

On 2/6/2026 11:55 AM, Christoph Hellwig wrote:
> I fear we're deep down a rabbit hole solving the wrong problem here.
> Traditionally block allocation, in XFS and in general, was about finding
> the "best" location to avoid seeks.  With SSDs the seeks themselves are
> kinda pointless, although large sequential write streams are still very
> useful of course, as is avoiding both freespace and bmap fragmentation.
> On the other hand avoiding contention from multiple writers is a good
> thing.  (this is discounting the HDD case, where the industry is very
> rapidly moving to zoned device, for which zoned XFS has a totally
> different allocator)
> 
> With multi-threaded writeback this become important for writeback, but
> even before this would be useful for direct and uncached I/O.
> 
> So I think the first thing I'd look into it to tune the allocator to
> avoid that contention, by by spreading different allocation streams from
> different core to different AGs, and relax the very sophisticated and
> detailed placement done by the XFS allocator.

When you say "coarse-grained sharding", do you mean tracking a single
"home AG" per inode (no per-folio tagging) and using it as a best-effort
hint for writeback routing?

If so, we can align with that and keep the threading model generic by
relying on bdi writeback contexts. Concretely, XFS would set up a 
bounded number of bdi wb contexts at mount time, and route each inode to 
its home shard. Does this align with what you have in mind?

We had implemented a similar approach in earlier versions of this
series[1]. But the feedback[2] that we got was that mapping high level
writeback to eventual AG allocation can be sometimes inaccurate (aged
filesystems, inode spanning accross multiple AGs, etc.), so we moved to
per folio tagging to make the routing decision closer to the actual IO.
That said, I agree that the per folio approach is complex.

Darrick, does this direction look reasonable to you as well?

[1] 
https://lore.kernel.org/all/20251014120845.2361-1-kundan.kumar@samsung.com/
[2] https://lore.kernel.org/all/20251107133742.GA5596@lst.de/

