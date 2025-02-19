Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9781525760
	for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2025 05:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739943167; cv=none; b=kBEC/f13HHsYjxI2HmJy90/5uwBzv088Id4inT1FdSfaRDoeIkuCwZK6RczghmZyJO4SG1hTxfXGKq+3XEWDqDlj7zcOrZ9grdVUz5/Pdmy+7KJcvPmLOyjTwv84Zz5JtM4L2u8Y74UlXJhb0f5vH7c93UxN32snDs6bI8lejtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739943167; c=relaxed/simple;
	bh=I66HaKePOgQ52c1hEquPdW98aTKOUb/G8CpDmpZSGvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hjB89RWXqAzjEHBuxVtv+Q9AuUhFc0riukgtj1Td5DY0PlpX2wdbGGRgFOxSUC2CKKjcpt05GO1IT4ZY8gM38Su2e9Vymn7ACDeUYZcxSMTZIBv9a128lVNCJU/L9J0PcmG7myuOXPh0puh0CuQ7ZomXy7/+yNJGm97NoJ8KdNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8D58F67373; Wed, 19 Feb 2025 06:32:41 +0100 (CET)
Date: Wed, 19 Feb 2025 06:32:41 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: decouple buffer readahead from the normal
 buffer read path
Message-ID: <20250219053241.GB10173@lst.de>
References: <20250217093207.3769550-1-hch@lst.de> <20250217093207.3769550-3-hch@lst.de> <20250218201029.GH21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250218201029.GH21808@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Feb 18, 2025 at 12:10:29PM -0800, Darrick J. Wong wrote:
> On Mon, Feb 17, 2025 at 10:31:27AM +0100, Christoph Hellwig wrote:
> > xfs_buf_readahead_map is the only caller of xfs_buf_read_map and thus
> > _xfs_buf_read that is not synchronous.  Split it from xfs_buf_read_map
> > so that the asynchronous path is self-contained and the now purely
> > synchronous xfs_buf_read_map / _xfs_buf_read implementation can be
> > simplified.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Thanks for adding the ASSERT as a guardrail against misuse of
> xfs_buf_read.

I was just going to remove the argument, but that would clash with the
refactoring in the zoned series.  But I plan to send that later.

