Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A5D1710;
	Tue, 28 Nov 2023 21:41:42 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1D819227A87; Wed, 29 Nov 2023 06:41:40 +0100 (CET)
Date: Wed, 29 Nov 2023 06:41:39 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Zhang Yi <yi.zhang@huaweicloud.com>,
	Ritesh Harjani <ritesh.list@gmail.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 10/13] iomap: only call mapping_set_error once for each
 failed bio
Message-ID: <20231129054139.GD1385@lst.de>
References: <20231126124720.1249310-1-hch@lst.de> <20231126124720.1249310-11-hch@lst.de> <20231129050322.GP4167244@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231129050322.GP4167244@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 28, 2023 at 09:03:22PM -0800, Darrick J. Wong wrote:
> > +	if (error) {
> > +		mapping_set_error(inode->i_mapping, error);
> > +		if (!bio_flagged(bio, BIO_QUIET)) {
> > +			pr_err_ratelimited(
> > +"%s: writeback error on inode %lu, offset %lld, sector %llu",
> > +				inode->i_sb->s_id, inode->i_ino,
> > +				ioend->io_offset, ioend->io_sector);
> 
> Something that's always bothered me: Why don't we log the *amount* of
> data that just failed writeback?
> 
> "XFS: writeback error on inode 63, offset 4096, length 8192, sector 27"
> 
> Now we'd actually have some way to work out that we've lost 8k worth of
> data.  OFC maybe the better solution is to wire up that inotify error
> reporting interface that ext4 added a while back...?

Just adding the amount sounds sane to me and I can add a patch to do
that.  I think this message originated in buffer.c, where it was
printed once for each block before rate limiting got added..

