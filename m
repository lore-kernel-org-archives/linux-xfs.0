Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444CB14F125
	for <linux-xfs@vger.kernel.org>; Thu, 16 Oct 2025 04:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760588567; cv=none; b=PfCme183zNaOtfg4nB7F5Y3WLlNPJ43xIQXKYUVHu9xQySP0oxKnAtE13o0WndN1Kxfbx/1W/zPjELsmcqEIgL7y6/z6fJVZsDDpu9RB9TViqqX7lJjD8aR0vdnlF9zGhlIjU4SxLgKsPSllEKDwbn4B+/2kAnqP6bZvgYyG7eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760588567; c=relaxed/simple;
	bh=0GHn+PNBARQlR4qSfpPvdWTzWXcO6K2xKoB49GfXMCw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ituaaJQbCioqpbzqXdBLGLtpz9tKZFqmE0XKw31BVYSQoQx8HRUH4V2SMLNsIn00OU4hEYWbSUXt2AAPOGjNnSVTQNTwJKA4jJFFiMSwequ5M80yQb0vrjKy/osLjn0EqysgJJg6ahHc5YmfO+5i/jIZQvoh77y4jExFt4KtgG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 89199227A87; Thu, 16 Oct 2025 06:22:41 +0200 (CEST)
Date: Thu, 16 Oct 2025 06:22:41 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/17] xfs: move q_qlock acquisition into
 xqcheck_commit_dquot
Message-ID: <20251016042241.GB29822@lst.de>
References: <20251013024851.4110053-1-hch@lst.de> <20251013024851.4110053-16-hch@lst.de> <20251015212032.GK2591640@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015212032.GK2591640@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 15, 2025 at 02:20:32PM -0700, Darrick J. Wong wrote:
> On Mon, Oct 13, 2025 at 11:48:16AM +0900, Christoph Hellwig wrote:
> > This removes a pointless roundtrip because xqcheck_commit_dquot has to
> > drop the lock for allocating a transaction right now.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Ohhhh this looks so much better!
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

This gets a bit updated based on moving more changes into it from
the earlier patch, so I won't add the reviewed-by to the new version
for now.

