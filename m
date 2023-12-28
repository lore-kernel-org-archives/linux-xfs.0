Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7DA3C07
	for <linux-xfs@vger.kernel.org>; Thu, 28 Dec 2023 06:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EA3E668B05; Thu, 28 Dec 2023 07:47:53 +0100 (CET)
Date: Thu, 28 Dec 2023 07:47:53 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, chandan.babu@oracle.com,
	linux-xfs@vger.kernel.org,
	kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH 1/2] xfs: fix a use after free in
 xfs_defer_finish_recovery
Message-ID: <20231228064753.GA13395@lst.de>
References: <20231228061830.337279-1-hch@lst.de> <20231228062633.GR361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231228062633.GR361584@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Dec 27, 2023 at 10:26:33PM -0800, Darrick J. Wong wrote:
> > -	error = dfp->dfp_ops->recover_work(dfp, capture_list);
> > +	error = ops->recover_work(dfp, capture_list);
> 
> Since I suck at remembering that dfp can be freed by recovery work, can
> you add a comment to that effect? e.g.

Sure.
