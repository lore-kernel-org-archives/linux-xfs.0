Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456981C0DE5
	for <linux-xfs@vger.kernel.org>; Sat, 30 Mar 2024 05:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711777130; cv=none; b=ER3OHtpTw9R6/iB8olCjwWhiwSdAPBy7epcjY9ursXsKHwtxuPFCPodu2Sr2kWahwaK14GvdaHkphs9BehEQI0vkBPePzMQBA5pbvRh0Ty5I8AQYbWr5JCAZEQsVbMrUwFwdwIOrutgJ9rba5OV+owR54v1nrCJS5HlmLD87RWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711777130; c=relaxed/simple;
	bh=jgAaLEciajX915p5vo1p69cBk+sueUuFUExXzpHpJzU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n8H6Gp+g36cwet3az5nH2q7VoXm3RkWazh7kaJM41PjVpKVbecZPVO7R+EVBfIJa7xn/STvIvtpVZqEOpct4GiGTYbdBWjI7gtHjlwkpfUi+dqL0PdNpgKyvRgNigmLOlHnD+LrEI2RyHSNbnj/UvEFXQdIkhQEYQTxdk4aHzGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yojFm5Il; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yojFm5Il"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yAy7GIIY7PyxgTjUD9V946dMxKuo1QHMQWNZEsrMOmE=; b=yojFm5IlmNvJJ0XooW/NpdyPiX
	E1Opix4V44PPzJzMYJXZz7iUE/T92SgNLdbCFwYO4JH7JfaEEWkIgFFB82F0Sr2GH2junnnCfb4sP
	t3G4CuKQjfeZrCF7JPPawJ1MZltxd7g7CJRsHhXbx/mij0DUznnYvCOtszHPV5EPjQgOXEvULxZgY
	2CWVHFG6NVLT31XbwRwsoMcOcmnzsNxERhveZdJvPuF+s/SbDWxiK2qvRkn5Fgw7/38WfdtWihwzL
	JOeosteMy6VHQtrTM+xisfpPWyLJeVaHa7F3+5y4ixdgicOy0IZJePscxANPZXWtyhTatIaHNlXYz
	4RQOSWyw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rqRQV-00000002qiz-0GUH;
	Sat, 30 Mar 2024 05:38:47 +0000
Date: Fri, 29 Mar 2024 22:38:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: fix severe performance problems when fstrimming
 a subset of an AG
Message-ID: <ZgelZ-O0ZWrci5Y8@infradead.org>
References: <171150385517.3220448.15319110826705438395.stgit@frogsfrogsfrogs>
 <171150385535.3220448.4852463781154330350.stgit@frogsfrogsfrogs>
 <ZgQEcLACdVZSxJ1_@infradead.org>
 <20240329213520.GQ6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240329213520.GQ6390@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Mar 29, 2024 at 02:35:20PM -0700, Darrick J. Wong wrote:
> Welll... you could argue that if the underlying "thin provisioning" is
> actually just an xfs file, that punching tons of tiny holes in that file
> could increase the height of the bmbt.  In that case, you'd want to
> reduce the chances of the punch failing with ENOSPC by punching out
> larger ranges to free up more blocks.

That is a somewhat reaonable line of thougt.  But is an underprovisioned
device near ENOSPC really the target here vs an SSD?  Either way,
if we have good reasons for by-cnt except for it being a little simpler
I can live with keeping it.  In doubt I just prefer to have simple code
and one implementation instead of two.

