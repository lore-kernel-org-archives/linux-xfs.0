Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40C019B3D3;
	Tue, 13 Aug 2024 14:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723560990; cv=none; b=BmeMusFQkHAv002u0Uwo8w8v+vy+g5e9/DIR93AMmCLMCxHbuFy+/PGsqk2BQmax/vBZ7PbhnEKrDEPz6052riDzSjundZiNS2I+YOrNndO/fEhCjqKyy9UylFdVuT46jdnarbcvdZ7GhavvkFTvW2IUBXHerXYGYUcCGdJwRH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723560990; c=relaxed/simple;
	bh=kGFUfdMXj6HRliT79PC14+UQh7Ss9NVjfdYf33o4V94=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bdky6Vafwp52Xkw7BmO8MqFHBk3bjSHJioVcjRXV70cAaMkF9G1rMTAucwWq2Hj8J9hOBUGXZI4IjqakOYcjuyDHhb/4Kg0OrMzLL9iGDYvFnPR6kGqlyHBorI3UL9nJO6zlNEPa0aY5P9KeBbDbCtpjJgZeFY9XxQrgesfWERw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0D08D68AFE; Tue, 13 Aug 2024 16:56:26 +0200 (CEST)
Date: Tue, 13 Aug 2024 16:56:25 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] generic: don't use _min_dio_alignment without a
 device argument
Message-ID: <20240813145625.GC16082@lst.de>
References: <20240813073527.81072-1-hch@lst.de> <20240813073527.81072-5-hch@lst.de> <20240813144331.GF6047@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240813144331.GF6047@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Aug 13, 2024 at 07:43:31AM -0700, Darrick J. Wong wrote:
> > +min_dio_sz=$($here/src/feature -s)
> 
> Or maybe _get_page_size() ?

Sure.  Or maybe actually query the I/O size, but I need feedback
from the authors that they actually intended that..

