Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81DAF489898;
	Thu, 30 Jul 2026 08:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785399526; cv=none; b=hQT5jDGrU42+4QJqEraccMoaRzy/1Z8ubHolb649Du72CUw7pj/Rv+nPXlAwPrbWaA45Vsi6keIf139MhFlHM4OJvY5bZ2ehxjjtX+kZO2EvpqJOjas3Q3aJhd1uPVdXiupHBO410K4ROt/Z4syeRdJEimvgVoLOAdafs9ONrbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785399526; c=relaxed/simple;
	bh=xH0/igTP4Raf8l5ZPr2i7jKI/SB7jkZXckSkfIczRW8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CDTS/j/9eUG5fV7iSxab2NeQjTHK8g04sMi3BBKVAg2KLZEx4z+dpSXsfSdnjSdVftYqQbHRZ84CSzBdhHcFeb6Ud/PW9uCc/G84jnGWQmuDCkMLEU13SRkkpFivMQdcXD2uG31JkHx2S67t5Kshp0uUjM/Zfii7A/FReVmLXuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0358568BFE; Thu, 30 Jul 2026 10:18:40 +0200 (CEST)
Date: Thu, 30 Jul 2026 10:18:39 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: fix unit conversions in per_binval computation
Message-ID: <20260730081839.GA10558@lst.de>
References: <178538912844.4070956.17029198681620903700.stgit@frogsfrogsfrogs> <178538912901.4070956.12472652319090346828.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178538912901.4070956.12472652319090346828.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 29, 2026 at 10:26:18PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed that we're doing the unit conversion in the per_binval
> computation backwards -- xfs_buf_inval_log_space's second parameter is
> supposed to be in bytes, but max_binval is in units of fsblocks.  Hence
> the conversion should be FSB -> B, not the other way around.

Oops.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

