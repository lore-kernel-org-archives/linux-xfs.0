Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB2E21C179
	for <linux-xfs@vger.kernel.org>; Thu,  5 Dec 2024 15:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733413413; cv=none; b=gApWti+nchboNLldMZfxRtiYF6C6wXigA4+f+AkFo2uahJbk9ii5ccrZK8xBmlvAZNHvIu0ZAWaCmAZr6GTsRu+mRhbl0s7omQa8nPA6SyY0rhlYwFoOJBYvFQEZvoKtvMKWiRyy5++tf2w6OU7OTvh/eYuYycaf/gTcpzWpNqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733413413; c=relaxed/simple;
	bh=lTK8Fl7hHS6Q++IDo6zbEnlouES+6SEIfO+cRe/BjtU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uwTPAzmGYWd6b+Qi+12QkaJnE9dmRWUpv71OpgnzBajrooK3DmUZNi1lhNj/YKV28a0i5Or1KJmNQOCF9ZpTi5vEfV8V47h2HL0Rum65U0fLvfpEVmBSGMRCDdcmHomeTqzhLJGgVI9AbGkOiNp/e+sHIhA/vMod79zAGrngUGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g8Bac/Ml; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g8Bac/Ml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07806C4CED1;
	Thu,  5 Dec 2024 15:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733413413;
	bh=lTK8Fl7hHS6Q++IDo6zbEnlouES+6SEIfO+cRe/BjtU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g8Bac/Ml/SB8/zXoTGmXZh3qTu1Bm58eunpzXRraOrK5D5/uOp3kAFGj0IcOjGtTO
	 3bdzldZ7ueJuL+eiY/23/xnJJExLLOBRJUPiONeEswdBIlq0g5/tilJzublfzSKMF1
	 rqOBhVZpuCs1JqFz8ZizIo0gc4jKAXbh+o220CCUiIYr7/RUnS36o5ZgXt2ppkgy3k
	 6G5WPqD8aSO5ZD2kJR8pjh2S79rAzQtRVCeIucb0Nlvqfh+c9kLXV0IKXFKH4OTzUJ
	 yPi4qV5XTlD884ii6DAfccASzNcJuWmHaaIv/v1hNWPSWgdzu0Vla/4fetz9ab5ddl
	 Mh1JUuI4NKMZA==
Date: Thu, 5 Dec 2024 07:43:32 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Jan Palus <jpalus@fastmail.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] man: fix ioctl_xfs_commit_range man page install
Message-ID: <20241205154332.GN7837@frogsfrogsfrogs>
References: <20241205100401.17308-1-jpalus@fastmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241205100401.17308-1-jpalus@fastmail.com>

On Thu, Dec 05, 2024 at 11:04:01AM +0100, Jan Palus wrote:
> INSTALL_MAN uses first symbol in .SH NAME section for both source and
> destination filename hence it needs to match current filename. since
> ioctl_xfs_commit_range.2 documents both ioctl_xfs_start_commit as well
> as ioctl_xfs_commit_range ensure they are listed in order INSTALL_MAN
> expects.
> 
> Signed-off-by: Jan Palus <jpalus@fastmail.com>

Yowza, I did not realize that was a behavior of INSTALL_MAN!
Thank you for noticing that. :)

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  man/man2/ioctl_xfs_commit_range.2 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/man/man2/ioctl_xfs_commit_range.2 b/man/man2/ioctl_xfs_commit_range.2
> index 3244e52c..4cd074ed 100644
> --- a/man/man2/ioctl_xfs_commit_range.2
> +++ b/man/man2/ioctl_xfs_commit_range.2
> @@ -22,8 +22,8 @@
>  .\" %%%LICENSE_END
>  .TH IOCTL-XFS-COMMIT-RANGE 2  2024-02-18 "XFS"
>  .SH NAME
> -ioctl_xfs_start_commit \- prepare to exchange the contents of two files
>  ioctl_xfs_commit_range \- conditionally exchange the contents of parts of two files
> +ioctl_xfs_start_commit \- prepare to exchange the contents of two files
>  .SH SYNOPSIS
>  .br
>  .B #include <sys/ioctl.h>
> -- 
> 2.47.1
> 
> 
