Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8D7284B37
	for <linux-xfs@vger.kernel.org>; Fri, 23 Jan 2026 12:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769170814; cv=none; b=s3U5cCvG6D6UQ0LynMI4U4Q9510miTKK0lXCu0w+gFHA6tO1xVJmBEkqd+iV/EgEsMZTZB1iF1RYArIXKsitRJjFrfCSMvJMF2A73m8wBHEWeGWmUjh/wFzLHhu19yk5glDVWizWiTWgo/DmFAHMOXRwSY8y/6Xv9IOd6aqha74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769170814; c=relaxed/simple;
	bh=ilL2dlrE/KiSomwQdu5uRqkjqR2ZbkgNV34FQzAfqYo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=DphwRX7PQ7zlRcikZjVo6NwHepOCOMTUhiDtiiHlxexc7b0+6D6gsPkgj5d0KxDmvMTrHt4ftd2nUt55hFOGDmnxQd0yWZVn/CPa6TwG/TB9dqQRx2X/+yNVfOCheW2Gk9WyVG2YYCtHIEzaOunUUmvroNK4Yvur491EOA2G6ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=m3M1j562; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="m3M1j562"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260123122009epoutp04b1d0b1a420f6feeb03d0373bf261c593~NW3pQUYXa1032210322epoutp04I
	for <linux-xfs@vger.kernel.org>; Fri, 23 Jan 2026 12:20:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260123122009epoutp04b1d0b1a420f6feeb03d0373bf261c593~NW3pQUYXa1032210322epoutp04I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769170809;
	bh=6+VPzKKm5P4+Ukz98y3OdGrfpQMZIr0UqmXEbym8kBI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=m3M1j5627yLPoZL30Kc47gc3PxKWO6Dy7mXBhF9PunIhXyoVWYLOolryD9S+tbFcn
	 CwnVFYU4c0XCy7mYFZiL7MVxOtgU2T2du2f7VizleoYfSO4lFQBi2wz13JuCdCkvcP
	 c98DV+XAqFd7ysvkob1WXG7spGGYx91WGPp+LqfM=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260123122009epcas5p497a6027961c55a49979853365ccb782b~NW3o6MLxm2354823548epcas5p48;
	Fri, 23 Jan 2026 12:20:09 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.86]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4dyH7X19GGz3hhT4; Fri, 23 Jan
	2026 12:20:08 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260123122007epcas5p3e7949f3926d91a345d37a057466ccaf3~NW3nnYea-2988829888epcas5p3W;
	Fri, 23 Jan 2026 12:20:07 +0000 (GMT)
Received: from green245.gost (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260123122006epsmtip1d12cea2890678c165bf6707bb45365a0~NW3mTG6ie1400814008epsmtip1v;
	Fri, 23 Jan 2026 12:20:06 +0000 (GMT)
Date: Fri, 23 Jan 2026 17:45:53 +0530
From: Anuj Gupta <anuj20.g@samsung.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, Qu
	Wenruo <wqu@suse.com>, Al Viro <viro@zeniv.linux.org.uk>,
	linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 02/14] block: open code bio_add_page and fix handling of
 mismatching P2P ranges
Message-ID: <20260123121553.cykonmoibjyvb6mq@green245.gost>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260119074425.4005867-3-hch@lst.de>
X-CMS-MailID: 20260123122007epcas5p3e7949f3926d91a345d37a057466ccaf3
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----HKC0oM6l2X7jDELFNxUL3gr1rNZobpnU9ZVzK0VPY15yFScq=_11fb2d_"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260123122007epcas5p3e7949f3926d91a345d37a057466ccaf3
References: <20260119074425.4005867-1-hch@lst.de>
	<20260119074425.4005867-3-hch@lst.de>
	<CGME20260123122007epcas5p3e7949f3926d91a345d37a057466ccaf3@epcas5p3.samsung.com>

------HKC0oM6l2X7jDELFNxUL3gr1rNZobpnU9ZVzK0VPY15yFScq=_11fb2d_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 19/01/26 08:44AM, Christoph Hellwig wrote:
>bio_add_page fails to add data to the bio when mixing P2P with non-P2P
>ranges, or ranges that map to different P2P providers.  In that case
>it will trigger that WARN_ON and return an error up the chain instead of
>simply starting a new bio as intended.  Fix this by open coding
>bio_add_page and handling this case explicitly.  While doing so, stop
>merging physical contiguous data that belongs to multiple folios.  While
>this merge could lead to more efficient bio packing in some case,
>dropping will allow to remove handling of this corner case in other
>places and make the code more robust.
>
>Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com

------HKC0oM6l2X7jDELFNxUL3gr1rNZobpnU9ZVzK0VPY15yFScq=_11fb2d_
Content-Type: text/plain; charset="utf-8"


------HKC0oM6l2X7jDELFNxUL3gr1rNZobpnU9ZVzK0VPY15yFScq=_11fb2d_--
