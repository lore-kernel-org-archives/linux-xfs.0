Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794351427;
	b=v+GEi6db+EsPfKvUh5qrzyxpVXRX+kqBax9By0sz5WaTY8WXZQ74Bxt/Y5qRIfbEZZKq
	 pra4/uVFD3Fn2MVEQrbOItAybxssBHYoweZ1hvwx5pm6sGW22/9TuPiEjN2S/V2+jiiI6
	 Iq3GqOd1H0Z8LkZYg7moN3NA61L9glBjGQoRFiwzp/Dpl0dPJeelq8yka0asMtYP3oLAI
	 TIm4oyKzq0s6v03Qp4R7dcPUusPg5JPCxgfuhv/Ytk8JW2w5xChP+ViYtALnLf+QukmKk
	 q9hmzTyytv8vvfLTKQDsYVaFW5SLCcEJ6EY2K5Xboad1vl8Xd6iO1jE+50pZFwyeq8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794351427;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=zMRt6PxEL6Wb2BMxAkW75q5nCrNja3XGEsRDEq4iENw=;
	b=xanwRIs5bwA4hggq/VStjlO6CbW4vGBOvgAfioo3DdDe5oxK2pBh9huvuXE2pkHL7Xxc
	 5dwd8lOg9edX8dsDPWxQeDGa+Hm8v0tLNDxnxbGX7HJpUxQxZoGqs7uhjms8mAHjnpShl
	 0HWlGiq8dAzQLUW6D/xKaI1qE2sZUuxwJHRxlS+D3lK/OTLNPxgI0r6FghRIQkutkNy9+
	 iT1G37T5jEdozALUvtJJEtHWh2fms0MTkME5wqY4w+hC3mFl/dWuubTx0VrE8NLVdV5oH
	 P7QvWTzZ2PE5le4j15BvBRxGMUUUclWcXNUl6ahM4NJt5Szx2biNUrP2zdOkeDr1+RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ojv7JGOS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F92B606A31C;
	Tue, 10 Nov 2026 22:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ojv7JGOS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875021F0093C;
	Tue, 10 Nov 2026 22:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794351427;
	bh=zMRt6PxEL6Wb2BMxAkW75q5nCrNja3XGEsRDEq4iENw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ojv7JGOSi3XNYPhiz1NFjZjFtyIvIIfkCWUkrQJM2myd+KQysLMT6+MFgXCpigUrG
	 SpzfWVOfHM7ZYNv1UZ+v/QRLRkpOKnk/FHJZTSD4vCT3tBjLbbQ2Dlm517GYNkEDfB
	 x9ESehVJ1jovfuAHVBPWJyEQDR500o8rMdhM/f8UT/4K/KTFT170fl93Ghuh7YQJG+
	 tyMom4SqIfHTgVJJz+Q1vXGcBqJkzE84onU5Rt1Nj8kJnQpPHgIU5vGA5woxVEPFEY
	 +GLu/2NR9OpzpyceHd/Vs6d+b2VuxJt4fR7Pia5FB1V4uj+Zx+7vErQuyXYR6udgum
	 4WlnjgFgHLddg==
Date: Tue, 10 Nov 2026 14:57:05 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: hch@lst.de, fsverity@lists.linux.dev, dsterba@suse.com,
	linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jaegeuk@kernel.org, chao@kernel.org,
	tytso@mit.edu
Subject: Re: [PATCH v2 2/5] fsverity: add I_VERITY_BUILDING inode state flag
Message-ID: <20261110225705.GG1907@quark>
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
Content-Type: text/plain; charset=us-ascii
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

A couple things missing:

    * Comment for fsverity_operations::begin_enable_verity needs to be
      updated, as it no longer has the -EBUSY case.

    * show_inode_state() is missing the new flag.

- Eric
