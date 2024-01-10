Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388213F8F0
	for <linux-xfs@vger.kernel.org>; Wed, 10 Jan 2024 10:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uFdchFJ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DADAC433C7;
	Wed, 10 Jan 2024 10:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704881706;
	bh=UAkXMCxAQkjCbyFQ1wpk6vp3A8ADtsqcU663ltrSonA=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=uFdchFJ4WLwrnR3drHhT+siDd3EVCsaW4HB4lylfV7wyrOVmQ/2tVztiVXo4pPFhc
	 /6nquRklIc8xJtxQplTWlnkC2x6zMlrndi8DTvEzBc34MTRbzlpqqZ8UVNnF4ULAn0
	 EP3xya2FboLcfUNNkD1gLBMo+PLV3nA5PsFbG8Sl/DOa6UVpuu40S0457uLa7y6H8P
	 KUL8KtrjtpKEKNO7iBZhOxF2ixU6DCneAt0GzCMgMtqY+tOhWfbbTYB6OPauvuUspM
	 DabksKC4we0LVjHopW52uhoxW8L4ow18t9E9PPed2AebV3wVhzuqqqIriQH9X9GlxU
	 svu8LjxxUkLdw==
References: <20240109021734.GB722975@frogsfrogsfrogs>
User-agent: mu4e 1.10.8; emacs 27.1
From: Chandan Babu R <chandanbabu@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Chandan Babu R
 <chandanrlinux@gmail.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix backwards logic in xfs_bmap_alloc_account
Date: Wed, 10 Jan 2024 15:41:32 +0530
In-reply-to: <20240109021734.GB722975@frogsfrogsfrogs>
Message-ID: <87cyu9ijfc.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, Jan 08, 2024 at 06:17:34 PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> We're only allocating from the realtime device if the inode is marked
> for realtime and we're /not/ allocating into the attr fork.
>
> Fixes: 8a3cf489410dd ("xfs: also use xfs_bmap_btalloc_accounting for RT allocations")

The commit ID should be 58643460546d
(https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git/commit/?id=58643460546da1dc61593fc6fd78762798b4534f)
right?

If yes, I will fix it before pushing it for-next.

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_bmap.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index ed7e11697249e..e1f2e61cb308e 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3320,7 +3320,7 @@ xfs_bmap_alloc_account(
>  	struct xfs_bmalloca	*ap)
>  {
>  	bool			isrt = XFS_IS_REALTIME_INODE(ap->ip) &&
> -					(ap->flags & XFS_BMAPI_ATTRFORK);
> +					!(ap->flags & XFS_BMAPI_ATTRFORK);
>  	uint			fld;
>  
>  	if (ap->flags & XFS_BMAPI_COWFORK) {

-- 
Chandan
