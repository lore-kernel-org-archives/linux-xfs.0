Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C01F63D
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 05:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738905594; cv=none; b=pLKVykxq9PyBpVbrH1kk8PuVG37pghTt8aWaY7gkkvuqstft68QvULmqhdw44nUoKqDUuVJMUYhVfxDemkICjZKWKZzLwwKXkEfhCoAqMehcIyEj2pTFaBHenSkH4zx9tOOKQEYDsgGT+zPs7uUBj8X6eNe5ZtPQMz3GHdo+Z9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738905594; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=abBan52/6DOlJkwjqzz11QaMYSXXXOKGUU4xfDaj7euSeL3GB6novno/d+0IcGkmrmbXmmOXc7wQJqVgR5kV9RczqbypBdlgC4Ul2Q1B/eVm8dGwgkxB0coSo1KHaZ+vaBE3On0NdPdYR1pp4dQMtDafJvjxAqoBj3r59rykCak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4mZ/RUbP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4mZ/RUbP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=4mZ/RUbPQ2Tv5vRd+GPBZejxQT
	oe5HvTCxMP+kA1DVb1qvvaAuPZ70v+R6IU8guQY6AQ/7JXazQWuWnCib95QXePjqvvAr7Gp6p2nUv
	SZcmmha+UsIZSeF77HrQ+cZkLlhdCbZykftRYIHh8Y7X7U7jSFrZbPuphEXac3DrS7TqLz551BcJn
	ZiOhZhpkqu4GZFT7+VxyjNTO2BiqVbv+Weg5FByA4Lfl0o4LNtxjoFVYfMmEvaxZzDWP/tkn0hfYQ
	f/Ho8Umwhwr2RQOxi76653dc3oz5IPL+DHo2lSLZA+zm/VG0W79I3gY1N8sv+0g6vkfX0Txv1r3Se
	fx7vx7kQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgGmP-00000008MGN-0dV9;
	Fri, 07 Feb 2025 05:19:53 +0000
Date: Thu, 6 Feb 2025 21:19:53 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/27] xfs_spaceman: report health status of the realtime
 rmap btree
Message-ID: <Z6WX-VspnpkMJMHw@infradead.org>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
 <173888088279.2741033.5703668513120399965.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888088279.2741033.5703668513120399965.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

