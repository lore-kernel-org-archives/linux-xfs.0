Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD55A309EE6;
	Fri, 24 Jul 2026 13:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784899570; cv=none; b=PyPqFCIUYVLX3mcps2lN70LEd7LbfdkxRLmgEskdW8rtPdCKIztNrFhModmRuIy2IgbmUyCQ/eu1WTPuunhL/vaPDpfnxahhI/J588v06E9JCp8McYo0Q9rK5w5D/IErCVdXLZXZ12VE126aEVd8UNRKyiYhAnDF+yoTWFU/fkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784899570; c=relaxed/simple;
	bh=G5lHzgIV74vAxd6Nc7CI5hfmxiWNkmgTyHtmtcUGieU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ff4jdtgprZSg+qRDOcTQCXBQI9UsRz0klsnbdvfZ+V4X8ET0rynPhGmLiPK7cyMt2j9DsLKONtdcg0mPhDlSRLKVht9rXDigzjXUVidnfcM/WcKsAETxAjPtn1NCXhM3vt4/f6vuDzLZ+WwnyVXZE/VRiOO7sZ9b67EvZz5Ivss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0EE3F68D0A; Fri, 24 Jul 2026 15:26:07 +0200 (CEST)
Date: Fri, 24 Jul 2026 15:26:06 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: nlink scrub must take IOLOCK before
 determining ILOCK state
Message-ID: <20260724132606.GE28170@lst.de>
References: <178487405343.3442778.10258954219942220821.stgit@frogsfrogsfrogs> <178487405483.3442778.17939171750881157462.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178487405483.3442778.17939171750881157462.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jul 23, 2026 at 11:22:18PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In xchk_nlinks_ilock_dir, take the IOLOCK before accessing internal
> inode state to figure out if we need to take ILOCK shared or exclusive.
> That way we can't race with directory updates.  LOLLM pointed out that
> the code was initially correct w.r.t. the IOLOCK, but then I broke it.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

