Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020511547CC
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 06:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734070264; cv=none; b=SZJ9BwdIofvuDetU7pqimBgyEjRkA6nECE9CtFzaCjVAfnWnLSylmdCrWFCIcT92J0oa8zv3DAuqiKw0XHik1CRweisbgBwBEd7SJHIGcGXVqmNWfkG4j2aHpFUfnenaIwelU0gmz4GPFq4++cDnj7BYmrtNw19E6NRRbuq4+5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734070264; c=relaxed/simple;
	bh=hkovd+V6GZRiSSu5qDoRgDRDVpHE1OkGJYSrpeOL38E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m7rrTwNO2joyBwaxW0rNx6468ogAtjf9MeLVUfcTDYZFOm/EhKvS18rLqtWZ31B74zaYQ4PAoOTjOw+6M5frSK75y0zc2mdqH9SZGmpviH0sfJSkQ0UXN6IAaZqkhPNlCncGoNmd50r45oNRitKLm/JUZeHoKSRI0iUa2fG84UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Y8SvzvrC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Y8SvzvrC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YcBgwOBhIOLCgabgrnZQh/td9yi3JKqnMJ9FMOM0tYg=; b=Y8SvzvrCP4yJ9fkVBv4P11KTJm
	56WiPgqtUv2Gt3iMD1oAspcI651llcJidI86Sn93XOEbK3KX9toHnzU9eqaUdonDivcPN0FQrR8UN
	T3XoO0lT8iihEXgETZHtKhjhplz44IkP30EW99YD7JAkkC0BrjnSd3ck4aVHkyov/Q2TYeJaa7CFs
	+xsWoUb4eiHdXhFnN9bMYlkuL67IaWV0j20IV5Rmwz0YhNAV2WgDOlmyMoMtMc5YnKAoteTTMB1SK
	O2bMv3+aDKmm8NBhgpz0pZSg28U1hAx/ZoP36Ja5QFDgghDyxU/UW7irED0yibTF9rxGkLQGaWiG/
	Uyj2G1Xg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLytC-00000002qLZ-2kMW;
	Fri, 13 Dec 2024 06:11:02 +0000
Date: Thu, 12 Dec 2024 22:11:02 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: allow inode-based btrees to reserve space in
 the data device
Message-ID: <Z1vP9qDWdywLExjt@infradead.org>
References: <173405122694.1181241.15502767706128799927.stgit@frogsfrogsfrogs>
 <173405122737.1181241.12229622781538486656.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405122737.1181241.12229622781538486656.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 12, 2024 at 05:00:35PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a new space reservation scheme so that btree metadata for the
> realtime volume can reserve space in the data device to avoid space
> underruns.

Can you explain this scheme a bit more here?

