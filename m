Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325BC1D68D
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 06:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 94A1B68AFE; Thu,  4 Jan 2024 07:21:02 +0100 (CET)
Date: Thu, 4 Jan 2024 07:21:02 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 06/15] xfs: don't try to handle non-update pages in
 xfile_obj_load
Message-ID: <20240104062102.GA29215@lst.de>
References: <20240103084126.513354-1-hch@lst.de> <20240103084126.513354-7-hch@lst.de> <20240103235538.GZ361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103235538.GZ361584@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 03, 2024 at 03:55:38PM -0800, Darrick J. Wong wrote:
> On Wed, Jan 03, 2024 at 08:41:17AM +0000, Christoph Hellwig wrote:
> > shmem_read_mapping_page_gfp always returns an uptodate page or an
> > ERR_PTR.  Remove the code that tries to handle a non-uptodate page.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Hmm.  xfile_pread calls shmem_read_mapping_page_gfp ->
> shmem_read_folio_gfp -> shmem_get_folio_gfp(..., SGP_CACHE), right?
> 
> Therefore, if the page is !uptodate then the "clear:" code will mark it
> uptodate, right?  And that's why xfile.c doesn't need to check uptodate?

Yes.
