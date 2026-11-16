Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.33
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794814749;
	b=Gc68WxDz88o+5qDNWDsdgfNDlNFfm95NYmWO2xBM969Hw/P6qpWLJDZ7OxsIGng+mTAU
	 99EuT6moCztmuh7JXA6v93vwpXbv9ThHoP8OJuVN3cAp/Myy2DAezYDBnRb6UXSdJ1Pdx
	 0AiohKkIwPCltZZAoiUtiJKxgfiVadryiy1pxtikHgnmkeMRMbcjWGAUp6oHKGTzMxUrF
	 8+fVghlCZmxiKlW5BMyzAZKxYVgCe3knVBGUQ9HKUqFdO6sc5AVGLNVFuuciGgk1SHbdt
	 kWc/py2fAnwceHggQXDOeGcsbfLEA7K3AzXcmSkFf7ZIrfHSMr9apxAlcdCb6AawKbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794814749;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Mime-Version:Subject:Reply-To:Sender:From:To:CC:X-Priority:
	 X-Content-Kind-Code:In-Reply-To:X-CPGS-Detection:X-Drm-Type:
	 X-Msg-Generator:X-Msg-Type:X-Reply-Demand:Message-ID:Date:
	 X-CMS-MailID:Content-Transfer-Encoding:Content-Type:X-Sendblock-Type:
	 CMS-TYPE:X-CPGSPASS:X-CPGSPASS:cpgsPolicy:X-CFilter-Loop:
	 X-CMS-RootMailID:References;
	bh=5v0X5pblnqRU7bFZThrTf/EG1Qe5N4R8+2m/NO3/YPI=;
	b=z1D62QbqS+EZXEQ/h+633BgBWExjaLA6nIBdRFRS+D7qjRLGXj5j9LzNYITV8RzL0kU1
	 hrdRS/L03HhjrWpeYkZCyZqxrBuClGy9+W+7BabK+sVB+1kqatzhaDPH1ibre/xzHAJlf
	 pzb80GgC8Am48nFPw7q7QaqHVOa/0C2jOpHQ1QabF5h9o0u9m/cn/May0WNr4IoXD2a0f
	 I1ZhQFPdfZEO8UIRFC1O9NNMsGKlc18FvN6QuA/T36wSKyjVMiNAjDl8+vrjnhixN2RXn
	 DLPG6cPUKKGHhijGLkISvppnmxUAbLNMPmfzn2ReL4J08FX8uk28inaIqdVsRCOGd/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=h4H8rGBq;
	arc=none smtp.remote-ip=203.254.224.33
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D53606A323
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 07:39:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E7D53606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=h4H8rGBq
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20261116073904epoutp03b12b8af9d921e59f6381130f64713c25~odoAwWpsn1590915909epoutp03a
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 07:39:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20261116073904epoutp03b12b8af9d921e59f6381130f64713c25~odoAwWpsn1590915909epoutp03a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1794814744;
	bh=5v0X5pblnqRU7bFZThrTf/EG1Qe5N4R8+2m/NO3/YPI=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=h4H8rGBqO/eKHQ0sleJ0/p+DzneuIVNSxFlr2Xa1VTUqE1bnqd6tDCde9TTNb2gpE
	 DYmsoI5py4nB963XgiKfmiMVWhZRJUbcPZQulljluCcPPUatC3aEabxkhy4EXR2gp/
	 3LCpHQaqLEG2yjUBcwUSRjHYJV5t8baInBTPuLQE=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPS id
	20261116073903epcas2p45252b5310b81720a5c2b16b7ae2ec306~odoAPYs-k1963719637epcas2p4h;
	Mon, 16 Nov 2026 07:39:03 +0000 (GMT)
Received: from epcas2p1.samsung.com (unknown [182.195.38.203]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4jSfr746Jfz6B9m9; Mon, 16 Nov
	2026 07:39:03 +0000 (GMT)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Subject: RE:(2) (2) [PATCH v2] xfs: check the disk address for hardware
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
In-Reply-To: <b34aac03-0d43-4ed1-9561-cb6e0e9c582f@linux.dev>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261116073903epcms2p13ca5bac24c591ae487f0b30dc45b87f8@epcms2p1>
Date: Mon, 16 Nov 2026 16:39:03 +0900
X-CMS-MailID: 20261116073903epcms2p13ca5bac24c591ae487f0b30dc45b87f8
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261112082952epcas2p1f902c4243d451635ff27fe1a1c5035fe
References: <b34aac03-0d43-4ed1-9561-cb6e0e9c582f@linux.dev>
	<b1fba95d-97c8-44ae-a5be-6d2fba7e7e78@linux.dev>
	<20261112-xfs-hw-atomic-align-v2-1-c90394805e7b@samsung.com>
	<20261113025544epcms2p575490538b97c26387515f8b5fc90c321@epcms2p5>
	<CGME20261112082952epcas2p1f902c4243d451635ff27fe1a1c5035fe@epcms2p1>

On Fri, Nov 13, 2026 at 09:45:22AM +0000, John Garry wrote:
> hmm.. I am still not confident that this the best fix. And if it is, 
> then I think that we should still change the size pre-check in 
> xfs_file_dio_write_atomic(). Here's a combined change which I am 
> thinking of:
[...]
> bt_awu_max is the HW max, and you are saying that it is not aligned with 
> the AG size (and so need a disk alignment check). However, opt max 
> should be (aligned to AG size), so we could check that vs size instead.

Thanks, agreed. v3 will check the size instead of the disk address,
in both xfs_file_dio_write_atomic() and
xfs_bmap_hw_atomic_write_possible(). The limit is the one max_opt
applies: the smaller of bt_awu_max and the largest power-of-two factor
of the group size. Below that limit the existing br_startblock check is
enough, so v3 drops the disk address check.

v3 puts this limit in a helper that xfs_get_atomic_write_max_opt() also
uses, so max_opt and the checks use the same hardware limit. The checks
call the helper rather than max_opt, since max_opt is 0 on a filesystem
without reflink. When I tried max_opt there, the one-block atomic
writes went to COW and failed with -EINVAL. The helper returns
bt_awu_max when there are no groups, which is the rt device without
rtgroups.

> BTW, with your proposed change, since HW size is not aligned to AG size 
> and we only check the size vs HW size for HW offload, it is in theory 
> possible to have an atomic write which straddles the AG and is rejected, 
> right?

Userspace does not see a rejection. Such a write maps to two extents,
so xfs_bmap_hw_atomic_write_possible() returns false and the write goes
through COW. This is the same in v2 and v3. In v3, a write sent to the
hardware is also aligned and no larger than the group alignment, so it
cannot cross a group boundary.

Best regards,
Daejun
