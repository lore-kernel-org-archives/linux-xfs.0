Received: from pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.83.148.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750A6351C05;
	Mon, 20 Apr 2026 16:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.83.148.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776702824; cv=none; b=rX3BWIM9nc9hpZY8o+UlRR9bQT8t8QKqeCbACKIrPl5nhI36+uYqYEFsqUjr4lCg8/zlPsT7WCFnzTgk3spuUpWRpPwaALFSKZX4QmHUTcCPvFfytdIfRsqNo8/op/XoUodPU4mon6AVDeaX1imRsh4sDCOs/nkvzMUR3KqSN0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776702824; c=relaxed/simple;
	bh=X9sWbHxc0NftggCUNc8XH5sYfXjCQ2bDYjxsPR5LFRk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m6Q49LAEcB80EXmTkdsNr44SU7r2Le1pK8BErNKlkB7KxRy6/yLnKJAkIL9nS9v6QYTt1b4x02G+s2N+KOZszE7qy/ZavGMxdPxKDwbfTo+3Byfgns7j3A2mhELeUJ9QlnPBdcUxHVsxiZEPUag7jP5dbjWZs3qqSzRCXXBGQhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it; spf=pass smtp.mailfrom=amazon.it; dkim=pass (2048-bit key) header.d=amazon.it header.i=@amazon.it header.b=g8VT04g0; arc=none smtp.client-ip=35.83.148.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.it header.i=@amazon.it header.b="g8VT04g0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1776702821; x=1808238821;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X9sWbHxc0NftggCUNc8XH5sYfXjCQ2bDYjxsPR5LFRk=;
  b=g8VT04g028WLp0BYgm+VZkZhBqWvQBQRnVsOcyCYF6A5HGGejxm2gH6f
   Oztb0Nb81G/nyQrbQlkxEzMjW67J7pqpWILnv7ovhKpgPWvJqJSYvTRwm
   ial7Ct7pxRiAI7JUFQvftkNQAsS+m6+OoW0aY33MmqVPFCHlxXgCNVGsr
   73R3Cp+R4nPBQhAc9X3xWayXEzvgyBFggUMZBtT4LyUnUdybvLAgYKktY
   PyaK3PhggYsazmp7fHXNit36N6tDshBTYqm5UM7hETD8Yhk4xk1C/zyGQ
   mIJWmHCAXfjY8wAdA/NMSFdpOyWUdbn4Hh6fRf9uWCsY+OZY9A4Mnp7qc
   Q==;
X-CSE-ConnectionGUID: LK3GeKKVQGCI5NhP+QU3WA==
X-CSE-MsgGUID: zR+AVDFsSEiBsgS/xI+5YQ==
X-IronPort-AV: E=Sophos;i="6.23,190,1770595200"; 
   d="scan'208";a="17524416"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2026 16:33:37 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:9653]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.43.27:2525] with esmtp (Farcaster)
 id 46b80425-918d-4d73-a66a-caf3b55c19b4; Mon, 20 Apr 2026 16:33:37 +0000 (UTC)
X-Farcaster-Flow-ID: 46b80425-918d-4d73-a66a-caf3b55c19b4
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Mon, 20 Apr 2026 16:33:35 +0000
Received: from dev-dsk-dipiets-2b-fa1865ee.us-west-2.amazon.com
 (172.22.139.101) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Mon, 20 Apr 2026
 16:33:34 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <ritesh.list@gmail.com>
CC: <abuehaze@amazon.de>, <alisaidi@amazon.com>, <blakgeof@amazon.com>,
	<brauner@kernel.org>, <dipietro.salvatore@gmail.com>, <dipiets@amazon.it>,
	<djwong@kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-xfs@vger.kernel.org>, <stable@vger.kernel.org>, <willy@infradead.org>
Subject: Re: [PATCH 1/1] iomap: avoid compaction for costly folio order allocation
Date: Mon, 20 Apr 2026 16:33:28 +0000
Message-ID: <20260420163328.22104-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <ldenszsy.ritesh.list@gmail.com>
References: <ldenszsy.ritesh.list@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D035UWA003.ant.amazon.com (10.13.139.86) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

I have submitted a v2 of the patch based on Ritesh's suggestion.
https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@amazon.it/T/#u

Salvatore



AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico



