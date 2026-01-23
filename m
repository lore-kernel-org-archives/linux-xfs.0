Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBFC322B89
	for <linux-xfs@vger.kernel.org>; Fri, 23 Jan 2026 12:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769170935; cv=none; b=faWyGZqTIyyHG6b1JRS0pB+2Q1yyV0G84JsGs7u4X9/+m5d1gPLIAB7fR8bCLGuPNN7GSJmpG0Ksf22legZyqS4IjEWeD6aEl2QjdAMyzJF50SfOMc/aig2r94UbkWUD1HnxZksMoh7dRNas74Lrt6jZxQD7Ziz43S0wuklfjL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769170935; c=relaxed/simple;
	bh=uE0Y4/PZw6wM3Bwc/XbiA6B4xt+1e3lNTVbeP03NVw0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=h586Z1Fzgb0bwFGMQjXVBY0X2towSLb5oGMblMlv1pI53WbeC+J2WynmZfOv8SYOJgyqzvP8C33WVM1VSEbxsUEHntL5hQiNNhb1mj03dq/gOFXRrAVY4tpu3JbRp+W/kefBdTy9Wpc7n1VtFv5ojY05bg+FFnRooU4Nqfo5Oj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=pHzDMq9G; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="pHzDMq9G"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260123122211epoutp02476f53969a05d7e7ac78ae5a9f6caef8~NW5a_3L4Y0818308183epoutp02w
	for <linux-xfs@vger.kernel.org>; Fri, 23 Jan 2026 12:22:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260123122211epoutp02476f53969a05d7e7ac78ae5a9f6caef8~NW5a_3L4Y0818308183epoutp02w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769170931;
	bh=uE0Y4/PZw6wM3Bwc/XbiA6B4xt+1e3lNTVbeP03NVw0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pHzDMq9GVyrdzmlgmj+xglim8lm/NSM9ExAxwKvli8ZCeQznXAuFbBzFV9jtIDlPt
	 Sh/A/HrUcnDyMr9NksMrblF1StFTJRF87NckjFlCaACmXqz88ydmg33LkZ0UblSt+3
	 4kpM2U3zZYurCzjNpb4Y72bt2+xOOmRn1j8tX09k=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260123122211epcas5p3fc203848070cabcb3d1611b073778c37~NW5ajvokM0046200462epcas5p30;
	Fri, 23 Jan 2026 12:22:11 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.90]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4dyH9t3RKPz3hhT4; Fri, 23 Jan
	2026 12:22:10 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260123122209epcas5p410ecea8a612e90a02822fc9a134d58a8~NW5ZLiw6V2254622546epcas5p4O;
	Fri, 23 Jan 2026 12:22:09 +0000 (GMT)
Received: from green245.gost (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260123122202epsmtip2e97547376611835d0ca7313b0258a322~NW5SvexHq2333523335epsmtip2w;
	Fri, 23 Jan 2026 12:22:02 +0000 (GMT)
Date: Fri, 23 Jan 2026 17:47:44 +0530
From: Anuj Gupta <anuj20.g@samsung.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, Qu
	Wenruo <wqu@suse.com>, Al Viro <viro@zeniv.linux.org.uk>,
	linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 04/14] block: remove bio_release_page
Message-ID: <20260123121744.rv6cp4veiltp2ssi@green245.gost>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260119074425.4005867-5-hch@lst.de>
X-CMS-MailID: 20260123122209epcas5p410ecea8a612e90a02822fc9a134d58a8
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----dZkOkAIazzHoUX-2rQXwJ8woeHD-_lbejx.E5KOGiu3cq0eS=_11eefd_"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260123122209epcas5p410ecea8a612e90a02822fc9a134d58a8
References: <20260119074425.4005867-1-hch@lst.de>
	<20260119074425.4005867-5-hch@lst.de>
	<CGME20260123122209epcas5p410ecea8a612e90a02822fc9a134d58a8@epcas5p4.samsung.com>

------dZkOkAIazzHoUX-2rQXwJ8woeHD-_lbejx.E5KOGiu3cq0eS=_11eefd_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 19/01/26 08:44AM, Christoph Hellwig wrote:
>Merge bio_release_page into the only remaining caller.
>
>Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com

------dZkOkAIazzHoUX-2rQXwJ8woeHD-_lbejx.E5KOGiu3cq0eS=_11eefd_
Content-Type: text/plain; charset="utf-8"


------dZkOkAIazzHoUX-2rQXwJ8woeHD-_lbejx.E5KOGiu3cq0eS=_11eefd_--
