Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D933A8FE
	for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2023 18:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VtdIOcn2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA0C4C433C8;
	Mon, 27 Nov 2023 18:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701108624;
	bh=LkzuF7EhCbFk6SQN6lzqszSg3BXqkC54lXt2L7AXfjA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VtdIOcn29TsgPMLOnsBSNTMby0XjhL1vlWd1guwJAZHSrwG2/MAHRRhS72kIyU+8M
	 qu9cOvbahyU/2KS2STlUiBm09qV/pNNEdPNRfrsRzEXT02a+Rthrm1bpMEdQXifSkd
	 TXvCpXgNJ4pjwnVQhDO5VefvfDOZEtaKHF+ek38N5gVFA5vuaQ+pbGa1w0wDkjgE6L
	 6Afn9m5t2DaskLtUk2wqN/Zt7+elenCYFGSra4eYDJDndYpnPMs4fCH4+KFwdI6qn/
	 q9RrflQ29FGiz0iDkRv5QYt+Ed3tgSu/gVTMBiB2p5/8Fe3i69n8HMoODL2ftxhZWX
	 14Vp1epWiEI6Q==
Date: Mon, 27 Nov 2023 10:10:24 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] libxfs: don't UAF a requeued EFI
Message-ID: <20231127181024.GA2766956@frogsfrogsfrogs>
References: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
 <170069441966.1865809.4282467818590298794.stgit@frogsfrogsfrogs>
 <ZV7zCVxzEnufP53Q@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZV7zCVxzEnufP53Q@infradead.org>

On Wed, Nov 22, 2023 at 10:36:57PM -0800, Christoph Hellwig wrote:
> On Wed, Nov 22, 2023 at 03:06:59PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > In the kernel, commit 8ebbf262d4684 ("xfs: don't block in busy flushing
> > when freeing extents") changed the allocator behavior such that AGFL
> > fixing can return -EAGAIN in response to detection of a deadlock with
> > the transaction busy extent list.  If this happens, we're supposed to
> > requeue the EFI so that we can roll the transaction and try the item
> > again.
> > 
> > If a requeue happens, we should not free the xefi pointer in
> > xfs_extent_free_finish_item or else the retry will walk off a dangling
> > pointer.  There is no extent busy list in userspace so this should
> > never happen, but let's fix the logic bomb anyway.
> > 
> > We should have ported kernel commit 0853b5de42b47 ("xfs: allow extent
> > free intents to be retried") to userspace, but neither Carlos nor I
> > noticed this fine detail. :(
> 
> It might be time to move this code into shared files?

I think Chandan started looking into what it would take to port the log
code from the kernel into userspace.  Then xfs_trans_commit in userspace
could actually write transactions to the log and write them back
atomically; and xfs_repair could finally lose the -L switch.

> Btw, I still keep getting annoyed a bit about minor difference
> in some of the libxfs file due to header inclusion.  Maybe we also
> need to be able to automate this more and require libxfs to only
> include libxfs headers and xfs.h?

<shrug> Ages ago Dave had a sketch to make xfs_{log,mount,inode}.h pull
in the relevant headers so that all the other source files only had to
#include at most three files.

I wish the kernel had precompiled headers, then it would make sense to
have one xfs.h file that pulled in the world and took advantage of
caching.

--D

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
