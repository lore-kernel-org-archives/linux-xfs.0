Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2835C2F5A13
	for <linux-xfs@vger.kernel.org>; Wed, 10 Jun 2026 05:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781068448; cv=none; b=Ek7dbF7dRZBJC8UqY/40Zna8malbDWq/w7s6GPiuF9radMDxPsmxQW81OefdyrW1X1fYOgmUmI5GXK+iuqVx0e8pGZhmf1kzcf0KmCyP/q6U+EeSO/4ju2npRjWE50PbLwR5cAaKBqYOlVJQfr1JEDsp8FqP9RCQpwRmgyi6H80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781068448; c=relaxed/simple;
	bh=Rwf9KgWsIjvqsxpkagabIXGwWmolFFBXC7JQ+xf7VQU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HeCAqZ/I64avM3J4ZOSGy2v/FWRqBcgT6uk+ZMAtaym9nCokStbtKdpRaismKIL1R+oWGdcxfiXAThCLzQibjn4SGjR0HDV+5nFLGFpKzsWe/byX02EXAg6O4EPdKa5ILjzWaN0nu/lg2Zzl+nxb00hM6Mz1Qoc9uB2rUwhzz5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hYV7XjhL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hYV7XjhL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+jmq/7UF6nOfdCUQ1XCXnJCxzMO9uT6vPqnL96siVYY=; b=hYV7XjhLGN+KoaFqzXf6OPaAdf
	xVq5R6gbr36uqqp1yNPpwAonpLJfE1NXR4Hgz7g0dhl/LjmqYXkIZGGZdde5N3HMthV0nHNrcIVfB
	cSvIrR2Qwl21iJrfQ43LM1wtQSMX4aD/Jm1cDzywh/Mv7w+ucbSwg0QEQ5i4ToUnbEcNzosD4Kl/f
	WN04NU2Koyu8SCkeOvj1d+jeCDMFilJS4xclIuxrL8ikhX/yQIzu0asFMpm4Iu/wEdrTVtI0hxGMP
	ou0COk3dq/ZLA42QbdzyAnpJeyrMFkBh229SedjLmjZCqCSjc7u2PEWmsAxkNWg06IgkdYRVMJIWT
	jERpsSTA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXBGQ-00000006oa5-2c32;
	Wed, 10 Jun 2026 05:14:06 +0000
Date: Tue, 9 Jun 2026 22:14:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Carlos Maiolino <cem@kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix pointer arithmetic error on 32-bit systems
Message-ID: <aijynolhADA0Gcjl@infradead.org>
References: <20260610045724.GS6095@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610045724.GS6095@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jun 09, 2026 at 09:57:24PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The translation of the old XFS_BMBT_KEY_ADDR macro into a static
> function is not correct on 32-bit systems because the sizeof() argument
> went from being a xfs_bmbt_key_t (i.e. a struct) to a (struct
> xfs_bmbt_key *) (i.e. a pointer to the same struct).  On 64-bit systems
> this turns out ok because they are the same size, but on 32-bit systems
> this is catastrophic because they are not the same size.  So far there
> have been no complaints, most likely because the xfs developers urge
> against running it on 32-bit systems.  But this needs fixing asap.

Eww.  I think we either need working 32-bit CI, or officially mark
32-bit as deprecated..

The fix looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

