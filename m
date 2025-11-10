Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B526F2E6CD4
	for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 18:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762797812; cv=none; b=jUkKnzqHrk8ljQuSkx4RlMzfJB6xYSkxMjecyIoxzPqaWxEB3kP/Yiutjmhg76IK4P/MOcch1xpY1palv5+NoZe/Ufd0R21CTKNguuEXHHdUyNxKNSiG1vIC0yFKj7AOQuKLCiJYshIFlU5JxQvP/CkyTf8Z1ueeQcfjAgZ+XXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762797812; c=relaxed/simple;
	bh=MNTKBUtkGeH48b+5tQeuXrgBmOJEh574fYj53hKFPPY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eL7s1liUK86QJc3noF3mssqp8Q9Km4KtzLuwSQX8+rH9J8kGARTcmqU3pGxBhh89AzpnauP7SLg7ZIO26IfE1J3cLq6TljgMlCrRWmAWW9PEnFBilytDOlCbqo9MKjdyKjS9Czu1hiH8C2yDCGsQgN9iBzxl+t8j6vJvBu3t4pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IJCdasL/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IJCdasL/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE3FC116B1;
	Mon, 10 Nov 2025 18:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762797812;
	bh=MNTKBUtkGeH48b+5tQeuXrgBmOJEh574fYj53hKFPPY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IJCdasL/igHf7k3TLaLOISPasaRvwfK+3NvkHeQJ2k4vcklg4zVmDc7KTPC7wItPN
	 bOxm5y5bvGYnacGlh5dQul9BRNwM4nHg9yWJQ2TriBZpX8ccjD8jhrOfHo1Y8hiWL4
	 6hShnK7vFLWJYxIBKJ6F37g2jSxbZ5F6lGxSU160uM2Q1UjYZo5ZpvCN6hcuwrb4j/
	 pzrrAxKNQ2Vq/P+SemHUWP3xVucVj+6++mUECkDOeZrGQwhQ3mRbBlBvreMbtxNCLp
	 dX4whd4gjc8Zpn6ZVJOmi82LS8Z+BSnDillb3t1P0b8RLHhnSweV4cqhcAATQpllq2
	 VpT7MqQdNSF/A==
Date: Mon, 10 Nov 2025 10:03:31 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [PATCH 01/18] xfs: don't leak a locked dquot when
 xfs_dquot_attach_buf fails
Message-ID: <20251110180331.GP196370@frogsfrogsfrogs>
References: <20251110132335.409466-1-hch@lst.de>
 <20251110132335.409466-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251110132335.409466-2-hch@lst.de>

On Mon, Nov 10, 2025 at 02:22:53PM +0100, Christoph Hellwig wrote:
> xfs_qm_quotacheck_dqadjust acquired the dquot through xfs_qm_dqget,
> which means it owns a reference and holds q_qlock.  Both need to
> be dropped on an error exit.
> 
> Fixes: ca378189fdfa ("xfs: convert quotacheck to attach dquot buffers")
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yep, that was a bug, thanks for fixing that.

Cc: <stable@vger.kernel.org> # v6.13
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_qm.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 23ba84ec919a..18a19947bbdb 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1318,7 +1318,7 @@ xfs_qm_quotacheck_dqadjust(
>  
>  	error = xfs_dquot_attach_buf(NULL, dqp);
>  	if (error)
> -		return error;
> +		goto out_unlock;
>  
>  	trace_xfs_dqadjust(dqp);
>  
> @@ -1348,8 +1348,9 @@ xfs_qm_quotacheck_dqadjust(
>  	}
>  
>  	dqp->q_flags |= XFS_DQFLAG_DIRTY;
> +out_unlock:
>  	xfs_qm_dqput(dqp);
> -	return 0;
> +	return error;
>  }
>  
>  /*
> -- 
> 2.47.3
> 
> 
