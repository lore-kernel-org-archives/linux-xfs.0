Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34FB751C44;
	Thu, 11 Jan 2024 17:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 125A768CFE; Thu, 11 Jan 2024 18:25:57 +0100 (CET)
Date: Thu, 11 Jan 2024 18:25:56 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, zlang@redhat.com,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: check that the mountpoint is actually mounted
 in _supports_xfs_scrub
Message-ID: <20240111172556.GB22255@lst.de>
References: <20240111142407.2163578-1-hch@lst.de> <20240111142407.2163578-2-hch@lst.de> <20240111172022.GO723010@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240111172022.GO723010@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jan 11, 2024 at 09:20:22AM -0800, Darrick J. Wong wrote:
> > +	mountpoint $mountpoint >/dev/null || echo "$mountpoint is not mounted"
> 
> The helper needs to return nonzero on failure, e.g.
> 
> 	if ! mountpoint -q $mountpoint; then
> 		echo "$mountpoint is not mounted"
> 		return 1
> 	fi

No, it doesn't..  I actually did exactly that first, but that causes the
test to be _notrun instead of reporting the error and thus telling the
author that they usage of this helper is wrong.

