Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8875E47B403;
	Thu, 20 Aug 2026 16:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787241790; cv=none; b=DzEZlEsKZQZ1j3cPfZJEya1Y+9BmwWs4cOHzrKs5dE2vjmpq8NSNzY6LlCKE7H5BsX8y+Ut/044RIjbNRIffMBMFbovfkXBMUnq/TVSTLlU4LB61md+D50UCDSvcWxlzi2wAPP+mkFBK47ZJJ8yAgDdvCSnhlXfnxeU4pM8bR5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787241790; c=relaxed/simple;
	bh=79njEvy2rSaDlEBjbDGZScgHuc32FVQeY5eDwhGFe3I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WpQoHTqsWmqcSHmoCswkb+WtsuPioNr0raeYfcIcovrdTxl2h1R5h8ngOK1gJ00MVyGH5LuyG/roK5pIx6rq92z2lKomDRGEnad1nOMJF2+0vC5ldvdWo9bXBf4AKj4Wo3Uo0mGGAR8UEck/eccLZoWPPl6shUwlIQIgQdmq0DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NX+en0OT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NX+en0OT"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 297C21F000E9;
	Thu, 20 Aug 2026 16:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787241787;
	bh=jIDM9QrPHZ5JzGz/UgBSk5V9sug2PcAZbty74ofBA8U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NX+en0OTTl5PiErfZbevke8QgLjC5VD3CdlWZe2MsnFeecQgqDJquZ/6kQtj1anKi
	 NJikc4muqHOYL0zITAI4CahsuuotfHMzl2XNbaM7p8lbcOXu9WdcoZIiFht5V85p/B
	 Nj08BE+3RYMt4s6ykK2KprtdiKeHFm7Xes4vhJvnltD4Ufssoz5twe2UksFzz195iv
	 nxKoSa+RX14dM0T+Z1Vbnuiu12vNYX3AUbfXaugbCDz56wplSGZJ5BlpCc9YyzdJ6s
	 tTDN8cEf5NVSml4DAK0U3oEMyl7TGwhzuqWJmH78o7rxAR7i5kVKMbNIVRfcDsitTS
	 p+xqdCIzpWE7g==
Date: Thu, 20 Aug 2026 09:03:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: fix xfs_rtrmapbt_mem_cursor for non-rmap
 filesystems
Message-ID: <20260820160306.GG6072@frogsfrogsfrogs>
References: <178659861838.833922.2269351780488724470.stgit@frogsfrogsfrogs>
 <178659861897.833922.17703139818760252058.stgit@frogsfrogsfrogs>
 <aoVKR4HmS3Hi7WBg@infradead.org>
 <20260819231943.GD6072@frogsfrogsfrogs>
 <20260819233025.GF6072@frogsfrogsfrogs>
 <aoaTA8AASaqKykLe@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoaTA8AASaqKykLe@infradead.org>

On Wed, Aug 19, 2026 at 10:39:15PM -0700, Christoph Hellwig wrote:
> On Wed, Aug 19, 2026 at 04:30:25PM -0700, Darrick J. Wong wrote:
> > On second thought ... the slab cache that we use to create rtrmapbt
> > cursors always makes them big enough for xfs_rtrmap_maxlevels_ondisk()
> > levels, so we always consume that much memory no matter what we set
> > bc_nlevels to in xfs_rtrmapbt_mem_cursor().
> 
> Make sense.  Maybe add that to the commit message?

Will do.

> With that:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> for the original patch.

Thanks for reviewing!

--D
