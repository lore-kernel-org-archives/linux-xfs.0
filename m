Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=34.218.115.239
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793113223;
	b=JYwOprDKi1pAZNwgoQFlfIYl5RVDJnXPkrF6vNSXIsd7gVW2/AAp871CT6wMHppjj+PN
	 GfunqvmsW9fotpMklnyLuaSmfVVM7fPT1njb/8iCFLMC3jNwVDvxM0vR4HbPFGozeMNX5
	 QuerO7spz6gv80RMUqQm67Q6SPipnHBVsYNOprRqRAUXO1vbHPlRlXLGN2rbk4S2tqbCs
	 HEeRQg5DPoiEvG1n4cWLCA1Gv17C1ZbmAvRL/iVePLM8b90kJ14sk3rRvj3sgM+d87fqN
	 PbLXH/nkd0m+n0IJnIEOQC1JnWdlbdjfdYbGIeK1bwYFjyhQ2mQLJ7goWqBCW3lkerQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793113223;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:Received:X-Farcaster-Flow-ID:Received:Received:
	 From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:X-Originating-IP:X-ClientProxiedBy:Content-Type:
	 Content-Transfer-Encoding;
	bh=plx93BXIQUOSUsvJsCgjZtiZG1rNFPpPYeNwPZQpSek=;
	b=F/i5ySxUl9bmWkpsNfgDPZSq8/5Dm2/urMJtIak0g9nWwaL9YTEcbGSNbSkRPQcjLWaA
	 3LcYLHnfDD20y7Aewp/sshIhIW57ZHMkvKHuzLfkC3XYi8/+7PWaiudo9ndo+iWK1znyK
	 8A7+GVych36qRwV1R+mR+Td9eKSlK5YnT9+PQx4SNzpEbaXuRRl/9xCgdxBd4VG/GhtgZ
	 1A4jUZTej8RtOH+ALnC2/Nmhpmqy1ip49R0Yulli2Lgbr2D14OAwXj0xzeUlvwRqqNQ5p
	 ojevD9NlxsWOzZssHlQG5dUMQWX10l0uDB7L1wuaRjwh1r81PHo/Rl/vEK4Oj13Hj7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amazon.it;
	spf=pass smtp.mailfrom=amazon.it;
	dkim=pass header.d=amazon.it header.i=@amazon.it header.a=rsa-sha256 header.s=amazoncorp2 header.b=Pr+4a0ZO;
	arc=none smtp.remote-ip=34.218.115.239
Received: from pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com [34.218.115.239])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B4D606BA8A;
	Tue, 27 Oct 2026 15:00:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16B4D606BA8A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.it header.i=@amazon.it header.a=rsa-sha256 header.s=amazoncorp2 header.b=Pr+4a0ZO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1793113223; x=1824649223;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=plx93BXIQUOSUsvJsCgjZtiZG1rNFPpPYeNwPZQpSek=;
  b=Pr+4a0ZO74Am0r5tComDFuEyLXg8/8D+ABkhsTH2E67J38O92mf1dO0y
   r1MYp8tmC2Ug1owEhstAWv7YnR7TJilX2us4no1vjukDDX60nnVY/6mtO
   RylVMeU4ZqUQAgIkgcISZxgDdVuSiK4VnaP8i3k3WhPy/90QcJG4auDMQ
   DOOXiCBEEUol8blm6kJcyvU7zMDaz3KNOv/tJ5t8/Z265W6/p48/xhzWz
   WXed5faNQDCbCttXMXYzT65X056B8ou5etRZuaIOKk6YF+bFv7s+nf2be
   VnyA9x4Yv3AwYpRM73PttoWkOMM8v0egSDMMNKfviG7YY3SwXdGTnkZDb
   g==;
X-CSE-ConnectionGUID: ItHuiPCkQKSeJuplJtYZkw==
X-CSE-MsgGUID: eak/GKDTTtOSAGPyGq8STg==
X-IronPort-AV: E=Sophos;i="6.27,181,1787011200"; 
   d="scan'208";a="32146695"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2026 15:00:20 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:31033]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.38.46:2525] with esmtp (Farcaster)
 id ef43fa70-f102-4124-a2a1-66e6ab51bbb5; Tue, 27 Oct 2026 15:00:20 +0000 (UTC)
X-Farcaster-Flow-ID: ef43fa70-f102-4124-a2a1-66e6ab51bbb5
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Tue, 27 Oct 2026 15:00:19 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Tue, 27 Oct 2026
 15:00:15 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <hannes@cmpxchg.org>
CC: <abuehaze@amazon.com>, <akpm@linux-foundation.org>, <alisaidi@amazon.com>,
	<blakgeof@amazon.com>, <brauner@kernel.org>, <brendan.jackman@linux.dev>,
	<david@redhat.com>, <dgc@kernel.org>, <dipietro.salvatore@gmail.com>,
	<dipiets@amazon.it>, <djwong@kernel.org>, <hch@infradead.org>, <hch@lst.de>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>, <matt@readmodwrite.com>,
	<mhocko@suse.com>, <ritesh.list@gmail.com>, <rvvandan@amazon.com>,
	<stable@vger.kernel.org>, <surenb@google.com>, <vbabka@kernel.org>,
	<willy@infradead.org>, <ziy@nvidia.com>
Subject: Re: [PATCH 1/2] mm: page_alloc: do not give all non-blocking requests reserve access
Date: Tue, 27 Oct 2026 15:00:02 +0000
Message-ID: <20261027150002.318916-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <arFBr22V60BMmVpl@cmpxchg.org>
References: <arFBr22V60BMmVpl@cmpxchg.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWA002.ant.amazon.com (10.13.139.96) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


Hi Johannes,

Vlastimil asked that v6 of my page_alloc patch [1] not go to mainline
before these two patches land, so Andrew parked v6 at the tail of
mm-unstable and dropped its Cc: stable until then.

Are you still planning to work on 1/2 and 2/2, and if so, do you have
a rough ETA? Or would you rather post them as a separate series as
they are? If anything is needed on my side to move them forward, I'm
happy to help.

For what it's worth, I ran both stacked under v6 on v7.3-rc1 and saw
no performance difference on my benchmark with or without them.

[1] https://lore.kernel.org/linux-mm/20261001082152.2879289-1-dipiets@amazon.it/


Thanks,
Salvatore





AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico



