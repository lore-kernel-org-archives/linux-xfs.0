Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1048440C;
	Fri, 12 Jul 2024 15:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720797529; cv=none; b=glsl/UDK5qhYGnuwyJ5pi379jupmfa+3tohgiJ6QPTFdVGvBDsAHJcA04u4lmvIXxAx7Z7u9u2MEF62D+7D933bKLEj1zRrBMXkg5GznwfhQOdA4W7pL4FQJQA5cg4gRDzvMl1At7dWMK42x1hblBmsSL9QA+YdRm3TUkVZfkTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720797529; c=relaxed/simple;
	bh=M/p6+O1hBUvWmBfOokNka/pO7EbQq2s+zuwR9vSFEv0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e/8rXiGtExp1VjTT1b+7LLWScmuNgQpCTrDRgJiKB1FIqHYkU/rVocgTH/8wmb/cJiKoquVHLGydvuurWWHkueKEOqSrXvc1NxGTOW6YR03iLNq4zObeVj2q/NMKZFSTrOkHLb7HyMqiYQbw/vO/eTjjGHeIrVNtdBACMQy0FzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ctgqHdtA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ctgqHdtA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60003C32782;
	Fri, 12 Jul 2024 15:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720797529;
	bh=M/p6+O1hBUvWmBfOokNka/pO7EbQq2s+zuwR9vSFEv0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ctgqHdtACHhfnQSeLWPfph3tHQNwG0p1SOYjCosiMn38IoB1ZxDFFaL/iBlU8k0ga
	 aZeLshB03MKios0YWjg0AdphwLnzlDDiqux2+gx+EvaP7cKXQsCw7GPtOfwL96VQUy
	 GcEZW/uPILOAp+DmOVGv07jNWjz7ckr1KKjmQwzoDFSZtx7xoFlbKh1clt1fMFzM+n
	 ogbGDOa05svsEQl+T7f6TnczeITR2bfvZXVczlIvNUZifRMNTpwotkG4UweaSCF55S
	 oE3DBboBU5VP8PRM9r2iFE7h0pREQAL9XNPL7/uis2SpPvq2mhierKP5embuLhsTyx
	 nP7rm+8sFXLZA==
Date: Fri, 12 Jul 2024 08:18:48 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] xfs: remove unnecessary check
Message-ID: <20240712151848.GS612460@frogsfrogsfrogs>
References: <a6c945f8-b07c-4474-a603-ff360b8fb0f4@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6c945f8-b07c-4474-a603-ff360b8fb0f4@stanley.mountain>

On Fri, Jul 12, 2024 at 09:07:36AM -0500, Dan Carpenter wrote:
> We checked that "pip" is non-NULL at the start of the if else statement
> so there is no need to check again here.  Delete the check.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>

Yep.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_util.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
> index 032333289113..cc38e1c3c3e1 100644
> --- a/fs/xfs/libxfs/xfs_inode_util.c
> +++ b/fs/xfs/libxfs/xfs_inode_util.c
> @@ -308,7 +308,7 @@ xfs_inode_init(
>  		    !vfsgid_in_group_p(i_gid_into_vfsgid(args->idmap, inode)))
>  			inode->i_mode &= ~S_ISGID;
>  
> -		ip->i_projid = pip ? xfs_get_initial_prid(pip) : 0;
> +		ip->i_projid = xfs_get_initial_prid(pip);
>  	}
>  
>  	ip->i_disk_size = 0;
> -- 
> 2.43.0
> 
> 
