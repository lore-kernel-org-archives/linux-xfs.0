Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80DB30B535
	for <linux-xfs@vger.kernel.org>; Mon,  1 Dec 2025 12:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764591664; cv=none; b=nw5DsiqP+RNpIHmREj6s9/dl0VIcRcG+P0aXOHIu/V7ZCmlYUzaJeQGvnwSfnqUTj0JjvIBBl/qV3P+ZEQGSSZ1ru9OqeeR69M56P5rKeiXvnr3ZhKPsOECIIq6CVzthId1GHKPHzzf3/WmeNbPKQokYf8XxP9RbT30xRuMK4Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764591664; c=relaxed/simple;
	bh=WAAXC8RfUyhXrGjHtHGb2e3QVCGpxa7z8hu1OAoTzFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CDiKg1Nly5hl+v6wG/ZqYWQdET0F6qxpYnXcmem10yGYjuitxebnAoKN/1M1Mwei4xkyrgR6V2GVW1H2SJRrHh85JYjkOAWBdFHyWY048itD/oakf0cBAlv8k7s7y+zlp8VnQuzA3IOi2LFNsZRWT3VYh7aOLwWDxkFZKKkoppI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sA/L2kiG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sA/L2kiG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0D9C4CEF1;
	Mon,  1 Dec 2025 12:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764591664;
	bh=WAAXC8RfUyhXrGjHtHGb2e3QVCGpxa7z8hu1OAoTzFI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sA/L2kiGau+MSzQfxFcwjf6pXuxkogBMjIgILUbyceWprRlFJ/Kjv7Fb10N0wgK5O
	 zTrPZ58jLGjFENgk4i3wXJQ2apF25zZ20oyeX9AfgeJWgdEBMxOz58jVCUh+QfRktV
	 kX8q2jTxnDLZp4HRRMAPJiBWc5fDVf2wOZPHyf6REa9U8gBlhZ10g9Y7qYSOlHIzs5
	 qKbLmmVoUZKpcgGVT6ZKQSvJagfluXZKs9rTlL6almXk9ohTYrrYKNXN4hi8FGSBVX
	 ELuy8G07G8/GTAKe+2UUhtgE+pRc+DZBRhhi1Zs71GPejEbq9WBNZqUS1pJxRjSDc2
	 Yds7AGpTqHpmA==
Date: Mon, 1 Dec 2025 13:20:59 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, 
	Johannes Thumshirn <johannes.thumshirn@wdc.com>, "hch@lst.de" <hch@lst.de>, 
	Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
Subject: Re: [PATCH V3 6/6] xfs: ignore discard return value
Message-ID: <gmyjpg2u6ddq3ndvmnxgosggo6uanjiplsxevve2hfbaajorln@lfhnef3iwq3g>
References: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
 <20251124234806.75216-7-ckulkarnilinux@gmail.com>
 <cHPDNEYuyhvyCtcgWEpBm2RRGpqTzjAaRzYfs89Kf4m9g2N5QYgxvA-yVTyUXmsl-ai5noj_VSSRisEN4nJlGw==@protonmail.internalid>
 <d9a0eb14-c532-425d-be8b-b6de58e8db31@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9a0eb14-c532-425d-be8b-b6de58e8db31@nvidia.com>

On Mon, Dec 01, 2025 at 06:28:56AM +0000, Chaitanya Kulkarni wrote:
> Hi Carlos Maiolino,
> 
> On 11/24/25 15:48, Chaitanya Kulkarni wrote:
> > __blkdev_issue_discard() always returns 0, making all error checking
> > in XFS discard functions dead code.
> >
> > Change xfs_discard_extents() return type to void, remove error variable,
> > error checking, and error logging for the __blkdev_issue_discard() call
> > in same function.
> >
> > Update xfs_trim_perag_extents() and xfs_trim_rtgroup_extents() to
> > ignore the xfs_discard_extents() return value and error checking
> > code.
> >
> > Update xfs_discard_rtdev_extents() to ignore __blkdev_issue_discard()
> > return value and error checking code.
> >
> > Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
> > ---
> 
> Gentle ping on this.

Thanks for the heads up, I'll queue it for the next batch
> 
> -ck
> 
> 
