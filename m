Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795487916;
	b=lnTsdPj9JzzM4cbKvjQWDefiCaZsRd328h3FDe+e+WsdFBogQ6GGWNqQxPads6ak7YE3
	 /YEPjPRO33Q8pfbwIdhUYKX0vus5Q0TpqQ/uQTMPrc/SS3Il/4zZf8DGZ9JxwgJV0Cxrz
	 Vei6mnBi4Ponj1OwhnydKq6yIADXSKaQ8K+G+zDTc1nMEYYDNdK9vZy9rFkm56+sH7Icp
	 CqcuDqM+aOuBvqGE/I5LPltaq4Bu4FIYbvt/vY/lfOVUee9LzVpIjs+1aBoxoKa2FCieU
	 d8tq4D8PIorJMRhmQy9soMS9pqlCeS1Qj7AdEP/aaIYaBoJ7KAWBqJUP4Q5bIN576Uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795487916;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Mime-Version:Subject:Reply-To:Sender:From:To:CC:X-Priority:
	 X-Content-Kind-Code:In-Reply-To:X-CPGS-Detection:X-Drm-Type:
	 X-Msg-Generator:X-Msg-Type:X-Reply-Demand:Message-ID:Date:
	 X-CMS-MailID:Content-Transfer-Encoding:Content-Type:X-Sendblock-Type:
	 CMS-TYPE:X-CPGSPASS:X-CPGSPASS:cpgsPolicy:X-CFilter-Loop:
	 X-CMS-RootMailID:References;
	bh=HKYZC3rzoE+ZzWxOI/rVzbevkg65KAdLMa12FNrpyAM=;
	b=GNx9RRkO6HECIlMhsYO1XVoc8hHvqRJalyT+a/eO81XLKrqJRg5AvU00ubwEJJ77RdjF
	 Fah8fe15p4SLV7ht5egO63KBNGWJoh43FYHVatUtcQYpclICcREgpzLebp0p4mxUkugCO
	 CRsAF2FhkgDm6nv7d44f4mk8KdkW9gX2Cg35mUQGCZafaYaRCCXd+7Q0K4Rf+9a0kaHVZ
	 TUzT3xrnemf7A6pOcI/EXa2Mwvra+na+2LUQ/E8TDCEAGkg6Tj5xySDy2QUqYGzQKWHEa
	 5A6XwBNjyuGUKzVN/WXJiHfrSyTIqYI+Y82PDURZI0T2V448DmKtAiWKho6PRfs/0RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=l2lNzl1+;
	arc=none smtp.remote-ip=203.254.224.25
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3F2606A321
	for <linux-xfs@vger.kernel.org>; Tue, 24 Nov 2026 02:38:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EA3F2606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=l2lNzl1+
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20261124023832epoutp025456a86b25f3fd100c90c6b23f094257~q2r5zQ7rS0932909329epoutp028
	for <linux-xfs@vger.kernel.org>; Tue, 24 Nov 2026 02:38:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20261124023832epoutp025456a86b25f3fd100c90c6b23f094257~q2r5zQ7rS0932909329epoutp028
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1795487913;
	bh=HKYZC3rzoE+ZzWxOI/rVzbevkg65KAdLMa12FNrpyAM=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=l2lNzl1+P4ApLy5C2IQ9EODD4FrtVU79BKZizu8rQhZElcUHN+MXReNq+BvRndHVs
	 VbOxuxxxa8ssffZsc4HfXybacXPIoxj/IjnWEN5iaad9x9YvCKj0ObjPbZmJVMup+J
	 1WZIvHW0temzVX9qc8no7c8RE8F/nWsOwDgTgITs=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPS id
	20261124023832epcas2p3f9fb0224a5adf118fb229811a08e40bb~q2r5fLSoO2445324453epcas2p3D;
	Tue, 24 Nov 2026 02:38:32 +0000 (GMT)
Received: from epcas2p2.samsung.com (unknown [182.195.38.210]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4jYRnh31BDz6B9m6; Tue, 24 Nov
	2026 02:38:32 +0000 (GMT)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Subject: RE:(2) [PATCH v2 1/2] xfs: number the cache flushes submitted to
 each buftarg
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From: Daejun Park <daejun7.park@samsung.com>
To: Christoph Hellwig <hch@lst.de>
CC: Carlos Maiolino <cem@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, "Darrick J.
 Wong" <djwong@kernel.org>, Amir Goldstein <amir73il@gmail.com>, Brian Foster
	<bfoster@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Daejun Park <daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20261120181424.GA1954@lst.de>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261124023831epcms2p795c1d5742991c1f6bb416c52db43a312@epcms2p7>
Date: Tue, 24 Nov 2026 11:38:31 +0900
X-CMS-MailID: 20261124023831epcms2p795c1d5742991c1f6bb416c52db43a312
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261120181433epcas2p26ece3eeb06a9aef1612ea1f4f13238a9
References: <20261120181424.GA1954@lst.de>
	<20261111-xfs-fsync-flush-seq-v2-0-b5c00c25d276@samsung.com>
	<20261111-xfs-fsync-flush-seq-v2-1-b5c00c25d276@samsung.com>
	<CGME20261120181433epcas2p26ece3eeb06a9aef1612ea1f4f13238a9@epcms2p7>

On Fri, Nov 20, 2026 at 07:14:24PM +0100, Christoph Hellwig wrote:
> Can you try to merge the two patches?  Having the logic split over two
> patches is really confusing.

Thanks, v3 will be a single patch.

> > +	struct xfs_buftarg	*btp)
> >  {
> >  	struct bio		*bio;
> > +	s64			seq = xfs_buftarg_flush_start(btp);
>
> Nit: we usually keep variables that are initialized at declaration time
> above those that are not. 

Will fix in xlog_flush_async().

Best regards,
Daejun
