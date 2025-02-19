Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D171FDE3A
	for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2025 16:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739981577; cv=none; b=bKY1TTw/wCjl49rPRLfCmTyKxfi0drbBdsrLqj2m6oeCgcFMfwotrCnJ/awcu/gpkLE3VuZSRmbB/jo+jpPsc+AZa690vtpMn7Po7lLLqw+Rn8BRoS8/YiGZpuynio+OfGFGBWrTBWU+k2nPlre2BqKLr79sMXW02YKk6uI+Hwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739981577; c=relaxed/simple;
	bh=k+qXduNrV/qo+MhrhIzSyfXS42SJhIUcivngDCjnmZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wr6uLlhx85DW0oAmbKTWqRCGAsBchEfhb+kGxsiw0H7Ht7VvYSYR9/Yj5dGl7Egi0e1zlSuizKPudDNIxrm30ivEplW15cvYTaixzQECbKf65rwzqVv+kwfme1ccPULeARrJygY17JR/T+YMelYN1+ZFiwceNkyPCd3P3TnM+rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tU7hvzOv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tU7hvzOv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5645C4CED1;
	Wed, 19 Feb 2025 16:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739981576;
	bh=k+qXduNrV/qo+MhrhIzSyfXS42SJhIUcivngDCjnmZ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tU7hvzOvpldOL/iEQtvjLlnzA4KQeDzUixhYxNVT5ZZxfHHp5zfCtboVuam4Xho7l
	 c61bZmQPpTXUc+Wi7fh8QUCZBxmlCB+q8pk5CI0mu+LnYPdK/VnR+l/nOyX3ZObDsz
	 xmwssmaqBuzbvN0emllH5zbLvDOgrB0+BG/prZhSAazRgxIDRmniVu2zqXfDvzscuF
	 uoeLaihbvgjEgOHNvxcqehlD1yIpslRIvLny5g+hlz2C44tRCwjQtZp9OVvKDzju37
	 Vylw6hHycG8cMD0XPjJq3nwPQ44iT9HZ1jL9vG1HBy31f+syoK51LM2imZ/B4ok40x
	 tZlD4/mFngrwg==
Date: Wed, 19 Feb 2025 08:12:56 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [XFSPROGS PATCH] make: remove the .extradep file in libxfs on
 "make clean"
Message-ID: <20250219161256.GY3028674@frogsfrogsfrogs>
References: <20250219160500.2129135-1-tytso@mit.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250219160500.2129135-1-tytso@mit.edu>

On Wed, Feb 19, 2025 at 11:05:00AM -0500, Theodore Ts'o wrote:
> Commit 6e1d3517d108 ("libxfs: test compiling public headers with a C++
> compiler") will create the .extradep file.  This can cause future
> builds to fail if the header files in $(DESTDIR) no longer exist.
> 
> Fix this by removing .extradep (along with files like .ltdep) on a
> "make clean".
> 
> Fixes: 6e1d3517d108 ("libxfs: test compiling public headers with a C++ compiler")
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Oops, yeah, I forgot that. :(
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  include/buildrules | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/buildrules b/include/buildrules
> index 7a139ff0..6b76abce 100644
> --- a/include/buildrules
> +++ b/include/buildrules
> @@ -7,7 +7,7 @@ _BUILDRULES_INCLUDED_ = 1
>  include $(TOPDIR)/include/builddefs
>  
>  clean clobber : $(addsuffix -clean,$(SUBDIRS))
> -	@rm -f $(DIRT) .ltdep .dep
> +	@rm -f $(DIRT) .ltdep .dep .extradep
>  	@rm -fr $(DIRDIRT)
>  %-clean:
>  	@echo "Cleaning $*"
> -- 
> 2.47.2
> 
