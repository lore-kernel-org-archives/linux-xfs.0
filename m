Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B3913777E;
	Wed,  8 Apr 2026 05:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775625382; cv=none; b=TOfEcckUiPJfK2MwQHvSFTHwmk5ouOl8GMS+0mevEffqrV7E/9ZLTKEFH9rtZV9EczN7HfkTcSJUZQK0kSnDh8c4X6hzYySasT58K+alfplDm4EDkto6AFYdxzbOYLDlGH3Bt+mkJCj0k4XUdAP623w7DOrCwG7kX0N7YPQQYcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775625382; c=relaxed/simple;
	bh=4rRfJtinVWPTbYI2t919oqiMcjj0/UkSh7Ln5yDTmm4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L4R036Ebb+mFlIdla+VD367H/tn+BFCYqh9hV4sGD0fMswWUYfwYrZhd4+OWgZRxsNz6kxYpHYgxhgVLklcnoQtQiTVXBlNcx8OeXXiCTf/E4xEPSSZtWo5V1J8qU84cnpS+DlpT6oqJ0u+/bO3lbkbG8klCyD0gzN+fro3rfFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B0CCF68C4E; Wed,  8 Apr 2026 07:16:16 +0200 (CEST)
Date: Wed, 8 Apr 2026 07:16:16 +0200
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] block: add a bio_submit_or_kill helper
Message-ID: <20260408051616.GB23717@lst.de>
References: <20260407140538.633364-1-hch@lst.de> <20260407140538.633364-5-hch@lst.de> <b2e8e413-39bf-4255-8aad-a30d7fd676ea@acm.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2e8e413-39bf-4255-8aad-a30d7fd676ea@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Apr 07, 2026 at 11:37:50AM -0700, Bart Van Assche wrote:
> Without this change, if a fatal signal is pending before the loop starts, 
> -EINTR is returned. With this patch applied, 0 is returned,
> isn't it?

Yes, I'll look into a fix.

