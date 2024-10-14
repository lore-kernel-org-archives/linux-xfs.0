Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75EAE1537AA
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 15:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919831; cv=none; b=oS2w3Z9Nr7bHNoojSTQWfvABYZRyiAi9byNNchm0PVIigX4m3mq20Th4R0apSBlxcq556EFFAI6uWe2oKorvd4ZWzmZFASrUyW8kqrqpvxfLacwFXcRzhHH4tNekzVDKfBrY3QpAKp8jSGXqlp1TqmLuqIJSMm1WbmSOLC4nTJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919831; c=relaxed/simple;
	bh=kYjHgA0L9kJyG8cgri1pkHRjPCnBpJlayOygR0t0XAA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FSH2WLrPx7xtw82TWWr9xQLh9EX/q3muequMKy39JLf6se47to7RwCzxxax193Y929q3KuZgInjQRvJaJVPQH/5edEtt0yardPG7OnjXkIqTMt05ztBpRL8zS4BzAeac4kJbWmnZ4KiT2z4fxyVehHqSILIVOHKd1/yNIo0ug94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o3AX/EDU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o3AX/EDU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A36AC4CECF;
	Mon, 14 Oct 2024 15:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728919831;
	bh=kYjHgA0L9kJyG8cgri1pkHRjPCnBpJlayOygR0t0XAA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o3AX/EDUdrG+PRIYmdu8xmPk4LrXLCErevEu7vu0XtuLpwksFfp4lPz9X+6eg0AZZ
	 z5duCIPe3rfW7hOEk/gSztGKEfJq0VbBhY0Q2hWFK1zV1QgXa7x1ONS9Mq3GStPpaf
	 DdwD0ghl1jE3xaOn0k/4/BFNOKsKrZTHkGvX0/f1Ct2Cfo0jTcjoUonYsFdTgRNc4B
	 SU7sGWzLTOPBGyU9Pt/ThCwCglbao45d0CPRGxLIYgIiZkNpn/Zuj+n0v25gUxUezN
	 1hPyJHpVDqZ2DXjdlAOiIYmHjuyp+Im7/10nHEx4bdJpenyWrBx+f10OVpFt3P+9vn
	 KnTSTIOBwt2Vw==
Date: Mon, 14 Oct 2024 08:30:30 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Brian Foster <bfoster@redhat.com>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: don't update file system geometry through
 transaction deltas
Message-ID: <20241014153030.GH21853@frogsfrogsfrogs>
References: <20240930164211.2357358-1-hch@lst.de>
 <20240930164211.2357358-7-hch@lst.de>
 <ZwffQQuVx_CyVgLc@bfoster>
 <20241011075709.GC2749@lst.de>
 <Zwkv6G1ZMIdE5vs2@bfoster>
 <20241011171303.GB21853@frogsfrogsfrogs>
 <ZwlxTVpgeVGRfuUb@bfoster>
 <20241011231241.GD21853@frogsfrogsfrogs>
 <20241011232906.GE21853@frogsfrogsfrogs>
 <20241014055850.GA20485@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241014055850.GA20485@lst.de>

On Mon, Oct 14, 2024 at 07:58:50AM +0200, Christoph Hellwig wrote:
> On Fri, Oct 11, 2024 at 04:29:06PM -0700, Darrick J. Wong wrote:
> > Ahahaha awesome it corrupts the filesystem:
> 
> Is this with a rtgroup file system?  I can't get your test to fail
> with the latest xfs staging tree.

aha, yes, it's with rtgroups.

--D
