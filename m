Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7AB6472F81
	for <linux-xfs@vger.kernel.org>; Fri, 21 Aug 2026 12:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787314137; cv=none; b=hwpfNmADPQbR9qyGroyzqfZNokd44yUbfQo75aYPkzIjYlgb8M/7l431ouVIZLVzv7S6Amb8e7u7k2Cp+mJGEy0hu5qrshwXgCtLAbXmiRah22A8loIsueaQPiTw83uitv4eIubv0ypUcCE2ONnYXwObtTWP5xdOKQaXqjp/lRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787314137; c=relaxed/simple;
	bh=l5oAWZu7rkPPk5oMwWiAfitjSBwWUsqAQIjilfN5Gjc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=ZE/rQVrTAS9D4cLeVWv/ZNN+zZNF9sbkMtFIoyKK9AI/R05q1AMnlKEmllvaI/LNv5xQhCpoBNMJOav/ffNA3QbRmaAfwz8DRfSeBv1kPDfYjZaSsoTWWy5nD/9Mt3Hv7eVaVgYgRq6xZh9gcnzkO+fymdIXIj21moR67tLKiZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=HO5kpqfa; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="HO5kpqfa"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260821120848epoutp02de512e3887479674a0444ff94aeafed1~N0Lr5Egqi0402704027epoutp02i
	for <linux-xfs@vger.kernel.org>; Fri, 21 Aug 2026 12:08:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260821120848epoutp02de512e3887479674a0444ff94aeafed1~N0Lr5Egqi0402704027epoutp02i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1787314128;
	bh=I53J9+mBwCgZZgPE7jNJEo1ZucOq6BAk5MDbIZ2A9pQ=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=HO5kpqfaYHMcO+v0mZtnrwxtnzMZ6fnXuASJoEdUrYzdqj/WSymtQDc1k8M0iZzJe
	 9EIFcMw4WyoesCNuDlhBJccf83bd+gAQtaHLYkWyepVwpnJukI7lUrjnM4LJc5Qrk6
	 1jJHqElGRv0D/UJyBS+mZQmBH1fq+mJahEYnY6Fs=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260821120847epcas5p36e56b8a34657aa0014c5258bb26b0074~N0LrVCgmY0633206332epcas5p3w;
	Fri, 21 Aug 2026 12:08:47 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.87]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4hRJxV5X0Wz2SSKZ; Fri, 21 Aug
	2026 12:08:46 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260821120846epcas5p1a48ba61937cb24bd471b1c9513285c0d~N0LpqDZY82301723017epcas5p1C;
	Fri, 21 Aug 2026 12:08:46 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260821120844epsmtip22a6ff317b708d781e5759db80a3bb5af~N0Ln4LpgO0471904719epsmtip25;
	Fri, 21 Aug 2026 12:08:44 +0000 (GMT)
Message-ID: <5f212467-8920-4273-aa01-29d80d6e8f6a@samsung.com>
Date: Fri, 21 Aug 2026 17:38:43 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/6] xfs: generic AG set based steering
To: Christoph Hellwig <hch@lst.de>
Cc: brauner@kernel.org, djwong@kernel.org, dgc@kernel.org, jack@suse.cz,
	cem@kernel.org, axboe@kernel.dk, kbusch@kernel.org, ritesh.list@gmail.com,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com, Anuj Gupta
	<anuj20.g@samsung.com>
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20260819072137.GG1541@lst.de>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260821120846epcas5p1a48ba61937cb24bd471b1c9513285c0d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260717125636epcas5p2b68dd498717813e0b395b9d57d9d97df
References: <20260717125538.508925-1-joshi.k@samsung.com>
	<CGME20260717125636epcas5p2b68dd498717813e0b395b9d57d9d97df@epcas5p2.samsung.com>
	<20260717125538.508925-5-joshi.k@samsung.com> <20260819072137.GG1541@lst.de>

On 8/19/2026 12:51 PM, Christoph Hellwig wrote:
> On Fri, Jul 17, 2026 at 06:25:36PM +0530, Kanchan Joshi wrote:
>> Improve allocator concurrency and reduce interleaving by introducing
>> fixed sized AG set.
>> Use low bits of the inode as a hash to select AG within the AG set.
>> Overall, a file will try to use the same AG (and contiguity is maintained),
>> but multiple files will be spread across all AGs in the target AG set.
> I'm a bit worried this kind of magic - the inodes close to each other
> might not all have data or very different amounts of data.
> 
> I suspect the root cause this helps with is that the XFS initial data
> placement algorithm that tries to place file data next to the inode is
> actively harmful these days.  So doing an initial AG selection similar
> to how the RT device does the initial RTG selection might be more
> useful here (and thinking about moving to an inode32-like scheme
> where small metadata with a lot of churn is constrained to a few
> AGs).

Thinking to drop this for now, as this may need a distinct series.

This patch was here because stream based AG-set extended what this patch 
was doing (i.e., the minimal fixed-size AG-set). That relationship goes 
with the change you mentioned.

Replacing default AG allocator with an automatic RG-style rotor (no 
user-supplied write-stream) might be a radical change in terms of impact.
