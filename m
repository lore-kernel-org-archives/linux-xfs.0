Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A936D4B3364;
	Tue, 15 Sep 2026 16:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.13.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789488134; cv=none; b=a3iEZjtgWE2aNIBKI52RhmpPD2k1ZTILfgERNyQCyJ9TAv6aks9Shks3dZaBcUWB7uyKeVPP7HXki5gUJoOlT9fqY/8mcZVmgMv5p81BhS3gjATysN1j+xva0ZC9IqLme3TIZGE0pzJJiyf3xESW9oaVSwKGO8CScSvssDiWmCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789488134; c=relaxed/simple;
	bh=tSXDKJA3syhrSNEZG47C+W2QQY3zaHqZ9KSolvwTOyU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ILqYAU5IL+OABsN9ZLjSl3xnFvTXnDNN/ZA8+iEMQpQdNzBwVgGY1+zHhKJBr/X1BNv3M1Epzlar0V5DhhQICxOIcR6Is/TAKgMadpUPxG1mGZb9bFcj3XeDwU6Eb91XQlQ6Uhm/EvSDMcMuOUe2lMuqaN2bZd8693+UUywL/AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it; spf=pass smtp.mailfrom=amazon.it; dkim=pass (2048-bit key) header.d=amazon.it header.i=@amazon.it header.b=s3Si+wro; arc=none smtp.client-ip=52.13.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.it header.i=@amazon.it header.b="s3Si+wro"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1789488131; x=1821024131;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zH2AffRhpysneQJNXQPa9UtiFiIZCjOUG9PhR8vSPsI=;
  b=s3Si+wronE6HXXBco3LTJ3Oaoxey4fZJD0WwbYWgquyN3Po72L+YXVlJ
   36Yy6m/pK5SY7ZghBopPgp//FC9pupuVrnWLW/JBKG2nGacyzY4hqI5t2
   Nv6FCVl7GdTX7cVgQb5lJRKDAUlTExN0Zx+l313t2vVTLjsopshFudnZt
   dwHNe30SvPRONKs0MTEap2zc7wLBKe1FE9ndO2nGOpdC2UCLm0rrB11+F
   5uOwfqqYdkrxic9TvRq+xMf9bV4Dp5mGD4LdqKg8xGoNFH15+SUx9GvDM
   VcuhQrNclyi+6ItqBLWkQJxo54UW1XlKjTfsL/y74y9sO/ehY3vGcUDlX
   Q==;
X-CSE-ConnectionGUID: u92piRZrSFapAw+TyK//UQ==
X-CSE-MsgGUID: YKI+s6tzTVW5liA/y0xZ6g==
X-IronPort-AV: E=Sophos;i="6.27,103,1787011200"; 
   d="scan'208";a="28716152"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2026 16:02:08 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.51:27276]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.19.159:2525] with esmtp (Farcaster)
 id 15f7d0fc-d5b9-43a9-b411-4c5574972f7d; Tue, 15 Sep 2026 16:02:08 +0000 (UTC)
X-Farcaster-Flow-ID: 15f7d0fc-d5b9-43a9-b411-4c5574972f7d
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46;
 Tue, 15 Sep 2026 16:02:08 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46; Tue, 15 Sep 2026
 16:02:03 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <akpm@linux-foundation.org>, <hannes@cmpxchg.org>
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
Date: Tue, 15 Sep 2026 16:00:42 +0000
Message-ID: <20260915160042.1265958-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260911093209.d9181d5950778897935f6bcb@linux-foundation.org>
References: <20260911093209.d9181d5950778897935f6bcb@linux-foundation.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


On Fri, 11 Sep 2026 09:32:00 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> does any of this look real?

The mechanism seems real, but it only shows up with vm.defrag_mode=1,
which is off by default.

With defrag_mode=1, a costly __GFP_NORETRY allocation that used to fail
cleanly can now succeed by fragmenting another migratetype's pageblock,
which seems like the wrong trade for a caller whose premise is a cheap
lower-order fallback. Johannes, do we want to keep it strict?
If so, we could add a condition like below. It is equally
applicable to v4 and v5. Happy to send it separately or in v6.

	/*
	 * Reclaim/compaction cannot run, so defrag_mode's strategy
	 * of enforcing ALLOC_NOFRAGMENT cannot be fulfilled. Allow
	 * fallbacks rather than failing the allocation outright.
	 * Not for costly __GFP_NORETRY: those have a cheap lower
	 * order fallback, so failing beats fragmenting.
	 */
	if (defrag_mode && (alloc_flags & ALLOC_NOFRAGMENT) &&
	    !(costly_order && (gfp_mask & __GFP_NORETRY)) &&
	    (gfp_mask & __GFP_KSWAPD_RECLAIM)) {
		alloc_flags &= ~ALLOC_NOFRAGMENT;
		goto retry;
	}


Salvatore





AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico



