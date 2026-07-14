Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6822D0C8F;
	Tue, 14 Jul 2026 06:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784009761; cv=none; b=qDe7YvXSq6yb5QaV2dT1x+WAIfsNPlEu+uzCweNVXuibyFUdhiMefMf9NcLmba8TuTtLGiK697SWz4KRIC+nYZ7+ceXFOsgrKbRL5j2s0ICeI9I3zmxqpwqlpsQqaRBWGNhOCJMqfMW6Z+uTNSjlslgi5I5oy+0U5dw27zpVNWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784009761; c=relaxed/simple;
	bh=M2cNH16uUh9HtD5dieFKwb+UKFkbxRqiVAQh8H9KX+8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TL2hLbcurPxwnrjAR3HCK9/5acW9ae8eZWwIqySKGQqhox/3y9BjVdyjt5L1YdD9fLxkfM54bkAH4059zCRFH+tW33l+2AL7sO1DkFLyj8ZhbPhW0YpfarTVdNghIcFIiKscx929MoFYTZ3g+v/wJ/kxMTKqsF84Z28zn2rH+hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E479468BFE; Tue, 14 Jul 2026 08:15:57 +0200 (CEST)
Date: Tue, 14 Jul 2026 08:15:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: clamp timestamp nanoseconds correctly
Message-ID: <20260714061557.GF1072@lst.de>
References: <178400716782.268162.4846177784022689546.stgit@frogsfrogsfrogs> <178400716925.268162.444784889317482361.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178400716925.268162.444784889317482361.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jul 13, 2026 at 11:07:15PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed an off-by-one error in the nsec clamping; fix that so that
> we never have tv_nsec == 1e9.

Hah..  

>  {
> -	ts->tv_nsec = clamp_t(long, ts->tv_nsec, 0, NSEC_PER_SEC);
> +	ts->tv_nsec = clamp_t(long, ts->tv_nsec, 0, NSEC_PER_SEC - 1);
>  	*ts = timestamp_truncate(*ts, VFS_I(ip));

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

But I'd really expect this would be handled by core timing/timestamp
helpers.
>
