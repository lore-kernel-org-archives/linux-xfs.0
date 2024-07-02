Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDE82A1D7
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719897749; cv=none; b=HEINFECpr9QNpkR3w5T+NPAlzCYVYPaBFZqyZ7hnXq+crACMjYChjnaOPEuGrMMRia8Eg8BBcelRDdPOiBNGyqp2V+ujjrT+lKLHQ9Z84P1m/6rrcWHyHBjAlgGbKzIXDgEV0iOKBH7mtc7BNxq80PPDGlJ/Vses3aAuyxwzdlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719897749; c=relaxed/simple;
	bh=5fpqp+vBAmeiIlsNj1z28ot/8QpmUnUNBFwKwY8tG7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TtlLRsERVg527NfaaQRsfXPiHD5E1in2PBE0t/fgDM3lHhZoLjM4siSlydATkapEbTWjRo3kvyPlK1BJCwRMa3MEavvqhlUQRDGCT12YaxdbkP4Use2ewZtkmbqKFCHxzOVksKg+pMtsUPxjU4vH5cWYfbq3Mm3ccu3Xn4oHNWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6014F68B05; Tue,  2 Jul 2024 07:22:25 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:22:25 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 03/13] xfs_scrub: add a couple of omitted invisible
 code points
Message-ID: <20240702052225.GF22536@lst.de>
References: <171988117591.2007123.4966781934074641923.stgit@frogsfrogsfrogs> <171988117657.2007123.5376979485947307326.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988117657.2007123.5376979485947307326.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jul 01, 2024 at 05:58:10PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> I missed a few non-rendering code points in the "zero width"
> classification code.  Add them now, and sort the list.
> 
> $ wget https://www.unicode.org/Public/UCD/latest/ucd/UnicodeData.txt
> $ grep -E '(zero width|invisible|joiner|application)' -i UnicodeData.txt

Should this be automated?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
