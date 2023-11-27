Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C1812F;
	Sun, 26 Nov 2023 22:41:11 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6138968AFE; Mon, 27 Nov 2023 07:41:07 +0100 (CET)
Date: Mon, 27 Nov 2023 07:41:07 +0100
From: Christoph Hellwig <hch@lst.de>
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Zhang Yi <yi.zhang@huaweicloud.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 04/13] iomap: drop the obsolete PF_MEMALLOC check in
 iomap_do_writepage
Message-ID: <20231127064107.GA27540@lst.de>
References: <20231126124720.1249310-5-hch@lst.de> <875y1nsnsj.fsf@doe.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875y1nsnsj.fsf@doe.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 27, 2023 at 12:09:08PM +0530, Ritesh Harjani wrote:
> Nice cleanup. As you explained, iomap_do_writepage() never gets called
> from memory reclaim context. So it is unused code which can be removed. 
> 
> However, there was an instance when this WARN was hit by wrong
> usage of PF_MEMALLOC flag [1], which was caught due to WARN_ON_ONCE.
> 
> [1]: https://lore.kernel.org/linux-xfs/20200309185714.42850-1-ebiggers@kernel.org/
> 
> Maybe we can just have a WARN_ON_ONCE() and update the comments?
> We anyway don't require "goto redirty" anymore since we will never
> actually get called from reclaim context.

Well, xfs/iomap never really cared about the flag, just that it didn't
get called from direct reclaim or kswapd.  If we think such a WARN_ON
is still useful, the only caller of it in do_writepages might be a better
place.

