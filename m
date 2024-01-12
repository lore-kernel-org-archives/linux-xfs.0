Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC9D5B5AA;
	Fri, 12 Jan 2024 04:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4B95068D05; Fri, 12 Jan 2024 05:41:40 +0100 (CET)
Date: Fri, 12 Jan 2024 05:41:39 +0100
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: check that the mountpoint is actually mounted
 in _supports_xfs_scrub
Message-ID: <20240112044139.GB5664@lst.de>
References: <20240111142407.2163578-1-hch@lst.de> <20240111142407.2163578-2-hch@lst.de> <20240111172022.GO723010@frogsfrogsfrogs> <20240111172556.GB22255@lst.de> <20240111211702.baimcixgpuhoqbib@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240111211702.baimcixgpuhoqbib@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jan 12, 2024 at 05:17:02AM +0800, Zorro Lang wrote:
> > No, it doesn't..  I actually did exactly that first, but that causes the
> > test to be _notrun instead of reporting the error and thus telling the
> > author that they usage of this helper is wrong.
> 
> So below "usage" message won't be gotten either, if a _notrun be called
> after this helper return 1 .

True.  But for the case reproducing my original error where I just
misplaced it it does get shown.

> If there's not _notrun after that, the message will be gotten I think.
> So I think the "return 1" makes sense.

As this point we might as well skip this patch, as it won't be useful.

