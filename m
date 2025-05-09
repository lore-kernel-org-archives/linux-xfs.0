Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC2F2110
	for <linux-xfs@vger.kernel.org>; Fri,  9 May 2025 14:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746800846; cv=none; b=b1aJTJXKlMFkY8J3Rh8Kq5AiZu0MzFhKYz5qmQmicBDCuNe5B3MRoe7sRd1y4H99P2oX52sZDtmJegMTgRoBEQoHbwobpYuNxdaTUqgq94Ouk4L9CdCueRBQwkwu2GOCIv1aeQkFQwx/F0SFdG/Rcia+etie1LmrsKyxaOVGL1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746800846; c=relaxed/simple;
	bh=7INa349h6C0oFFV5nLvfnkfFSUvB5dyKIGXBwNxQT+4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QVKBRQSj5Oaya8I/qY5U2cRXywW06mP/7sESyjPI/9W6DG8icSt/pV/bUT/4D45umYxRXBxBow78roeXcDAh/ih5Qd65zTBhhJnUfDA9SPhXV0zQp7g4cNj6IjWSJ17ZAxcRlP8EiJmDJfx/vzbMOrpxz0J3aXe4MmM21gBcoTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fAL2sgMb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fAL2sgMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD03C4CEE4;
	Fri,  9 May 2025 14:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746800846;
	bh=7INa349h6C0oFFV5nLvfnkfFSUvB5dyKIGXBwNxQT+4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fAL2sgMb8IJPa9BBkdm5ddt33FNZVLHeEqg+w2ngJJyQEcr9NL6TqbI2RxvflVwW/
	 VKMbF32HFk/CEZTt9c7RG770vT+Q/reQef/L5Q/ZJy3Z92QkkGjv5vX72uir2OBwjT
	 /R38lRMPBSKmySjsZectMp3vvbfS/pS9gknslnxHUkcbVy+nVB34vXhxlGZVTwK2w+
	 ANVZNevr3EIAqaTPuyd2YjXkGQoIwmLGWWbnvmhelY5z6m4+gytanZh9O7x7gwrZh+
	 Sfyst70nmq7JyElv1oUmx8Cpno2yeUOgAtPceXikTYb33QHFVY7qoRoke7+TIdfcbF
	 mX+mSgFbXbHwg==
Date: Fri, 9 May 2025 07:27:24 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Daniel Gomez <da.gomez@kernel.org>, linux-xfs@vger.kernel.org,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>, gost.dev@samsung.com
Subject: Re: [PATCH] mkfs: use stx_blksize for dev block size by default
Message-ID: <aB4QzM8PTC2qD9EW@bombadil.infradead.org>
References: <20250206-min-io-default-blocksize-v1-1-2312e0bb8809@samsung.com>
 <Z6WMXlJrgIIbgNV7@infradead.org>
 <323gt6bngrysa3i6nzgih6golhs3wovawnn5chjcrkegajinw7@fxdjlji5xbxb>
 <Z61wnFLUGz6d_WSh@infradead.org>
 <hljsp2xn24z4hjebmrgluwcwvqokt2f6apcuuyd7z3xgfitagh@gk3wr4oh4xrt>
 <Z7RFQQoC5J7Dl6HC@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z7RFQQoC5J7Dl6HC@infradead.org>

On Tue, Feb 18, 2025 at 12:30:57AM -0800, Christoph Hellwig wrote:
> On Thu, Feb 13, 2025 at 02:26:37PM +0100, Daniel Gomez wrote:
> > That's a good question. The stx_blksize field description indicates the value
> > should be referring to the fs block size that avoids RMW.
> 
> One that is optimal, the RMW is an example.  This what Posix says:
> 
> blksize_t st_blksize    A file system-specific preferred I/O block size 
>                         for this object. In some file system types, this 
> 			may vary from file to file. 
> 

So this should just be repsined with this just stat blocksize?

  Luis
