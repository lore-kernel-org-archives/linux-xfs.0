Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FB8230999
	for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2024 08:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731487828; cv=none; b=sniR1X46XK7sCw3IS4bnNVSykGDuaFqGcAjb9Mtyzbt0R8DbgYaoOFwu1Wn4BhYNPc8zC81HslHN4kgCcSC2quaQ8EQj6y3yLdvWpBZyOnA9HvlELQTUOFis2IN5H0zTHMc3e7q2iEUHRHI4R+Av8D4rtA4sP51dBFx1NZclAMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731487828; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=soTY/D84v/mGY+CBRcayRhlZDBSIEvYSnNpsW5RwbAvIeJlj135CTwKBwyVx+Wi5qx8yb9CYw04Lhhc/9l4UI+MHbKNCmTfSvQHuCHrreFjvDsQ+E6AG20jm+qDl/mFVJwP9EPUbmrdve2/+WY5D0dSTTwCcfamYR/6s1txuong=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WdS42zbH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WdS42zbH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=WdS42zbHrAfZhIsJp8hNDxYdP7
	ogUE3vETPNDoMU3va+OWYTvgAt5tER00y1IbbYw/v4jlbhxTNXmgoGNqgBJ6w51YZYvfcefOHqHTx
	zegjFbB+GOUA1OWBAf2stKpiITMjNrHpu0t/pCmvunKwYsuFpVUt5123zc8oCyhFfqT0+Osl3ns/5
	iRn4nKdyQKBhZVwXhvO30GmgoIBmyfiv4y8hownBAJ0I62Gm3CY9BeO324sf2UDdydmhQ/WXxTQj+
	HpHKmB/K7ZFZ+za7qeiR96/NT/M2Rd5o1XrVw/bnJUvLlwYycOZ794KIaSgBKXnmGTPzJO1LtU9KY
	a9mgvYAQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tB951-000000069I4-0sR7;
	Wed, 13 Nov 2024 08:50:27 +0000
Date: Wed, 13 Nov 2024 00:50:27 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH 3/3] xfs: prevent mount and log shutdown race
Message-ID: <ZzRoU9Uo6Zxdo3yA@infradead.org>
References: <20241112221920.1105007-1-david@fromorbit.com>
 <20241112221920.1105007-4-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241112221920.1105007-4-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

