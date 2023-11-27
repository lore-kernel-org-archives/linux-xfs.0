Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A47DA138;
	Mon, 27 Nov 2023 00:13:48 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id F18AA67373; Mon, 27 Nov 2023 09:13:43 +0100 (CET)
Date: Mon, 27 Nov 2023 09:13:43 +0100
From: Christoph Hellwig <hch@lst.de>
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Zhang Yi <yi.zhang@huaweicloud.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 07/13] iomap: clean up the iomap_new_ioend calling
 convention
Message-ID: <20231127081343.GA30160@lst.de>
References: <20231126124720.1249310-8-hch@lst.de> <87ttp7r68u.fsf@doe.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ttp7r68u.fsf@doe.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 27, 2023 at 01:13:29PM +0530, Ritesh Harjani wrote:
> Christoph Hellwig <hch@lst.de> writes:
> 
> > Switch to the same argument order as iomap_writepage_map and remove the
> > ifs argument that can be trivially recalculated.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/iomap/buffered-io.c | 11 +++++------
> >  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> Straight forward change. Looks good to me. Please feel free to add - 

Also the subject should be changed now that I'm reading your reply.
I dropped the rename of this function that I had in earlier versions.
