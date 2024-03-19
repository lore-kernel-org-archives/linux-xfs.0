Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1389C3D55D
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 23:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710889590; cv=none; b=YhzVpXRvUw5XV7+w1JOb6OE0jMjrb4PoA60/iaKBPHyWepBEwfgcFuA+VoaIkC29TvSoGN2+I2l4Rz6EJiRb/HncG/NL/gFEnbQ3UGfIfOwO10Mqgaf97ZGO3qzoS6HKjNs7XeYOJTtBtuxxL5HhlKy8air4uiXtrQnfFhN/Czo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710889590; c=relaxed/simple;
	bh=qzXOUDWQ3/p0Mbx42PLXyKiu8+S4127zuRm+qZmyjkA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JQC4LYCXq6bvgCd5g650RNfX5cyMRH/05MeUG2H2CBjHwA3W3L6/AV5S1TjN6gk//+48r5ZpKqc1iSrvIgsRyPMum2mKA4RKVTfUTkHjyM7tYEP3OFtaY+JCmx2aGOMgA+xzdihGJPBDWcmqIoftegFmwLavxJtwePr+eTARagg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=B0WA26Ea; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="B0WA26Ea"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CVMfC+y+IVcPJm4qN1ocO3J3zqxuoD6GnzoL5MsUN7Y=; b=B0WA26EaGsXwYoPZr1nuETP66v
	gjwXYYX9ha0ypfwdiH6OQfZS44SQQ1NTOQbgUPJLtQP6YKf5sxSCbLqmxJcmXc2r8aMCbBOrutsVh
	9AGv4+vE6PUEMIiJQgwfPtgG/0IM6iqbOayxukWPZD2mgI8uOAP7mN1nv1YlH6iCaPv0hl3WOIqSA
	Bl7bCu1/KZmjEkfpKeo3U8J+LiWzCmUSyFi1AQgGOIcX0tD44JNBRWkB3fDwJkse0M2YB85warHSp
	KawUihPEKY8GPY4vZlTGnJbWFjnXnowtm6KszC93Luiv/BOqfVCSXnIPboT15AsfaCEOFwBRyNA0h
	/NfRJiyg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmiXM-0000000EZCW-1zXm;
	Tue, 19 Mar 2024 23:06:28 +0000
Date: Tue, 19 Mar 2024 16:06:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: internalise all remaining i_version support
Message-ID: <ZfoadKGgatGjTM_5@infradead.org>
References: <20240318225406.3378998-1-david@fromorbit.com>
 <20240318225406.3378998-3-david@fromorbit.com>
 <20240319175411.GW1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240319175411.GW1927156@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Is there much of a good reason to do this now vs oing it whenverer
we actually sort out i_version semantics?  It adds size to the inode
and I don't see how the atomics actually cost us much.  The patch
itself does looks good, though.

