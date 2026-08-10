Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A8B3FA5CD
	for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 15:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786375401; cv=none; b=c5pq2rKavEOIWFYUzxbOXu/YpPyJIezojUgINRCb69BXGlTtO4Ur7jjdj47U/fzDCDvYwdOMpe2hSa2z7SLRO4c5nPpjiB5OQ2MLK0I6PmyQOtvVhDyrqDH8doOxOJ8rddzmdE5QhGipt6IB2io0CWpF5kWd3D7j5z2+mUdT3Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786375401; c=relaxed/simple;
	bh=58J7DB/UqPEcjZ2Jdqf3n2NXLDLxd1GXWsUMbvgqdQc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S1LT8IBQeyuqOFHlnWeVlfajsSxkg3Ldf/pNuGuSD9J+wZX2KcbN81KrEPwhYsASqZpGLjJqogOWUVXRidjPz12ERlXi99j2ZapVGqd/vnbUEGHRTso4gdFCsYsAc99BFsJw8VUD6w7GsGm/8erjAcxAbfsNHO2udtLV60F9INg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E0D4A68B05; Mon, 10 Aug 2026 17:23:15 +0200 (CEST)
Date: Mon, 10 Aug 2026 17:23:15 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, hch@lst.de,
	cem@kernel.org
Subject: Re: [PATCH] xfs: fix IOMAP_F_DIRTY flag overwrite in zoned DIO
Message-ID: <20260810152315.GA19201@lst.de>
References: <20260810152132.495705-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810152132.495705-1-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Aug 10, 2026 at 05:21:31PM +0200, Andrey Albershteyn wrote:
> Missing IOMAP_F_DIRTY prevents completion handlers from updating i_size
> on the direct IO path, the flag is set but was overwritten by
> IOMAP_F_ANON_WRITE latter. The writeback path for buffered IO doesn't
> seem to require IOMAP_F_DIRTY and looks like an error.
> 
> Fixes: 2e2383405824 ("xfs: implement direct writes to zoned RT devices")
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

I actually have exactly the same fix in a series I'm about to send
out, and a cleanup to move this into common code.

I guess we both saw the same Sashiko comment :)

