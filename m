Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46AC323EA87;
	Thu, 19 Feb 2026 06:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771483336; cv=none; b=MRiyTo/QxAt9IKvKT9Ug/OBg1idn4aQItywvR6G0LkcFt8KpIqtY3LccxQzT6/Lw10/RfXg4t09Q0lApsSQxOhjPHtRCjf9Pe0JNHn4SjgcZWuQtjA5QGlzR9CangqKFmG4b63IzMI+j6UNUEAD0l7wiLO2jtG4j3hY15vHHYKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771483336; c=relaxed/simple;
	bh=wqV64pKVJBsnLZr6sSNRl45vRIDIASqMB0d2Wm7yOvY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DVOTmF+hIvJGmtYP4D5tjJIH71gjJSwNdzSmQ/jtgJuJEe7s6uNsTS0bXeDv662C+j3d2+98yrqXIcE1WqYCOso47tSoaMTg/rUJdM/TFlpAF7FlVPha+h+JQe7HC7BLIR3ALVr50IuoVyl8qRWs978X054aPXpbG78lfZ41H48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3GZjS264; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3GZjS264"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tNEyZbhtjMGOQlCquDyDe1KKIEC0Fae5kKcwjq2xFQ8=; b=3GZjS264ua1wURKRsSkR/1ApA6
	6gY41Ruf9VKxof9DSwmLnGZH1Iap92ASuapIYsI5I8J4o9c97hCnzVw8pvASAVEEvSmh2haobkeq2
	0pYv9jOoF584YNKJLNGdxgbchI+Vkp85rryT1jLiqh0llDPVoY9/z/xA5VFWzITqzp20DYYyD0Z39
	1yX6ARmQlNmoLiQLHejH27+zHXq5MNW8wZrGwz24Md1ySA8VdXWEsIHB06+YYatb4mRkyu7++X2Tl
	rTn7i/MwpYkbkWhsy1lYguA7xMY8xsemWVtMBd/E7Nx/ySTv65qVzXr4RRp+T9FPSRHmJihNWwt0x
	1Wm07cpQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsxjq-0000000Ayqy-3Y5X;
	Thu, 19 Feb 2026 06:42:14 +0000
Date: Wed, 18 Feb 2026 22:42:14 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: fix xfs_group release bug in
 xfs_verify_report_losses
Message-ID: <aZawxiX5D769M5EX@infradead.org>
References: <177145925377.401799.10773940743454980308.stgit@frogsfrogsfrogs>
 <177145925473.401799.4192737708449778278.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177145925473.401799.4192737708449778278.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Feb 18, 2026 at 10:01:30PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Chris Mason reports that his AI tools noticed that we were using
> xfs_perag_put and xfs_group_put to release the group reference returned
> by xfs_group_next_range.  However, the iterator function returns an
> object with an active refcount, which means that we must use the correct
> function to release the active refcount, which is _rele.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

