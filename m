Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FAB1DFE4
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 06:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4B9FC68AFE; Thu,  4 Jan 2024 07:15:43 +0100 (CET)
Date: Thu, 4 Jan 2024 07:15:42 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 05/15] xfs: remove the xfile_pread/pwrite APIs
Message-ID: <20240104061542.GC29011@lst.de>
References: <20240103084126.513354-1-hch@lst.de> <20240103084126.513354-6-hch@lst.de> <20240103234849.GY361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103234849.GY361584@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 03, 2024 at 03:48:49PM -0800, Darrick J. Wong wrote:
> "To support these cases, a pair of ``xfile_obj_load`` and ``xfile_obj_store``
> functions are provided to read and persist objects into an xfile.  An errors
> encountered here are treated as an out of memory error."

Ok.

> > -DEFINE_XFILE_EVENT(xfile_pwrite);
> > +DEFINE_XFILE_EVENT(xfile_obj_load);
> > +DEFINE_XFILE_EVENT(xfile_obj_store);
> 
> Want to shorten the names to xfile_load and xfile_store?  That's really
> what they're doing anyway.

Fine with me.  Just for the trace points or also for the functions?

Also - returning ENOMEM for the API misuse cases (too large object,
too large total size) always seemed weird to me.  Is there a really
strong case for it or should we go for actually useful errors for those?

