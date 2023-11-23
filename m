Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hKHheKiO"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C19B41B2
	for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2023 22:36:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wapePl4ZQywkP2b7YjEv00/PdVkX7QnTaNxYfxyXhjI=; b=hKHheKiOcuqyYNzjGbeebqNiA4
	lvIZ9Yj+q7G1iY1Nf9Ecl+FskcpEYXTwZUyPXY4YEdo9jn2V8IJi9KuZf4b7OdP+vi7WW3WOxgZKs
	4wQwVIRVMttczvToVdNyT+n0w+X+gCCsGCFSdG9WZlCpQPHl61NGAcVirMVa7jsfddpRU2uIyZF5T
	eAB0vI2HvFPIzV5jcLOO9OW0+JeCHUsdu2vzGyhB1Fcz+RIRuNjAmBhmhqCt+faolKIHP5QKLe7/K
	QmD8CaewcYRyF7DxkixthYhOGJhm9e7sf/G1VRz3tCJSZph2xtt1NVn5IbjcG6XCFh02skKpLnU5p
	QEBrrQiQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r63Kb-003vCD-2A;
	Thu, 23 Nov 2023 06:36:57 +0000
Date: Wed, 22 Nov 2023 22:36:57 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] libxfs: don't UAF a requeued EFI
Message-ID: <ZV7zCVxzEnufP53Q@infradead.org>
References: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
 <170069441966.1865809.4282467818590298794.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170069441966.1865809.4282467818590298794.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Nov 22, 2023 at 03:06:59PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In the kernel, commit 8ebbf262d4684 ("xfs: don't block in busy flushing
> when freeing extents") changed the allocator behavior such that AGFL
> fixing can return -EAGAIN in response to detection of a deadlock with
> the transaction busy extent list.  If this happens, we're supposed to
> requeue the EFI so that we can roll the transaction and try the item
> again.
> 
> If a requeue happens, we should not free the xefi pointer in
> xfs_extent_free_finish_item or else the retry will walk off a dangling
> pointer.  There is no extent busy list in userspace so this should
> never happen, but let's fix the logic bomb anyway.
> 
> We should have ported kernel commit 0853b5de42b47 ("xfs: allow extent
> free intents to be retried") to userspace, but neither Carlos nor I
> noticed this fine detail. :(

It might be time to move this code into shared files?

Btw, I still keep getting annoyed a bit about minor difference
in some of the libxfs file due to header inclusion.  Maybe we also
need to be able to automate this more and require libxfs to only
include libxfs headers and xfs.h?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
