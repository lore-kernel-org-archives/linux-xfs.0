Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C148414DCB
	for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2026 12:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784895862; cv=none; b=dmHRCng0g0UHQLSxIDdyvJudoW/waJ9WyEGv1Zlq843B6ISIfKOvzHC3/lDbk8gv0ULpg2PFRoBmOG7xroHEb74cT9YRlS3qZH1J9VQy0Eix1vW+Lhjc4HNbMlqH01xKx6sa8UHde76sby8k3W4soAbf4t82PSrbCg+2Bd2dNm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784895862; c=relaxed/simple;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=TDQdbstSq8bYb2hisz3T1In8gD6iFkk51aG2FW1lrdV6Jbjy9h5yQfJOD0aCBvMDN3X0oJN4zvrZh7vC8q7zpA9xxdBn5z0DGdgz36qnL855RgYD4oaFdEVwVlnDGw/XLA8zxXal+xeWfULrU57rfDFcdKnoB8kZfMQ7ZHWG7wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=HyXsRm51; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="HyXsRm51"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260724122418epoutp0465bab1414bb34637dee94aebc223b48a~FOVOMr09V2079220792epoutp04U
	for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2026 12:24:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260724122418epoutp0465bab1414bb34637dee94aebc223b48a~FOVOMr09V2079220792epoutp04U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1784895858;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=HyXsRm51N1mNHsnAoiKZMSaBU8dZxM/lyFwDAUGiH7K6J0CjINPjCiIZxSlc7jAxb
	 TipN/iA+NlODe99ACAPrIAYbUZo8En6MvRzl9nd+V3LYIvaahlDULj0s+Fujt4A4aU
	 0eOUqvIRISxRPgDq2Zf2EuwJx7gMqJ2a0LH1dFns=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260724122417epcas5p3b580a307bb7015cb3e8ff7576722aa76~FOVN0Pckv2221422214epcas5p3F;
	Fri, 24 Jul 2026 12:24:17 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.95]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4h66cK1bcrz6B9m6; Fri, 24 Jul
	2026 12:24:17 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260724122416epcas5p4e74e51c5d27e30cd7a6cec37576742f5~FOVMf_ZqD3195231952epcas5p4M;
	Fri, 24 Jul 2026 12:24:16 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260724122414epsmtip2f2d423a26e57a3e37e177a4b8d94aecc~FOVKmHGlV2502225022epsmtip26;
	Fri, 24 Jul 2026 12:24:14 +0000 (GMT)
Message-ID: <c484d8b0-6a70-4e5e-bc23-0876e4402441@samsung.com>
Date: Fri, 24 Jul 2026 17:54:13 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] block: handle nogenerate/noverify properly in
 fs-integrity
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Anuj Gupta
	<anuj20.g@samsung.com>, Christian Brauner <brauner@kernel.org>, "Darrick J.
 Wong" <djwong@kernel.org>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20260724051001.202741-4-hch@lst.de>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260724122416epcas5p4e74e51c5d27e30cd7a6cec37576742f5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260724051025epcas5p30c7757a3fa4156781ebf4309aabd62ef
References: <20260724051001.202741-1-hch@lst.de>
	<CGME20260724051025epcas5p30c7757a3fa4156781ebf4309aabd62ef@epcas5p3.samsung.com>
	<20260724051001.202741-4-hch@lst.de>

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
