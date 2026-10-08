Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417192BE656
	for <linux-xfs@vger.kernel.org>; Thu,  8 Oct 2026 01:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791423845; cv=none; b=WMfJTB4p0YMpgne5Znw9aEkP+go44IIWFz6fWYawMjA9+q1+jRY8hDqDO3c5uh6hwQQRLYxtUKhfpCKjOh29YRNG47C5frOFhlSqfo+d9CiJ0TkelhoEGr+3asn9311JVN59VmsMwWF5cTqaHD+Jp/58aXd4y95TIIbbfv3a7kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791423845; c=relaxed/simple;
	bh=jtdDpg3UfqTpVad76RJMqdpz4OeLclt56SLM1NQfYCE=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=RYzLhgi7oGKnpanMJbFaFGOXnbAfI/kGbjGV2hGnmvtXQLTLURgqa/HRSkwX/J/lXYvFU6KWv24+ZAZYE4ZSwsOb3JGkVcD63LxDRYl4fg6aoPZgX+3swPuJShb+2xrFq5uIQRaskq9b0Aco+D8n6n/730kqOq6rOvU34XmZjes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=t7RVXtHy; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="t7RVXtHy"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261008014400epoutp0147219065d87eb5dda8668f0ffad05daa~can3oZs591311013110epoutp01J
	for <linux-xfs@vger.kernel.org>; Thu,  8 Oct 2026 01:44:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261008014400epoutp0147219065d87eb5dda8668f0ffad05daa~can3oZs591311013110epoutp01J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1791423840;
	bh=zqrcydtI8fgLaNv0n5I0SDoEvi6u5RkP/wVl9Cri4bA=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=t7RVXtHyyvLOFDyUO0E/eyLZ/dXoC1PkvMh7NoolH4jFSSiuQf2Z3QmVJAeZ99Rek
	 cgsjlu8RsBRc2Y3Q6NsD1mBPOOZx0kBYDydna2oeKGWMxFDpniz0lpdQvd9MusQzRR
	 p4MlF8o/EfjpzUpTPDAlekA2+mOx+bwHOOgrvEoA=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPS id
	20261008014400epcas2p3774688c45298cfd7569e06c0cbeb859e~can3Eu7fe2186221862epcas2p3C;
	Thu,  8 Oct 2026 01:44:00 +0000 (GMT)
Received: from epcas2p3.samsung.com (unknown [182.195.38.204]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4j0XpR6n8qz6B9mC; Thu,  8 Oct
	2026 01:43:59 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: RE:(2) [PATCH] nfsd: do not return overlapping extents in a block
 layout
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From: Daejun Park <daejun7.park@samsung.com>
To: Christoph Hellwig <hch@lst.de>
CC: Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, Dai
	Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, "Darrick J. Wong"
	<djwong@kernel.org>, Sergey Bashirov <sergeybashirov@gmail.com>, Carlos
	Maiolino <cem@kernel.org>, Amir Goldstein <amir73il@gmail.com>,
	"linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Daejun Park
	<daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20261007131133.GB30647@lst.de>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261008014359epcms2p81ce38cf0091bc8f75b88980e9c3f1717@epcms2p8>
Date: Thu, 08 Oct 2026 10:43:59 +0900
X-CMS-MailID: 20261008014359epcms2p81ce38cf0091bc8f75b88980e9c3f1717
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261007131141epcas2p46e1bc1592a0789298bc9f7e13c7ad393
References: <20261007131133.GB30647@lst.de>
	<20261007-nfsd-block-trim-v1-1-53370f97047a@samsung.com>
	<CGME20261007131141epcas2p46e1bc1592a0789298bc9f7e13c7ad393@epcms2p8>

On Wed, Oct 07, 2026 at 03:11:33PM +0200, Christoph Hellwig wrote:
> But given that you're pretty active in this part of nfsd now, can you
> also look into my earlier suggestion to allow a single map_blocks
> return multiple mappings?  That solves more of the root cause of
> creating incoherencies.

I posted it here:

https://lore.kernel.org/r/20261008-xfs-nfsd-map-blocks-v1-0-560026cdccb6@samsung.com

->map_blocks now fills an array of mappings. XFS maps the whole range
of a layout under one hold of the iolock and the invalidate lock (the
latter as Darrick pointed out in the earlier thread), with one flush and
at most one log force, and nfsd checks that the extents follow each
other instead of trimming them. The window between ->map_blocks and
nfsd4_insert_layout() is narrower but still there.
