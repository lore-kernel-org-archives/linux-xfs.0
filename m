Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDC332695A;
	Wed, 28 Jan 2026 03:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769571502; cv=none; b=U4bmgmm+o+dlvhDFngbZmio5uQj496KNy1DfbmW8G1Alz3jA4yxZi5Aa9vpfIsC+iKkpaeZ7knfwMqvv5u2py8eX+9nT+O1KEyjnh2n3AvlJQfU4OV2dMFUxGNWD9MMYpmhLeblsTmBO1JgcGwgVbCASipfLmsSZhsaa6m6wZoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769571502; c=relaxed/simple;
	bh=ibOrC1oOHq8cKuDX0T9tDDdb3yupvIjm63YakjnVoF4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IqPNnLwGO2jh4HYhWtQ7e3+s7obbqv91WwyKqncKjX1TTvi1YarINTv2xnD7L0ug3vCOydM08vWYqJQS6sWjatWt4q6Zkz0Psh3E+Ht+73bFUvuD/G+90qoYcoEaB/zX/D9+D+nX9k/Rx2Qtxjb41NPe7Z7CQSyiobA2wIooqyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 52E19227A8E; Wed, 28 Jan 2026 04:38:19 +0100 (CET)
Date: Wed, 28 Jan 2026 04:38:19 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, zlang@kernel.org, hans.holmberg@wdc.com,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] xfs: test zone reset error handling
Message-ID: <20260128033819.GA30962@lst.de>
References: <20260127160906.330682-1-hch@lst.de> <20260128014255.GK5945@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128014255.GK5945@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 27, 2026 at 05:42:55PM -0800, Darrick J. Wong wrote:
> > +# try mounting with error injection still enabled.  This should fail.
> > +_try_scratch_mount && _fail "file system mounted despite zone reset errors"
> 
> Is it necessary to _fail here explicitly?  Or could you just echo that
> string and let the golden output disturbance cause the test to fail?

The echo would work to.  But why would that be prefable?  Is there some
hidden downside to _fail I haven't noticed in all the years?

