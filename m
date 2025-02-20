Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CB5214817
	for <linux-xfs@vger.kernel.org>; Thu, 20 Feb 2025 18:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740076599; cv=none; b=dTTqoWIlJKOl02ud/2Y8iVq7mL7RYzmPQlpKJB5hlPsAOBve4CgIjLP7knYknDRRMIr/rGcUTPB7Pj6Oj1FvkJvZrGKjihRyZNM1NhVlr0LJYdYn15uQdgIKkmtGJ/gIOjVpcIWXLyvAebxgtnPseKAHDMYaK55S0ZuBxbrVOF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740076599; c=relaxed/simple;
	bh=4wulJRwNO/8Y5eDWIxUUMIMmeb8KFTFxd8lKPUJdKdU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W59DQvWR5UT5VO70UP6xv9UsuZ4Wn5wMILlp6VIKuhJRTzN91G8bm29nMQdM8G1K5euSIoCjAZfcBURmPptpPqDc+cku02sp2HznYkbBFDT2r5R0V5z5q3Ye7c6qBVHtLfSHVAg7GkSAzmqDZcxx2srZS1whdp18b7p0KJV2vw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CUoVOvJ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CUoVOvJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92DF7C4CED1;
	Thu, 20 Feb 2025 18:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740076598;
	bh=4wulJRwNO/8Y5eDWIxUUMIMmeb8KFTFxd8lKPUJdKdU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CUoVOvJ0I4on0jBYNk2I1FQ49aMkG73BE3v7jJVhgnAK7SOMHvTZ1ElU8B61yHSGG
	 gcq9rfdEig9RAytlbp5cYloRJB9CCWzBLA4k/j7xqVL38yrNOIMx2Xikmoesf5nASw
	 LQt4AkCKwUN+UTBSaojNhm421n+v7rdY6vUcWHPq8Zn/gaAYbp3jy0dd0MCxvp2ErQ
	 eH3m4l+zfaTw43mV+AJUH9lUZD4y5+dt0FO79FqhaQfoLOPp8YImzoVDQc0Eh/VQVJ
	 WuGtH/bRmkNkzAMvXfhzzD/D7jb2kqawZFRTwY2n6G7z34jgKGg4LwPpG5zC5oXss1
	 RNW5mIeZlUgMw==
Date: Thu, 20 Feb 2025 10:36:37 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, aalbersh@kernel.org
Subject: Re: [PATCH] libxfs-apply: fix stgit detection
Message-ID: <20250220183637.GR21808@frogsfrogsfrogs>
References: <20250220164933.GP21808@frogsfrogsfrogs>
 <20250220175600.3728574-2-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250220175600.3728574-2-aalbersh@kernel.org>

On Thu, Feb 20, 2025 at 06:56:01PM +0100, Andrey Albershteyn wrote:
> stgit top doesn't seem to return 0 if stack is created for a branch
> but no patches applied. The code is 2 as when no 'stgit init' was
> run.
> 
> Replace top with log which always has at least "initialize" action.
> 
> Stacked Git 2.4.12
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Works for me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  tools/libxfs-apply | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/libxfs-apply b/tools/libxfs-apply
> index 097a695f942b..480b862d06a7 100755
> --- a/tools/libxfs-apply
> +++ b/tools/libxfs-apply
> @@ -100,7 +100,7 @@ if [ $? -eq 0 ]; then
>  fi
>  
>  # Are we using stgit? This works even if no patch is applied.
> -stg top &> /dev/null
> +stg log &> /dev/null
>  if [ $? -eq 0 ]; then
>  	STGIT=1
>  fi
> -- 
> 2.47.2
> 
> 
