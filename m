Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5162A937;
	Mon,  5 May 2025 05:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746424682; cv=none; b=MqG7JS09Y86Tek1qxyVQrsfMaA/ez+2vUv9dqiNaE4Cn6MHArWKmknlb53R19iygnngQHgLwaDOGCF495JmY4vPhubrD3WH+09BOmCcbgA+ZV0RJhffKDXhA7gyZyjc1ky4HodRErcRXV2r3zD67V1JrV9/HEUV9urrqWi2C/80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746424682; c=relaxed/simple;
	bh=XEbJZvsUXctQGQEr7IstQeGutiGWNpuml3Rhm2Jdzb4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=acXW+PGF0Rxm84fNHwG5URBHMGxqfTKP0CaFXqKQwWA9Jz5xysA8Pvs3PLZ/WEl+Wlhk13HCrwE0ci+4tIeI0crUMi3v680fcf5RYJIB4GaqpUlcLC/GxG2jA+DD/R0R2owV2L6sK3Br+ogwh+VmaIaM3P8G/0wyBstSJExXcpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 52AEA68BEB; Mon,  5 May 2025 07:57:56 +0200 (CEST)
Date: Mon, 5 May 2025 07:57:56 +0200
From: hch <hch@lst.de>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>, hch <hch@lst.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/2] Add mru cache for inode to zone allocation
 mapping
Message-ID: <20250505055756.GB21256@lst.de>
References: <20250430084117.9850-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250430084117.9850-1-hans.holmberg@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 30, 2025 at 08:41:20AM +0000, Hans Holmberg wrote:
> Sending out as an RFC to get comments, specifically about the potential
> mru lock contention when doing the lookup during allocation.

I am a little worried about that.  The MRU cache is implemented right
now rotates the mru list on every lookup under a mru-cache wide lock,
which is bit of a performance nightmare.

I wonder if we can do some form of batched move between the mru buckets
that can reduce the locking and cacheline write impact.

But maybe it's worth to give this a try and work from performance reports
as needed.

