Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3411DFF2
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 06:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 129E768AFE; Thu,  4 Jan 2024 07:26:53 +0100 (CET)
Date: Thu, 4 Jan 2024 07:26:52 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: put the xfs xfile abstraction on a diet
Message-ID: <20240104062652.GF29215@lst.de>
References: <20240103084126.513354-1-hch@lst.de> <20240104013502.GQ361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240104013502.GQ361584@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jan 03, 2024 at 05:35:02PM -0800, Darrick J. Wong wrote:
> On Wed, Jan 03, 2024 at 08:41:11AM +0000, Christoph Hellwig wrote:
> > Hi all,
> > 
> > this series refactors and simplifies the code in the xfs xfile
> > abstraction, which is a thing layer on a kernel-use shmem file.
> > 
> > Do do this is needs a slighly lower level export from shmem.c,
> > which I combined with improving an assert and documentation there.
> 
> What's the base for this series?  Is it xfs-linux for-next?  Or
> djwong-wtf?

xfs-linux for-next, sorry.

