Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD85D134419
	for <linux-xfs@vger.kernel.org>; Thu, 21 Mar 2024 21:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711056507; cv=none; b=sGSMXDeqL0rBw0IpRzZKGa3fljuQR85FdkprKUtfnNVYtmHF6G8qJjM9oeIkGdnbrjDOGLAiLQ8Hma71XR8HL5hmKNeA0hSn8gpNtke0i1moQjg6poFPV0IVkgWgnYQSgiOBDzxpo6yM9TmRfbkKSb8pQXE9hUwQZymkecwY5Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711056507; c=relaxed/simple;
	bh=aVoKvcFSvd0AxLF9sOHDGj9sPZ8dRZdsqfK/rK/iH9o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sZcwVV9nx6KF3sU+MvhNcvwL+Tb6AbfdBVjgrhIPdlheivUEBKlOJHMpTYjgyzIzQTgQEZ4vFixAtjoq5TIIg0u+lJAcTceCLhwCosFUQAdX5FD9w61DWO5/4gfEzZWmmd6mH/PSVD3RXkeGMSGMeytsx+FCliQypEyuvIjxMzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aPxwb9Uz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aPxwb9Uz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=W7lBwjChH7tVs60+syJspl3dQE+Jca8PtvvgHetwiLU=; b=aPxwb9UzzsFJPvdKWn1jJ2Jgxr
	61awRIDjX1g4QwB7vBI4FBZVYQuS5yrxyZ3jJgW1+XGzMrndGma37ZMdkg3GWog5NZ95uj2YrU3Xu
	B8JCIJ7QQ7FvEdpfAADgJ1KzYusui1NFE+YoJS/0uHdF97dX7JGLo/yLeQ7yw7V5eHsqHdCtrKEti
	QtKRXQJO2dqmJwkXnfCpEiXraepPGK4jY4w8hWPgEleTpKn+XxtYhB3S2Fg1MxIOtGloG4h3CqeuX
	Nze/4jfkKl4RSbbBQTQ/tNZyR7xxrx4jakWZyib654akvcz/0HIudhiP9NZl+z5CLhcy1mfjj9Hn5
	aRBBOrwg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rnPxX-00000004jVU-1KHL;
	Thu, 21 Mar 2024 21:28:23 +0000
Date: Thu, 21 Mar 2024 14:28:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: convert buffer cache to use high order folios
Message-ID: <ZfymdyLxJ_-GkFji@infradead.org>
References: <20240318224715.3367463-1-david@fromorbit.com>
 <20240318224715.3367463-4-david@fromorbit.com>
 <20240319172909.GP1927156@frogsfrogsfrogs>
 <ZfoEVAxVyPxqzapN@infradead.org>
 <20240319213827.GQ1927156@frogsfrogsfrogs>
 <ZfoGh53HyJuZ_2EG@infradead.org>
 <20240321021236.GA1927156@frogsfrogsfrogs>
 <20240321024005.GB1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240321024005.GB1927156@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Mar 20, 2024 at 07:40:05PM -0700, Darrick J. Wong wrote:
> > Well xfs_verity.c could just zlib/zstd/whatever compress the contents
> > and see if that helps.  We only need a ~2% compression to shrink to a
> > single 4k block, a ~1% reduction for 64k blocks, or a 6% reduction for
> > 1k blocks.
> 
> ...or we just turn off the attr remote header for XFS_ATTR_VERITY merkle
> tree block values and XOR i_ino, merkle_pos, and the fs uuid into the
> first 32 bytes.

That does sound much better than wasting the space or crazy compression
schemes.

