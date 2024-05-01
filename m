Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B081146D75
	for <linux-xfs@vger.kernel.org>; Wed,  1 May 2024 18:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714586439; cv=none; b=KjOTTY7GtcGWiRIhpRtQ2rkgFDedt8OO/MVtSiwCwZN7pey6ifvVx0VNGXIYB6GLDDplxt98hhFLWKti6teqTjGFmiEVRw+m2rkbZBZ8FgvHy5Dm/cfzlLEMFz8G7d+Wv1nC4LtjZF5E79zarRHPj1UTWsWFgoGSp/zuGKTRDbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714586439; c=relaxed/simple;
	bh=Xv4HmzH1kZcIsNUwwyoeGL8U13NMihYD5CCoyzcSIcw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fTRnTO4CrZhQ3g7DfVpBUitEeSP+aDNXnVBp4Pq5oH0bFw5Varjlst34fcQGtZk28merdS2CLJjHqYkPD3al/4WuqAym5jg0jzP51E6KswCX15+IDD1rPVlvfrTzNzRJxl5L24YvsnMoW4FMT6JOigHK6XBA3whufMyVJkb6hB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TV/dAAqa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TV/dAAqa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714586436;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yfFCMYZujq7noVmk/XGKcbNQ6eLGaH7/3IfzirrANV0=;
	b=TV/dAAqaCEe/Qcj3ypoYrQSFy9gaXidNMpA//hDPXuwKTIDz7sDXYmOpyIuHTGtkEPjrgX
	EakBQEkruGSZxnY+nffJM+rfY7Nyj+skAXDfTIHHxKJttZ6EANDHTFG8jR/jo1OFiaMB8R
	lLvX459XrMjTK+iU3dp2PGaGDjY1mZU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-596-NXI_AKNPNhCphyL0OIgRjg-1; Wed,
 01 May 2024 14:00:32 -0400
X-MC-Unique: NXI_AKNPNhCphyL0OIgRjg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6482A3811F2E;
	Wed,  1 May 2024 18:00:32 +0000 (UTC)
Received: from redhat.com (unknown [10.22.34.15])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D6D2202450D;
	Wed,  1 May 2024 18:00:32 +0000 (UTC)
Date: Wed, 1 May 2024 13:00:30 -0500
From: Bill O'Donnell <bodonnel@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] debian: fix package configuration after removing
 platform_defs.h.in
Message-ID: <ZjKDPjshrJFjrIzd@redhat.com>
References: <171338841078.1852814.8154538108927404452.stgit@frogsfrogsfrogs>
 <171338841094.1852814.10756994414036094487.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171338841094.1852814.10756994414036094487.stgit@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

On Wed, Apr 17, 2024 at 02:18:22PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In commit 0fa9dcb61b4f, we made platform_defs.h a static header file
> instead of generating it from platform_defs.h.in.  Unfortunately, it
> turns out that the debian packaging rules use "make
> include/platform_defs.h" to run configure with the build options
> set via LOCAL_CONFIGURE_OPTIONS.
> 
> Since platform_defs.h is no longer generated, the make command in
> debian/rules does nothing, which means that the binaries don't get built
> the way the packaging scripts specify.  This breaks multiarch for
> libhandle.so, as well as libeditline and libblkid support for
> xfs_db/io/spaceman.
> 
> Fix this by correcting debian/rules to make include/builddefs, which
> will start ./configure with the desired options.
> 
> Fixes: 0fa9dcb61b4f ("include: stop generating platform_defs.h")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>

> ---
>  debian/rules |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/debian/rules b/debian/rules
> index 7e4b83e2b..0c1cef92d 100755
> --- a/debian/rules
> +++ b/debian/rules
> @@ -61,15 +61,17 @@ config: .gitcensus
>  	$(checkdir)
>  	AUTOHEADER=/bin/true dh_autoreconf
>  	dh_update_autotools_config
> -	$(options) $(MAKE) $(PMAKEFLAGS) include/platform_defs.h
> +	# runs configure with $(options)
> +	$(options) $(MAKE) $(PMAKEFLAGS) include/builddefs
>  	cp -f include/install-sh .
>  	touch .gitcensus
>  
>  dibuild:
>  	$(checkdir)
>  	@echo "== dpkg-buildpackage: installer" 1>&2
> +	# runs configure with $(options)
>  	if [ ! -f mkfs/mkfs.xfs-$(bootpkg) ]; then \
> -		$(diopts) $(MAKE) include/platform_defs.h; \
> +		$(diopts) $(MAKE) include/builddefs; \
>  		mkdir -p include/xfs; \
>  		for dir in include libxfs; do \
>  			$(MAKE) $(PMAKEFLAGS) -C $$dir NODEP=1 install-headers; \
> 
> 

