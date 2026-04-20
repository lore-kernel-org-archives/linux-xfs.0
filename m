Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8633876C7;
	Mon, 20 Apr 2026 18:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776710702; cv=none; b=Nv0afz118AMWVP0Ozaq5fqadJNCUmqWrZNsNAap7Iannv0/iJuAOUN2z8k/wb2NBiz2J8AEkiZjLVXrPadEnNvLBq3Erq0YY1NdVy+oXlP6qGbwrtNnhE+sJMPWg7kBlpm7uC1A43dhArp1w8VCgRvS6lC6uX9nrzfIET3F5bR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776710702; c=relaxed/simple;
	bh=cKMqMN2l71w8SFQhRDA7WgxB78lBD8fzgiDka4+J2R8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qhLx788DlC5201fBbHrs1KsxfRlS9JXC0SgC4qmhiNLiR3o+x0jU9SNG4QmoRZMsPhmOthqCk2SEQ1bb9LsyoVItKxhanLVY0dMpefw5goK8R19NwdI+R5tlrIc8OfBfcm1mkOVeUak7OfcPgO0V+8zwwwoTeAV1Neb+Fyf8034=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gyQvP9NQ; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gyQvP9NQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CCWzvfTkfoysVZruaWLzaWr+SFpVpTuSMaDm2I0ptYw=; b=gyQvP9NQH4r6dXlwTYIg3EdmZG
	PEZFOWUYAt0Yi1FDtRoC6fLhs7KC9jT0IdU9WwtKOqpKvxq6MWVRZmVDtLoL9KJpHU795TFi6V4Pc
	YIwSLARetSg1gvYxziTCA1HAFg9flSkUpKxt0hkWL2zrnHu1JV+wvoQEax4u/IV1NLSg5NMBZkva5
	gWa95Slf9k/7R0ytd9rTl2PPZNUZik4QWaNTOW64DO4N7DOVq5dP6HL4jmhlgU1zWHLpc8rqumFEB
	T35bPhhRL0G7AjuOg9HT2GQ++O0RmYRoiRR0q5v+EZmG7jjXfTMg5QKsZu+7/XT1bQ8f4Sx5TxYBS
	YLrHcfJA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wEtcA-00000008sWu-39DB;
	Mon, 20 Apr 2026 18:44:58 +0000
Date: Mon, 20 Apr 2026 19:44:58 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: ritesh.list@gmail.com, abuehaze@amazon.de, alisaidi@amazon.com,
	blakgeof@amazon.com, brauner@kernel.org,
	dipietro.salvatore@gmail.com, djwong@kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/1] iomap: avoid compaction for costly folio order
 allocation
Message-ID: <aeZ0Kp8dBqjsyWki@casper.infradead.org>
References: <ldenszsy.ritesh.list@gmail.com>
 <20260420163328.22104-1-dipiets@amazon.it>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420163328.22104-1-dipiets@amazon.it>

On Mon, Apr 20, 2026 at 04:33:28PM +0000, Salvatore Dipietro wrote:
> I have submitted a v2 of the patch based on Ritesh's suggestion.
> https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@amazon.it/T/#u

... but without linking back to this thread, so nobody who was exposed
to that thread for the first time knows about this one.  That's poor form.
