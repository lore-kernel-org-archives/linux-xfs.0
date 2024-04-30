Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8920D127E2F
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 09:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714469891; cv=none; b=l59d7Nk83veQHh1JJNaHEoK6DVco3cQUNJA5hqhL1pW7T6DTcbqw7Fi32KVt4u3j6rL64fI886eTyC8Gaofc79Mfebz6aq4XfrivVi2215LpXSgzu2Y+Ery0OzauXtGiUU0bRjBaoMZe6AZoAOGggmkSvO+EMz8xWVyNfeFSnJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714469891; c=relaxed/simple;
	bh=+95jUhtf4xjAcDvQVI05s+bxMiNPBSFGfJ2XolWF97M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K7jaox5hRId++lJVMc7AvP/0pHmpcrSL28nukV66c/9pQG99UBenrgMXpx4jtBXRAvDsnaWjz1u8LXgbVavAo9350fGT9Ow9N/3jUSLO/ZDQPH8FiBedkb55vKvG58TNHZhCmeowI41Ik79p5jDu7oBCzFqnufLT8Dyanz2Q6Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B222768AFE; Tue, 30 Apr 2024 11:38:05 +0200 (CEST)
Date: Tue, 30 Apr 2024 11:38:05 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8] xfs: optimize extent remapping in
 xfs_reflink_end_cow_extent
Message-ID: <20240430093805.GB19310@lst.de>
References: <20240429044917.1504566-1-hch@lst.de> <20240429044917.1504566-8-hch@lst.de> <20240429154344.GA360919@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240429154344.GA360919@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Apr 29, 2024 at 08:43:44AM -0700, Darrick J. Wong wrote:
> Nit: This loop actually queues multiple intent items -- one BUI to
> handle the unmap, one RUI if the rmapbt needs updating, one CUI to
> decrement the old data fork extent's refcount, and one EFI if that was
> the last ref to that space.  So I guess 128 of these is small enough not
> to overflow a tr_itruncate transaction...

I've not actually had 128 hit by xfstests, to stress this patch I did
reduce the number to 4.  I played around with asserts a bit and
I can reliably hit 64 items, but I haven't tried bisecting further.

> before the xfs_defer_finish call, and with the same file block range as
> was unmapped in this transaction.

Indeed.  That's going to be a big rework, so for now I'm just going
to resend the reset of the series to get the fix and the cleanups in.

