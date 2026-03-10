Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA0F3C8721
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 21:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773177578; cv=none; b=r2/S8vQJAAZjlHaqIeqNC37oWsPbn71Bm5akOxZgArCPdvEHSgwJdNsObAdG/wBFWrdbhnHdkiMo6SioRP4NMS1qDvG/eFJxuQogk7g6bLgAE4a88eu4k/VW0mdIVvzXPXHZ5Da/YT8xcescU1Hyz29FrnGbEG7iqyEY5d1EabI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773177578; c=relaxed/simple;
	bh=Zf7/i0jGVAu0/+7+dSwJFtM3bUaQc1Rs7UI/+ZD5oOs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=QYrN303412jC6bRLW90oqyj79AGNMDxDRjSQBFE3CUbaU0tzJQ5KbgWrIURw+RrzHBxx8sk+HXA+LJ8QvYip2h1kkpEgD0LM1yAePP0xaafZb0MrfrFRsKXECnD9JjPmUmteEm3H0gRRw1f/+iJI75lz93HS+0MjHkd4J/P2kTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=XEWWl6od; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="XEWWl6od"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260310211933epoutp048ed8ab0522324cae415ea9b62794213c~bl5utmSXp0440304403epoutp04M
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 21:19:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260310211933epoutp048ed8ab0522324cae415ea9b62794213c~bl5utmSXp0440304403epoutp04M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1773177573;
	bh=WwMjZur1Xm8pRnWlc1Gkb+/unkxaBfqJrvZe+O8jiJY=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=XEWWl6odqYYdrhbBZBD6L5tw3NkcrGvmAXc9/LRTE3VOVzpD/vZruWY8hAt2nRiGb
	 gu7mcGmk0AISIDCN3cjzecbBFeJeaeaydkVKiOu3IKurcKhVIFu0jJt+qUDDdMufSh
	 K0fLDHUqBfUqKABtu2icem/94kuu/N7mJ/r7vpf0=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260310211932epcas5p158327b35aaf2d8aeb73b3e5056937f5c~bl5uDXnwT2299022990epcas5p1R;
	Tue, 10 Mar 2026 21:19:32 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.94]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4fVmwg3hb6z6B9m4; Tue, 10 Mar
	2026 21:19:31 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260310211930epcas5p12a8e25dc1aaa1026025282b281b04d46~bl5smpzcF1050410504epcas5p1h;
	Tue, 10 Mar 2026 21:19:30 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260310211928epsmtip1700dab47f7127f82fbeec89dedbd4ee8~bl5qrJzFO1355813558epsmtip1w;
	Tue, 10 Mar 2026 21:19:28 +0000 (GMT)
Message-ID: <9b0d2f1c-f3dd-4e7d-963b-dd0fde02b243@samsung.com>
Date: Wed, 11 Mar 2026 02:49:27 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] write streams and xfs spatial isolation
To: Christoph Hellwig <hch@lst.de>
Cc: brauner@kernel.org, djwong@kernel.org, jack@suse.cz, cem@kernel.org,
	kbusch@kernel.org, axboe@kernel.dk, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, gost.dev@samsung.com, Hans Holmberg
	<hans.holmberg@wdc.com>
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20260309154047.GA18538@lst.de>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260310211930epcas5p12a8e25dc1aaa1026025282b281b04d46
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260309053425epcas5p32886580a4fbe646ceee66f2864970e9f
References: <CGME20260309053425epcas5p32886580a4fbe646ceee66f2864970e9f@epcas5p3.samsung.com>
	<20260309052944.156054-1-joshi.k@samsung.com>
	<20260309154047.GA18538@lst.de>

On 3/9/2026 9:10 PM, Christoph Hellwig wrote:
> This is laking numbers to justify all the changes.
> 
>  From previous experiments the most important isolations is to put
> the file system log and metadata into a separate stream each, which
> would be the first step before exposing user knobs.
> 
> And once we look into application optimizations I think your best bet is
> to resurrect the FDP/write streams support for zoned XFS that Hans and I
> did and posted in reply to one of Keith' iterations of the write stream
> patches.  This will reuse all the intelligent placement decisions we've
> put into that allocator.  Once that is done we can look into exposing the
> write streams already inherent in that to user space, but we really
> should be doing all the ground work first.  And maybe some of this can
> apply to the conventional allocator, but given that it has no way to
> track the placement unit sizes I'm a bit doubtful that the results will
> look great.

In the LSFMM thread on this topic, you advised that I should not tie a
high-level VFS/XFS feature exclusively to FDP as a single
implementation [1]. I took your advice and tried to communicate that
general value with this iteration.

- Parts of these patches rely on block device's write streams. Block 
device provider can be anything (lvm, raid etc.) that chooses to expose 
streams to leverage the application's spatial isolation intent. That 
goes back to what I added in the cover letter: write streams enable 
collaborative data placement, allowing the abstraction provider to 
leverage application intent.

- I added Patch 4 (AG steering) and Patch 5 (software streams)
specifically with this general-purpose intent in mind. For FDP only 
enablement, I wanted only first 3 patches.

Regarding the Zoned allocator approach - this was designed for a
fundamentally different device architecture. My concern with porting
FDP to it is that it negates the design consensus + progress we reached 
since the RFC last year.

Temperature vs. Spatial Placement: The Zoned allocator leverages
temperature/lifetime hints. The deliberate design choice to move away
from a temperature-based API was made in RFC itself, and I outlined
the reasoning in the cover letter ("Comparison with write hints"
section). Also the discoverable interface allows to add things like 
logs/meta streams easily.

Hardware Constraints: The Zoned allocator is designed to manage strict
hardware constraints (tracking exact zone write pointers, host-side
garbage collection). Conventional and FDP drives offload these 
constraints to FTL anyway.

Lack of precise placement unit tracking: If any inefficiencies occur
due to that, they would exclusively apply to FDP-capable device.

The AG steering scheme is intended for the broader class of conventional 
block devices which don't expose write pointer, placement unit etc.

[1] https://lore.kernel.org/linux-fsdevel/20260223135339.GA17313@lst.de/
