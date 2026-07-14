Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8063C37AA95;
	Tue, 14 Jul 2026 06:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784009530; cv=none; b=fz/wCO64v3g35hyFwHCD7YiQ31cyhKg/aSKuaFlEoy/iOHGJ06paY/IUMG2HDo9qFI79oKrqt//2rMZuBuXqmHyd94448MWIg7rqWYrEiMzIOe3I7AGCQ6TJzABG8zpoZUxrUPb1Q23H9QHOsBt7ZDUCs9BY5uAOJ/tlRb4doJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784009530; c=relaxed/simple;
	bh=EzN8+dGI/kLmV+LFC01SIqudc/LtqvHKW5ivKEghVug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c+0ZzK7nrdmUyPp4/O1qAEZVTYoP4nN53hA+bImUR6AdLa51LHJVV9gYVUHjMJBBbVb7niJHBVW7XH228eT/HrU2JawneHTpIWm8hQXwnq3vbyZiNoVngnDI5oP4Y8k/AaoxyuP4y+59IV7uL2IJRcwoeQQPtI6LmUvsvfqZYPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EF48068BFE; Tue, 14 Jul 2026 08:12:06 +0200 (CEST)
Date: Tue, 14 Jul 2026 08:12:06 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: fix off-by-one error when calling
 xchk_xref_has_rt_owner
Message-ID: <20260714061206.GC1072@lst.de>
References: <178400716782.268162.4846177784022689546.stgit@frogsfrogsfrogs> <178400716859.268162.13837291911320452593.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178400716859.268162.13837291911320452593.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jul 13, 2026 at 11:06:28PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed an off-by-one error when computing the length of the
> rtrmap to cross-check.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

