Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E385C613;
	Fri, 18 Sep 2026 06:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.42.203.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789713145; cv=none; b=iuiiU7DlQBVdBf6XOJQoAsQTdtWX+wyFVOLvXJfdIkm7EKtZG6bnCM9YJrGE8+3udExOYc9soZKpihu2SBG6lPWTE0rXZGo1m5a+ZXVKH6yhOFynoYHaBcgTh9Y9r5BJvDp+xnr8EBqRwyIAhLsJrEfYQ2Qr/l8GQrDeQ7kYY5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789713145; c=relaxed/simple;
	bh=v1VBUuCGiCGHn6DMhi3GFEqygj/aAsvMykxntaLG+rE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IjQ/bMQt8pezcSLlU2ft9ALJxXyEiYqBCqXZ2fhlF+G6i4xGyc2SCmnEFHIos7JRAxPV74wmVNw9+67lYLP5W9lU+fMBouTztmEpODh9kZIv/XsqcP78PG4ajs79cg/dXjxrUyhUCJyUYf8v2eZzNOhLzfuaFWjp8zPZzg4crsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it; spf=pass smtp.mailfrom=amazon.it; dkim=pass (2048-bit key) header.d=amazon.it header.i=@amazon.it header.b=e4SeXKS9; arc=none smtp.client-ip=52.42.203.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.it header.i=@amazon.it header.b="e4SeXKS9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1789713144; x=1821249144;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v1VBUuCGiCGHn6DMhi3GFEqygj/aAsvMykxntaLG+rE=;
  b=e4SeXKS9RoBo+P9LsLnDPT7XL5EmTXjJZf1NVlo1WtkbWd3GjgVgiHG0
   g2qD8/nDSo/11utVzYWmWWfoGIQS6CoB8FhC6GkEWmHr8z9HiwbKmLXVx
   ka6GrZc/xQHFH8yA3L5EZJLfw9B3ZylDy5woWRZWPMtQ7JUAzrfnkD67/
   jicnp8I/+jHvvj8tidyxdG4ZKBR5KsyT9ruPbeW29A7KVuPtgR992tJj7
   kMN55VhPh4GEr28PD6nHxeFSEep9l3fHur5M74xn7eZvkU4xRcVyuM0Od
   WyIphZ3jcD/SqtRbnS2dA6dADcHMIw4UlyGEQV36lq05wo+ek6ik9fFfm
   g==;
X-CSE-ConnectionGUID: grg7F6DNQJqEHQap4KfNQg==
X-CSE-MsgGUID: Zvmx89DtROO9zU5quSqcRw==
X-IronPort-AV: E=Sophos;i="6.27,103,1787011200"; 
   d="scan'208";a="29037761"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2026 06:32:20 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:4831]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.35.200:2525] with esmtp (Farcaster)
 id d6faa5cd-2b7e-433d-abc2-14217cad7632; Fri, 18 Sep 2026 06:32:20 +0000 (UTC)
X-Farcaster-Flow-ID: d6faa5cd-2b7e-433d-abc2-14217cad7632
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46;
 Fri, 18 Sep 2026 06:32:19 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46; Fri, 18 Sep 2026
 06:32:15 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <hannes@cmpxchg.org>, <akpm@linux-foundation.org>
CC: <abuehaze@amazon.com>, <alisaidi@amazon.com>, <blakgeof@amazon.com>,
	<brauner@kernel.org>, <brendan.jackman@linux.dev>, <david@redhat.com>,
	<dgc@kernel.org>, <dipietro.salvatore@gmail.com>, <dipiets@amazon.it>,
	<djwong@kernel.org>, <hch@infradead.org>, <hch@lst.de>,
	<jackmanb@google.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-xfs@vger.kernel.org>, <mhocko@suse.com>, <ritesh.list@gmail.com>,
	<rvvandan@amazon.com>, <stable@vger.kernel.org>, <surenb@google.com>,
	<vbabka@kernel.org>, <vbabka@suse.cz>, <willy@infradead.org>,
	<ziy@nvidia.com>
Subject: Re: [PATCH v5] mm/page_alloc: avoid direct compaction for costly __GFP_NORETRY allocations
Date: Fri, 18 Sep 2026 06:32:03 +0000
Message-ID: <20260918063203.2802342-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <aqlvnm8AKp5f_UhG@cmpxchg.org>
References: <aqlvnm8AKp5f_UhG@cmpxchg.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D038UWC002.ant.amazon.com (10.13.139.238) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


On Tue, Sep 15, 2026 at 04:17:00PM +0000, Johannes Weiner wrote:
> It would be possible to remove the costly_order gate here and just
> bail on __GFP_NORETRY. But no strong feelings.

Will do, I'll drop the costly_order gate and bail on __GFP_NORETRY.

Andrew, since you dropped v5 and restored v4 in mm-unstable, I'll send a
v6 (v4 plus the above change) unless you'd rather have an incremental
patch on top of v4. Let me know if anything else is needed on my side.

Thanks,
Salvatore




AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico



