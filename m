Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB442F9C37;
	Wed, 14 Oct 2026 13:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791983348; cv=none; b=DVQ/Wh+z+i8AfIicZ6EgoEzzITn7236Rz30YSXAy6De+3Xftqrx0VFBg0LcohIg4qVgeyU5fqA8FYpAMoJrGWTjvV9KUmBAeny4QghvGNY0D5JpUodTbY9oR1o5RvPkL8hxr2UyyhpEXLJ1qKh7/L+jL6MBtLvsw3UbSm+InTXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791983348; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dd2U81W4gm2YCM9qDw4Llvqx8OK8HbQsCTYW2RnvraE/3u0q5xGNj/hFu8XUjYjOjC2oRrVxXv7lqKwdqNncVhbtPiJU/a1cewVrgzrvdnGvSpZT35IJ2LcRj5POOF/WRm7qQeSNhmUO8Hl12il7CYMllC4TrfKdqG7ESqySS3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A254268BEB; Wed, 14 Oct 2026 15:09:03 +0200 (CEST)
Date: Wed, 14 Oct 2026 15:09:03 +0200
From: Christoph Hellwig <hch@lst.de>
To: daejun7.park@samsung.com
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dgc@kernel.org>, Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>, Dai Ngo <Dai.Ngo@oracle.com>,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	linux-nfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] xfs: clamp a pNFS LAYOUTCOMMIT extent before
 computing its end
Message-ID: <20261014130903.GC15773@lst.de>
References: <20261014-xfs-pnfs-commit-hole-v2-0-d3a02a79ab6c@samsung.com> <20261014-xfs-pnfs-commit-hole-v2-2-d3a02a79ab6c@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014-xfs-pnfs-commit-hole-v2-2-d3a02a79ab6c@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

