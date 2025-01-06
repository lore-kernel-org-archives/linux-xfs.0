Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15475166F1B
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jan 2025 19:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736193016; cv=none; b=haJhFYUVgIeICwSER6DObpQiZ3llEf9djOTi4s0SUKmlTHuJcMERYlqKahHjndoj0BjJDumyt58AlNAe58gg9KHHC/BuEsMXNqPGlCYDefOCXuC4BdOHsD1VX4rYWHKHkqJa9fMzDrGaqKYruvpxWS8kh66qpk1V+a8OvxfuVDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736193016; c=relaxed/simple;
	bh=qZrIRS5AY+T3wFVH5bchscLnpfKuTFiolBE5u9YJtJo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jjBAhgAIac71CDKDOzLWm1Faz8ANOGJx0hsONTdXe4VlmK1mAXcjA0hJtPWFQmJATeyzvLudHC1W4Zp2IOrIvr62tMETIB3zmrOjobJPqCGPnurkNhfc5YCCOa9nxfkznJKovGfk7Amo6QuHRBquIvoCuBZPTzP/hdo7+svEQBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DwJM5dU+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DwJM5dU+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D45C4CED6;
	Mon,  6 Jan 2025 19:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736193015;
	bh=qZrIRS5AY+T3wFVH5bchscLnpfKuTFiolBE5u9YJtJo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DwJM5dU+nwUCGSKcgsIHw8TN+vonD+32cSpVmC0jNZtWpSASvaF/rCBxa0QUbwM9z
	 +gRhDxznUu5+5fP+9ZqWh0o09OR0xy+VUiN5cST3vY4UsgNrrbmqUic5FqS/gHal+5
	 cb9d0HAiYINhFfQcEcGIBwJDpz9OQyoee/LWYDiJMcGLGd2AxCKEvDpx5aKbNdytYJ
	 dXeE/qsKyWRhYrMpjUtIVr/BrOQPllCOoq2FkPv+qiTwYVZsBKOni2MxBP2ptFCUqm
	 W4J6dCLXFhN5caR9UGh7Ldd0D0IpU4GCSMfMRhBSoZ68u6m20N5el8DcNJnlUhtnSK
	 hfs+AaOsCCM7A==
Date: Mon, 6 Jan 2025 11:50:14 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@redhat.com>, linux-xfs@vger.kernel.org,
	david@fromorbit.com, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [RFC] Directly mapped xattr data & fs-verity
Message-ID: <20250106195014.GI6174@frogsfrogsfrogs>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
 <20250106154212.GA27933@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250106154212.GA27933@lst.de>

On Mon, Jan 06, 2025 at 04:42:12PM +0100, Christoph Hellwig wrote:
> I've not looked in details through the entire series, but I still find
> all the churn for trying to force fsverity into xattrs very counter
> productive, or in fact wrong.
> 
> xattrs are for relatively small variable sized items where each item
> has it's own name.  fsverity has been designed to be stored beyond
> i_size inside the file.  We're creating a lot of overhead for trying
> to map fsverity to an underlying storage concept that does not fit it
> will.  As fsverity protected files can't be written to there is no
> chance of confusing fsverity blocks with post-EOF preallocation.
> 
> So please try to implement it just using the normal post-i_size blocks
> and everything will become a lot simpler and cleaner even if the concept
> of metadata beyond EOF might sound revolting (it still does to me to
> some extent)

I was wondering the same thing -- why not just put the merkle tree
blocks well past EOF and use the regular iomap readahead functions to
get the tree data read in bulk.  Plus you can do readahead optimization
that the fsverity code seems to want anyway.

Just be sure to put it well past EOF, since the current weird thing that
ext4 does (next ~64K after EOF) would seem to allow mmap reads of merkle
tree content for systems with really large base page sizes (e.g.
hexagon).

--D
