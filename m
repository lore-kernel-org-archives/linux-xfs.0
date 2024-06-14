Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751F3146D60
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 03:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718337286; cv=none; b=VXnXJlK9lsXu5PAoHb8scy1oPcOho6XymznHFJ0rbUNdejZ+bjYLmdQZa0O7dn/wpj9IAQcx7DXchFTbd5hYNUwN29ooqW3z5+3X3BYMnoCbqxKROZ5YeRNlvcNefr3KyFHQc7dDtjTSO8k5kdhf+skuZ5ToJT9bpBdB0wja8jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718337286; c=relaxed/simple;
	bh=BkAXDbiqXxyCU0g/YguKNhiV1LTtTvmOk27l24Y9Lr8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bD6NvLo4IXxpnfz/VDXvlth6N6jGwAq2JeUdGT871SyMopJnbN2IZ6LQKJCi2DOPOl3Xw0UfuRVJlkSgF+EHNeaNcQj5E+x68X2U6fpM0odgWe09zJ9dT2Y+JvqxHDlV3NN6kFLbwV1oLC1biae9L30sVtvY19C7dKHDOP00BgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZBgDEIX0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZBgDEIX0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0221BC2BD10;
	Fri, 14 Jun 2024 03:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718337286;
	bh=BkAXDbiqXxyCU0g/YguKNhiV1LTtTvmOk27l24Y9Lr8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZBgDEIX0sa/oGS09RUzYlY1Btgrnmb2xiRkUHC4fR8+yCKIdmY5BfrZwlTWgwAbqQ
	 xq0Lm2uecn6TvFD3q3Evy507YoLpWI6mJHOkRQgGNWtJq87A7Lhe2qo3hjceV/P2C6
	 tL3fZaDkvdmxbruZtBWCagoIvrBspQ0qq0GMR9WS93t4vVhu4EQoH43Lb6SACl605D
	 bG+5n5aSNiMLiO6fJes/iZuyNu8l1rV444aHLjNltw/P7p9utPoWCm7V/ONCRZRMlP
	 W8mUQQNyvIj8AsVar1MAqZ/+aHc6B4twS51vQXCXn97/8LNn6t6wbH5gvWlS7WWJ0T
	 YNgIiWqwq8xGw==
Date: Thu, 13 Jun 2024 20:54:45 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Bill O'Donnell <bodonnel@redhat.com>
Cc: linux-xfs@vger.kernel.org, cmaiolino@redhat.com
Subject: Re: [PATCH v2 4/4] xfs_repair: correct type of variable
 global_msgs.interval to time_t
Message-ID: <20240614035445.GE6125@frogsfrogsfrogs>
References: <20240613211933.1169581-1-bodonnel@redhat.com>
 <20240613211933.1169581-5-bodonnel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240613211933.1169581-5-bodonnel@redhat.com>

On Thu, Jun 13, 2024 at 04:09:18PM -0500, Bill O'Donnell wrote:
> Use time_t instead of int for interval field.
> 
> Coverity-id: 1596599
> 
> Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>

Hopefully the intervals never get that big, but yes, we could use a time
interval type instead of the ever popular int.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  repair/progress.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/repair/progress.c b/repair/progress.c
> index 2ce36cef..15455a99 100644
> --- a/repair/progress.c
> +++ b/repair/progress.c
> @@ -91,7 +91,7 @@ typedef struct msg_block_s {
>  	uint64_t	*done;
>  	uint64_t	*total;
>  	int		count;
> -	int		interval;
> +	time_t		interval;
>  } msg_block_t;
>  static msg_block_t 	global_msgs;
>  
> -- 
> 2.45.2
> 
> 
