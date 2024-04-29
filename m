Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67FB83A15
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 17:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714411203; cv=none; b=nelg7wZH4ZpThyLemxt4l7ngpvJHrcaRcds0gdj+gkLIL8pdakmJ92o9mZqGVAWGBY8zoMFI8Lu2u+qm5TzygAtShp+Szffdhu+t1VyEDmXjcszfIU1oQXFXIdOfw1ze6zvwjMPkdVfUT5gi6+OFPsHBsZh+cVBOv0sLEWVFJQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714411203; c=relaxed/simple;
	bh=6vH7DKtxlmfwXrd0a+WrIb57ab2pppkUkEaSaL066r0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UVGHrMnZ0R8fvQpHrVpY6GjYnkvoI3s0gHt4bqw0AzoahXuYHBFtj+UScmRlL5JQGHZhJ2aUm8k6LQaWlEiVt4zet8/OZTn26/aUZVfEgEiOHgqS1cd4ue8K6zE0I5+w8nkaha5c/7mVxdSdw56XmZ+pUuWHiivoqLVAMPXv9jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bUneaAPY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bUneaAPY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F17AEC113CD;
	Mon, 29 Apr 2024 17:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714411202;
	bh=6vH7DKtxlmfwXrd0a+WrIb57ab2pppkUkEaSaL066r0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bUneaAPYVf7ahsTzjhFg7Ol0yTpLCgqxl1z7P9j1bbmC477rJxABohGtXEBtPYCWb
	 hCxrYRQjwLvNLARoebr4EZXoM6BqfjUucVy3HwiTub5LfOa4A6l1pK1U4zv2Ti2r5l
	 H7l/4sPFYgGZbZx61Sg8QqqKrpeo/wj707jVmi2wBu55lPXiBp/vCMlZ/NBbq1Ydf/
	 t+Ie6p3polFYVMFQ0Kf99TDIpZ3o80DNxMCcpFFgOpH3c324497VN8tSa59whO9vFa
	 wPn5hnliT0QOpAjt2ja3rUI/uPZGgikaF/Q/0CQ+89JZzwN/XXINuSAJmoHFiQDCwj
	 QYNIkdWU+5SNQ==
Date: Mon, 29 Apr 2024 10:20:01 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: pass the actual offset and len to allocate to
 xfs_bmapi_allocate
Message-ID: <20240429172001.GG360919@frogsfrogsfrogs>
References: <20240429061529.1550204-1-hch@lst.de>
 <20240429061529.1550204-6-hch@lst.de>
 <20240429154817.GB360919@frogsfrogsfrogs>
 <20240429171840.GI31337@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240429171840.GI31337@lst.de>

On Mon, Apr 29, 2024 at 07:18:40PM +0200, Christoph Hellwig wrote:
> On Mon, Apr 29, 2024 at 08:48:17AM -0700, Darrick J. Wong wrote:
> > Referencing
> > https://lore.kernel.org/linux-xfs/20240410040353.GC1883@lst.de/
> > 
> > Did you decide against "[moving] the assignments into the other
> > branch here to make things more obvious"?
> 
> Yes.  I did the move and then noticed that I'd just have to move it
> back in the last patch, which feels a bit silly.

Ok then
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

