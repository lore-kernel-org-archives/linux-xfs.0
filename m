Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794822894;
	b=bS+A64D6gikapZV09T7y2qRRz9GRRWOpjqhI7bAbzPmsfUexgKE7+HDLA4r5NbK6H9Ng
	 ghzd58oZGYinZkEDKxOA1ZzVXIoIU5uytBUOfuMnZPbOi8RCI7urNyfzdz7i2StU/FqI3
	 +y//edAh8AhuOK7iMqczaZy7VbDZkO98Z5A5bevTeRhi+dd/ufdkOAgEEFzI91MUAg2Bq
	 WBgvcu6nML12AkqEWWDa/iG9kLbIma+zOOL/Scv2E0ud5Az8yNHzOw32GwxRHHQ/LWl59
	 j98J0IP4HtQzteWOEgM1ZFkUuUhOiZIibu8Imlq2R0vfWF7eq9H0Z9v4j9D4BoYOo8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794822894;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Mime-Version:Subject:Reply-To:Sender:From:To:CC:X-Priority:
	 X-Content-Kind-Code:In-Reply-To:X-CPGS-Detection:X-Drm-Type:
	 X-Msg-Generator:X-Msg-Type:X-Reply-Demand:Message-ID:Date:
	 X-CMS-MailID:Content-Transfer-Encoding:Content-Type:X-Sendblock-Type:
	 CMS-TYPE:X-CPGSPASS:X-CPGSPASS:cpgsPolicy:X-CFilter-Loop:
	 X-CMS-RootMailID:References;
	bh=p37TzPPaQxXbDXDs23NTbmcI4MGLq8txBbkhklNkR9A=;
	b=AEuFoOI41woo9aRe1X3P0s1c5d+Onl1QXSH0cCqrBqChC52Pz4GrBcQzXXDidikqhPa0
	 TVVp2xr8aGEJNzGpXWHk0G1mNfE7jIeAeKcaoM8NN9BDIMRChsbzZRCvKPADFpe1dmOPu
	 QZJalBiHKMDIsGxLW2Y6NTQrOzh/Jlh9vBfEB+vAC+lcgOW8eyKfI+ZdaOqN/UF+CLLUx
	 Qgr/0LOYlAzci0Ps+aa9qxTh/Rdiekvvnq9HO++LlHCT9yGETSkykm0sfmtzNLSoR5zWV
	 ZtKdFmNOCbwhJYphfL8Z5IiVAL4jv7yxs+haMuSYUl9cvzb2sABn7UVehcSze6s5hTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=NFcg2oAY;
	arc=none smtp.remote-ip=203.254.224.25
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9DA606A323
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 09:54:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E9DA606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=NFcg2oAY
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20261116095450epoutp02780ca9eec6246e4dd05bb797765031d7~ofejNEQdV1161411614epoutp02v
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 09:54:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20261116095450epoutp02780ca9eec6246e4dd05bb797765031d7~ofejNEQdV1161411614epoutp02v
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1794822890;
	bh=p37TzPPaQxXbDXDs23NTbmcI4MGLq8txBbkhklNkR9A=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=NFcg2oAYapV4cFNjVm9QBSqqZ0M8n+/FQ37Oqn+mY58SXBEunBGUumGwjaSyHdA/R
	 ZAhkWKD7XUGK8vRVkLYNw/z3CKU3HS3hCGh03rU/mtRW0vtUl4s2DYojBES727IAs7
	 S4dhrqztxaK4KKNzCdsmjxn/5MxqqDSnrwTLI2LI=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPS id
	20261116095449epcas2p2a288c413ca6f9ca4362c9de33f574a0b~ofeim-tHj1406114061epcas2p2F;
	Mon, 16 Nov 2026 09:54:49 +0000 (GMT)
Received: from epcas2p3.samsung.com (unknown [182.195.38.204]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4jSjrn2cnyz2SSKZ; Mon, 16 Nov
	2026 09:54:49 +0000 (GMT)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Subject: RE:(2) (2) (2) [PATCH v2] xfs: check the disk address for hardware
 atomic writes
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From: Daejun Park <daejun7.park@samsung.com>
To: John Garry <john.garry@linux.dev>, Carlos Maiolino <cem@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
CC: Pankaj Raghav Partha Sarathy <p.raghav@samsung.com>, Pankaj Raghav
	<pankaj.raghav@linux.dev>, "Darrick J. Wong" <djwong@kernel.org>, Christoph
	Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Daejun Park
	<daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <96330e94-d3c0-447c-aef0-7c56b24e122b@linux.dev>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261116095448epcms2p7c3d40cf340a05ad81a6c33820c3f1e61@epcms2p7>
Date: Mon, 16 Nov 2026 18:54:48 +0900
X-CMS-MailID: 20261116095448epcms2p7c3d40cf340a05ad81a6c33820c3f1e61
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261112082952epcas2p1f902c4243d451635ff27fe1a1c5035fe
References: <96330e94-d3c0-447c-aef0-7c56b24e122b@linux.dev>
	<b34aac03-0d43-4ed1-9561-cb6e0e9c582f@linux.dev>
	<b1fba95d-97c8-44ae-a5be-6d2fba7e7e78@linux.dev>
	<20261112-xfs-hw-atomic-align-v2-1-c90394805e7b@samsung.com>
	<20261113025544epcms2p575490538b97c26387515f8b5fc90c321@epcms2p5>
	<20261116073903epcms2p13ca5bac24c591ae487f0b30dc45b87f8@epcms2p1>
	<CGME20261112082952epcas2p1f902c4243d451635ff27fe1a1c5035fe@epcms2p7>

On Mon, Nov 16, 2026 at 08:11:51AM +0000, John Garry wrote:
> Yeah, I was really asking if HW atomic could span 2x extents before we 
> catch it.

It is caught before any bio is built. xfs_direct_write_iomap_begin()
checks with xfs_bmap_hw_atomic_write_possible() that one mapping covers
the whole write. For a write over two extents it returns -ENOPROTOOPT,
and xfs_file_dio_write_atomic() redoes the write through COW, which is
still atomic. If a shorter mapping ever got past that check, iomap
fails the write with -EINVAL instead of issuing a partial REQ_ATOMIC
bio.

> Maybe what you have in this patch is ok. I'll wait for v3 and consider 
> it more. Sorry for the hesitancy.

I wrote the v3 I described and tested it against v2 before posting it.
v3 sends every write above the group alignment to COW, also when the
extent is aligned on disk, as in AG 0. v2 sends those writes to the
hardware and falls back to COW when the hardware path is not possible,
for example when the extent is misaligned on disk. So I'll keep v2 as
posted and not send v3.

For reference only, on emulated NVMe (QEMU) with a 64 KiB atomic unit
and boundary, non-debug kernels, three runs of 10000 overwrites: a
64 KiB atomic overwrite in AG 0 took 35.2-38.6 us with v2 and
69.4-78.1 us with v3. In a misaligned AG 1 it took 70.5-88.8 us with
v2 and 68.8-88.7 us with v3.

Best regards,
Daejun
