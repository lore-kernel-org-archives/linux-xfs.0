Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28AB533FE08;
	Tue, 27 Jan 2026 10:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769509895; cv=none; b=A8LNp97CUmwRfqNXBoq/uQZrkaLI8F7suq/gM1vZ8Mq4OilvoweVgAHWQWEsG2LKG1c5O3/UrQFxERJhZOH8aEDyqS3necWkdKlSF7KnLp1+IWqvxTOVmduoW/q7/95pNkay8wKF9jBmG9tufxqIaBULVgIdGmLFhifsu2kBNes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769509895; c=relaxed/simple;
	bh=yez8CxCaJvQdm0pFsZYXYFvGPQwxl8sc40KXS7WLMao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rco23tuptvjxy5JHrU3kZgK5yts18VE1Xd7EPWIjABHFf+Cm9hvCaXMMgrXWXche/TUln6c9Y5lna+dUvqwEiln8bgVexKKb2YOs891heTnp4NiWzNIKDxeSrgbLh7hEOaumJLRp+06Cdo+MzOCzKprE/bhKe0YoKqsVhSvXYg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jCsabYyg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jCsabYyg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA25BC116C6;
	Tue, 27 Jan 2026 10:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769509895;
	bh=yez8CxCaJvQdm0pFsZYXYFvGPQwxl8sc40KXS7WLMao=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jCsabYyg1Yh0toV4raRWeB0w052zRrIQIPMTaAsVzG58wRJzE/U3nUnLpzCJLN2jY
	 dKFHFv/Y97VUUIgUc5+0LfDfHoRCnTHkjHU5SSGTIgA42bqhDfUyr5YlSKqRls6g1Z
	 E2dA1E62ZAjsLfu3getHhtKVtFBQlxrkW4Vn4mfiDetWqiellOrBpALD3bISUOwLVL
	 01SxuohvYEQ9bfSPvaDCzRdkF8D1MC1z2lxIUPU5OyfsrqF9jRom7FBm3L9u2GWM1I
	 LIPNeZ8sde/d1d832ikbCUW8g1GztzNi3nMkpCiZcOdwStCLKGrmYwGHzwKeRBGdG4
	 SpM8Mh7BiJtsA==
Date: Tue, 27 Jan 2026 11:31:30 +0100
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, "Darrick J. Wong" <djwong@kernel.org>, 
	Carlos Maiolino <cem@kernel.org>, Qu Wenruo <wqu@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: block or iomap tree, was: Re: bounce buffer direct I/O when
 stable pages are required v2
Message-ID: <20260127-dezent-ungunsten-0cc7a56917ba@brauner>
References: <20260119074425.4005867-1-hch@lst.de>
 <20260123-zuerst-viadukt-b61b8db7f1c5@brauner>
 <20260123141032.GA24964@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260123141032.GA24964@lst.de>

On Fri, Jan 23, 2026 at 03:10:32PM +0100, Christoph Hellwig wrote:
> On Fri, Jan 23, 2026 at 01:24:08PM +0100, Christian Brauner wrote:
> > Applied to the vfs-7.0.iomap branch of the vfs/vfs.git tree.
> > Patches in the vfs-7.0.iomap branch should appear in linux-next soon.
> 
> Hmm, I have another minor revision in the making.  This is mostly
> spelling fixes, removing a duplicate page_folio call, adding a new
> comment and adding symbolic constants for the max bvec_iter/bio sizes.
> 
> I also have some other work that would conflict with this in the block
> layer.
> 
> What do you and Jens think of waiting for another quick respin and
> merging it through the block tree or a shared branch in the block
> tree?  There really is nothing in the iomap branch that conflicts,

I don't mind per se. I haven't pushed this into -next yet. We can also
just wait for the next merge window given how close we're cutting it.
