Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70E013D52C
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 05:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728885537; cv=none; b=EGrS8MuwL6rgojGNWvfx6a9jL5IjzMI9Ov3ork58CC3phTHbKz7cUCatTtvXbdvuMysLWuJ7/XXcC5ghrxmNb+zMg04DMGgsVYPKCuMwbGQtowNqwu5FP0AA5eemoa8xnXuR2DqknKNmachvY+FiJwQLoDUu+2iXpzCsqX0vfIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728885537; c=relaxed/simple;
	bh=+1q7vZeDkBIxOtcDQKsR0JwCArM0Btf5C4dz6pkSmoo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P0OOtTigY12osEkiR2ydgy5ydv8gkmrelknWDiTqZ/Zy/xCBCgKb0Hq04WCGot+6lF9s03H+Mg48BMtJ4i9IpX97c6tI6kPgile5NOBefG/gKUDAvujKcSD3wzhfg0fEsORYuB7V8jWclVNF7Egrm00rCpn1FY5nIe4fAUTlADw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 420DF227AA8; Mon, 14 Oct 2024 07:58:51 +0200 (CEST)
Date: Mon, 14 Oct 2024 07:58:50 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: don't update file system geometry through
 transaction deltas
Message-ID: <20241014055850.GA20485@lst.de>
References: <20240930164211.2357358-1-hch@lst.de> <20240930164211.2357358-7-hch@lst.de> <ZwffQQuVx_CyVgLc@bfoster> <20241011075709.GC2749@lst.de> <Zwkv6G1ZMIdE5vs2@bfoster> <20241011171303.GB21853@frogsfrogsfrogs> <ZwlxTVpgeVGRfuUb@bfoster> <20241011231241.GD21853@frogsfrogsfrogs> <20241011232906.GE21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241011232906.GE21853@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Oct 11, 2024 at 04:29:06PM -0700, Darrick J. Wong wrote:
> Ahahaha awesome it corrupts the filesystem:

Is this with a rtgroup file system?  I can't get your test to fail
with the latest xfs staging tree.

