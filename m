Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A3C1494A8
	for <linux-xfs@vger.kernel.org>; Mon, 15 Jun 2026 13:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781530616; cv=none; b=gxLRWnzntE07/uh2l2nuXwca98/YatCxePwwvTCK9NxJnr0ovSu0cR3SKSYFQyOgBdYRMd2j/FtmJdwe+hzoqceAZ9x7AZVBkWhyG7fQrWNt5qz0ouDhhHjZdUu7pFhNoTPlFJ/DTTm05QaJppO18ILLywM+6xYy5joX8TCgtMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781530616; c=relaxed/simple;
	bh=46skPWd9AEA6v34oR20RjzyQmy2F0jOSaEAijCKHQKE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qW6JU7tN3HyFbeoe7uovZ+pg/vmzb59lNarxDv+nLOU4mDlbTT8F4ZTgNjK+bGuvlWF0e2oWptfDrMxb95dgOGlLefFjhqe97QF5UMP0Bjtk5G502/G9RhIj74BAMh9uDxstjNRkjyteZi8n4sfckWa04sl0dYLN7lrs1xS2x8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D768468AFE; Mon, 15 Jun 2026 15:36:52 +0200 (CEST)
Date: Mon, 15 Jun 2026 15:36:52 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yao Sang <sangyao@kylinos.cn>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, hch@lst.de
Subject: Re: [PATCH] xfs: add a data I/O shutdown reason
Message-ID: <20260615133652.GD26132@lst.de>
References: <20260612091743.256304-1-sangyao@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612091743.256304-1-sangyao@kylinos.cn>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Let me throw this into xfstests to see if the new reason confuses
anyone first, though.

