Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794538554;
	b=NTBNagzpLS7SfCnVSOYXhjmrPXTUdO0IWfn9Sg1pw3tsFoMTjZtZ5TRvpoYvw1K3EHis
	 iFvpWd2j3fH95jUDHTkCHBLjmBB5KNflYfWmy05HGp3Un7w2QZcOX2ASporjOlVowOPRe
	 zVDruiBemztFfbHgYAGdJV5rK1xAI5fhVeXVxEuTfsMOx83qlKo0BHpOGezoodaFrLV60
	 k1caDifzN9Q2+450+zjQNYd5x55JIjGFZwQJUrRckDAA7xeCPh+4vxAIGjcjfpLa6eva7
	 x+4Sj5eBIvUzhGlChFrEBxevrNjB4tBTqD/GXMYe6T51Z26TjBK31WVdiNfnF1Rqu1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794538554;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Mime-Version:Subject:Reply-To:Sender:From:To:CC:X-Priority:
	 X-Content-Kind-Code:In-Reply-To:X-CPGS-Detection:X-Drm-Type:
	 X-Msg-Generator:X-Msg-Type:X-Reply-Demand:Message-ID:Date:
	 X-CMS-MailID:Content-Transfer-Encoding:Content-Type:X-Sendblock-Type:
	 CMS-TYPE:X-CPGSPASS:X-CPGSPASS:cpgsPolicy:X-CFilter-Loop:
	 X-CMS-RootMailID:References;
	bh=9J49L3RJCoP4wGzjgUzC9F4wdGRkMlmrD0u8fG02hSo=;
	b=4nL8nPJfRAuR0NQClmit4sJkLEL5et2+83q1I+T4GK2Njb+0Mx3wzJIYqZBZa8K6Mpon
	 mKTPBpZY5qySQgnn6lGuOB2cmMldbmElEv7fI48XCcX6USz8NdyThsRHQeSbgHW6VZKSm
	 yFp9UvGHMq4qjmvmcOqjk0R89zJElPitjsW8Ky49cMrTnhjRTgvSS35oyuWRvSpOXiNPF
	 anzy80sWCKqVXy7DZEF4onRawG4vXnhYcXcI3A4bgNWr9I0/sgW+fkzgVo9DDeZsGC6nP
	 H6syzAH7sG1n3oNXRrgf+WiFV/wJSQhvILB1mxpB7sKuxwO135TSBpD/4TQKt3hW4hQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=gj79tWV3;
	arc=none smtp.remote-ip=203.254.224.25
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11D6606A321
	for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2026 02:55:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B11D6606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=gj79tWV3
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20261113025545epoutp02f95faad6ab752d04eacea4b1c28e2511~ne0ylg8It2757927579epoutp02z
	for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2026 02:55:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20261113025545epoutp02f95faad6ab752d04eacea4b1c28e2511~ne0ylg8It2757927579epoutp02z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1794538545;
	bh=9J49L3RJCoP4wGzjgUzC9F4wdGRkMlmrD0u8fG02hSo=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=gj79tWV3wblhiJujlxUqLh7qjVIvYb+PuzwDRbnnAE74mcTKKbL8ipyTae3nIKAwX
	 mygS2hOiSY6LT4xRsw6j/ymPw4N+2QPpxy96K58o5I/bzW+Tjguhiu3YXwK4H6T2li
	 5IkjPbiFapKxKdtJaH+tfBj6KuOWbsUeYbs9FehU=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPS id
	20261113025545epcas2p499843543740948a35fd04ddce318f6c6~ne0yE-HAm1552515525epcas2p4B;
	Fri, 13 Nov 2026 02:55:45 +0000 (GMT)
Received: from epcas2p3.samsung.com (unknown [182.195.38.208]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4jQhhc5XQSz6B9mB; Fri, 13 Nov
	2026 02:55:44 +0000 (GMT)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Subject: RE:(2) [PATCH v2] xfs: check the disk address for hardware atomic
 writes
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
In-Reply-To: <b1fba95d-97c8-44ae-a5be-6d2fba7e7e78@linux.dev>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261113025544epcms2p575490538b97c26387515f8b5fc90c321@epcms2p5>
Date: Fri, 13 Nov 2026 11:55:44 +0900
X-CMS-MailID: 20261113025544epcms2p575490538b97c26387515f8b5fc90c321
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261112082952epcas2p1f902c4243d451635ff27fe1a1c5035fe
References: <b1fba95d-97c8-44ae-a5be-6d2fba7e7e78@linux.dev>
	<20261112-xfs-hw-atomic-align-v2-1-c90394805e7b@samsung.com>
	<CGME20261112082952epcas2p1f902c4243d451635ff27fe1a1c5035fe@epcms2p5>

On Thu, Nov 12, 2026 at 08:29:42AM +0000, John Garry wrote:
> On 11/12/26 00:41, Daejun Park via B4 Relay wrote:
[...]
> > -	if (!IS_ALIGNED(imap->br_startblock, imap->br_blockcount))
>
> Is there anywhere else in which we do an alignment check on 
> br_startblock that relies on the group size to be a multiple of the HW 
> awu max?

No, I did not find another one. This is the only check of the start
block for the REQ_ATOMIC path. Two other places depend on the group
alignment, but neither checks br_startblock:

- xfs_get_atomic_write_max_opt() already caps max_opt at
  xfs_calc_group_awu_align_max(), the largest power-of-two factor of
  the group size (from ec8f62cc109a).
- The allocator aligns the AG block number, not the disk address,
  for example for XFS_BMAPI_EXTSZALIGN in
  xfs_atomic_write_cow_iomap_begin(). In an unaligned AG, that extent
  can still be misaligned on disk. With this patch, the next atomic
  write to it goes through COW instead of failing.

Best regards,
Daejun
