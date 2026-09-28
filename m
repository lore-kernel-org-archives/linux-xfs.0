Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EDAB3AB279
	for <linux-xfs@vger.kernel.org>; Mon, 28 Sep 2026 05:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790574264; cv=none; b=pP5vqslqxgyCnie/opcADOFbBb+/ydgO2OmX/rSzWgJudobszD00MJENwqQ4zPxPs+bpnXxeRuFXyaCSNfjG3czksfh2cX+enFjji4KPzNqtMPOAd5uUpTdriAy9UQbkIKoskS4RBC0eEQG0bVxZ2GE8ywjpLyKi/VXtEBpt5FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790574264; c=relaxed/simple;
	bh=ZeSIKYmYNA7X0LJismKJqfYY1ffRz+WwjW9ET/2t3sE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HRVJYLfeDfGVzXfAGKfYXQl1lK1K0z1thsB5jf1RapMgausgGPOBExJGAS0fbmMIt372RB/ih5pwW6y9ko5uOZRpzoIuOrLOmolj73nNXKbJSf6LRTW5XvQL/k2Ja9iw5h2Nd43fDZwu8Bs317sj0c+cqm4eFf4ZB5CzIbyGYPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Z8eP22Q4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Z8eP22Q4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4X2wtSJn2o5W4vyclWjFUZa87z8v0iLsGvwrUtztPRs=; b=Z8eP22Q4x4vEsagcKLhRuoAtwr
	zZSmDC5fTiL74zr5gOYYF8mEgR2rJvmD4jt925rjjelVsZIdhTO8zoa7GM0gSxlwreTNl3GkIHqjx
	ZHYLWIRIzonOFjkLia5dzR52/Bvd0Mb8xgQyQJlyPitcaK0MycmFsG+b8+FnAMbINxSfQk5TzJwj3
	tgfxshQrBlojGCXAtew8QYKurHPzEGJz0WTjHRkFiYseVphlZHXA8QXaD4NwWhDEDTgPkANKepjk0
	38BuHCLVdtpRAii0xlTiqHSIEoDEF2h8tRNRbRi4xpFS/r7gsS0jQWwNOXqKIOeU7hkuwFenoBe0S
	SMM6BmHg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xB49y-0000000HOCs-2ew7;
	Mon, 28 Sep 2026 05:44:18 +0000
Date: Sun, 27 Sep 2026 22:44:18 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Theodore Tso <tytso@mit.edu>
Cc: linux-xfs@vger.kernel.org
Subject: Re: running "make clean" in xfsprogs doesn't wipe mkfs/*.o files
Message-ID: <arn-smyk5m2gCkYT@infradead.org>
References: <arnTiMxkxgR7oRYb@mit.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arnTiMxkxgR7oRYb@mit.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

I don't have an answer either, and haven't seen this one in particular,
but the xfsprogs build system is special at best or broken if you want
to be frank.  A while ago I started on a ninja + meson port as that
seems to be build system of choice for many low-level tools.  I didn't
really have time to do more than a minimal demo, buf if someone wants
to move to a less broken build system I'd be 100% supportive.

