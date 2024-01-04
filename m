Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B10A1A70D
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 06:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A63D168AFE; Thu,  4 Jan 2024 07:14:15 +0100 (CET)
Date: Thu, 4 Jan 2024 07:14:15 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 04/15] xfs: remove xfile_stat
Message-ID: <20240104061415.GB29011@lst.de>
References: <20240103084126.513354-1-hch@lst.de> <20240103084126.513354-5-hch@lst.de> <20240103234533.GX361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103234533.GX361584@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 03, 2024 at 03:45:33PM -0800, Darrick J. Wong wrote:
> > +		__entry->bytes = inode->i_bytes;
> 
> Shouldn't this be (i_blocks << 9) + i_bytes?

Actually this should just be doing:

	__entry->bytes = inode->i_blocks << SECTOR_SHIFT;

The bytes name here really confused me.  Or we could change the trace
point to just report i_block directly and not rename it to bytes and
change the unit?

