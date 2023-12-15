Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA8F46BC
	for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2023 04:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9928D68AFE; Fri, 15 Dec 2023 05:10:13 +0100 (CET)
Date: Fri, 15 Dec 2023 05:10:13 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/19] xfs: tidy up xfs_rtallocate_extent_block
Message-ID: <20231215041013.GC15127@lst.de>
References: <20231214063438.290538-1-hch@lst.de> <20231214063438.290538-13-hch@lst.de> <20231214211620.GC361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214211620.GC361584@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Dec 14, 2023 at 01:16:20PM -0800, Darrick J. Wong wrote:
> > +	if (maxlen < minlen || besti == -1) {
> 
> ...because I was worried about accidentally ending up in this clause
> if maxlen < minlen.  I /think/ it's the case that this function never
> gets called with that true, right?
> 
> (Would this be a good place to add a ebugging assertion?)

I'll look into it.

