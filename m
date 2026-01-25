Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FF42FFDEE
	for <linux-xfs@vger.kernel.org>; Sun, 25 Jan 2026 20:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769372100; cv=none; b=BQhMEFqiRj/YY5dxNbecPFVDucoiXQfARn9NsWqbN1IBDx97Lu6QAKb9Xshih6z+Merwf+3QJ4A8m4kHdtHAIehHfaZgl1iDKh1NCiQhg+rqxxUfSpt+BUNrjTUX5WOAbmlKXzt45u0OgowfH7QsU2PA3JU2LAYDzJkliWYwx4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769372100; c=relaxed/simple;
	bh=OuBEfKb4DxWC/8jq3lLUOnyZkjh2+ze7Hx0jfDBe4Dk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=aXTiM3UZhrLqrNLLiLfINdzONwCsON2HbU257cSRVhwp1P7DaHPvACQSCXUzr/1wMMonTDosP2vLi0ZeJ68iAE+DeZ+G1ASc7rP9dfjc8n6CdUIV4zDnsHXXtEFTgOU1/Bxk8M9wzUFAWS4wMp1aGkshK9TVaOUQ0wzQxPGAabE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=uqG9kP19; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="uqG9kP19"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260125201449epoutp021fae7c11aa57ce1c55a42969667c9dad~OEop99y1I2043620436epoutp02U
	for <linux-xfs@vger.kernel.org>; Sun, 25 Jan 2026 20:14:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260125201449epoutp021fae7c11aa57ce1c55a42969667c9dad~OEop99y1I2043620436epoutp02U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769372089;
	bh=OuBEfKb4DxWC/8jq3lLUOnyZkjh2+ze7Hx0jfDBe4Dk=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=uqG9kP19rtZSs14wvuV61aVi0lbK5ujOjhydtohKaqfMYd60QZB2LrW9JozgGTaP/
	 g1skEaa2+sJ1a1ZWauHUZSi0Faf5D3yLWdyAITvSwmmGdAi3ITjFQa3NEYeSTCPTEM
	 +1n8qdGUM4e9hxZ418SaGFlE65wYt2ZhB9PajEvg=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260125201448epcas5p364329e0bf8ea6d1baaaed0addfe5fb83~OEoo97vDo1870518705epcas5p3-;
	Sun, 25 Jan 2026 20:14:48 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.88]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4dzjZH4BJ5z6B9m5; Sun, 25 Jan
	2026 20:14:47 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260125201446epcas5p12e8f4a24a151776c67079759b2667611~OEonL3qVE0032500325epcas5p1n;
	Sun, 25 Jan 2026 20:14:46 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260125201443epsmtip1c399112a41f8d93a5d789d339a01036b~OEokegkJ51855218552epsmtip1V;
	Sun, 25 Jan 2026 20:14:43 +0000 (GMT)
Message-ID: <88813626-a33c-464f-a782-41b815800fa9@samsung.com>
Date: Mon, 26 Jan 2026 01:44:40 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/15] block: factor out a bio_integrity_setup_default
 helper
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Christian
	Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>, Anuj Gupta
	<anuj20.g@samsung.com>, linux-block@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20260121064339.206019-3-hch@lst.de>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260125201446epcas5p12e8f4a24a151776c67079759b2667611
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260121064706epcas5p3966a36ee7579ee56b6f13eec5ff5067d
References: <20260121064339.206019-1-hch@lst.de>
	<CGME20260121064706epcas5p3966a36ee7579ee56b6f13eec5ff5067d@epcas5p3.samsung.com>
	<20260121064339.206019-3-hch@lst.de>

On 1/21/2026 12:13 PM, Christoph Hellwig wrote:
> Note that this includes a small behavior change, as we ow only sets the

with commit wording fixed,

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
