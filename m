Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD6C132489
	for <linux-xfs@vger.kernel.org>; Thu, 21 Mar 2024 22:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711058538; cv=none; b=I/EJ/8T+U3AdstZLxunqtJ2XCo6nktxOns7cy3TJy9+ktd3YuQ3D0ILy1NVKSznF+ukZZpn42UEdl3bvMlKrvfu/xYCK1Tf2RCZT+FhXzk+Qgjw6ekrq6qn1Z3tW5B3VOuv8YfSw+qIkZX9Uwzp/iradP7s9Ru8ZBff68/kS3YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711058538; c=relaxed/simple;
	bh=oum0WnHePQJg4aaJtKfKAF0LXElpeYvWQ5jfmNjYOGk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hv3RTJrhjHl9zQW8rnbQuCcRGr6mKlCvQFokWdm2Ly3bnCvfGd03JVlN7y54KnnpS3kRJEhrYrTze/47HwsnvWm1+79Eb/tklu+RUxA7MFTj5qC33FeUvys8Muvybg8PrpMrpLPkEEvcq8M096OwCPErVvapULgY53Qnd18hv8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZlRSHoQA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZlRSHoQA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nivHEGqybZRg0zKXh9bvVNZ+V3K57K+lJHhLsfPQkT4=; b=ZlRSHoQAV3fWfbkHuecLwPuMBY
	ApeVFech6ZU0v2VA/AwHbGBjQc/qjmmDE9ybu1yaITb8Awy1LVOJvZbgu37VVrMFob61/xD1To6gt
	9JEXy9q4T4j3tcbFHUBpbZM2yIPf93o5XsXdBTIN1eBWmQ0c15ro+TkRK9tCGXsxtl7PcG9A+LbFG
	xY01tIaqBc5VI6WZj9Tte2J5in6kFkSX+cZGa6sPh88GoMMuTjsFsThQB67ApAG/yNinUV3ojxsFF
	ZDIF+uHLzc24xWFjgiO27edvN0z4Rf6B+inHUsTAT5Kr45Xy5fqcjvokWOkYq+5t6TZJ2Vs68UBCR
	fUHwz5HA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rnQUK-00000004p0q-1Q6q;
	Thu, 21 Mar 2024 22:02:16 +0000
Date: Thu, 21 Mar 2024 15:02:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: convert buffer cache to use high order folios
Message-ID: <ZfyuaEXwOpr4H07n@infradead.org>
References: <20240318224715.3367463-1-david@fromorbit.com>
 <20240318224715.3367463-4-david@fromorbit.com>
 <20240319172909.GP1927156@frogsfrogsfrogs>
 <ZfoEVAxVyPxqzapN@infradead.org>
 <20240319213827.GQ1927156@frogsfrogsfrogs>
 <ZfoGh53HyJuZ_2EG@infradead.org>
 <20240321021236.GA1927156@frogsfrogsfrogs>
 <20240321024005.GB1927156@frogsfrogsfrogs>
 <ZfymdyLxJ_-GkFji@infradead.org>
 <20240321213903.GL6226@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240321213903.GL6226@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Mar 21, 2024 at 02:39:03PM -0700, Darrick J. Wong wrote:
> 
> It turns out that merkle tree blocks are nearly "random" data, which
> means that my experiments with creating fsverity files and trying to
> compress merkle tree blocks actually made it *bigger*.  No zlib for us!

For a cryptographically secure hash, not having high entropy would be a
bad thing..

