Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F94F1A8F98
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 23:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734131651; cv=none; b=dMa3O8PvGV7zm23276qiRsRlrPhMpfAcoYUiC98pCjHR3QnP/zdIUss5ae2B6rIANckSQUWd7h1/gN+t734JtuVKF++VB4rPwZK7lXJUvGfcqlU7TphO3RgveMRBuTBd4T02VWQFPtxCa08xAsUCnl5TLQPrxE9lOjwlTmMQ0lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734131651; c=relaxed/simple;
	bh=DKaf3SuPYtlw2svL9/XqAQCXVWNE8BwMhTrzkWzB0dg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WiOun3YCZqpqU+ftQ68auEZRMzx4w2EY0Z2YWft5d7tkmJZuEsJpSeO+6UV3QrTiqN8+OHVGTLaIPaLMaMjuVqfG6CxjYuzKr3N4DBxv6KMAekxrofOt/D3uIh/DzrY+5AeC1qjMMDyCMJTxPEPVnzBbWkVVhKf1GgVVSuVijKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OuFu0Kej; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OuFu0Kej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5AA5C4CED0;
	Fri, 13 Dec 2024 23:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734131650;
	bh=DKaf3SuPYtlw2svL9/XqAQCXVWNE8BwMhTrzkWzB0dg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OuFu0KejepOZ4foZ4/M8k8MKcmy1MVvWbVWGvL1z7HVGrsEQBFFxtHVahe5B1AigR
	 OgWDPBtsMZ8OSCbp1z4ceS7sT04kFxojk03urua1WMmPULCj50aXzcQbi7t3cgYFVe
	 W7SqNQju+ZiYabxWqWfqDePIWL+BcA0DIh1RlhoDAZbzbCt9QvBQ+C2+nr7rAx5jWN
	 V0Vpuar/mjSa6LH5pk3X8E3UZL4z8u4FW4RXU2Kw6BYOGt2NlBEiNuWK0gbhJ+Lk2Q
	 S4tsWVqdZmFWoM0qpXkw3LN447ovcL7J4pBLbTYelCYhXua41w4YgRKzG6edXngHCN
	 tvHza3oih2kiQ==
Date: Fri, 13 Dec 2024 15:14:10 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/43] xfs: refine the unaligned check for always COW
 inodes in xfs_file_dio_write
Message-ID: <20241213231410.GH6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-13-hch@lst.de>
 <20241212214442.GY6678@frogsfrogsfrogs>
 <20241213051400.GH5630@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241213051400.GH5630@lst.de>

On Fri, Dec 13, 2024 at 06:14:00AM +0100, Christoph Hellwig wrote:
> On Thu, Dec 12, 2024 at 01:44:42PM -0800, Darrick J. Wong wrote:
> > On Wed, Dec 11, 2024 at 09:54:37AM +0100, Christoph Hellwig wrote:
> > > For always COW inodes we also must check the alignment of each individual
> > > iovec segment, as they could end up with different I/Os due to the way
> > > bio_iov_iter_get_pages works, and we'd then overwrite an already written
> > > block.
> > 
> > I'm not sure why an alwayscow inode now needs to require fsblock-aligned
> > segments, seeing as it's been running mostly fine for years.
> 
> Because the storage you test always_cow on doesn't actually force
> always_cow on you :)  I.e. these segmented iovecs can end up overwriting
> a block.  That's ok if you're on a conventional device, but it will
> error out on a sequential write required zoned.

Fine with me then :)
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

