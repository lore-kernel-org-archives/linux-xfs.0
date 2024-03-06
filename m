Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633E9BA55;
	Wed,  6 Mar 2024 15:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709738284; cv=none; b=h/+1hdURkVxUeJL8iWTt0MRnIgLkGlBVwq1atcCrcB3l5XEw9Sd7xE9fwyefMOt0JPk1rQetYda3fot3piSQUBDENJ93bucmP7huhDp2eWycTZ5Dzs8pxfmHqnrx/o+eiwqSYhG0d/pgt/z5U5a4pkNBASqE5wZ1af/o8o3d32o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709738284; c=relaxed/simple;
	bh=kdI12UVzX6lpq1QBluI7I6aLQ3ybbrpK6dosRKpBtLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AmKxdZnw8g7tqfPZLU+iDi6BrtLCi/wq442R3cBpV86Ppzetb8K5R9c0024GtTifKPq3C7aOWwBYVPuOMXQ2KuMvXZ5nQDistp/OmSJLFxs1iWKE4M06SWKJ2mGgtyGZEYIbvHeDK3a5vsVX8mRcP5UZwFwhx5tWjRxR6A1npqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fB1fKKMG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fB1fKKMG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bw8ugCPqqTeafA6il4qR3SoVrdmve72xh88yft6c/MA=; b=fB1fKKMG3bIHQVXCTcBfdCFnnJ
	Lh2d5mquAonomnMp0U8WEjwcMZ/pX6BdTcd0vnyAAVLtZsAOmU/0FhWDXMTVeMhwRavtWwLZkIUAq
	9pIH1fWHGg+eY9E2Fx2madA1z156c3ksx7h2fzvN5ErjR5jPBMHCmdb+OrUfW6SUHU0FcX2HU2wzj
	IRvNu3+cDCZeHPI6SFcBp2s+m1ZsRaVnzi/4Bm3DEzhJlKxPdzHXb49PbocRwjxVNxcDMrNx9jHYU
	n6ULV2VMH3+y1ji7K2ZdtJbTgU+/+WdPhFS1kGama4S/MAFfzF2CA9qfiKygiUNLLqmT28EXdRS0w
	/BNRb3Og==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rht1u-00000000kee-32QR;
	Wed, 06 Mar 2024 15:18:02 +0000
Date: Wed, 6 Mar 2024 07:18:02 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [BUG REPORT] General protection fault while discarding extents
 on XFS on next-20240305
Message-ID: <ZeiJKmWQoE6ttn6L@infradead.org>
References: <87y1avlsmw.fsf@debian-BULLSEYE-live-builder-AMD64>
 <Zehi_bLuwz9PcbN9@infradead.org>
 <Zeh_e2tUpx-HzCed@kbusch-mbp>
 <ZeiAQv6ACQgIrsA-@kbusch-mbp>
 <ZeiBmGXgxNmgyjs4@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZeiBmGXgxNmgyjs4@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Lookings at this a bit more I'm not sure my fix is enough as the error
handling is really complex.  Also given that some discard callers are
from kernel threads messing with interruptibility I'm not entirely
sure that having this check in the common helper is a good idea.

Let me think of a better way to deal with this.
