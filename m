Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB375190462
	for <linux-xfs@vger.kernel.org>; Tue,  3 Feb 2026 07:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770103940; cv=none; b=cRl4PyWtz1meSer72LD48agifQxoLoPI1Gvv7W6aH9XiGWKCl5ExC/xsUznvQOqLehzNjsWgO+AmKmTaPilmgxsG9idYd3JiEpU91Nourc3lWul3g4DwLsHfxwODVIXGe/HenM2Gzs5EjOEwksizaqeVODTNubMvLGGLf9Cv1CE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770103940; c=relaxed/simple;
	bh=TIrZf/bfYFR7dObncn2TdpDlXe9PrLJ819dtxbwUs1E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=QxFCG6AWaL9OZr4HRjrlpa3lW/rq0s/I6/CwRgxAGRzIZoibPM1hJo1cFUBq8eodcm8VwAn/gsUYVB4pYkwfOkFKX6m6rIFOJIK/gW9zwTvUSRlx+es3BC98gnSc0QoedDVfzn6pUQkmQtAFYZs2K+DsAl1tyNffFQCAhWHUMc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=rhK/m23P; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="rhK/m23P"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260203073216epoutp0325bd25807cd5c43df0221c06802b8419~QrCbrcmeF1852318523epoutp03b
	for <linux-xfs@vger.kernel.org>; Tue,  3 Feb 2026 07:32:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260203073216epoutp0325bd25807cd5c43df0221c06802b8419~QrCbrcmeF1852318523epoutp03b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1770103936;
	bh=GEM5n02Ulac7TkOC/loRAoXQMHBkMvS2O9ly7ncfHrg=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=rhK/m23PowM1nvJnnEqBrXM3kQfiI18uUCyb+2P1FnGCPmCJFxa4sFzr34TmiaV+E
	 F9peggOOQ34fnfe21sNA1Sw74VYQ5YqrqbOKciB7ISroW0vIWbRTGDGK1nkafOqua5
	 rPCKQ8WFpIMT1soqaBoneQRTL/57hluean9KPWzs=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260203073216epcas5p10e212c450887dfeb2d262b56ad02c9e2~QrCbDxKYE1157711577epcas5p1Z;
	Tue,  3 Feb 2026 07:32:16 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.90]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4f4wDG6Lxzz6B9mD; Tue,  3 Feb
	2026 07:32:14 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260203073214epcas5p27d7fabd36d5f2751902539f0c5618805~QrCZPje9k2053520535epcas5p2V;
	Tue,  3 Feb 2026 07:32:14 +0000 (GMT)
Received: from [107.111.86.57] (unknown [107.111.86.57]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260203073210epsmtip1d1b85e69ec1468536e5beea7c27bbf70~QrCVdv_iT2822828228epsmtip1w;
	Tue,  3 Feb 2026 07:32:09 +0000 (GMT)
Message-ID: <1d750771-84cf-4af5-bda8-4feef110276e@samsung.com>
Date: Tue, 3 Feb 2026 13:02:08 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/6] xfs: tag folios with AG number during buffered
 write via iomap attach hook
Content-Language: en-US
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com, david@fromorbit.com,
	amir73il@gmail.com, axboe@kernel.dk, hch@lst.de, ritesh.list@gmail.com,
	dave@stgolabs.net, cem@kernel.org, wangyufei@vivo.com,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, gost.dev@samsung.com, anuj20.g@samsung.com,
	vishak.g@samsung.com, joshi.k@samsung.com
From: Kundan Kumar <kundan.kumar@samsung.com>
In-Reply-To: <20260129224002.GF7712@frogsfrogsfrogs>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260203073214epcas5p27d7fabd36d5f2751902539f0c5618805
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260116101256epcas5p2d6125a6bcad78c33f737fdc3484aca79
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
	<CGME20260116101256epcas5p2d6125a6bcad78c33f737fdc3484aca79@epcas5p2.samsung.com>
	<20260116100818.7576-5-kundan.kumar@samsung.com>
	<20260129004745.GC7712@frogsfrogsfrogs>
	<20260129224002.GF7712@frogsfrogsfrogs>

>
> Also, what happens if this is a realtime file?  For pre-rtgroups
> filesystems there is no group number to use; and for rtgroups you have
> to use xfs_rtb_to_rgno.  The i_ag_dirty_bitmap and the m_ag_wb array
> will be the wrong size if rgcount != agcount; and also you probably
> don't want to have in the same per-group writeback list two inodes with
> folios having the same group number but writing to two different devices
> (data vs. rt).
> 
> --D
> 

For this series I’ll explicitly exclude realtime inodes from AG routing
(skip tagging / fall back to normal writeback). Rtgroup-aware routing 
would need a separate rg-domain (separate worker array/queues sized by
rgcount) as follow-up work.



