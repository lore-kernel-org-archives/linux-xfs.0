Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807BD3C585B
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 10:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782989723; cv=none; b=oyFHKBpyv5OqK82UzJW4eAoYabQp4fDiJz3sYAUYc389LtH54ivkL7oTXIweaqNor2d43aLCtcVAOWpnncR/xV+M+fVurCB54mJcIWXwnrDvr9lUvM0bprTQlVn02yophJvL3ymGH5APh//hKuyrjeeeEP5IpCr8uft+1huj4xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782989723; c=relaxed/simple;
	bh=KlDamcuCbx1UUKZ0bMk/HgJ2SP3yT3BYKlYA4bK8pD8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C7pmKg0QHY/z0Pbcb8ZboNMtT+tyB+hnlOqi1jzZMFjAUN0dFW97tE6HaWJDctt903iq1G0qo8kweFEjuALN0g80lAD64ip8Y+DY2KOmFl8govQNuVtFwzPc9AtP1z5k0sd/UaFa7Z9RnFeDAnkP1+3GhfnartPV2nZ1uBTvyHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=b0lv0VKk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="b0lv0VKk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=j++dNdsabe6Y2uy01YShmCRj/YXHscS61+1I7WTnMLs=; b=b0lv0VKkaiY73eJNBJJBmDncDo
	A13YAifHjO08FghF6XXW5sPWb+SEMBHeqvIGl6PykHnfUB25KlKR5QtO04gonJ7YBIcU5/6OYJ7jb
	de0oewjKJrOd//wyVVAujAmgTBeLJkelV2BANw9kjAVcBLUr8cAGuBXd6DUoHIDAszaEKz9v7hLpA
	lsW4QmMYP5Aamvub7C57XizF4XoBikjbPQaUgSF+eZcFjXfrT9FvCZKSnMu1fkdSkEs0+uOKTcc6P
	mLjITgdStr8TSSX8c1shNVpU9g91AULhKLObwFcEGzqfNsJr3eR+8yT4eBqhwvsf72oHkA5exD2I4
	pz2996Nw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wfF4i-00000004Ejj-48fI;
	Thu, 02 Jul 2026 10:55:20 +0000
Date: Thu, 2 Jul 2026 03:55:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Weiming Shi <bestswngs@gmail.com>, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>, Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@infradead.org>, Xiang Mei <xmei5@asu.edu>
Subject: Re: [PATCH v2 2/3] xfs: splice unsorted log items back to the
 transaction after the loop
Message-ID: <akZDmPT_n7g3NGZY@infradead.org>
References: <20260701153833.3155514-2-bestswngs@gmail.com>
 <20260701153833.3155514-4-bestswngs@gmail.com>
 <20260701214354.GH6526@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701214354.GH6526@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jul 01, 2026 at 02:43:54PM -0700, Darrick J. Wong wrote:
> > +	/*
> > +	 * Return the remaining items back to the transaction item list so they
> > +	 * can be freed in caller.  This should only happen when we encountered
> 
> s/encountered/encounter/
> 
> (same verb tense across a sentence)

That might have been my fault :)

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

