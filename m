Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E3D158A09;
	Tue, 10 Jun 2025 14:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749566760; cv=none; b=EMVxibgFVXBcPswChBIoKHf4g3cQ2TKWnx0Nq4KjoVV1SwvE7o9SoBreqto6Meo/KD1bLOOQ9F2XC33Q9voVQi6yyuIJrW7iiji3Ivd1pnXHbhok+I3lWy+QS1Yjh6G/9oO1z1MA/YxZU0coU86W1JZKpmRU822xP+thaej6eCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749566760; c=relaxed/simple;
	bh=J9nGwxfwXz5iylx/qn3XaM0i2N9hObkU173+pStnLoI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ppPEX/nK+c5c/sHAkuy/c21+/3lsJbZfRlKpCuN6Bna6LF6iNVEiyAcyeKI4QPN6/pyhZxiXDb5QIL6NeLzCFOZQ8Zj4IBxGd6oiiSQq8mz9kqXSr/D5oiSz1vd0YW2ZU1q+U1Seq+5Ea/Yp1hu4tp/bjrZFlZIgP4IdV6I50CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cDLQFtgt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cDLQFtgt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883A6C4CEEF;
	Tue, 10 Jun 2025 14:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749566760;
	bh=J9nGwxfwXz5iylx/qn3XaM0i2N9hObkU173+pStnLoI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cDLQFtgtl0JSeASXXjyDwEy7Inh5tlw/03f7nCwxLofeoGhCx5RrWcsePlsouegFv
	 uzEMBfPdEHKRj0/SGcN5pO5Wm23wiBfuAdtfK0ZDU1bfUxRgXWUZeaxZmnkWbtnGJS
	 fG3bUoe/AmGo5wz22xM2JaSeqNVOR7pNGg/5ENhriKbuUhNga1vCrLMgtbJN8n+JAI
	 4u2ZVuhveAb/d+wzpRnVrn3acS32j3AAAvCGhI/wuEZKYyPM3tiGHOk8Swche2HDJi
	 tVhZfZmWp6KuDHlLmgVOyvknKQwoqspLKBSWAKgHWvXQ1oKZ9pzGUEMGRO6xpBmdo9
	 eDPnjjUe1R//Q==
Date: Tue, 10 Jun 2025 07:46:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Ma Xinjian <maxj.fnst@fujitsu.com>
Cc: zlang@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs/603: add _require_scrub
Message-ID: <20250610144600.GD6143@frogsfrogsfrogs>
References: <20250610091134.152557-1-maxj.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250610091134.152557-1-maxj.fnst@fujitsu.com>

On Tue, Jun 10, 2025 at 05:11:34PM +0800, Ma Xinjian wrote:
> From: Xinjian Ma <maxj.fnst@fujitsu.com>
> 
> This test uses xfs_scrub which is an EXPERIMENTAL and unstable feature.
> Add _require_scrub to check if the system supports it.
> 
> Signed-off-by: Xinjian Ma <maxj.fnst@fujitsu.com>

Oops, thanks for the correction.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  tests/xfs/603 | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tests/xfs/603 b/tests/xfs/603
> index 04122b55..d6058a3e 100755
> --- a/tests/xfs/603
> +++ b/tests/xfs/603
> @@ -20,6 +20,7 @@ _require_xfs_db_command iunlink
>  # until after the directory repair code was merged
>  _require_xfs_io_command repair -R directory
>  _require_scratch_nocheck	# repair doesn't like single-AG fs
> +_require_scrub
>  
>  # From the AGI definition
>  XFS_AGI_UNLINKED_BUCKETS=64
> -- 
> 2.49.0
> 
> 
