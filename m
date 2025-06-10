Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD3317736
	for <linux-xfs@vger.kernel.org>; Tue, 10 Jun 2025 13:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749562363; cv=none; b=nCb+7dlwMv08zqOBCNT4mVB2zhfr5qXNsFhkpscmksAlOLBZnhb1sZVGWhbHpG4aINBmpfQMu5goYg0wWT57ehG/D9J2AigAwD/T1RCdYKRCYqse84TwsIC6gcv3NJWrtcQTIC2KHpnnKUSEzu+OOVaUVKGNaKiHY1X4+jK4nEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749562363; c=relaxed/simple;
	bh=23/+KcG14gqBYTo0i2hw0GQrzT6UAyf3PtueKhv8hRQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZlsQKdRof7iNhQKXhHKBAKOzVFPrFE4UBdUF9NE2N8hOEpOzwUZ+lH3LO+WxvtFJINz2rAp88/7LjHHaN4tXYX2fRLr3MRyyJz2OCvmaLT/pUBL26zhDMFsF2fyRTZumoLbvTwHqnKJwk7flvqvD98dNmWjZfcSmYL4M4vyx8yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1FB2968CFE; Tue, 10 Jun 2025 15:32:36 +0200 (CEST)
Date: Tue, 10 Jun 2025 15:32:35 +0200
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/17] xfs: cleanup the ordered item logic in
 xlog_cil_insert_format_items
Message-ID: <20250610133235.GA28445@lst.de>
References: <20250610051644.2052814-1-hch@lst.de> <cqWn7I8cwwfGuWnf1e0-3it6wZgwjbXDsuuqz5qtz1MSy4hWQDWfQNT8SefFV7CfDrh1OSxj8qotWfFp9SYFtQ==@protonmail.internalid> <20250610051644.2052814-3-hch@lst.de> <txjhmsaiqnyjl46nhz75ukobgnmxwy6ka3wlsb6xvdz5v6bj3t@hpkwwjwk5f5k>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <txjhmsaiqnyjl46nhz75ukobgnmxwy6ka3wlsb6xvdz5v6bj3t@hpkwwjwk5f5k>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 10, 2025 at 09:56:04AM +0200, Carlos Maiolino wrote:
> > -		if (shadow->lv_buf_len == XFS_LOG_VEC_ORDERED)
> > -			ordered = true;
> > +		if (shadow->lv_buf_len == XFS_LOG_VEC_ORDERED) {
> > +			if (!lv) {
> > +				lv = shadow;
> > +				lv->lv_item = lip;
> > +			}
> > +			ASSERT(shadow->lv_size == lv->lv_size);
> 
> 			This assert is kind of confusing me. if we have an
> 			ORDERED vector here, couldn't we still have a shadow
> 			size smaller than the current vector?

The size of ordered items never changes, it's always the same constant
overhead.

