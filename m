Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8484B195
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 22:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733955152; cv=none; b=PGzOCSGN2ZQOPLaH6uIejgxux1ikmzc2wmA3PUhkyBlMHQ0QxlBqFFKNFJYyVb2JZZL8WazvKSgppa+2wvMrTiv7qWTNS6bRUNVO7FQwwQ3brG0weyrNDre5MMfALH9gu9kwFxFzQKXeZi0Yc1fGPsHC/ti7FiZn7AisJcKVmms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733955152; c=relaxed/simple;
	bh=xXku8MGfLxGTyCnx0pRyuWN+UgbKw6apWAMvkF2Y1ew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FYv9sPNgkZuxxnyhzbv/m3Xf4u94sbhnpMqAAe53TztuivNTDDOm+0zVhKRcai0wCM7Cc0yFU/ORqZo/ZkUqi1m3SGxvNFckNBNzDVJwt+FmvOXfjAxtAOG6Yyh5FXLF851826R5dJyNApLaW7IlZ0Kh2xiiCePJwPZeyDTVer4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OXUck4VD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OXUck4VD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BDE2C4CED2;
	Wed, 11 Dec 2024 22:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733955151;
	bh=xXku8MGfLxGTyCnx0pRyuWN+UgbKw6apWAMvkF2Y1ew=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OXUck4VDYjGWidgk57+rMD9h+2JExcce9ja/qX76Ypqd3oH1jDwU3TWzCQ3WcRpA0
	 2ah0+SOsdkiNbL5zhfusYqck3pxdDfJMjKAQZ2OgVnphuDmYvCee10tn7JMrCNbKjq
	 8wj2yGLcfI8g8g0RZnx0WF+r58VhxqkawuXnRTp5j6T3EOj8V8L1Kp0YSf0PlR5YOZ
	 75YlC6L1iK8WL6s7/1lOgx+TND3rBelgGKELzK7i70BnF27pt5Na1Ao4Yka2rjCoMZ
	 JIuCqpjenVnAseONXqH7lRb9GzEUTnv9S3MCY9hLFdmIECycD9059Nn9BbcA8sp8+R
	 +k9vMAq40tcgw==
Date: Wed, 11 Dec 2024 14:12:30 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 42/50] xfs_io: display rt group in verbose fsmap output
Message-ID: <20241211221230.GY6678@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752587.126362.15499339908546372305.stgit@frogsfrogsfrogs>
 <Z1fY8Bir7RXwTMOB@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1fY8Bir7RXwTMOB@infradead.org>

On Mon, Dec 09, 2024 at 10:00:16PM -0800, Christoph Hellwig wrote:
> > +		} else if (p->fmr_device == xfs_rt_dev && fsgeo->rgcount > 0) {
> > +			agno = p->fmr_physical / bperrtg;
> > +			agoff = p->fmr_physical - (agno * bperrtg);
> 
> This second calculation seems awfully complicated vs the simple:
> 
> 			agoff = p->fmr_physical % bperrtg;
> 
> Any reason for that except for copy and pasting the AG version?
> 
> > +		} else if (p->fmr_device == xfs_rt_dev && fsgeo->rgcount > 0) {
> > +			agno = p->fmr_physical / bperrtg;
> > +			agoff = p->fmr_physical - (agno * bperrtg);
> 
> Also a little annoying that all this is duplicated, but that also seems
> to be based off the AG version.

No particular reason outside of copy pasta.

> So while this could all look a little nicer, the changes themselves
> looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
