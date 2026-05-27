Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A5433688D
	for <linux-xfs@vger.kernel.org>; Wed, 27 May 2026 12:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779885797; cv=none; b=eKtuCarjNPBxg3nA8Iq3vuSVSM74RFH2Wy5xSYe6/dwB3RiXDNhyTy3I7o9CK8eUhGYYu0gLJFeIBrkQd/XUiSgguQswwf7uY0GZSbXWH6BhkNifgAxTwWCINumqge4Cy+32pHNWx0y7APtfh/5sCF9MCYhPNVSBYm0nTV1dwt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779885797; c=relaxed/simple;
	bh=ZS4rOkhBfJTMHaVfK1NmBjyoD3qG2frKdwRhawWxyuo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S3K3xhBc+XebO1QDY/KElb8rSKdnrPhVZWL/bx6H941cCy1RU8do8jQAIzEoxFAlT4o+uG5jUkQT5jYxWoaos6WW4P2IXofpX8nbNWKCcC8wpGT8hCnELOo/fvJNX+rckQM2KRMDqCRqcdoqypTpxfuWDdAkwo5QpCS85AOghDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QnRZHgDa; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QnRZHgDa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZS4rOkhBfJTMHaVfK1NmBjyoD3qG2frKdwRhawWxyuo=; b=QnRZHgDaZpL8y4SY/p7KnDPv8n
	ofCX15K8B89onHw511Ekl2noSyhkPV9uXs8wPi6HMt6rSS1jYUU0IXRKtHKJRo7oxm7G9LBJBLXoz
	yN0j0RiuY9ihkKEd78aYD6Pc1Q0tDlLwUAb8FBqJbTqxjnnLMxJYMsNCYeBQ6THVZCWIsPFMW6jzT
	V3G13NGivk8w4Gj8vNRK6ULeXOhqb+SnIfutsC4yS9LddcIivuthVWEmLGghMGeilcKFvU/Vz4uWt
	7h/cg5B6uF5dIfqxRIgFabqDVAYKxLeJzi6btDer0ptfFJYl/VaCjHs1FVck+GxIjDlU1aKz6PNG3
	PqfFibbg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSDbP-000000047Zm-3waZ;
	Wed, 27 May 2026 12:43:16 +0000
Date: Wed, 27 May 2026 05:43:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Remove mention of PageWriteback
Message-ID: <ahbm48E74Nj67B_U@infradead.org>
References: <20260526195400.352557-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526195400.352557-1-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, May 26, 2026 at 08:53:59PM +0100, Matthew Wilcox (Oracle) wrote:
> Update a comment to refer to folios instead of pages.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

