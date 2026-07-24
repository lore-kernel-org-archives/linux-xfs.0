Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A3628541A;
	Fri, 24 Jul 2026 13:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784899272; cv=none; b=Yjfxy0JYH+RNX550awcCoZki0+CgbmWv2oTUfUytTXgfLai05Mycowz4AQnCei57n0Aqly0tlerM7RrELG/mVGu4POeZ9Ya90TlQiVq0GDmu175uEbLTH+uwTFBdJH6MD9jdZetw4m98t7njvAtd48f7xwXeteRCikRi3Xth8MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784899272; c=relaxed/simple;
	bh=uo7KNHGcqjwGPVfMUSgttbKy9t/k4VvK1XU1Gq0U62Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dv898mx61+cLmJSYZyrcqsw6NDEFaizHGE0YFlpHYHH1XfciVz1MOv3jcvZEkLXzsyRmSVCpXXMWkEJo7Zq9DGo0I+UNkEoMRK6E6Gm8cJ1rScriw1eJrnqKPfpUuqYRBVaJpIno4Gb2vOUUWNFs26mV/Qla2BFh2XHyO57XZHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C139868D0D; Fri, 24 Jul 2026 15:21:08 +0200 (CEST)
Date: Fri, 24 Jul 2026 15:21:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: only check mergeability of bnobt records
Message-ID: <20260724132108.GA28170@lst.de>
References: <178487405343.3442778.10258954219942220821.stgit@frogsfrogsfrogs> <178487405399.3442778.7901047937592189648.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178487405399.3442778.7901047937592189648.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jul 23, 2026 at 11:21:16PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In the cntbt (free space by block count) btree, records are not supposed
> to be in startblock order.  Hence the mergeability check is pointless.
> Remove it, since it does nothing, as LOLLM points out.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

