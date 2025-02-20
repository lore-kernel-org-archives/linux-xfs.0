Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A932179BC
	for <linux-xfs@vger.kernel.org>; Thu, 20 Feb 2025 08:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740039171; cv=none; b=bpY+uU+G5roUtcovcIsqbkUOr5WnAFIamlWhH2a5J/8/Y376cNRtSLB5n4q1SvsTNTNnf+QaSoGAbklCh1PKowX46HctKEmtEZNywEFXPqh8bQzw6dplvkYxjAkEZnlhgDvIy7qN/7T4np2EloT6ILNu8/saW1Ou2K/zZnatY+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740039171; c=relaxed/simple;
	bh=Nf2Dh9bdQsvYYrD+dI6OthvaYbTzZ1NDAMeTnaS9ZS8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CmlX9W6XfMtP8rFgBIdbyTixfLgQTgyMGUwMpVw6r40pOGjB9jrfq/4pFCMsRrmBzHvJogSdlr5TPqcV5OPrzOQZLtCUbYA7CrDxp4WDStJV/fNLWGwBFnmzS4KUhUNNJ3Fr0MdRCGTkOqwlodj5vfjKvZjzU7zymOHoEYrQPQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kE+P084f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kE+P084f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E375C4CED1;
	Thu, 20 Feb 2025 08:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740039171;
	bh=Nf2Dh9bdQsvYYrD+dI6OthvaYbTzZ1NDAMeTnaS9ZS8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kE+P084frfL45+74Q7dbCe4O0blM5CnQ2A0rAEhzm2/gliYi5y3ZcR2nKM6IoxWVi
	 8Ez6ouu6kp0efEPXKyskcpwb/QebmYoRFcwnpJjZ51N0+R38Y8tLh19KsHZqF8uvAT
	 CsAWGhwoWSYl2qrcOEE/uPYYSm4B1hUJx78PbwKwtFVxdey2s7zTG8m0Oha5knflAj
	 e6sLRDqVDDqT6x2L+vjC5fZkMhaIxc6pj1tsvb//q965qoKRa2ZYS6NOGTrrfF/hzb
	 A6CazFoszIUPLnq2AYufDhhxGiedejxms8n095lKI7S1XO0C9I7d1UGmRZC6RjY3LK
	 INHO4RfzvNkqw==
Date: Thu, 20 Feb 2025 09:12:46 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [XFSPROGS PATCH] make: remove the .extradep file in libxfs on
 "make clean"
Message-ID: <rqpluafkqedqjl3acljv3nugq3gjxpldmglon72a3j3up6cvn3@inq2q6xj5rtb>
References: <Ma-ZKGYU7hIk8eKMYW8jlYh_Z0idBm-GTBibhJ9T1AQdH_B6PFLlAEEOXoTUJ85eBFU_fC2m0pdM3xOdcrf4mg==@protonmail.internalid>
 <20250219160500.2129135-1-tytso@mit.edu>
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

Looks good.
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


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
> 
