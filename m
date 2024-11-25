Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CF613CFA6;
	Mon, 25 Nov 2024 05:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732511412; cv=none; b=Z/1FvUVAhW2vi/QHktsQDXHkpD+gGvSJ1TVNqwBszJPuGIkFQ/Z1ILZDLGhtAONlneV55FCVbRB/i+MX/inoYk9RxdWdwUa5WEKoNlpWvWIumClE837ALSfcoOivEqE0A3nhCxNtQXLqsZfhP3l0/M5T7omeMINz4+HhU/TT9H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732511412; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MaG9NiPLw5735TdIIIX+jOBc9nWqLuLk+AHLqKQeCCQZbffw7LRweqUpn54lh9JEkTlJwFcKjP3ic6aiT39uCnwFqXcpQDtKoAU9IFBLW45TQUAviknHoWTszWopZi+vt57uFm0KYRzUfOFrWs9y0DeHxNt+4hNhmLRbHUyrEEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uRjkTABN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uRjkTABN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=uRjkTABNl4FwYVUDSFbpN5xUT6
	+/RiOOqUEpAylRA/B5PZXYMpEgSIjCNZXnQbdq+h5Bz3tCgeu0Jf6AQ1/HWI4SQpNb0ndCRABTH5p
	dZxUVKgB65JElLJppySV/9EkAq1nvH4yLWsGdW2+hPayZ1LhLvxZarm8HQYUTXsdikPgxvUvndz+c
	90yJD4ysU41/R0BWhK3axb0nmRNkq0UbworlOBejyQ9yzanqeA9GJ9BDziFFDqZcy9HEBw7x+3zBd
	0cMamaOJaofDglNNs99V74vel4dKpyAJ2i6Ca9U+bJ0vQFLWcLQrMuuJikuLr96pR1TDw2wScxVR/
	xdgjAlSA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tFRMP-000000074Tv-2ZaV;
	Mon, 25 Nov 2024 05:10:09 +0000
Date: Sun, 24 Nov 2024 21:10:09 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/17] generic/757: convert to thinp
Message-ID: <Z0QGsVNRO5o0NhPY@infradead.org>
References: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
 <173229420045.358248.13209894180925094165.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173229420045.358248.13209894180925094165.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
