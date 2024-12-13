Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EB8188580
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 05:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734067350; cv=none; b=ugLZKGxkuuwjQkRDYoBmm7BdYOkJ5YXlQKOjflAjXNA4aI49mQKKaMHyg8xJii4KJmiGKiBSFYIfm76UXO4amMma4MYVP8hoe7fEL0aok0VfzD69+Ylh9BP3nX+NQVh19Bvbqrk71xrSdKdOpGL3NWh3J7QA5fFTlx2czfZBS0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734067350; c=relaxed/simple;
	bh=qFSjNfLFJb/NOyv9+mqJFhuCiZLqCNjInGVI6CTe9B8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ScJ78XmxTTqoL2EmU+hXJhBVGvFFALLEqsWu05Y6n9i8ipjbzj3Ez3tzvTBYVPaD596aKp4za3VHUVxCyAKtj/rHFcPdjipC+Q+P1+crOtTOTjXrTsqVZ/bTKJbL9y5M9j8JLecrbU+KE+6zTU12ZB6Na/jLC58JXDnoqvPCRFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C630F68BEB; Fri, 13 Dec 2024 06:22:23 +0100 (CET)
Date: Fri, 13 Dec 2024 06:22:23 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/43] xfs: don't allow growfs of the data device with
 internal RT device
Message-ID: <20241213052223.GL5630@lst.de>
References: <20241211085636.1380516-1-hch@lst.de> <20241211085636.1380516-18-hch@lst.de> <20241212220727.GC6678@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241212220727.GC6678@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Dec 12, 2024 at 02:07:27PM -0800, Darrick J. Wong wrote:
> On Wed, Dec 11, 2024 at 09:54:42AM +0100, Christoph Hellwig wrote:
> > Because the RT blocks follow right after.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Aha, I was wondering about that.  Does this belong in the previous
> patch?

Sure.

