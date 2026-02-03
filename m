Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBB137F8D8
	for <linux-xfs@vger.kernel.org>; Tue,  3 Feb 2026 06:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770101268; cv=none; b=dX4DkjXn6fZxIxtdT4xiN50qadfPE0cTFeQCUNIPu35+L/s9at+ZlblTzqu2t3EqBATjYtvjQolow9dImx4yOXcvznXKGGWnFIP8j4TDFsJ4PdWjHutlr3/K3LdDbJqrrLurqD+dQxeC6uHowj/+dCLuf8LvTG5nD+p7BhySdl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770101268; c=relaxed/simple;
	bh=o6OPJOk+abcapVV0wn3PrZKo750aHF2HKH082ZtGaC8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b3vUL/+5Sal7ZFttGYJqgW8+eOy/pr8kW3nv37uSvJXNNepMguertyHXLCOod1TR3iPvXVZKvjMuqolxNSNbD8WQTAJ4yltiPQP50ZneUB6gcX+djo2/HBaCu7zq+7E6VY3EnOUKSvWTLCmFVyFBTFQHXyukvlQgVPCjTz6LKDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5E88168AFE; Tue,  3 Feb 2026 07:47:43 +0100 (CET)
Date: Tue, 3 Feb 2026 07:47:43 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: cleanup inode counter stats
Message-ID: <20260203064743.GA18484@lst.de>
References: <20260202141502.378973-1-hch@lst.de> <20260202141502.378973-2-hch@lst.de> <cd435a8cf4f29d2b979b025c56de898f439c649a.camel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd435a8cf4f29d2b979b025c56de898f439c649a.camel@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Feb 03, 2026 at 11:46:41AM +0530, Nirjhar Roy (IBM) wrote:
> On Mon, 2026-02-02 at 15:14 +0100, Christoph Hellwig wrote:
> > Most of the are unused, so mark them as such.  Give the remaining ones
> 
> Nit -  Typo - "Most of the are <...>" -> "Most of them are <...>"

Yes, thanks.

> > +	uint32_t		xs_inodes_active;
> > +	uint32_t		__unused_vn_alloc;
> > +	uint32_t		__unused_vn_get;
> > +	uint32_t		__unused_vn_hold;
> Any reason to keep the unused field?

If we drop the unused fields the sysfs output would change.

