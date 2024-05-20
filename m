Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531FE136E26;
	Mon, 20 May 2024 15:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716218963; cv=none; b=RWCDJ96q4GN24By0jWHa2O/NwPhykQiRlxyr3fbQ2LJRU/4sBjgjIs3tUdJ4LXwSgWnbp8uUoVEysp3ftKn9NRNEzU7rGHdeK256kQBwlIFJoh7ZezwsE6IIgkRNNj9r8VqduxEqJ/GuYol/AgaihuMWabE9TBIBuVPo0GUm3n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716218963; c=relaxed/simple;
	bh=FBs9X56eKBI2JAbmZy5yCTEtlol77G+62J5ZNmT6Wp4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U06JsMYn2u8/XgwEE+N9BsMmeekioGjRAWxvCd0AUi3y2baxQjM3MAw1vZCqGSb5iGxDtJoNsIABTQLrdCyFGnBo+3197J3aDy6BOxJX3pSettHaf14Y/Hh79VzWMoMTaTSbH/MmXdOe8fW3RIxkEl9bh4GRDg4XX+6dW+XEByo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C9ED068AFE; Mon, 20 May 2024 17:29:17 +0200 (CEST)
Date: Mon, 20 May 2024 17:29:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: Xu Yang <xu.yang_2@nxp.com>
Cc: brauner@kernel.org, djwong@kernel.org, willy@infradead.org, hch@lst.de,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	jun.li@nxp.com
Subject: Re: [PATCH v3] iomap: avoid redundant fault_in_iov_iter_readable()
 judgement when use larger chunks
Message-ID: <20240520152917.GA485@lst.de>
References: <20240520105525.2176322-1-xu.yang_2@nxp.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240520105525.2176322-1-xu.yang_2@nxp.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

This looks generally good.  But a few nitpicks:

 - please split the mapping_max_folio_size addition into a separate
   well-documented helper instead of merging it into the iomap change.
 - judgment is a really weird term for code.  Here is a subject I came
   up with, which might not be perfect:

"iomap: fault in smaller chunks for non-large folio mappings"

