Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC40B93;
	Sun, 26 Nov 2023 22:33:29 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 61D8F68AFE; Mon, 27 Nov 2023 07:33:26 +0100 (CET)
Date: Mon, 27 Nov 2023 07:33:25 +0100
From: Christoph Hellwig <hch@lst.de>
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Zhang Yi <yi.zhang@huaweicloud.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 02/13] iomap: treat inline data in iomap_writepage_map
 as an I/O error
Message-ID: <20231127063325.GB27241@lst.de>
References: <20231126124720.1249310-3-hch@lst.de> <87bkbfssb8.fsf@doe.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bkbfssb8.fsf@doe.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 27, 2023 at 10:31:31AM +0530, Ritesh Harjani wrote:
> The code change looks very obvious. But sorry that I have some queries
> which I would like to clarify - 
> 
> The dirty page we are trying to write can always belong to the dirty
> inode with inline data in it right? 

Yes.

> So it is then the FS responsibility to un-inline the inode in the
> ->map_blocks call is it?

I think they way it currently works for gfs2 is that writeback from the
page cache never goes back into the inline area.  

If we ever have a need to actually write back inline data we could
change this code to support it, but right now I just want to make the
assert more consistent.
