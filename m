Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F78C113;
	Sun, 26 Nov 2023 22:29:39 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1F9A668AFE; Mon, 27 Nov 2023 07:29:35 +0100 (CET)
Date: Mon, 27 Nov 2023 07:29:34 +0100
From: Christoph Hellwig <hch@lst.de>
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Zhang Yi <yi.zhang@huaweicloud.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/13] iomap: clear the per-folio dirty bits on all
 writeback failures
Message-ID: <20231127062934.GA27241@lst.de>
References: <20231126124720.1249310-2-hch@lst.de> <87edgbsvr8.fsf@doe.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87edgbsvr8.fsf@doe.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 27, 2023 at 09:17:07AM +0530, Ritesh Harjani wrote:
> Christoph Hellwig <hch@lst.de> writes:
> 
> > write_cache_pages always clear the page dirty bit before calling into the
> > file systems, and leaves folios with a writeback failure without the
> > dirty bit after return.  We also clear the per-block writeback bits for
> 
> you mean per-block dirty bits, right?

Yes, sorry.

> 		/*
> 		 * Let the filesystem know what portion of the current page
> 		 * failed to map. If the page hasn't been added to ioend, it
> 		 * won't be affected by I/O completion and we must unlock it
> 		 * now.
> 		 */
> The comment to unlock it now becomes stale here.

Indeed.

> Maybe why not move iomap_clear_range_dirty() before?

A few patches down the ->discard_folio call moves into a helper, so
I'd rather avoid the churn here.  I'll move that part of the comment
to thew new check below iomap_clear_range_dirty instead.
