Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.24
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793089902;
	b=tvTsqFnoS+h31x+UPWJoz50INiDUumCC7023vcUQL2khvR03C5H1k3W1EOoocl+VZqOe
	 iPEC/giE6DxxB2SDa7nZuz0ABT8dMqPGgWXIoaNU+0xJzhP3De+rI1oJjHjR4EaD5tyku
	 0z11eL70XnBtNtAdojPeMjoYsSUZtJGuYm1J8gTqFlzN/FhPkQeQ6NYwby/WoxPBDeFVm
	 eaNVLAiTEl9aXcmd5dHzVoqOsqn/kZzILOq11gGGqNQ4O0J4aBnD7kC8ITLbP3sWefGnv
	 jR91TJjDOM4KgXJTV8UAUdYRfY2ddr28/HpeOjUsLkncwHwoCkmCyvLigvwKK4CT9mA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793089902;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Mime-Version:Subject:Reply-To:Sender:From:To:CC:X-Priority:
	 X-Content-Kind-Code:In-Reply-To:X-CPGS-Detection:X-Drm-Type:
	 X-Msg-Generator:X-Msg-Type:X-Reply-Demand:Message-ID:Date:
	 X-CMS-MailID:Content-Transfer-Encoding:Content-Type:X-Sendblock-Type:
	 CMS-TYPE:X-CPGSPASS:X-CPGSPASS:cpgsPolicy:X-CFilter-Loop:
	 X-CMS-RootMailID:References;
	bh=P1MNsw8Rzo4tDNmS4iyrSef2YaeHjBn+VyXBlrSW+E8=;
	b=cxn9uCH26wRAbxTeAI6gI58VC0LfZ3OliLpWbdnUqpimGIxXMW29/v5nHeYWSapiDRTk
	 D+b8v4MbBTsoLRDnBuNOvOdiQhK841RtSQThGAcynljYjY7DdJLOxHyq2/iqngYhvCxQG
	 pi1FynzcceUvgqU/fIZCtNAAlLkueLUTKADHyEZlmQzCbTJTXpUG3TEdBD5TACYK9aYHU
	 60wPSIATqZh11Wd8jpTae192bX70/jPlemiuoxOUMJbwZivbIuGiLn9KcrNivToOz5tKn
	 uEg7jD6WQG7V/JFE2g+k/eXQHMqUDtZrMhU5JvmIZD+yrsoDj2hka09OVine4WsqvEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	arc=none smtp.remote-ip=203.254.224.24
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A90606A31D
	for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 08:31:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88A90606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261027083136epoutp01dc3571e0d2c78f816a540b92cfceb7eb~iVcKyw-or0566005660epoutp01c
	for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 08:31:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261027083136epoutp01dc3571e0d2c78f816a540b92cfceb7eb~iVcKyw-or0566005660epoutp01c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793089896;
	bh=P1MNsw8Rzo4tDNmS4iyrSef2YaeHjBn+VyXBlrSW+E8=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=Zxk8Qhls8BBg+NPsUF50iS7ZHqaxG91eqx3BUrQD9bv9ZourUO+zG+3mTBtkBBqBF
	 uSDL5Tzb5FwIXahv4DleJC6VhHvmEi4y5+ZSLUOO23U87u+d8kTJtxT3M1Kq1GEnHz
	 6J5ZkcALnOk1539NHIQSiwZGj4cxdZTJfcbGw57U=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPS id
	20261027083135epcas2p4540c5ad7f4d5bc2c255d423e1283d4e7~iVcKWU0-x1805918059epcas2p4C;
	Tue, 27 Oct 2026 08:31:35 +0000 (GMT)
Received: from epcas2p4.samsung.com (unknown [182.195.38.205]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4jDNxz4gM3z3hhT3; Tue, 27 Oct
	2026 08:31:35 +0000 (GMT)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Subject: RE:(2) [PATCH v4 2/9] xfs: add a flag to convert unwritten extents
 without allocating blocks
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From: Daejun Park <daejun7.park@samsung.com>
To: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
CC: Carlos Maiolino <cem@kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "Darrick J.
 Wong" <djwong@kernel.org>, Dave Chinner <dgc@kernel.org>, Chuck Lever
	<cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, Dai Ngo
	<Dai.Ngo@oracle.com>, Sergey Bashirov <sergeybashirov@gmail.com>, Andrey
	Albershteyn <aalbersh@kernel.org>, "linux-nfs@vger.kernel.org"
	<linux-nfs@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>, Daejun Park <daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <atoEubjhGZgA2WQk@quentin>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261027083135epcms2p81a1eecd6f9277131d458bd28ebe80ec4@epcms2p8>
Date: Tue, 27 Oct 2026 17:31:35 +0900
X-CMS-MailID: 20261027083135epcms2p81a1eecd6f9277131d458bd28ebe80ec4
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261022124400epcas2p11d97ce2b0b9b4009ba8cabe1068b58e8
References: <atoEubjhGZgA2WQk@quentin>
	<20261020-xfs-pnfs-batch-v4-0-9230fa2ca4a4@samsung.com>
	<20261020-xfs-pnfs-batch-v4-2-9230fa2ca4a4@samsung.com>
	<CGME20261022124400epcas2p11d97ce2b0b9b4009ba8cabe1068b58e8@epcms2p8>

On Thu, Oct 22, 2026 at 02:43:50PM +0200, Pankaj Raghav wrote:
> Minor nit:
>
> The following might be more explicit here:
>
> ASSERT((flags & XFS_BMAPI_CONVERT_ONLY) ? bma.nallocs == 0 :
>                                          bma.nallocs >= *nmap);

Thanks, that is clearer, and it holds: with XFS_BMAPI_CONVERT_ONLY the
loop stops before xfs_bmapi_allocate(), the only place that counts an
allocation. I'll use it in v5.

Daejun
