Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2FBF4F7;
	Fri, 12 Jan 2024 04:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E761868CFE; Fri, 12 Jan 2024 05:42:23 +0100 (CET)
Date: Fri, 12 Jan 2024 05:42:23 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@redhat.com>, Christoph Hellwig <hch@lst.de>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: check that the mountpoint is actually mounted
 in _supports_xfs_scrub
Message-ID: <20240112044223.GC5664@lst.de>
References: <20240111142407.2163578-1-hch@lst.de> <20240111142407.2163578-2-hch@lst.de> <20240111172022.GO723010@frogsfrogsfrogs> <20240111172556.GB22255@lst.de> <20240111211702.baimcixgpuhoqbib@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com> <20240112021749.GN722975@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240112021749.GN722975@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jan 11, 2024 at 06:17:49PM -0800, Darrick J. Wong wrote:
> > If there's not _notrun after that, the message will be gotten I think.
> > So I think the "return 1" makes sense.
> > 
> > What do both of you think ?
> 
> _fail "\$mountpoint must be mounted to use _require_scratch_xfs_scrub" ?

Yes, that's better.  I didn't even remember _fail exists..

