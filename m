Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795121385;
	b=Vg3pg/t9m0uTEBWze9QDmyTAKL9YxR3qW+oobNjKFG1px+9MJdVE6WKf5qsexPqM22CR
	 mZJRn8bs6emi0niHtwwS+zhY9A9NuhEau2v2VSbuzVBdXijobNcBEAzGroHC13vOnqYjm
	 DjmljN5DJ6PM7+irFjVa8P+wOkflkiQEW0bjVDjJQdxsd5Mln6jV+6GhzArKpKyWrYplH
	 nwtoz/Lqqq6TjgMmtyFisG01QUE4Cu/ivNg1fqWst8TEgWFMlhzKO760Iz3++ptr0/+Xr
	 dfvlWREDPM2/ITKL8zwMTxUeTxr/bNjYGDYQdNwrijiF1z3N5Di2m4H9riRrIx3mbVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795121385;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=6uUyYlgjM4gUdz5mj1dp5lYq0596fRi9TUMCukh9VpQ=;
	b=rP2lrXWpmuKpLCwJ6TXESEtwkbHdNAURHNefVse34z4WRtwv+MCikcfQ7z/H+radPO2q
	 k7rro/UKSasYTlLnQv1ye47upO7OLFM6pQXgIDMy6/s656s/D/kRosoOQSI5LN5IVV6CU
	 z092tk0RhDy1wMwICdRbWfaXNRhkh+65xxk6bHhsvzLhDHlC2kEhs1gx0tOnmjrW/zIYv
	 az7R/sRnelxsPm6vsmXbkol/ixpw6VKuP1JUbWya/Fac6QefyYDKiSWG5lDyCTgJKr/JA
	 1zL0ZC2GEm1m7JjTB1iDrX40QatCHqreaWx+CXUWKJxV/5Qd9IaL8TVYCI+EQXvqlwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XUsuVD2N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A48B606A905;
	Thu, 19 Nov 2026 20:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XUsuVD2N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C419A1F000C0;
	Thu, 19 Nov 2026 20:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795121384;
	bh=6uUyYlgjM4gUdz5mj1dp5lYq0596fRi9TUMCukh9VpQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XUsuVD2NP90/zfhUq9QbKDAGXZhdmG7O0dpAwPuMLXYuHA+VoVSq3LwTuzGNJ2xoy
	 pV7h6GlpNWJZdh+tQ7T8BoZICBsaA2neeIJsyeGJPjHbEd8sWe8qD312t0m4XYkqV/
	 LoSlP2csABz4sBDz1ttLmKZMKk3vQnxk3YuS21AsxlarQsWPozwmZMwptG4NWo0QR9
	 N1wVktid4Bxzu54Xfs2Jy80X4EjDqQKBN1ZyQpXn7zh7DxjSVlmxETqGvXpTodcoIJ
	 /PHgRfyNNNvlC/QJrm8d/c88bX+m/rrMjwyCSXG6XjQiLY63pymmDeSx+CM73mL4Pd
	 /Lts2Y92lgbmg==
Date: Thu, 19 Nov 2026 21:49:39 +0100
From: Christian Brauner <brauner@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: ebiggers@kernel.org, hch@lst.de, fsverity@lists.linux.dev, 
	dsterba@suse.com, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	viro@zeniv.linux.org.uk, jaegeuk@kernel.org, chao@kernel.org, tytso@mit.edu
Subject: Re: [PATCH v2 2/5] fsverity: add I_VERITY_BUILDING inode state flag
Message-ID: <20261119-geben-irren-erspielen-4456e4be9246@brauner>
References: <20261105115532.613467-1-aalbersh@kernel.org>
 <20261105115532.613467-3-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261105115532.613467-3-aalbersh@kernel.org>

On Thu, Nov 05, 2026 at 12:55:27PM +0100, Andrey Albershteyn wrote:
> Every filesystem that supports fs-verity keeps a private runtime inode
> flag meaning Merkle tree is currently being built *_VERITY_IN_PROGRESS.
> They all serve the same two purposes: reject a concurrent enable with
> -EBUSY and let the write paths recognize the special writes done while
> the tree is under construction.
> 
> Hoist this flag into the VFS as a new inode state flag,
> I_VERITY_BUILDING, and manage its lifetime in the generic fs-verity
> enable path. The flag is set after ->begin_enable_verity() succeeds and
> cleared after ->end_enable_verity() returns (both on the success and the
> rollback paths). Add the concurrent-enable guard.
> 
> A new helper, fsverity_is_building(), is provided for filesystems to
> query the flag. No filesystem uses it yet; the per-fs flags are
> converted in following patches.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  fs/verity/enable.c       | 22 +++++++++++++++++++---
>  include/linux/fs.h       |  6 ++++++
>  include/linux/fsverity.h | 21 +++++++++++++++++++++

fs,fsverity:

as prefix, please.
