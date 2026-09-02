Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3500377A9F;
	Wed,  2 Sep 2026 07:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788333826; cv=none; b=RK1ckvtl0joKePCB9XmPCtBK1kANlEO3uCeKEFdl5vMq8//bYN9oKp2BKIZ8B6/7XjOAVrXAFKXKVaz0bwrbNnkqLPa5dKAYBRYEvj2wMzERMQzDTfBcq1QGz4giZi5HS+iKbH+GWH9fBzLELq6pTDHGMXFJsre4uhSSY0mg6Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788333826; c=relaxed/simple;
	bh=U012WLytBz4hBF5Cy1v0GvN936vlab5nHwXsni8Nd18=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=seNqDenZeFRAiHXB6p8Pb+nZ8kgPy9effsMU0dGls95u+k27mfo/A2SmXCYxvYK6IJ3h1NMIWCJGi559FuPnu2jMzU6A73qvAdPRfssxgc+S1+Gwd7+U4KbxPuACIxwinLDS56U10LxK+UnahHhrkxkzwkcx+pxiN4U3FwX52Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A243468B05; Wed,  2 Sep 2026 09:23:41 +0200 (CEST)
Date: Wed, 2 Sep 2026 09:23:41 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: compute dquot checksum after resetting dd_lsn
 in repair
Message-ID: <20260902072341.GC26173@lst.de>
References: <178832750681.3508131.6009513367948627110.stgit@frogsfrogsfrogs> <178832750773.3508131.8667220003399042973.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178832750773.3508131.8667220003399042973.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Sep 01, 2026 at 10:49:16PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM complains that xrep_quota_block updates dd_lsn after calculating
> the crc of the ondisk dquot.  That's clearly broken, so fix that.

Yeah:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Also why do we set the lsn to 0, shouldn't that contain a valid value
(probably the current LSN, but I'd have to look deeper at what this
does in detail)

