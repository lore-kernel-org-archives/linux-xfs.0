Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C8616D9D0
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 14:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712760938; cv=none; b=JykGzqPCxsmiwrlfG33BA+bHugHr35tAQAj80bykv2eRWvmkf4XK0YNdhULMIbr5Rrkq4xTlQ6yumNCEDMy0Q19rXGW5cbYP/v24QamLWbdP5pXSKcnIHKJ84BVRxSH3B+WGK3jc158oBBXbgeqEfnlaSohRsguS6NonYIF+T+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712760938; c=relaxed/simple;
	bh=4wqxNiT81+A/1cPd4oGkHHym7Th78sLoq8Srd0226K0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gIuyaHBrdI1csHjqPCeB6Nptv935FsySX/UcpnNw5zNZ3q6r0pyQMv6fgGBEfazwf43+e4dbg5P1B2Fb0aawr2drPXTFucXcOM0Xmn8ESbS0W5CQCqBa9m8aKgJQIZlmAAHoXFD91crGnsTu0Vg7H2/o8URJ8cpTU2zcEZ3k5Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Qg7WbNgP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Qg7WbNgP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kqjPnanakgQVP8QkfFfwgY1HubS5wQe1jXr6JtHhf4Y=; b=Qg7WbNgPWmOzjMUyZTRcACJ6bO
	wH63Mg3+zhyHHS1wVO4+OfmJ67xiSCZrWT66u5/v5oGl3bgmzYILXkiTNbtYW7sqlsGonWmlseH9m
	xbSGo/y/Ym6xjfu47gm7ZHF82FKGKIQAJaHKoHLQkZkjfieDyiFBY9841bBcNX0YPPE6g3AMVndxy
	DGszKVU9n7TVNWRbBM9ujOZkFey0sukjsFCUi5wUAlWcHOcy+/b+91UYIrnlDYICnhKoB+g0kJkd/
	DCVaOjJIY32MmUImRLYRwspag7spPJPSudVmu1Es3OUv/Gw1NGGMmtAYxM7IOoMgAH7y9N1Z88Ycj
	IaVZshPg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruZMN-00000007coV-2pWT;
	Wed, 10 Apr 2024 14:55:35 +0000
Date: Wed, 10 Apr 2024 07:55:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: reduce the rate of cond_resched calls inside
 scrub
Message-ID: <ZhaoZ3NefVUXXx0b@infradead.org>
References: <171270972010.3634974.14825641209464509177.stgit@frogsfrogsfrogs>
 <171270972034.3634974.9974180590154996582.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270972034.3634974.9974180590154996582.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 09, 2024 at 06:08:38PM -0700, Darrick J. Wong wrote:
> Surprisingly, this reduces scrub-only fstests runtime by about 2%.  I
> used the bmapinflate xfs_db command to produce a billion-extent file and
> this stupid gadget reduced the scrub runtime by about 4%.

I wish the scheduler maintainers would just finish sorting out the
preemption models mess and kill cond_resched() and we wouldn't need this.

But until then:

Reviewed-by: Christoph Hellwig <hch@lst.de>
