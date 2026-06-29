Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A129E401A37;
	Mon, 29 Jun 2026 12:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782737170; cv=none; b=mfppTB2mU1FCi4UJ5V4ma2D7cZEeox5Lr4gcVoTwTQkuCQ5zgnvdeIHf+zk46xi64DL2lnp7YVYqp9l9cZd3N0fRRLDDrXB6CSRbudCyPKu1ZZvQKTZygFb7cQ35uigtqJM+BTjGWa1yBo447PtQsQmU4KL9MhOGlEg9rRnHizY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782737170; c=relaxed/simple;
	bh=389AEM2utSqn2fN8FAKtgkgAr4Z17AuWTFZfzIj2Gjk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kSgka/qaSHXIDERNeck18XPW3cB1U8OplBdPydPX8SUmfSEUSxK+TsMsE1gHsx38g+rpCpyDwvt1kEGVk+ohLRcM2Z3E+nfUfgnSjBjL5m31Uo98iBdVGEOeMUGYmKUSFOYCbqe0WMJjaH4ptM50H3lV+Y2TrjWmhqdYC2DtZXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 53E6668C7B; Mon, 29 Jun 2026 14:46:04 +0200 (CEST)
Date: Mon, 29 Jun 2026 14:46:03 +0200
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Filip Blagojevic <filip.blagojevic@wdc.com>,
	Matthew Wilcox <willy@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: update BDI {io,ra}_pages values based on the RT device limits
Message-ID: <20260629124603.GA23417@lst.de>
References: <20260623142109.1838702-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260623142109.1838702-1-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

So, I guess we're stuck with this approach?  Or any other ideas?

On Tue, Jun 23, 2026 at 04:21:05PM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> we ran into a bit of a funny case where adding an SSD to store metadata
> to a (zoned) XFS file system reduced the performance vs using a HDD for
> both data and metadata.  It turns out this is due to readahead code
> looking at the BDI limits, including the io_pages value that can't be
> inspected or tuned from userspace.
> 
> This patch has the simplest fix for that by just updating the values from
> XFS, but for a long-term solution this feels a bit ugly.  Other, a lot
> more invasive options would be:
> 
> 
>   1) support multiple BDIs per file system.
> 
> 	This would work pretty well for XFS, as data for a given file is
> 	always entirely on one device, and the VFS writeback code is not
> 	used for metadata.  But it probably doesn't work well for other
> 	cases
> 
>   2) stop propagating these values through the BDI
> 
> 	Have a way to query these parameters from the file system, either
> 	through a method if we want to be fully dynamic, or through fields
> 	instead of going through the BDI.  The downside would be that
> 	sysfs modifications of the readahead size would not work after
> 	the file system initially queried them.
> 
> Thoughts?
---end quoted text---
