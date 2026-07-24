Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492BD3DD861
	for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2026 12:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784895784; cv=none; b=L8jvfIq7Ado2eJ3GnlAmskVaRfgO0tLvqBVNThUDhqoBiOCHc6zUeYY6s+HlmK+SNXCKitO1p4XJ440/AI4DUh+fjU3BMlcerU4AJNgp/882r3dCStggy6kG4233avecGAhuwrqVMqBnwp7u2g2Rb9nYpYPu+of5xszt5QzeS08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784895784; c=relaxed/simple;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=JnbZMRCPE+nQCRuS/Nltk4IaDkJf9ipNtIGLvanJ/DBBchOmB6kBHKbMuVD7SSEWkcw+lhaQDf4YYw/Cq/2bFkutECWRD4KzFwC5GA2zlMxW4HWDlkJnnCNWI2UznroInT81lo6FDYXvjVMP8nMJ2qB9Hx0U7cxU0JHghFMCQ4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=oD2kxkF9; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="oD2kxkF9"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260724122259epoutp018a6dcab70a50f024f493c3b2891e42c7~FOUFLk8Lb0913909139epoutp01D
	for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2026 12:22:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260724122259epoutp018a6dcab70a50f024f493c3b2891e42c7~FOUFLk8Lb0913909139epoutp01D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1784895779;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=oD2kxkF9Ol9wr8pHAhxdadsqcYkjcU7vh7wZWsFDYZZz2S+9r+Yd/iBxIQ7rqm/yt
	 vYruzd9bJa1JVg0J+SUAz5kXg/dvkKSpBvP/6KbtULbtt8AZRjl/aYR52FNWBJlyIy
	 1A0QwqkwF+KD1vL+2+u8i3qS1GHWDAp14qxDID1M=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260724122259epcas5p166e6a4896376fd41e56f822a6f5d57c7~FOUEwVcno1632016320epcas5p1s;
	Fri, 24 Jul 2026 12:22:59 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.93]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4h66Zp5cZjz6B9m5; Fri, 24 Jul
	2026 12:22:58 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260724122258epcas5p255e856fdde8b4514db1de4d2d031d8b5~FOUDqpV5-1849618496epcas5p2Q;
	Fri, 24 Jul 2026 12:22:58 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260724122256epsmtip15d5900ba8ed0352e78f097ecddb21e08~FOUCQlRtg1799617996epsmtip1B;
	Fri, 24 Jul 2026 12:22:56 +0000 (GMT)
Message-ID: <620fea3b-04f4-442b-9175-3175f38073d3@samsung.com>
Date: Fri, 24 Jul 2026 17:52:55 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] block: lift BIP_CHECK_FLAGS to
 include/linux/bio-integrity.h
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Anuj Gupta
	<anuj20.g@samsung.com>, Christian Brauner <brauner@kernel.org>, "Darrick J.
 Wong" <djwong@kernel.org>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20260724051001.202741-3-hch@lst.de>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260724122258epcas5p255e856fdde8b4514db1de4d2d031d8b5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260724051026epcas5p16435f16b25cb443b0f6d916a090237eb
References: <20260724051001.202741-1-hch@lst.de>
	<CGME20260724051026epcas5p16435f16b25cb443b0f6d916a090237eb@epcas5p1.samsung.com>
	<20260724051001.202741-3-hch@lst.de>

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
