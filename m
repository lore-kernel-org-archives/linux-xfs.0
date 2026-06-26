Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A84038A70A;
	Fri, 26 Jun 2026 15:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782487107; cv=none; b=TGMn7e5fvtUZi1wJV1fMn7W17K8ozWMFCvSUdpie8iacbzqiRyssb8sgX0atrFsY08lWf/IRYa24kY03bpg9LlH69qGgp75bylAjMCWGRtQ1K2se+HdyVALOhJ22X4n0Ub6jXPFn5KKvoZHSIBZHnoxGC0HIglQ9YMhMG/W0CEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782487107; c=relaxed/simple;
	bh=2KaVfWM+Qo4aNdX5D50M5uyKqWlrGwDSoPjLpPektUE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jx8Fpdr+KXAi8ppPWoKMWy0pxedd8VA16XN8tAVJmTXO/mMUEQq+r8e7HuuQutLys3udyUuLxNQWeS7O3NGWiN9URk/y1dGB/zuvpHxAujCAWjFBhIOejuNsNiar0R+SlxulY/4IZ2B3s44QMZ2gcoWnqNP9NggtltrTKvjRKAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V9L2jMbj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V9L2jMbj"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6860D1F000E9;
	Fri, 26 Jun 2026 15:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782487105;
	bh=N1izH24sFK3s2lr8NdpQUjFvEDOfF4o02D5/C5FuVSk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=V9L2jMbjEyvuf6ptTyy0a63/oLsDUXvNn2ljy7kLZ8EuE15xsx8gh/sQmVX7BpVcw
	 OCBxGbAPByFW6wulFzvO/boTO2E/21kXHyDhYb8By4exfCxLA/8SUIFg4us6ZkLy08
	 uBtR8nqEbroQiL1M8f7vHLbz+lpv3JBeRdnTsyD2UjWbgehI8u2hlPOTArucIbbq1c
	 Xyb9pb2uOcQ1wRbaLxJXp9llo+YNGZJw9mFSH2NpxR1vvlqY1oPFJ8RS9mQ5BW6IbC
	 e/o9yX7AzvL1wrzVyj6IUx2iPKtFU5p0LyaxmD+9AWxfIT8aTBiRtPX6IK/zVTZ7Pq
	 DOGY9CCmBojqA==
Date: Fri, 26 Jun 2026 08:18:25 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: linux-fsdevel@vger.kernel.org, jack@suze.cz, hch@lst.de,
	serge@hallyn.com, linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 2/4] quota: Don't issue audit messages on quota
 enforcing
Message-ID: <20260626151825.GU6078@frogsfrogsfrogs>
References: <20260626114533.102138-1-cem@kernel.org>
 <20260626114533.102138-3-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626114533.102138-3-cem@kernel.org>

On Fri, Jun 26, 2026 at 01:45:21PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Calling capable() to determine if we can bypass quota enforcement or not
> can trigger spurious audit messages. We don't really require it here so
> just use the capable_noaudit() version.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/quota/dquot.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> index 64cf42721496..1122a29215f7 100644
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -1308,7 +1308,7 @@ static int ignore_hardlimit(struct dquot *dquot)
>  {
>  	struct mem_dqinfo *info = &sb_dqopt(dquot->dq_sb)->info[dquot->dq_id.type];
>  
> -	return capable(CAP_SYS_RESOURCE) &&
> +	return capable_noaudit(CAP_SYS_RESOURCE) &&

Yeah, we're just checking if we're going to enforce hardlimits, not
actually denying something based on lack of capability.  For all we know
the user is well under their disk quota limit.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  	       (info->dqi_format->qf_fmt_id != QFMT_VFS_OLD ||
>  		!(info->dqi_flags & DQF_ROOT_SQUASH));
>  }
> -- 
> 2.54.0
> 
> 
