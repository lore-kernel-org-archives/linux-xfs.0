Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C430EC2EE
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 09:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SDp6uoHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD92C433C7;
	Fri, 24 Nov 2023 09:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700817347;
	bh=dp+0gp84gJnx4zARhESoSh7gaxWndKXAoq7ltKmdNcM=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=SDp6uoHROEJ3Lkw69l27CcOeZPylXn6GmaqquzGfPtAyHoJjQn35uxVm6QKPHqQ81
	 lMIS9Ft2+Vg3aaGJKN3fKDKgwz6NMerjnycVv8Kdy/ntirCird42YwYAbj9Dw9oUgh
	 0woZMSiKpL7/lbI4jt7Y2/MTdMKJwDKMoBtF9MBAC0wS6C3f07nidYTu+A/KU6XNpt
	 MmU9Axy4nZCzi9dqzd+6JMFTKoKtl1NQyFi7C7AGkzr5ieDpYfofdwlZrc1ZBVE29R
	 tRAU/bPxLacvHYekvuNZtd2zT/urVEkCxV1Y5tyll7B/Pysrt6PD0M5INsIVs47oIq
	 RjKEuo2wqd46A==
References: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
 <170069441966.1865809.4282467818590298794.stgit@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From: Chandan Babu R <chandanbabu@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] libxfs: don't UAF a requeued EFI
Date: Fri, 24 Nov 2023 14:40:00 +0530
In-reply-to: <170069441966.1865809.4282467818590298794.stgit@frogsfrogsfrogs>
Message-ID: <87plzzwlz3.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Nov 22, 2023 at 03:06:59 PM -0800, Darrick J. Wong wrote:
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
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanbabu@kernel.org>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  libxfs/defer_item.c |    7 +++++++
>  1 file changed, 7 insertions(+)
>
>
> diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
> index 3f519252046..8731d1834be 100644
> --- a/libxfs/defer_item.c
> +++ b/libxfs/defer_item.c
> @@ -115,6 +115,13 @@ xfs_extent_free_finish_item(
>  	error = xfs_free_extent(tp, xefi->xefi_pag, agbno,
>  			xefi->xefi_blockcount, &oinfo, XFS_AG_RESV_NONE);
>  
> +	/*
> +	 * Don't free the XEFI if we need a new transaction to complete
> +	 * processing of it.
> +	 */
> +	if (error == -EAGAIN)
> +		return error;
> +
>  	xfs_extent_free_put_group(xefi);
>  	kmem_cache_free(xfs_extfree_item_cache, xefi);
>  	return error;


-- 
Chandan
