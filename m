Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F27447206E;
	Thu, 15 Oct 2026 18:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792089931; cv=none; b=JJxuY3tYF/KW3yXY2COrS7sqqX3Kvg9cmDSCNmkWUlzWSRDH0n2weSfaxuVtTB6w86zld22J7zZZGsUOOH8sY5fKxJGP7u3422VAVMOrCFSDBIbMMSF+gWy77R136EuruRq2XnsP2vFTee66PHQjIGnW3k2xpY2xm3BGlCse1xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792089931; c=relaxed/simple;
	bh=I3tZdMdmCIOWHEnGl7YfWCGmIzALv0Koq+Ihui0HSpE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qdTPFQAZGTeOWWvPVQKs3qbIeOWBUjWvN/wSj5EwqHdHcWvO4d9Dn1syeTX2iFMk7BVBUHiWngRZ2t2pbepXGsWm8DYroFWtY+ks6LZvzDV4S/C0pR8etDCUo66phd3PdJ13gjjuGv+1rLURRhkwPT/HDP7Eqg0t8oXRw27KJRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R5rKYFZh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R5rKYFZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A9451F000C4;
	Thu, 15 Oct 2026 18:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792089921;
	bh=FEcWZLTNpOdYCiy8ICkVMEhy7qL2+iG3Q/NPD6O3NxQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=R5rKYFZhRXZWfuTnYXY/AYUnin7tCz5ny4vGO7V25Wof3xtB6rS2SeaOmUWkjdaMp
	 C+l55ixgDWTiyniul0IUb6382kPGVIhE0vcmzvc+NisiUafwVsXNGqKleO8P9neoSr
	 8JFOQTLWlbusFRBGAZh0rvLmTpI8kASrHTtuNu2xD31fr3ZRcYsZmeAsY512QorkLH
	 R7miFL0y0o2O71qhHrKe80HlYEXtkGcwKHANU8vrWnYrJ3CkIeNPE1nmFrzXQLRR4O
	 MHj8Ks5HObqeHlJYU46OUqvx7nq1VFWG1iWNfubUN5fcHzhMwvN3D9HZrzxUvqPxiZ
	 mcYmDj+J4JkHg==
Date: Thu, 15 Oct 2026 18:45:19 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Baokun Li <libaokun@linux.alibaba.com>
Cc: linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, jaegeuk@kernel.org, axboe@kernel.dk,
	hch@lst.de, djwong@kernel.org, brauner@kernel.org, tytso@mit.edu,
	berto@igalia.com, adilger.kernel@dilger.ca, jack@suse.cz,
	yi.zhang@huawei.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH 03/13] blk-crypto: reject fallback data unit sizes it
 can't handle
Message-ID: <20261015184519.GF2170687@google.com>
References: <20261011170958.1759230-1-libaokun@linux.alibaba.com>
 <20261011170958.1759230-4-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261011170958.1759230-4-libaokun@linux.alibaba.com>

On Mon, Oct 12, 2026 at 01:09:48AM +0800, Baokun Li wrote:
> Such keys exist on filesystems whose
> block size is larger than the page size, because fscrypt uses the block
> size as its data unit size by default.
> 
> Fix this by advertising only the data unit sizes that the fallback
> really supports, and by rejecting keys that the fallback can't handle in
> blk_crypto_fallback_start_using_key(), so that the failure happens when
> the key is set up instead of during I/O, and before any data is written.
> 
> Fixes: 488f6682c832 ("block: blk-crypto-fallback for Inline Encryption")
> Cc: stable@vger.kernel.org
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>

Several patches in this series are marked as fixes, but they seem to
only be needed for encryption with data_unit_size > PAGE_SIZE which is a
new feature in this series.  I don't think these should be marked as
fixes, as they will cause unnecessary backports, CVEs, etc.

- Eric
