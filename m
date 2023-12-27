Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE31C53A2
	for <linux-xfs@vger.kernel.org>; Wed, 27 Dec 2023 07:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7236268B05; Wed, 27 Dec 2023 08:26:28 +0100 (CET)
Date: Wed, 27 Dec 2023 08:26:28 +0100
From: Christoph Hellwig <hch@lst.de>
To: kernel test robot <oliver.sang@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, oe-lkp@lists.linux.dev, lkp@intel.com,
	Linux Memory Management List <linux-mm@kvack.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [linux-next:master] [xfs]  7f2f7531e0:
 BUG:KASAN:slab-use-after-free_in_xfs_defer_finish_recovery
Message-ID: <20231227072628.GA21175@lst.de>
References: <202312271458.851834a0-oliver.sang@intel.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202312271458.851834a0-oliver.sang@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

It looks like the tracepoint will access dfp after it has already
been freed.  The fix is to simply add (back) a local variable for ops.
I'll cook up a patch.

