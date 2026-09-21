Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D4C30DEA6
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 08:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789979661; cv=none; b=W05va5lFY53zIQRThWazDQK4vH8c+gvsUpCwF8tQBcXVtNi2LkqNtbpg67STUQ6TlA0wTvbEaOcYwTte1TXedU2Nu6yXD+u3X/LN4JpRkBx1lVRuX5ur0E+9llLasOjbdB5Dy8B6Iqg29ekGe8RNfJNHz+6mDt6J3jLm/c2Njns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789979661; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fOsoNdq8JNbLMaqRuFg0y5r0Dg+KtolZnkEuyPaZQDNVtTKJE3zxFVQ577YYVkK+1/xlJFqo3RR30UMs0ByiAskX4IS0EK0L49EIKDVNRAE2Syq5U5Aa6pp13q+RKHuJt/Yv5SxaaeG+cI5mRYl5sP0DNw4aKU3DabAh9Kff9MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AAFA568B05; Mon, 21 Sep 2026 10:34:16 +0200 (CEST)
Date: Mon, 21 Sep 2026 10:34:16 +0200
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: djwong@kernel.org, sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 3/3] xfs: make xfs_iomap_write_direct() report an
 error to xfs_trans_cancel
Message-ID: <20260921083416.GC20936@lst.de>
References: <20260917103633.14703-1-cem@kernel.org> <20260917103633.14703-4-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917103633.14703-4-cem@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
