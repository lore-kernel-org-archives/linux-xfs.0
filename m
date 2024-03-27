Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6F314D285
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 16:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711558597; cv=none; b=Q4S48gUP+gHyB5y8b0Rdvbl2qPPJ+zuAaP5t/mwCXuf4L7c7JAvtkDVxPmEbkc/GqtEld4OhftlHs6UOGbbnwXK4J1SeK8VYSlS2+SYj2GB569//mtIvti0x/h8HIFkFBX1VvpjAq9EXdmy9suknMJpcG3ekxxr57gf4GsY1zRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711558597; c=relaxed/simple;
	bh=FKfLXEcGlf9DaO13cGrjXG/QenuofwB/22NX+vOOjVA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NjAqEJ/YJaYRHhKDRPg8HaE3tnoQWw6Vh0pz72Rss2zzM0ykPgHEh/u96myJiWoR3hU8rMlwrNncM17rchMLeIGKBYPzLP7Bx1UgUYjVAKkCDmvhQLV2TRUQVwJhFAgivFD40YRTz8LAsLU71cDMT2Sff9Q8dYocpEkEPqP+sBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WiLZjkLf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WiLZjkLf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=w4EIhUGpwrYB+Y29obnGmeUDGiQoS1bwTRMMH68RWic=; b=WiLZjkLfCddtdQdp0fYkg3tYwo
	KlmR2cwa4df3sZw3Lx2/FOmYhfq78dCAC8sevcoUKNTfkZkARs12UfBA69/UY3w9FV1087DI0VJvG
	VOs1MFUKmzBWlL6gyBpmibWnKa9fH/oKZCylkaigkePpsG+GAbF/X1iKT8B4KkX4SVKj5X7pmKyCX
	q90tG18YPgmIav1M12lI6TzAjOFYSF1lDjPX5jj+2IWGSZv7qSPgqjN+rG2qk98SwEQwCPbGlyEAL
	VgJbYAhXb27KpYk1nEusYYgnpqrpvSK9Dx37b1QP5xBh+eN3wByJZDAX61ikF7J4yQI0EhgEgr4M/
	g5WGrPTA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpWZn-0000000AAZe-3wg1;
	Wed, 27 Mar 2024 16:56:35 +0000
Date: Wed, 27 Mar 2024 09:56:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: fix potential AGI <-> ILOCK ABBA deadlock in
 xrep_dinode_findmode_walk_directory
Message-ID: <ZgRPw7o8-OcjN6ft@infradead.org>
References: <171150379369.3216268.2525451022899750269.stgit@frogsfrogsfrogs>
 <171150379387.3216268.6890967813601957901.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171150379387.3216268.6890967813601957901.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> Thread 20558 holds an AGI buffer and is trying to grab the ILOCK of the
> root directory.  Thread 20559 holds the root directory ILOCK and is
> trying to grab the AGI of an inode that is one of the root directory's
> children.  The AGI held by 20558 is the same buffer that 20559 is trying
> to acquire.  In other words, this is an ABBA deadlock.
> 
> In general, the lock order is ILOCK and then AGI -- rename does this
> while preparing for an operation involving whiteouts or renaming files
> out of existence; and unlink does this when moving an inode to the
> unlinked list.  The only place where we do it in the opposite order is
> on the child during an icreate, but at that point the child is marked
> INEW and is not visible to other threads.
> 
> Work around this deadlock by replacing the blocking ilock attempt with a
> nonblocking loop that aborts after 30 seconds.  Relax for a jiffy after
> a failed lock attempt.

Trylock and wait schemes are sketchy as hell.  Why do we need to hold
the AGI lock when walking the directory?

