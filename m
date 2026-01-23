Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E021C84BD
	for <linux-xfs@vger.kernel.org>; Fri, 23 Jan 2026 12:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769170719; cv=none; b=LQjtXtPaui37oOCf0MXaoGiGw82nYxHBEJMQ+4aySVhXmOPQURFJfekErn/cfo43wyD6Orh1TB0siGDVKh7Uw2HfrKbrfyhL50d6ozSOkAoAggFtKs9ZEzye4ExxGXwGlY75suZYTjz4bA0AglCwY0TRfPt/2LJYHPiDq4Blh9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769170719; c=relaxed/simple;
	bh=Ibv50jU/EOdekdVYIAJPI44nrpi7ec4RH5igVxtsObo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=bKL5aqGXbTJUux1iyE92s2yqq4j9OV501AilG/AzK1+QZoypg0/Ig+XziLXMn3IY57iOVHcCQ2osMJZEJdREoqeTvlhH8O3lgnVe/d9Lenvum3SeU7xGVwlntjeF16quIDxq4tLJbaVrKuAYCWrZtY4piyENFoXtEqrVys7sXtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=O6kpcJ/L; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="O6kpcJ/L"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260123121836epoutp0431008ee4cde7bba74ff0aba2f16e923a~NW2SSk-MD0694706947epoutp04w
	for <linux-xfs@vger.kernel.org>; Fri, 23 Jan 2026 12:18:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260123121836epoutp0431008ee4cde7bba74ff0aba2f16e923a~NW2SSk-MD0694706947epoutp04w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769170716;
	bh=Ibv50jU/EOdekdVYIAJPI44nrpi7ec4RH5igVxtsObo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=O6kpcJ/LOM5juIc2+PSBkjULkndByHLszHOhF4y1/wZkjKg0TlIbKcc78cC/WlHj9
	 pis948jRu5Xad8R7HRNCUBKVe1iTX4Q9vDmIsLYd4Zqgg1e4uoGr677FaCe2+uef73
	 T25Ia3foGItfQ6UNM3a4fT/q6jZhrfGSvKIr8Apc=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260123121835epcas5p35edc9c7b887ace25845fb69073fd02c1~NW2R0pHFq0347603476epcas5p3F;
	Fri, 23 Jan 2026 12:18:35 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.92]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4dyH5k4wG7z6B9m6; Fri, 23 Jan
	2026 12:18:34 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260123121834epcas5p16908988385a372270e3f617c6b0a52d9~NW2Qj7lKT1530515305epcas5p1p;
	Fri, 23 Jan 2026 12:18:34 +0000 (GMT)
Received: from green245.gost (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260123121832epsmtip1ab33741bd6d15ae8a231c7e47e81dba4~NW2POcCiO1297612976epsmtip1P;
	Fri, 23 Jan 2026 12:18:32 +0000 (GMT)
Date: Fri, 23 Jan 2026 17:44:16 +0530
From: Anuj Gupta <anuj20.g@samsung.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, Qu
	Wenruo <wqu@suse.com>, Al Viro <viro@zeniv.linux.org.uk>,
	linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/14] block: refactor get_contig_folio_len
Message-ID: <20260123121416.pdj5peze755kdnth@green245.gost>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260119074425.4005867-2-hch@lst.de>
X-CMS-MailID: 20260123121834epcas5p16908988385a372270e3f617c6b0a52d9
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----IrfruICR4kMULzJWPGPqiSt5VhS9eUGYkVmPB-DHhmy0YhYM=_11f361_"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260123121834epcas5p16908988385a372270e3f617c6b0a52d9
References: <20260119074425.4005867-1-hch@lst.de>
	<20260119074425.4005867-2-hch@lst.de>
	<CGME20260123121834epcas5p16908988385a372270e3f617c6b0a52d9@epcas5p1.samsung.com>

------IrfruICR4kMULzJWPGPqiSt5VhS9eUGYkVmPB-DHhmy0YhYM=_11f361_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 19/01/26 08:44AM, Christoph Hellwig wrote:
>Move all of the logic to find the contigous length inside a folio into
>get_contig_folio_len instead of keeping some of it in the caller.
>
>Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com

------IrfruICR4kMULzJWPGPqiSt5VhS9eUGYkVmPB-DHhmy0YhYM=_11f361_
Content-Type: text/plain; charset="utf-8"


------IrfruICR4kMULzJWPGPqiSt5VhS9eUGYkVmPB-DHhmy0YhYM=_11f361_--
