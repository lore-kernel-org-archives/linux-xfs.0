Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8D6344056;
	Tue, 10 Mar 2026 08:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773132739; cv=none; b=CJ77/wpY3eLumqpCy6jkOpPYAyk3eYuxUdyY+TvK2HydC29FGSPelw5ulU4ANvxS8a4BhXegggB9ZhaPg1lV0KmaeS8caVVvUpSmDgzuvJuOq8WVOQSHmM3EX26ZCieJfpjM1wDgwPIh9w5/7IycUN16btHjSorqkEF0IizlTcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773132739; c=relaxed/simple;
	bh=YE/8ErxgCU6ccq0j/72+rFyZHP7RM8uqp1ZKp406WOA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fmulRtMaPO9LwAOyHoPPeDS5GN2gxCP4QVilaKeaT+h4R619aWIYQrJ0JMEDyO3gdm6/rGjNrskCO9ZYtL9HciEV2oi1XnVShda4D6H5paOvd2rLmqmMIBqNGEDp0qiXlLHuCS3D86Ww21wy5GHB6WYV+Nu9/RhPk31QtVI2v+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AgyOy06q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AgyOy06q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D33FC19423;
	Tue, 10 Mar 2026 08:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773132739;
	bh=YE/8ErxgCU6ccq0j/72+rFyZHP7RM8uqp1ZKp406WOA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AgyOy06qC3f5as+fnx6q8XiIFegCNNBdHtCUKIf9i3mTnqmHVa9A6T/0NhhL64KHy
	 64O8GUDpY3v4KR87B3OiwyE9zFtOlblfossyZUKBYFJBpr0G+anlE8hL9jvX1HUel4
	 RF6g8WD2PcOp4ns1xBUQVq/3i94Ld3uKBleNb0iBoPbRFULUBgltAKGMOzAA8eK4en
	 MaRgizJHgCPO39OTdreF2kl0j5Q8CC5Jam5McdS/M+4WEBUby30oYpInVz6r8XILw7
	 DR+JTeX8JMr3ODV3cnhz2S5F5+7WSFd1QAe2opW8o1vwmU4nnZG5MtYhsUqmUKbVhm
	 vV53Ko8mqC0OA==
Date: Tue, 10 Mar 2026 09:52:15 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Chen Ni <nichen@iscas.ac.cn>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Convert comma to semicolon
Message-ID: <aa_Z9AkLoS6BrTwc@nidhogg.toxiclabs.cc>
References: <20260306014800.1257769-1-nichen@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306014800.1257769-1-nichen@iscas.ac.cn>

On Fri, Mar 06, 2026 at 09:48:00AM +0800, Chen Ni wrote:
> Using a ',' in place of a ';' can have unintended side effects.
> Although that is not the case here, it seems best to use ';'
> unless ',' is intended.
> 
> Found by inspection.
> No functional change intended.
> Compile tested only.

What tree HEAD did you apply this on?

I can't find where this code exists. I'm assuming you sent it against
some tree other than XFS's tree?

> 
> Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
> ---
>  fs/xfs/xfs_aops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index f279055fcea0..79ec98c8f299 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -792,7 +792,7 @@ xfs_vm_readahead(
>  {
>  	struct iomap_read_folio_ctx	ctx = { .rac = rac };
>  
> -	ctx.ops = xfs_get_iomap_read_ops(rac->mapping),
> +	ctx.ops = xfs_get_iomap_read_ops(rac->mapping);
>  	iomap_readahead(&xfs_read_iomap_ops, &ctx, NULL);
>  }
>  
> -- 
> 2.25.1
> 
> 
