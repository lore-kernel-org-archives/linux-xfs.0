Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA2D352C5C;
	Tue, 16 Jun 2026 05:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781587459; cv=none; b=fc8+g+bP/P89pcySL+yEtMFScVRzmQ4WsPMXvoLk92EWLI7z5ZvS7xMEsic51Vjw8doXiy8hbq7Knic5aGFVg3I8R471nWVpwYDdX02sG4kXlA1D7n+HacbnWigfJX/Iy6E0rsp1GzpTD8krbfqnAsxo1L5Vta+DaJP2LLywYNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781587459; c=relaxed/simple;
	bh=A8g0anbaYDKg9PH8cSs4YMB8cBHGJF1Sc1VTItDADdc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZZ++YmodieP34Sf9sBKUHfRnT+mTuDRw0GfUB+3xAUbSSGNxhGYouvoRTKOeGH3hTSbB5DzX7ttshkEOMv1N8sJzJlls8DfI+bMBVukXW0iTDHJwb0Bulhj6xKvtUp5rSOiyet+hoTPfzwUUq+yglzUjXQA1YLjZo3e60tRof3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DXhPkN3a; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DXhPkN3a"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DbuGFDRb1m73RQAM1n526x7yX/8fbwGqIbwf2jihmfM=; b=DXhPkN3aKnnC/BLAPIhAuy/zJU
	QSrAzP8egEzYesTTscbBya1qbiWfjoknqojPwcSmVWx1vHivIh9JJTkm/1ocyV0lKe4gGomrYNE4c
	ytC96TfhcYhGIE2Wabk/MCTtsD8VhP0RoX9O0MLvgYdct9bhUrbhSuQFo2eOzvZMzCjirq9GUhDJQ
	iRMed104ZNFhQEd2GqRz76cu7TNoJgzOe5P8V+EGu0CYRNPWyuMfbqlFm4llEpsgM+zrFbvmMermI
	M/l2hma4p3qPQ7hIdCuwnlljgCywoKvW+8DfHEV0fVBszLW+Y7eZVEtGRUEtBuoW08stAMx267lPg
	tF7ODN4A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZMHZ-0000000FFEp-3zDP;
	Tue, 16 Jun 2026 05:24:17 +0000
Date: Mon, 15 Jun 2026 22:24:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Eric Sandeen <sandeen@sandeen.net>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: mkfs.xfs "concurrency" change concerns
Message-ID: <ajDeAYs79j4enacm@infradead.org>
References: <84c8a5e5-938d-4745-996d-4237009c9cc5@sandeen.net>
 <ajAJ6lXJWcko4epj@infradead.org>
 <20260615154048.GW6095@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260615154048.GW6095@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jun 15, 2026 at 08:40:48AM -0700, Darrick J. Wong wrote:
> Lukas Herbolt posted some fixes for a few of the fstests to inject
> concurrency=0 into mkfs.  IIRC there weren't any changes for 078, but
> you might ask him if he has more bugs to address.

Shin'ichiro, can you check if inserting concurrency=0 fixes xfs/078
and xfs/216 for you?  (and IIRC xfs/217 which lingers in some reports).

