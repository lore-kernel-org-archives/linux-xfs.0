Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5181BDDB
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 06:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B1CDA68AFE; Thu,  4 Jan 2024 07:27:25 +0100 (CET)
Date: Thu, 4 Jan 2024 07:27:25 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: remove the in-memory btree header block
Message-ID: <20240104062725.GG29215@lst.de>
References: <20240103203836.608391-1-hch@lst.de> <20240103203836.608391-2-hch@lst.de> <20240104012405.GN361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240104012405.GN361584@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 03, 2024 at 05:24:05PM -0800, Darrick J. Wong wrote:
> Originally it was kinda nice to be able to dump the xfbtree contents
> including the root pointer.  That said, it really /does/ complicate
> things.

Doesn't any kind of dump need to talk the btree anyway?

