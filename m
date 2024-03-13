Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEBB159163
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 22:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710367564; cv=none; b=Kv8BkIJBab/LJFh3S5ADhmmk09h/SkgQ0Eqtnzwl0z7DfIJf5DDqvHa/z4300H2G+2FN6VeM043k8uQQsD7WkgXAc2CoGi/4Yzm4tqbtpWtWWiRWepaJUBnCX/wj6AxkWpp7uJO/LZ0ZVaVVRgOjGXZ37wQg3skUe+vWLSwtlvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710367564; c=relaxed/simple;
	bh=7p0ahBiXRsEc3MYNWTnQ6VSvjQJLIK9CnSJUb+DPUeI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SHdzW0gVcJIiTv5/nD0Vk0wCNqbnJ0iARCpSYkQpwdXkgzp3ZLmeAHkfI4qJWXRuxSB6333z+VLWJWJo0Xpcnz4Orl7J6Pf4Ik+xRcBCCXQikfF7DFyhrIUI0OqCb74rqR+/P9xM5bWI4xpb1oGgLSNBX83pOYVcydnLm55ynw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=W061gdtA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="W061gdtA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Q5iSVyUVrDsI+tjo6aDDawYUJBZC7a6oavg3nJrIMnk=; b=W061gdtAgfKz8vmZ7gBPE3vWGP
	EcAFu9/JNX+Tf8HT+Ayn2M13V9E9tv8nmRkiyh8++eAdI7mCk+uWGf8tX3RUshBrvOsYxwlHNZlCW
	Dd6oYNuNoIZY+jqvzJrBf9mbVlVW5Zm4rmEWidAoCNU4ftuoIqLbEgHc+z41uOeplcOKPxZwzrKkG
	argK+YMgX0uCg5JFmM3Y0+CkYlNPWWsAD8JwcSq0i8WRM8HK6Z09kcb/EIgCmHDGTLy3LBTWm+Bfn
	Xfn1Crt4YZ/TEOftNg6TJp2ofK/ujGQk7oS+ygFFNpH5bKKOwF0Q7dKlP8U18iRgTtAMUqd08+bkk
	6Ax+bWcQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkWja-0000000C4Ph-2HOW;
	Wed, 13 Mar 2024 22:06:02 +0000
Date: Wed, 13 Mar 2024 15:06:02 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET V2 05/10] xfsprogs: fix log sector size detection
Message-ID: <ZfIjSigEX1ZfM1MF@infradead.org>
References: <20240313014127.GJ1927156@frogsfrogsfrogs>
 <171029433208.2063634.9779947272100308270.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029433208.2063634.9779947272100308270.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Oh,

I just rebased and retested this as well.  Either version is probably
fine.

