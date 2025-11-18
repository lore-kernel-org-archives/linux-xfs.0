Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D771136C5B5
	for <linux-xfs@vger.kernel.org>; Tue, 18 Nov 2025 17:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763485203; cv=none; b=ROZoy6msCKkKmZ+46pQCkedv+6kGNCp53Bawv9Wr8SgBkX6srGuHd/iuSdr2ur3byXECj1LFFTO8pyBF1nmyTnNQaI4vVDS/5YuE47ln/OxpRWSyACT+h1bd4NJt+KjwtOuZJ87/ERJlfS5MdVaamaGv2PiOR8D++csaOs2LwbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763485203; c=relaxed/simple;
	bh=uTiP2LQj+KqTA7YOlsKA0AjChXTrZfTDjnhGOaOzjsU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DEdR+YhJeYhBZay5OjFkRz+dcbUwOu8UtF8RwBPa0/EgrjhKVkEGulOxlxmk4tKfaXcFQzizmv6lZ3Mz7fxDTqoqE+jcW41QIQ4xrmn9zPbhXIVMAsnOkdnXNOs+EJrQGeRrBsmhEpdyTJYLrkuPzWfevAITAPDqt3EG0D1zmJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LsDml0rz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LsDml0rz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 489D9C2BC87;
	Tue, 18 Nov 2025 17:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763485202;
	bh=uTiP2LQj+KqTA7YOlsKA0AjChXTrZfTDjnhGOaOzjsU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LsDml0rzeiUSt/ZaCgL/419+wBWNZt3WOkATw0VoxWXm5J6hNOvqwDXxfyCbS7qLL
	 sV+I9/A/SkpiVLdJ48NGmyLPVSw7p0CRYoY8dGLHcNGh/iKlObhsY9rmYf3JGlMTjS
	 dcz6pVtLZppVeyFgCW8XR0sRT3muHj+6woEDAhoB9Vu12yGfxKqYivJV4iawQyx5p3
	 ZOWTdKUvKygmf0FhagEYIqV7PC1MOC+4vQinAA2qcN7vOxmQ5EvMAZiDjmQRIRyx3G
	 qZofigjq1opoVgdbadvjCuAis9wZPSv00HqwWvuqPT5VkAodVpyVEDVmLrwx6Ae7mD
	 IIQ779Sk/7MYw==
Date: Tue, 18 Nov 2025 08:59:59 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Hongxu Jia <hongxu.jia@windriver.com>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net
Subject: Re: [PATCH] doc/man: support reproducible builds
Message-ID: <20251118165959.GL196370@frogsfrogsfrogs>
References: <20251118092113.2265541-1-hongxu.jia@windriver.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251118092113.2265541-1-hongxu.jia@windriver.com>

On Tue, Nov 18, 2025 at 01:21:13AM -0800, Hongxu Jia wrote:
> From: Hongxu Jia <hongxu.jia@eng.windriver.com>
> 
> When compressing, do not save the original file name and
> timestamp by default (gzip -n). Make archives be reproducible
> at each build
> 
> Signed-off-by: Hongxu Jia <hongxu.jia@eng.windriver.com>

Seems fine to me.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  doc/Makefile        | 2 +-
>  include/buildmacros | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/doc/Makefile b/doc/Makefile
> index 83dfa38b..17b63c85 100644
> --- a/doc/Makefile
> +++ b/doc/Makefile
> @@ -14,7 +14,7 @@ include $(BUILDRULES)
>  
>  CHANGES.gz:
>  	@echo "    [ZIP]    $@"
> -	$(Q)$(ZIP) --best -c < CHANGES > $@
> +	$(Q)$(ZIP) -n --best -c < CHANGES > $@
>  
>  install: default
>  	$(INSTALL) -m 755 -d $(PKG_DOC_DIR)
> diff --git a/include/buildmacros b/include/buildmacros
> index 9183e5bc..6ba0d515 100644
> --- a/include/buildmacros
> +++ b/include/buildmacros
> @@ -105,7 +105,7 @@ INSTALL_MAN = \
>  			t=$(MAN_DEST)/$$m.$(MAN_SECTION); \
>  			if $$first; then \
>  				if $(HAVE_ZIPPED_MANPAGES); then \
> -					$(ZIP) -9 -c $$d > $$d.gz; _sfx=.gz; \
> +					$(ZIP) -n -9 -c $$d > $$d.gz; _sfx=.gz; \
>  				fi; \
>  				u=$$m.$(MAN_SECTION)$$_sfx; \
>  				echo $(INSTALL) -m 644 $${d}$$_sfx $${t}$$_sfx;\
> @@ -132,6 +132,6 @@ endif
>  MAN_MAKERULE = \
>  	@for f in *.[12345678] ""; do \
>  		if test ! -z "$$f"; then \
> -			$(ZIP) --best -c < $$f > $$f.gz; \
> +			$(ZIP) -n --best -c < $$f > $$f.gz; \
>  		fi; \
>  	done
> -- 
> 2.49.0
> 
> 
