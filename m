Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53192350A05;
	Fri, 11 Sep 2026 14:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.77.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789137047; cv=none; b=hQnaM/h7po3LHoEtZvmFntIvfHTUm5f4jX1ZCH3TRaYTs2mMxJIKFsNIWLRcNC77GaCosFIDoP7ByDkcBEDBksb89IwrzcDvDBrgdlxx8UFUBjTn2UMD4YfObTpuvH2ZZb4LgVC2exFQT3VbeiQxG83XEqvXlMPMFQsWXu25MCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789137047; c=relaxed/simple;
	bh=fhlXhMKwCgy0VW4p1/ceblcbln66SDQBBDi2Ot6Q7qg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n0Wt0xIWAtsLyo52nm98BS2dMHkKxNxEPoP/DywXSxKe8t6JhpJ0K7HiA5eGtDNqI4oh/ajDf08nKcqloCQnr1ME3ocCYuS11MRxrEkW0Bwdfc0DYZX15473yTPDG3pMEQot80cukmyDatiADBSGn8SImBegbuk9NRMpv5Fq6Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it; spf=pass smtp.mailfrom=amazon.it; dkim=pass (2048-bit key) header.d=amazon.it header.i=@amazon.it header.b=btSaHegH; arc=none smtp.client-ip=44.246.77.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.it header.i=@amazon.it header.b="btSaHegH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1789137046; x=1820673046;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fhlXhMKwCgy0VW4p1/ceblcbln66SDQBBDi2Ot6Q7qg=;
  b=btSaHegHJ24hWTku93wjjPsDBMe3RoJtvTjNBLyEaakRVVwxeQT0bgMq
   Mvkz7IhYIZ6oSbRsD86C0MNhxeGG4zwAwib4A4ZqxpBVJyhgBiyTt5sSd
   QemVILZoMKvWaXOZloW0JYMB1h6teJNLZSsblwIrIz8F8hFgFT8IAOMJX
   8hHd7iWCd1wLjC9vk8pzrwl/mKiWtzOP/4DK59ORAiBaSRBLagcYSQcZd
   Egd+4Ywim0l8WiexpRJgBEhScUH3dLbmQHwaTARZZHmWSBvBV6sl/nEu5
   KP3BhAXKQDo6hGcKUDFcnqPGEnbhZw1/TXrd4BHaqHdu0lsWmUSe5ANkl
   w==;
X-CSE-ConnectionGUID: uhkva1SMRPiWJ6tkKRQojQ==
X-CSE-MsgGUID: Gj7DMLnZR6qpUKLfGvwZ2A==
X-IronPort-AV: E=Sophos;i="6.27,97,1787011200"; 
   d="scan'208";a="28425865"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2026 14:30:43 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.234:19142]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.62.198:2525] with esmtp (Farcaster)
 id 6cbbef2e-8b23-4af2-9c06-09ccb670a4ad; Fri, 11 Sep 2026 14:30:43 +0000 (UTC)
X-Farcaster-Flow-ID: 6cbbef2e-8b23-4af2-9c06-09ccb670a4ad
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Fri, 11 Sep 2026 14:30:43 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46; Fri, 11 Sep 2026
 14:30:39 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <akpm@linux-foundation.org>
CC: <abuehaze@amazon.com>, <alisaidi@amazon.com>, <blakgeof@amazon.com>,
	<brauner@kernel.org>, <brendan.jackman@linux.dev>, <david@redhat.com>,
	<dgc@kernel.org>, <dipietro.salvatore@gmail.com>, <dipiets@amazon.it>,
	<djwong@kernel.org>, <hannes@cmpxchg.org>, <hch@infradead.org>, <hch@lst.de>,
	<jackmanb@google.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-xfs@vger.kernel.org>, <mhocko@suse.com>, <ritesh.list@gmail.com>,
	<rvvandan@amazon.com>, <stable@vger.kernel.org>, <surenb@google.com>,
	<vbabka@kernel.org>, <vbabka@suse.cz>, <willy@infradead.org>,
	<ziy@nvidia.com>
Subject: Re: [PATCH v4] mm/page_alloc: avoid direct compaction for costly __GFP_NORETRY allocations
Date: Fri, 11 Sep 2026 14:30:25 +0000
Message-ID: <20260911143025.2332562-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260910150056.499c6312198f1898acb68adb@linux-foundation.org>
References: <20260910150056.499c6312198f1898acb68adb@linux-foundation.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D032UWA002.ant.amazon.com (10.13.139.81) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


On Thu, 10 Sep 2026 15:00:00 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> Yes please, a v5 would be good.

posted v5 version in
https://lore.kernel.org/linux-mm/20260911142102.2294202-1-dipiets@amazon.it/T/#u

Thanks,
Salvatore



AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico



