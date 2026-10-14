Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A584582CA;
	Wed, 14 Oct 2026 13:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791983162; cv=none; b=FWqhnUgkhX4PJrXEzlH36WmikpMmWYExQrv0OWq/ULpwZRx1LxovexKHXsKtcGiLYXYvl//xdM/tSDBMZkOyDC+hQ82wsaotrCPq0N/RtlvfUqPowiR7+WuyqBM+QtBvZYfYJXg045G7NRrP7kCex2Evjb927a7lLoiZWF5F+sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791983162; c=relaxed/simple;
	bh=oVs/gIMuL881eLwUXewA+7D3o86KvXDU42xkdhXGLWI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZpDUkjyyHtL0M7GmtUfsut5ml6DBwq5K7DBfMM8WcnPDxyXEuwETORU9V7muBMDpM097YIBInN1NBu4yJHoWPejizMQ1wI6ffJhfjzfuPb8cEicZUQCLfFpenVlMOrFn0y0GRn4+q+HRrQEgvM2zqpCSjERYnAbi0YK2z1C+JBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 614A768BFE; Wed, 14 Oct 2026 15:05:57 +0200 (CEST)
Date: Wed, 14 Oct 2026 15:05:57 +0200
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
Subject: Re: [PATCH v2 0/2] xfs: refuse pNFS LAYOUTCOMMITs of ranges
 without blocks
Message-ID: <20261014130557.GA15773@lst.de>
References: <20261014-xfs-pnfs-commit-hole-v2-0-d3a02a79ab6c@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014-xfs-pnfs-commit-hole-v2-0-d3a02a79ab6c@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Can you please send your entire xfs pNFS batch of patches in a single
series?  That makes it much easier to coordinate.  Let's ignore the
parts about the nfsd interface for now (I'm going to review them,
but it's clearly too late for 7.4 at this point).

