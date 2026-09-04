Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E035C3F871B;
	Fri,  4 Sep 2026 12:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.42.203.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788523729; cv=none; b=g9NtSSXIjW2fA5H+sANeVVqGcKudueAzN43hJoSJqiR+ickDfS4oQQCzQnWnvEWHgqZv1o1kf7u3YvnWFx1oa3e3HLYpn1W9vvrITYRffAQf4KIkaWn0cXj1gZonkmM+fdvc5gXWWS5svmowsoaNE6PLvnc2bqWD8fgvViqox+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788523729; c=relaxed/simple;
	bh=yeQfZRe37uTQFMCzdgM6w8pnuJQjYBmF7q9HtXaNyyM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MrRucp8s5wALC1K6N2ojzLmysggiGXZtU6xziALTNEZM/5JQ+jg10LA5CtfZRjkelpSsJmQ37k4iDPLlFDB6RRigQLva8273zmyffdVjELeB8AGQM+TmZWV2xnJoFyrmNMaiDeM8QLfo/X8WvrkDaRyaLVE8TBFArz22jrJg8e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it; spf=pass smtp.mailfrom=amazon.it; dkim=pass (2048-bit key) header.d=amazon.it header.i=@amazon.it header.b=PA++hPy+; arc=none smtp.client-ip=52.42.203.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.it header.i=@amazon.it header.b="PA++hPy+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.it; i=@amazon.it; q=dns/txt; s=amazoncorp2;
  t=1788523727; x=1820059727;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yeQfZRe37uTQFMCzdgM6w8pnuJQjYBmF7q9HtXaNyyM=;
  b=PA++hPy+Uy/nAlaRkw8TmePgapMZWazidL6H3fdyrJ+7mHeFwMvi9tCz
   yoyBYyp0uZDtv7OcIqUlElOn/0ETcB9Y9/gOP35ImSvt3KeQyik9LVIeX
   U8ZXlhgpQbyoKbFaAVgzLHFYN22sVZzgYyaWmKopJZXWa3Ar59zKGknnE
   VY6TmL0yKXez7O5saMdQDvdfzrmwa51VVVpzZvkVDPiXY7DdurNbsckSU
   dXeK4X2hqAWOTPtmzZKmle8krrCk6tPMTajlR5IHN9Drgxy+V6H9p69LM
   WUYSwGbcQqEk+8uzC3OXeL7WUEZ3jrPz5CFhf0eYdy6TVWzHiDUULmhiI
   A==;
X-CSE-ConnectionGUID: d/CPTFUJSGSK9F4J3yp0GQ==
X-CSE-MsgGUID: aQlVFFEmSDOk9HvK8nEqgg==
X-IronPort-AV: E=Sophos;i="6.25,262,1779148800"; 
   d="scan'208";a="27848437"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2026 12:08:47 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.48:18188]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.14.124:2525] with esmtp (Farcaster)
 id e2747aa3-2a41-48cc-9cc9-c0602878100e; Fri, 4 Sep 2026 12:08:47 +0000 (UTC)
X-Farcaster-Flow-ID: e2747aa3-2a41-48cc-9cc9-c0602878100e
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Fri, 4 Sep 2026 12:08:46 +0000
Received: from dev-dsk-dipiets-1b-77b833da.eu-west-1.amazon.com
 (10.253.66.177) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46; Fri, 4 Sep 2026
 12:08:42 +0000
From: Salvatore Dipietro <dipiets@amazon.it>
To: <hch@infradead.org>
CC: <abuehaze@amazon.com>, <akpm@linux-foundation.org>, <alisaidi@amazon.com>,
	<blakgeof@amazon.com>, <brauner@kernel.org>, <dgc@kernel.org>,
	<dipietro.salvatore@gmail.com>, <dipiets@amazon.it>, <djwong@kernel.org>,
	<hannes@cmpxchg.org>, <jackmanb@google.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-xfs@vger.kernel.org>, <mhocko@suse.com>, <ritesh.list@gmail.com>,
	<rvvandan@amazon.com>, <stable@vger.kernel.org>, <surenb@google.com>,
	<vbabka@kernel.org>, <willy@infradead.org>, <ziy@nvidia.com>
Subject: Re: [PATCH v3] mm/page_alloc: avoid direct compaction for costly __GFP_NORETRY allocations
Date: Fri, 4 Sep 2026 12:08:28 +0000
Message-ID: <20260904120828.4022204-1-dipiets@amazon.it>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <apf-wsCj_5QvAPcV@infradead.org>
References: <apf-wsCj_5QvAPcV@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D032UWA001.ant.amazon.com (10.13.139.62) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


Hi Christoph,

On Tue, Sep 02, 2026 at 10:47:00AM +0000, Christoph Hellwig wrote:
> This looks really nice. Can you turn this into a formal patch?

I've submitted it as a formal patch: https://lore.kernel.org/all/20260904115629.3993331-1-dipiets@amazon.it/

Salvatore



AMAZON DEVELOPMENT CENTER ITALY SRL, viale Monte Grappa 3/5, 20124 Milano, Italia, Registro delle Imprese di Milano Monza Brianza Lodi REA n. 2504859, Capitale Sociale: 10.000 EUR i.v., Cod. Fisc. e P.IVA 10100050961, Societa con Socio Unico



