Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA7B1C173C
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 21:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733952832; cv=none; b=RIaKBOJhfCavFGOYrboiEgc8Aatya0fXdVe4HcFXF3c/9M4PZfaYhPWK2RRBqfGJkJa4oSFUYpDhE2dvDTI+0KhKGJk1CNt7TJywwSug0YN7BFcD5ytUBGmyWcsv7MR3Gs+KVHhubfqar++f9pGxa6xc9wGzh/9O0NHsxuGkKvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733952832; c=relaxed/simple;
	bh=+yEcczCD2Xj1gJUqDBiEovvUKllNamm0YLZuNUhladM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U2GlNWWo/83uvuRO+jvZzYTbG1X99gzWbJVagwg91drIZmRxGc4G44zmaQ3mwAMVEJPd2IefvRg60rxcg1cxtmh/rDHPeV4fVYL7FO0e0X/58z5hz9Ae0K14nwTyTWBOKW23tcPz1gwCDVYjVf/RSXn6JDCcq3PFiTinMVxOsNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PJvKsvFZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PJvKsvFZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF55C4CED2;
	Wed, 11 Dec 2024 21:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733952832;
	bh=+yEcczCD2Xj1gJUqDBiEovvUKllNamm0YLZuNUhladM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PJvKsvFZDfDUjG+++ErgEMrn9WX10RMbzK4eb35acce0dLamH6CAXVcs9pCntEr3q
	 Cig2y0bEBBWz7PNQS3g24XQJloeEaZmosSpRukHxM79FfmZDpZuIT3L03OvbmcH3if
	 tbRC7PVe/xXUxuKnaeb+AoZMBE32ye4ZQtfvOmwpQsXy1ogL4OfqjyhnHPfWwT1Hgp
	 1WsV3AcSqc5xCW5+M5fBkZsHCTu2w7Kd7NTrlHiHNGIrztKNiI2SLdTmaH2/iVDchL
	 zwS5yexd86gXAtaH+ioIAYwi85eF0ZRHCYLCLp1HikRc7ATs2c/bBzEbx596PpvuPb
	 ao+G1inboLbfQ==
Date: Wed, 11 Dec 2024 13:33:51 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 26/50] xfs_db: fix rtconvert to handle segmented rtblocks
Message-ID: <20241211213351.GT6678@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752342.126362.7151084225885980106.stgit@frogsfrogsfrogs>
 <Z1fUJ3mpFOizl5vK@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1fUJ3mpFOizl5vK@infradead.org>

On Mon, Dec 09, 2024 at 09:39:51PM -0800, Christoph Hellwig wrote:
> s/fix/enable/

Also changed.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
