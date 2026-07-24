Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5BF3B3898
	for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2026 12:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784895740; cv=none; b=u3+hwvi7j5mcV9Pzc8+GkjtrLPS+6yFWmay5iBIFLgO6GLMW6n9IQbCUwKwEDGkEVCbXAZyWKIPVr/AaxcHO6IdRXNuvdGzSIok7IgT7K7Ks+7K1a9TTHgu6RAVxrZkBST3fTQ5OgRAkeLTm72Nlu2IWj/Q0dfrlEMTDGKEokqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784895740; c=relaxed/simple;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=kPLSu/tmhW+b7ujx8w0oWT9Brd7gSOV8p/N097lMg9UqaHUW4Dyyt8g9kuGCZYz7fTyY4wGSB3Ni8f38zFf9TALWIN5IgNiLOq/nmFoUWo7KpTwYABdqvV6synHI4IwAacf8uyNUWoAafZP89wZHDg059fmRSe2r/Sp1eVvtjiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=UCRAo+HW; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="UCRAo+HW"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260724122215epoutp01b7e2ed7c2b21739f2ce6ea9428f0838b~FOTbxAn9b0582705827epoutp01V
	for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2026 12:22:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260724122215epoutp01b7e2ed7c2b21739f2ce6ea9428f0838b~FOTbxAn9b0582705827epoutp01V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1784895735;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=UCRAo+HWJu3qkhQpYMjpDhb4oHqVMvG117e3ui6a/vKzZvIUr85yXpLFNTyuEWt1e
	 9ACzUODCeVFGRvE6BbPxpj+jkoswpJEVZPLUenTIIujNwtBPva+USyyrC24SJsTaN7
	 xlBiKitPUAbIIkrayEz0CKyd55lQ2pCDIfjko2Qk=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260724122215epcas5p3c61355e52ea0eebbfa4af1aa201513ba~FOTbWF2Gi1193711937epcas5p36;
	Fri, 24 Jul 2026 12:22:15 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.92]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4h66Yy1zWTz2SSKX; Fri, 24 Jul
	2026 12:22:14 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260724122213epcas5p2ee91c8421e086e72de9e91abb0ab4cef~FOTaOt2392006320063epcas5p2M;
	Fri, 24 Jul 2026 12:22:13 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260724122212epsmtip1e9d45490ff4f570ce11afa2a879354f3~FOTY3DyVl1747517475epsmtip1t;
	Fri, 24 Jul 2026 12:22:12 +0000 (GMT)
Message-ID: <48b9c789-5ec9-49b8-8635-dbfd8ea4ef1f@samsung.com>
Date: Fri, 24 Jul 2026 17:52:10 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] block: remove bip_should_check
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Anuj Gupta
	<anuj20.g@samsung.com>, Christian Brauner <brauner@kernel.org>, "Darrick J.
 Wong" <djwong@kernel.org>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20260724051001.202741-2-hch@lst.de>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260724122213epcas5p2ee91c8421e086e72de9e91abb0ab4cef
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260724051025epcas5p14939b6d2ecbfb02bcfd7180cf3f39fa4
References: <20260724051001.202741-1-hch@lst.de>
	<CGME20260724051025epcas5p14939b6d2ecbfb02bcfd7180cf3f39fa4@epcas5p1.samsung.com>
	<20260724051001.202741-2-hch@lst.de>

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
