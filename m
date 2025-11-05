Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5540D1991D2
	for <linux-xfs@vger.kernel.org>; Wed,  5 Nov 2025 19:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762371946; cv=none; b=gR9d2QHZvEFonIiZKXcnyQscMoWxwHMnup39NotHfx7MYM0EaDkwC/OPBZ/Cx1gHD/D3f4IjI+zDCTQ6+3JXkfGKM3T7ajdWUqCuW9oP7ArvkGBM6blvQ64iBdPhu3pBNVxCBK3r+zx+3o5V4WWux19H5+nILhnNzp5k2Kkh3wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762371946; c=relaxed/simple;
	bh=qyboaB6H1BJRzhgveEK0A0zSIwcRXHCJVlTd05htb60=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ryBolDnHo4Yph6R9ewdkEurphcGtGxQ4Xs7F99qUYCWeiTTkSEbD3fYZMaKg1mn9VPwZ9is+rDUNNZ4QOsNaemsk3dpfnrcZ1PkP2KPt6Uz1UGLj+JzsfF6+0DaLGzT3EmqRhKLA3wH5dnJBRpfhK5Krt6r3XicYPkjBkf5rgSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C04C5227A87; Wed,  5 Nov 2025 20:45:39 +0100 (CET)
Date: Wed, 5 Nov 2025 20:45:39 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: free xfs_busy_extents structure when no RT
 extents are queued
Message-ID: <20251105194539.GA5780@lst.de>
References: <20251104104301.2417171-1-hch@lst.de> <20251104165919.GJ196370@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251104165919.GJ196370@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 04, 2025 at 08:59:19AM -0800, Darrick J. Wong wrote:
> Yep, this fixes a memory leak.  I wonder if you could combine the two
> into:
> 
> 	if (error || !tr.queued) {
> 		kfree(tr.extents);
> 		break;
> 	}
> 
> But I don't care passionately either way.
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

I'd rather keep the fix minimal for now, but yes, otherwise that would
work as well.
