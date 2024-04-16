Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27CC12BE9F
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 16:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713284951; cv=none; b=p1CrBDtzKLQyDZ8/TMojrKgh3ob6B89lKg1gYDD6D3378PFcGb88c6Z/mdAfBm1lrAPvn4H8dTg5FqJquw+bw4EXtb06ayzKP/fhgYCcmqLEoWFYegyUM8gZvEhhYO2+dkQLwqYqMSX+EorR6hHyQ/lGltMlrJUMVwZQ+p15vkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713284951; c=relaxed/simple;
	bh=cTAmUyuyb1tOuTNCdErIa6LGoIyUr8PYWPBJjdqBlQA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=quN87/r+RvwxekfAa6NEDj1Z3KvZmQXDpTNTS94+/h30yXz5pYyl04StDsmssGOBYHs99ks225noQ9155GdjdWQKCj9kqDDsVsw1hIglpxUEWFPe8TotpIIdZ9n5PjgVOSj2KRP3XKX5EqQhXI/wIrw7vorNW+CpWTN6t5n/LLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=j5OWcasj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="j5OWcasj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Jg4MJeMnHFDCY2NmKKRagfHeiCA/S816FI2mRoTy29o=; b=j5OWcasjVr6eDsq6KdGA4tuZMx
	l3vLL9o0/rXsEkC841scVEqZFg6KSrChXndh3clRaK0LrTWfM30wJvZ0h5dovawjBlxf51JuSKAqB
	7dC5G3lDZBwST2MhEX3qZOAh/XKWdQFYFVuC2twOWoT2Lw+NqmOwT2/s1+HgE3qcfn2su5QVUBq+G
	xYnB4LOs330kflPCQGK17cpCwhkDICuPYLcsJAlHwRjTNKg1Jye3EopaEfG5mKS2ROh6F1eAEKq/n
	e9Bg068JSlget1DIjqFBaPFlpJjN7HzhosXk2mI8WQZk/VGSn+VYo3dOuPuXjvMBIfsTx+cg8NOHC
	iPw6eoHg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwlgD-0000000D1Cm-0dvc;
	Tue, 16 Apr 2024 16:29:09 +0000
Date: Tue, 16 Apr 2024 09:29:09 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	cmaiolino@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 090/111] libxfs: partition memfd files to avoid using too
 many fds
Message-ID: <Zh6nVRlJXXN87tho@infradead.org>
References: <171322882240.211103.3776766269442402814.stgit@frogsfrogsfrogs>
 <171322883514.211103.15800307559901643828.stgit@frogsfrogsfrogs>
 <Zh4EpDiu1Egt-4ii@infradead.org>
 <20240416154932.GH11948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416154932.GH11948@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 16, 2024 at 08:49:32AM -0700, Darrick J. Wong wrote:
> > Not a fan of this, but I guess there is a real need somewhere because
> > we run out of the number of open fds otherwise?
> 
> Yes, we can hit the open fd limit...
> 
> >                                                  Given that repair
> > generally runs as root wouldn't it make more sense to just raise the
> > limit?
> 
> ...and we /did/ raise the limit to whatever RLIMIT_NOFILE says is the
> maximum, but sysadmins could have lowered sysctl_nr_open on us, so we
> still ought to partition to try to avoid ENFILE on those environments.
> 
> (Granted the /proc/sys/fs/nr_open default is a million, and if you
> actually have more than 500,000 AGs then either wowee you are rich!! or
> clod-init exploded the fs and you get what you deserve :P)

Whar is clod-init?  And where did you see this happen?  

