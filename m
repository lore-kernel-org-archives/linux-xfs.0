Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA6A4E80DD;
	Wed, 14 Oct 2026 13:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791983320; cv=none; b=jviYJj24vVb/D8B57/bgFJx7p2ic6Z6bBToRWe0eVmEN5OLhe2Z5mCq9/NQYRSp8ikieJakLKDYl08Qd1RuazJ+N9tyJ8cwfiFWg0Ch3A7pcACFuvvt9eI7IBvag+9wbBOXpQvCylX+DAXDHFD6H/7+mIJCdDB1KcavvxebZv3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791983320; c=relaxed/simple;
	bh=1W9+AXP8Cf/4Fxmh0xWs5DP/GIQQfSuQk4+7BuGn5fM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VcOStZzEEkyIpdYjpbiyjP+oXdo5tZR06m2JdZqOWaHay1u2a/9WP85XXKuuKNUlgxQ94xOfrs7ZF3WoH2gTn0z9nsqWCqTm5VoPO2WoBvs8AfCUZTWm4mY2sHuBkqaeXTNgkbcBlZNAIgwDlViWnwvUZVkIhdIawb4/oKnZ39g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 315F068BEB; Wed, 14 Oct 2026 15:08:35 +0200 (CEST)
Date: Wed, 14 Oct 2026 15:08:34 +0200
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
Subject: Re: [PATCH v2 1/2] xfs: refuse a pNFS LAYOUTCOMMIT of a range
 without blocks
Message-ID: <20261014130834.GB15773@lst.de>
References: <20261014-xfs-pnfs-commit-hole-v2-0-d3a02a79ab6c@samsung.com> <20261014-xfs-pnfs-commit-hole-v2-1-d3a02a79ab6c@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014-xfs-pnfs-commit-hole-v2-1-d3a02a79ab6c@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Please split the flag addition from the user in the pnfs code.

Sashiko sais the EIO could trigger a shutdown, which looks like a valid
complaint to me.  So we'll need to bypass that.

