Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABADE1A3174;
	Fri,  2 May 2025 19:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746214783; cv=none; b=jjy7hpabIhef26uNehKhcCRHeLl4Y7DlmwKrDZZ2iiTHdbhdaad0+L0MIfjkcnBUgGbd1YXomX/nuTvFwYdWSq2TXeDiN0gTSCWh9rpwp8rw2AZhWm+nJM4QtP4rzn81FNa+JaEfVVJ6AqEFOdkfbuNnJ5VkeUfDsVg6XxqQ+Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746214783; c=relaxed/simple;
	bh=k5ESsesPC5OR+0zT4B5/ZWz83ketQ0H1TXs4uooMZp0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V+bvZXsc2vN5LhUIcK99j96bRSRLRMpwhinVtXEiZtxUlCVkuMijnzwvpuNhToiZTPpsa8Wc34BC5h2H5gN4i3dRVtap39/EwQhzrF15dMsdWFwtke682wj4SEYPVOODCi12xEDUHR8j6MoSeZsaUP4U8At3nDid7RF3WPtwofE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A4uZ5IuG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A4uZ5IuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AAD0C4CEE4;
	Fri,  2 May 2025 19:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746214783;
	bh=k5ESsesPC5OR+0zT4B5/ZWz83ketQ0H1TXs4uooMZp0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A4uZ5IuGHOfHXSImjmXrn8i2zJAXx9Yv1KTG4MS2fbFXXn3ZIJWUkbW/bngiuP6+q
	 uMzCpJvuyC3HkeoJNx3MFQMzfZTwQyo+sAE0GvC2o3rrB9pDG6ANp4bnmZN2mmC8JV
	 +TQRvSox212XUAjD2sxoYvXlOdWQ+NPdiTNMmpK9pL74FzsmF2bJbrTplBckUhw0xv
	 LlZuqAHQmVW92+guMa1lo6gIwBNaNN08wC+xkHSjpS0utOHe0R0NFA67W3hQDB4Mkk
	 bWcHx875FWkwgxqsRsNEQJZ5MCBJWjYrAnIBgRNxVhJLg6kD5lPNATCEu9EhSL1BE0
	 yYbHbgFhwN+MA==
Date: Fri, 2 May 2025 12:39:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH v5] generic: add a test for atomic writes
Message-ID: <20250502193942.GP25675@frogsfrogsfrogs>
References: <20250410042317.82487-1-catherine.hoang@oracle.com>
 <aBRwTFxik14x-hyX@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBRwTFxik14x-hyX@infradead.org>

On Fri, May 02, 2025 at 12:12:12AM -0700, Christoph Hellwig wrote:
> This fails in my zoned device tests with;
> 
> mkfs.xfs: error - cannot set blocksize 512 on block device /dev/nvme3n1: Invalid argument
> 
> that error turns to be because the scratch rtdev /dev/nvme3n1 has a 4k
> LBA size, while the main scratch device has a 512 byte sector size,
> which is a configuration common for but not exclusive to zoned device,
> and which means that we can't use a 512 byte block size for the file
> system.
> 
> I'm not really sure how to best add the case of a larger LBA size on
> the rt device to this test, though.

Me neither.  We can't write 512b blocks to the rt device obviously, but
I think the whole point of the separate "sector" size is that's the
maximum size that the fs knows it can write to the device without
tearing.

Maybe there's a way out of this: the only metadata on the realtime
volume is the rt superblock, whose size is a full fsblock.  Perhaps we
could set/validate the block size of the rt dev with the fsblock size
instead?

--D
