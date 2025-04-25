Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734E6258CF4
	for <linux-xfs@vger.kernel.org>; Fri, 25 Apr 2025 14:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745592702; cv=none; b=oR+ji1b2ZiJ5iKc8ZRik28sF2QHrY9Zifc7jvgcOiBnbfdn6HJtH8Sc+WJGpqaZMMl7fcN7iNNYtjgmJI8ZPoEgIdNkQKpNzTgbBG+hGtw4yANHrBeCDZmIaJCASZRHXQwcXJREbuONbmUY3FwMfRMyjAueOIpLuYmea0199Xas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745592702; c=relaxed/simple;
	bh=G0paqg2pzuamSxqFgPRoXWv3qLzDJJwmJJy4qdYXMD0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NbZlu57QnnkQN0vKUxQ3ob6FjrliqTjcw7Ci5RRSRBPPVVr44iYv1moyWWmZmjd5OMO8tNnZ5adyGuRRrlri56rbNMpMIg/eaIYIE3tl3EuniyWbZRX1/NNfhQuZjMv65HXehSuLoVWpkpmOrH49wcGUc9DHI34V4LeXkYWtUJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OLzIqnTU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OLzIqnTU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6bR4JZ7rIXoRJat9z45lXJ41aQSXz7U5lsA0gElzoRY=; b=OLzIqnTU41VY1WJLoDIty2VdII
	mfvEtztzwKJ31dDkijifj0+izwjPUOE6DCg0IhYe0hQ8qXEwS7clc7T1mxlghfBsGk94tfOJae6hS
	6DSop4oDF380hSh1cWTIhskcmvN62Tk4zaJT5BNMzp8VwMNfG+Y6XzEdclXv/7bo+dWE2+9WX5oBR
	EHF0UWcL4fZE4zfxVwnZf1poSGlcoFA1+mTFIAtODWylkOhQpKxi7jE5Nl9KJgJfWTtO5qF2H08El
	3F2glbV++auuGuDclcWPcbpWer5CeQvEO8c3cIzm9B25/OyaNXEomWYp4L/jSeR2Vi6/f3+t4bas0
	vU5g0i/Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u8KOx-0000000HUWk-3rqr;
	Fri, 25 Apr 2025 14:51:39 +0000
Date: Fri, 25 Apr 2025 07:51:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, aalbersh@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs_io: redefine what statx -m all does
Message-ID: <aAuhexEdp5BD3cQ5@infradead.org>
References: <174553149300.1175632.8668620970430396494.stgit@frogsfrogsfrogs>
 <174553149374.1175632.14342104810810203344.stgit@frogsfrogsfrogs>
 <aAuKGV6N1RSnbVoq@infradead.org>
 <20250425145001.GP25700@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250425145001.GP25700@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Apr 25, 2025 at 07:50:01AM -0700, Darrick J. Wong wrote:
> On Fri, Apr 25, 2025 at 06:11:53AM -0700, Christoph Hellwig wrote:
> > On Thu, Apr 24, 2025 at 02:53:23PM -0700, Darrick J. Wong wrote:
> > > +The default is to set STATX_BASIC_STATS and STATX_BTIME.
> > 
> > The default without this options is to set STATX_BASIC_STATS and STATX_BTIME.
> 
> How about:
> "If no -m arguments are specified, the default is to set
> STATX_BASIC_STATS and STATX_BTIME."

Fine with me.

