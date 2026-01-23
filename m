Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E53332EC9
	for <linux-xfs@vger.kernel.org>; Fri, 23 Jan 2026 07:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769151700; cv=none; b=lzKFxUeocd7lKeS0+B9r/P1h+1agDXrdnJIKcPepB2EFz0rgNxeLFh4AEcA92AlDGSZ+4oR7BdmEQe8QKMH3wyvF9okXljY4jOS5umHy1LKGrj7D6npx1Rt8J0ZGMaW+h6drLKJNNcIfoYSH6C2OKTTw1AgeO/JJSy3afYCNdPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769151700; c=relaxed/simple;
	bh=2dY+uegfP7QmkFBDA9tlvAmT3GC7yw60EwaBV948yIQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DbD4bk1T18n7zFyt7kc0V0p0yBp5K3AFMB/AWliQ5rcCMmX57AlRRMk00r/2I6VNd4ZaObfGsCZ/U/YCh6UmGD+aoKZI98AgSqRFkLFw/y5ftrdsZ4rjjkx/zIjM95JohybQyFv35B6KFHwkIY3O73IpmIbv067f0H7hHXp+YzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HAvugkm0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HAvugkm0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00620C4CEF1;
	Fri, 23 Jan 2026 07:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769151700;
	bh=2dY+uegfP7QmkFBDA9tlvAmT3GC7yw60EwaBV948yIQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HAvugkm0/mVkQ5TX791lwxiN8FHGCBTr4tGKko2bb6KoSrmat5FduYYk5XE8otaGb
	 NdK9e+r+OeywuDYvk6X1OVZPbu6K2W8e4hVER8mBbDK5+0w/ShTZARy5zqa1zWNCGe
	 QVRRcVmXi4ZMuvJ5ClTiD6NuM/4erb69FiLObDnp9jeCQUJf+MHRP6KaDQYYHtpIT7
	 Aya7Kh2trL1/RIfh6lx1TUmU0gcsY6QBLHj6daQrouTr9NqBpE3pjDzR/rSRxjaL3G
	 oDAJNlynBogJilIg7YSnghv3UFlJxJitVlZFzAy5Xq/mFU0xNK+wEqq0zfBz8GVt7E
	 FN84KWFC5aBOw==
Date: Thu, 22 Jan 2026 23:01:39 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org,
	syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com
Subject: Re: [PATCH 3/3] xfs: switch (back) to a per-buftarg buffer hash
Message-ID: <20260123070139.GP5945@frogsfrogsfrogs>
References: <20260122052709.412336-1-hch@lst.de>
 <20260122052709.412336-4-hch@lst.de>
 <20260122181012.GD5945@frogsfrogsfrogs>
 <20260123053619.GB24680@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123053619.GB24680@lst.de>

On Fri, Jan 23, 2026 at 06:36:19AM +0100, Christoph Hellwig wrote:
> On Thu, Jan 22, 2026 at 10:10:12AM -0800, Darrick J. Wong wrote:
> > Anyone want to venture forth with a fixes tag?
> > 
> > (Though I wonder if a less invasive fix for LTS kernels would be to make
> > unmount wait for xg_ref to hit zero, though I guess that runs the risk
> > of stuck mounts if someone leaks a xfs_group reference)
> 
> I tried.  It probably is the patch that initially added the per-ag
> rbtrees:
> 
> 74f75a0cb7033918eb0fa4a50df25091ac75c16e
> Author: Dave Chinner <dchinner@redhat.com>
> Date:   Fri Sep 24 19:59:04 2010 +1000
> 
>     xfs: convert buffer cache hash to rbtree
> 
> but as I can't reproduce the issue locally, and getting syzbot to
> verify it required horribly hacker to avoid lockdep I can't actually
> confirm it.

Yeah, I, uh, rely on syzbot reporters to test the patches because I
can't make head nor tails of the horrid reproducer code it generates.

Granted, the reproducer code is a lot less awful than it was back in
2017.

--D
