Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51B036C9F5;
	Thu, 12 Mar 2026 14:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773325893; cv=none; b=RBO6AIN3555jPAa8OJwySvD9gbMvwCLqtu2boYkpOrVlJjLfO0zifbcHz08RzeutQmwJ6h/uvP/7eaPwKEf32hZqVDQeLVl+75EYLwxPm2vkGQ3Sb/SfaHkhlYaIgHshTbUvpIxSFa7V2uQ8Hn1S3JpoormUZyEhws7bY7u1hAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773325893; c=relaxed/simple;
	bh=0rMt0YM2fkZ8wZp3hsTw1L+xQeYenh8rRNPYQmUrKPM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DcKrGXIyMYOAQj0mtQOIwwUzNc9EYw5AQwCaSloBirGIIHsut/mBbtLyvvwmOFJ7urO5S5Nq1wJme8o+NIZ1uYzC7gmiooZR3wnTE0SwbR1t34kev9Do/pUl4CF1Rf9j2uFQH3nyGK5YaXTTRMlQGATAUSoqErT1/gnZN5BrQJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=po75g93Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="po75g93Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB05EC4CEF7;
	Thu, 12 Mar 2026 14:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773325892;
	bh=0rMt0YM2fkZ8wZp3hsTw1L+xQeYenh8rRNPYQmUrKPM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=po75g93QpkKPxqbl+KMoG1tR6PwKwrp19MEu35F5FqZ3Hj1KiOlN6K0Osz+MYQQaE
	 vnmp0eCDQ10JUGj6lRdkX2yMZtij7CVn2frD3bPRNdHfVKIbLqrBixsr11Jb87cLJ1
	 tLXqCtGb09mVKGec9U5kPbnVaLUXiD50bxUg2Pud/myS26Fxk7XN6UmmC51Qeeyp22
	 lgb/Iu5k2CWDt7HCVE8CQP8yCWg83RJZf/Mh32ew0U2jqisPoig/azWOFEZfrIO/M9
	 f010xdOM9VQG4rPT2VRmmHd+EBpfm1sOx5szk1Wo5nyg2xwpKoS8fPpKYTKa0PDXNs
	 t4XHha3VyE0fg==
Date: Thu, 12 Mar 2026 07:31:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: hongao <hongao@uniontech.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: scrub: unlock dquot before early return in quota
 scrub
Message-ID: <20260312143132.GJ1770774@frogsfrogsfrogs>
References: <1C42C3A2C8CD80B0+20260312121026.23660-1-hongao@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1C42C3A2C8CD80B0+20260312121026.23660-1-hongao@uniontech.com>

On Thu, Mar 12, 2026 at 08:10:26PM +0800, hongao wrote:
> xchk_quota_item can return early after calling xchk_fblock_process_error.
> When that helper returns false, the function returned immediately without
> dropping dq->q_qlock, which can leave the dquot lock held and risk lock
> leaks or deadlocks in later quota operations.
> 
> Fix this by unlocking dq->q_qlock before the early return.
> 
> Signed-off-by: hongao <hongao@uniontech.com>

Yep, that's a bug.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: 7d1f0e167a067e ("xfs: check the ondisk space mapping behind a dquot")
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
> index 1d25bd5b892e..222812fe202c 100644
> --- a/fs/xfs/scrub/quota.c
> +++ b/fs/xfs/scrub/quota.c
> @@ -171,8 +171,10 @@ xchk_quota_item(
>  
>  	error = xchk_quota_item_bmap(sc, dq, offset);
>  	xchk_iunlock(sc, XFS_ILOCK_SHARED);
> -	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, offset, &error))
> +	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, offset, &error)) {
> +		mutex_unlock(&dq->q_qlock);
>  		return error;
> +	}
>  
>  	/*
>  	 * Warn if the hard limits are larger than the fs.
> -- 
> 2.51.0
> 
> 
