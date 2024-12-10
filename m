Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA99A79FD
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 04:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733806743; cv=none; b=NftYt4QVjfNRJ7uTEQWIqlc0oLUkUN+AsTOzmo3OqXxS2GAoANEfq6XMjJFcWMUSWlZ+nI0VAsszqpKHOrZ+ZHshw1iHqKcGYfRk2jazzpwd7cejBYPsjc2D7Iv44vcYM6XEGzptTJE2zYjAxK+q0/BpTv4fsJiHVLK7FBbLSVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733806743; c=relaxed/simple;
	bh=LFFb5MUXb1JNaXhx1U1Fn/qPTqqFb/0E7l4vPpzJ444=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JVLmM0att8XIPXUZTUJkOFNX4CmfFO2lqGXdA60f1HFBkGfVeYy8a9SOhdpkCrQl07XEEO6xOS5lvlEfdk0TnyoCuH2nu4iiuqFq0gttov0R74sxe//r5WCRmX/UNQkhJVNkvDat+nLmb8r9kfqdr9hM8OZYUyLKdjA4O1j7GR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0rrilemb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0rrilemb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Fjjz316tDZzua3e0aDRRsG9zfnPbn8m5qqdtju1LtCU=; b=0rrilembwYWZBoj/k7Qomiq1XY
	KUnGsP2d4W6COPtEMJM5jvaUj1ryLBh+41kmNPa5sytGfqfB72IziNiyV+u952GZaa0bygvep6mwX
	J7sUdg73GoA5NY9ZZzP+OEjYc3V865flmAf/+DUuouWzx+fzgouNpKrkaRBq+bnogrXRtrRcOwtOh
	9U6+/lvTULHDDqcIMKqCF+NYgdXMIlkneKBHOy0OMNX7bf7TUv+Ya6aIc+Dv3MCo94WanMWyL1AWV
	Sp5vBqEJm6xgK70HmIXJgv5rEQgnSt1AldgjqWm6N3pO6zCShFW9angbhYj8PtpkuVupm1c3bIz8j
	cpJIVEXA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsKr-0000000AEnH-20Fk;
	Tue, 10 Dec 2024 04:59:01 +0000
Date: Mon, 9 Dec 2024 20:59:01 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/41] xfs_db: don't obfuscate metadata directories and
 attributes
Message-ID: <Z1fKlUAXhDI8DGg9@infradead.org>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748407.122992.15776756109293532453.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352748407.122992.15776756109293532453.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Dec 06, 2024 at 03:42:30PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Don't obfuscate the directory and attribute names of metadata inodes.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

