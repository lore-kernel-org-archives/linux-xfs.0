Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1B81D5CFE
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 04:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785213579; cv=none; b=Ew9XChuJ44lIUeDdHPXy1KT3jRA5FtsR2wgqdM/7+x7Y7EVvkZuDsxwW8a31iqhRrPPUhMKQKmxS+OlKnSYJW7ERsZpv3DZ8QxE2CvpdK3wiL+Db5WgtvoPLlZAyODTB862kX24tnuiNcaSx4ngQMeqIZoie6EtEaLknYb2sIdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785213579; c=relaxed/simple;
	bh=wL51jWCJz0w6TW5ZdX7eOyCbWgOTx/J38Qe1A05jNs4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cWuTcF4N/ejdWKeNhz9GZsS4qmkJ8Av/kjCxoXTEby4qQWj4Vp7FfKaGyczJTmo2ZiWfIDFBC2+SE/jH5L6vuPkCD7AuxtMHnDvUmTxSVD3eghp/jkC45OeJCabrYAwH05Z0TA6See9WQrPU2uaHNQV4xlrOt8zHg+XpKI8qgLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DA93C68AFE; Tue, 28 Jul 2026 06:39:35 +0200 (CEST)
Date: Tue, 28 Jul 2026 06:39:35 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/12] xfs: remove _XBF_LOGRECOVERY
Message-ID: <20260728043935.GC20064@lst.de>
References: <20260715145147.95654-1-hch@lst.de> <20260715145147.95654-6-hch@lst.de> <20260724164904.GS2901224@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724164904.GS2901224@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jul 24, 2026 at 09:49:04AM -0700, Darrick J. Wong wrote:
> On Wed, Jul 15, 2026 at 04:50:58PM +0200, Christoph Hellwig wrote:
> > Adding _XBF_LOGRECOVERY to every buffer write from log recovery is error
> > prone.  Instead key off the behavior on log recovery being active with
> > indirecting that through a flag.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> That makes sense.  I suppose if anyone wants to capture ftrace data
> they'll see the printk log stating that we're starting and ending
> recovery, right?

Yes.

