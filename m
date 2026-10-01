Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB9A47C10F;
	Thu,  1 Oct 2026 08:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.68.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790843579; cv=none; b=QMf2d0CPsR32xTFApUimPe/wOyovOxU0M949BVsBcCIWxF87yTw+p5mA0vV6jxaNdlRgVhaNPBzz3gLeagPAGrHXuFIVq3pk1eeIDaIFj8IxHZSIReo5rnEM+9rXY8OUo1Krw/Y1dHToWLYsCklgo6pxm6IN+crxzo8tKeniOo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790843579; c=relaxed/simple;
	bh=1AcNDqeJqycLPgcWo0w6spdygMY5Og6ep6m0g2qt0Fs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FTfe/8wEtLPfcAjTuybj4SJHEP9GlsSdKtypwuJsf2qGQte9Wl4hT2SoSHqtv25MEAn3fIxXeT8s9lv5oya7N7ICv4Don5/I/Ge4fZfr/yZX8mq9JFsNbXkLp1y1ymopI9QtvwRZLPnfdCwdVgxtxMmb7f4bsFfGjWd6DVsYJDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it; spf=pass smtp.mailfrom=amazon.it; dkim=pass (2048-bit key) header.d=amazon.it header.i=@amazon.it header.b=KOmbAFLy; arc=none smtp.client-ip=44.246.68.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.it header.i=@amazon.it header.b="KOmbAFLy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1790843578; x=1822379578;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1AcNDqeJqycLPgcWo0w6spdygMY5Og6ep6m0g2qt0Fs=;
  b=KOmbAFLymFdVUpohnXSuCqmESPX2pkKjUqWHk3KmfdEeNCVIPH84U1JK
   dNcPGNErSCV6fwedfBeBOhT0Xplo4jtUBAyC5TsN95dFPD6eAiMnLgT2c
   OSslakhULSvkpiiqLgvBcOaW+peCmS8w+LQYdlRUbZg1BbWGyMAzcmTQx
   nmUT1uvWBP7XT7FqX4FDeC8XmwWA8MCWcmHbdFmrAYEvgb4WTMNBmVbz6
   TP6QsZwYXK7F0C+fCIvRaNQ9hxvTsKmLddb5KkFuPquX8PQiRe5+OcFaW
   XQm2uACGwFdfeEUU1d9O8UOcj29y6OC+N2P2SGEkPerDPPiAlhCp+cf/B
   A==;
X-CSE-ConnectionGUID: RdSEhq9fSUmEovqNwHA6YA==
X-CSE-MsgGUID: O4aa3J/gRK6q7miLgl890A==
X-IronPort-AV: E=Sophos;i="6.27,134,1787011200"; 
   d="scan'208";a="30023040"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 08:32:55 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:17289]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.25.157:2525] with esmtp (Farcaster)
 id e186863d-f635-425e-adeb-010d139eebf3; Thu, 1 Oct 2026 08:32:55 +0000 (UTC)
X-Farcaster-Flow-ID: e186863d-f635-425e-adeb-010d139eebf3
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Thu, 1 Oct 2026 08:32:55 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49; Thu, 1 Oct 2026
 08:32:51 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <akpm@linux-foundation.org>
CC: <abuehaze@amazon.com>, <alisaidi@amazon.com>, <blakgeof@amazon.com>,
	<brauner@kernel.org>, <brendan.jackman@linux.dev>, <david@redhat.com>,
	<dgc@kernel.org>, <dipietro.salvatore@gmail.com>, <dipiets@amazon.it>,
	<djwong@kernel.org>, <hannes@cmpxchg.org>, <hch@infradead.org>, <hch@lst.de>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>, <mhocko@suse.com>,
	<ritesh.list@gmail.com>, <rvvandan@amazon.com>, <stable@vger.kernel.org>,
	<surenb@google.com>, <vbabka@kernel.org>, <willy@infradead.org>,
	<ziy@nvidia.com>
Subject: Re: [PATCH v5] mm/page_alloc: avoid direct compaction for costly __GFP_NORETRY allocations
Date: Thu, 1 Oct 2026 08:31:49 +0000
Message-ID: <20261001083149.2918529-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260918143502.b4fb3587b64e260e14485348@linux-foundation.org>
References: <20260918143502.b4fb3587b64e260e14485348@linux-foundation.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D037UWB004.ant.amazon.com (10.13.138.84) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


On Fri, 18 Sep 2026 14:35:00 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> So a clean v6 would be best now, please.

Done, v6 is here:

https://lore.kernel.org/linux-mm/20261001082152.2879289-1-dipiets@amazon.it/T/#u


Thanks,
Salvatore



AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico



