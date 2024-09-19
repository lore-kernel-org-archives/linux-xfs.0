Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADCD1537C8
	for <linux-xfs@vger.kernel.org>; Thu, 19 Sep 2024 07:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726731997; cv=none; b=V2pBvHqEWEng5vrPViejaA/0qagxKJd26L9Vfx+KtuDfHPz6J2wAzO0VXMaiagRAxVgsGT7E4x9TOpRFedMC3s989+BLuAGLixhKHfBF6R2no2OvuGHDEYKRBmwbXo/25U2cQ1gkxfIVWFujUVONyRaQzkGN8M+i9/iBwd8eAfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726731997; c=relaxed/simple;
	bh=5CROLap4pNdYuhXHLb7WQMNYOtAuiZVGrByg8YCHm+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cn1JQOF+lIZfx5H6OiZ8gOwGYP3wam8j59Zei7pHISQ2h+AAz/qR23PANtvrA5I4PqdvBrkBI+ZCEdBIceR2M6xLxY5Duit06rbRowt084yOFvBCCJAAa2oeasI65cEjJnoLogNrJqbK/IXUzboqIUToEj8ThW5LjBCRlWaiP+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 43DC7227AA8; Thu, 19 Sep 2024 09:46:31 +0200 (CEST)
Date: Thu, 19 Sep 2024 09:46:31 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: create perag structures as soon as possible
 during log recovery
Message-ID: <20240919074631.GA23841@lst.de>
References: <20240910042855.3480387-1-hch@lst.de> <20240910042855.3480387-4-hch@lst.de> <ZueJusTG7CJ4jcp5@dread.disaster.area> <20240918061105.GA31947@lst.de> <Zut51Ftv/46Oj386@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zut51Ftv/46Oj386@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Sep 19, 2024 at 11:09:40AM +1000, Dave Chinner wrote:
> Ideally, we should not be using the new AGs until *after* the growfs
> transaction has hit stable storage (i.e. the journal has fully
> commmitted the growfs transaction), not just committed to the CIL.

Yes.  A crude version of that - freeze/unfreeze before setting the
AG live was my other initial idea, but Darrick wasn't exactly
excited about that..

> The second step is preventing allocations that are running from
> seeing the mp->m_sb.sb_agcount update until after the transaction is
> stable.

Or just not seeing the pag as active by not setting the initial
active reference until after the transaction is stable.  Given
all the issues outlined by you about sb locking that might be the
easier approach.

