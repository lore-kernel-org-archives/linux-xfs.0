Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C5E5220
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 04:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A4DD368B05; Fri,  5 Jan 2024 05:27:54 +0100 (CET)
Date: Fri, 5 Jan 2024 05:27:54 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: embedd struct xfbtree into the owning
 structure
Message-ID: <20240105042754.GA23630@lst.de>
References: <20240103203836.608391-1-hch@lst.de> <20240103203836.608391-6-hch@lst.de> <20240104012133.GM361584@frogsfrogsfrogs> <20240104063218.GI29215@lst.de> <20240104071454.GY361584@frogsfrogsfrogs> <20240104071735.GB30339@lst.de> <20240104072200.GB361584@frogsfrogsfrogs> <20240104192822.GI361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240104192822.GI361584@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jan 04, 2024 at 11:28:22AM -0800, Darrick J. Wong wrote:
> Though looking at buftarg allocation and my old notes from a couple of
> years ago -- a second reason for allocating the buftarg during scrub
> setup was that the list_lru_init call allocates an array that's
> O(nodes_nr) and percpu_counter_init allocates an array that's
> O(maxcpus).  At the time I decided that it was better to put those large
> contiguous memory allocations in the ->setup routine where we don't have
> any vfs/xfs locks held, can run direct reclaim, and haven't done any xfs
> work yet.

Given that we use the page LRU for the shemfs pages, I don't think we
need the buftarg LRU list at all - aging just the buffer container
doesn't make much sense.
