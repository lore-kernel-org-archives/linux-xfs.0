Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6F823C4F8;
	Mon, 12 May 2025 15:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747063646; cv=none; b=LjyboKxsGwvDm8eqRQQIb7I/t9Zjw2P2to2US7fuZm9om5qnftSAFyydLWkQ94KCbuSMLg0hamXcf8yxZ7zChFVSliCjNUW1ptrw8OVRFXAOCasHf/GX0DpWCWPN/G4GYSI5xsNVDhSc/QsaCDvBUj6HDuM99pK3JlDn+UjE/O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747063646; c=relaxed/simple;
	bh=FfRnLz1AebwBws3t3Hkm89jWrDj9+l4g+B6niOHEauw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fvG/b8HGo4pW2HQ2XQuPLD9nDgySGMOVoBTYZNWroBs3nNJYK4phpvlb1vuvuR7XngYaqDgY3SCVWF24sEGHGZruHV6r6iCI2LPQh92Hy6qHGjLr948liu65bRif2JeDNJDV7N/Ctkvix3lkvk9k8eJ9Qv1XS9iBkhEWtHbLsBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6903E68C4E; Mon, 12 May 2025 17:27:20 +0200 (CEST)
Date: Mon, 12 May 2025 17:27:20 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, zlang@kernel.org, hans.holmberg@wdc.com,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] common: skip zoned devices in
 _require_populate_commands
Message-ID: <20250512152720.GA9517@lst.de>
References: <20250512131819.629435-1-hch@lst.de> <20250512150824.GD2701446@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250512150824.GD2701446@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, May 12, 2025 at 08:08:24AM -0700, Darrick J. Wong wrote:
> Do you need to _notrun the other mdrestore tests too?

All the the other ones seem to just restore to files, which works.

> I was wondering why this patch didn't add a helper:
> 
> # Check if mdrestore is supported, must come after _scratch_check
> _require_scratch_mdrestore() {

That seems reasonable, I'll look into it.

