Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FAA41865A
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 06:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 219FE68AFE; Thu,  4 Jan 2024 07:25:23 +0100 (CET)
Date: Thu, 4 Jan 2024 07:25:22 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 11/15] xfs: use shmem_get_folio in xfile_get_page
Message-ID: <20240104062522.GD29215@lst.de>
References: <20240103084126.513354-1-hch@lst.de> <20240103084126.513354-12-hch@lst.de> <20240104001251.GE361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240104001251.GE361584@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 03, 2024 at 04:12:51PM -0800, Darrick J. Wong wrote:
> > +	if (error)
> > +		return error;
> > +
> > +	page = folio_file_page(folio, pos >> PAGE_SHIFT);
> > +	if (PageHWPoison(page)) {
> > +		folio_put(folio);
> 
> We need to unlock the folio here, right?

On the error return?  Yes.
