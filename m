Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D2D1FDA89
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 16:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756224654; cv=none; b=cHUMd1YkL0Qt8sFINEpk9BTQVPVqJNYpipMOtRKi8/LHE7236e0IAYHPwoQeUpsvoigyTaIZVUze3jHfu6HYx6oYtNk7CKCskHrYOz6ejomLU5eK199FGOq9iR2phr26UirMk76HKdXF0U5DzaqE/9SK3AUSFO4Q5NxdEcKxkao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756224654; c=relaxed/simple;
	bh=TGhQmenEs+xboOCL7IjRtlw6trZifDAiYYBHxoWbKMw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oFk2WrqGNTaOiKUv1GHLsfR0p4Jbv2PeDoZ9SH2Pf9X4J9C1XdEQuCARUKCUa8/7HSoc/GizQSGjpGX9hZPBbVYx9Kbos3RA2RnweuEYztDKDajxB53otIjEOxo6UuwMMlNPakWkCBTTNG+K/QGRA24qdsTEXVn0iPpQR7fvpwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=scJB2VC1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="scJB2VC1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4BDC4CEF1;
	Tue, 26 Aug 2025 16:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756224651;
	bh=TGhQmenEs+xboOCL7IjRtlw6trZifDAiYYBHxoWbKMw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=scJB2VC1qbG9JwAkZPZSi/+IhUoXt8nTbF7ryZdsj3H219H8ozfkmQt6sHT/40SCk
	 MBju+NECoNMIV1klDUnv37Izhy5H7aFr+HP8wSX1P2AhAS1FaUBWOyXbm3yZfDmy/0
	 u8Qw4nBSqFnj4XR7i/XiHkXwwbAHoO8GdsyV2T0Y0B6ml/Pa+QtQhXQkzBDHhK+B9k
	 HpKo0gftPtbnzvo9j+jtboewlBsxlv0b4DmNHnUbl0oKIEpHDWA9HcTxAtBk3m6uxG
	 0KB2PX9hjaiTbMYJyZMh3J+892O6zOrY4CYynpqoX1mHdtpLowYPnCyQMqewhKa+kP
	 RdyqQ4vBxyy1w==
Date: Tue, 26 Aug 2025 09:10:51 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christian Kujau <lists@nerdbynature.de>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@redhat.com>
Subject: Re: xfsprogs: fix utcnow deprecation warning in xfs_scrub_all.py [v2]
Message-ID: <20250826161051.GC19817@frogsfrogsfrogs>
References: <ce844705-550d-3eb2-0d08-d779f9ebc029@nerdbynature.de>
 <20250826155747.GB19817@frogsfrogsfrogs>
 <9ad33531-f8c0-07cf-59e4-7e6bbb173ebc@nerdbynature.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ad33531-f8c0-07cf-59e4-7e6bbb173ebc@nerdbynature.de>

On Tue, Aug 26, 2025 at 06:06:26PM +0200, Christian Kujau wrote:
> On Tue, 26 Aug 2025, Darrick J. Wong wrote:
> > Heh heh heh.  That old code was for compatibility with RHEL6(?) back
> > when I started writing online fsck.  That's indeed no longer needed
> > because even RHEL7 supports datetime.now, so thank you for the update!
> 
> Thanks for providing the context. Scrolling through that whole script I'd 
> say the helper function is not even needed anymore. So, if it's not too 
> much hassle, here's a version 2 of the same:
> 
> Signed-off-by: Christian Kujau <lists@nerdbynature.de>

That also works for me--
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> 
> Thanks!
> 
> diff --git a/scrub/xfs_scrub_all.py.in b/scrub/xfs_scrub_all.py.in
> index 515cc144..ce251dae 100644
> --- a/scrub/xfs_scrub_all.py.in
> +++ b/scrub/xfs_scrub_all.py.in
> @@ -493,12 +493,6 @@ def scan_interval(string):
>  		return timedelta(seconds = float(string[:-1]))
>  	return timedelta(seconds = int(string))
>  
> -def utcnow():
> -	'''Create a representation of the time right now, in UTC.'''
> -
> -	dt = datetime.utcnow()
> -	return dt.replace(tzinfo = timezone.utc)
> -
>  def enable_automatic_media_scan(args):
>  	'''Decide if we enable media scanning automatically.'''
>  	already_enabled = args.x
> @@ -515,7 +509,7 @@ def enable_automatic_media_scan(args):
>  	else:
>  		try:
>  			last_run = p.stat().st_mtime
> -			now = utcnow().timestamp()
> +			now = datetime.now(timezone.utc).timestamp()
>  			res = last_run + interval.total_seconds() < now
>  		except FileNotFoundError:
>  			res = True
> 
> -- 
> BOFH excuse #72:
> 
> Satan did it
> 
