Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A100430AD14
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 15:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756223868; cv=none; b=GC4FAO+Bn1mWLhELUa2zZYbukpJ1Sy00+Ad9pXvbN8gLZBUIElJ7dEa7EtUciEcwlqjPLa8Ut9tnfs44wFQWbtei0BDjdcCCJ+na6VJQmXvoluBNylyuvveZOoJ1ewgbbZXpSALXd7i74bAKQ5qtVaGP60gR+As11WWAub8lH3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756223868; c=relaxed/simple;
	bh=Uo0wpM9Q5HSFub2WwDa/F8FzzqyP2MYMddzWpzZGIRU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BjqexdOy17VZBorwHjg9lBnWGI/2q4oeGD5mFDfMnv/a1FxQIBRU9PpfV5u4F1f8mcR/cy1Do8xFs1HSWk3MDgdRTmD+/dL/FtQe8WqMvNIiInvY2BrsuJJVZwPqDnUhC+WUOzR2tn880TeMAzs1GubGfwZne17Tro7KDf6K/3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KrZ5/2rQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KrZ5/2rQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080EBC4CEF1;
	Tue, 26 Aug 2025 15:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756223868;
	bh=Uo0wpM9Q5HSFub2WwDa/F8FzzqyP2MYMddzWpzZGIRU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KrZ5/2rQvwmBlwHXxbIKkCL6FMXvDh20nlZmVr3Lb2KYBXYzaCuShwr0CDx/gnOZB
	 DbiPfnI8hVttgAgr1nxjW2/9dj3VOl1GmIo4DEEYV5nDS7A2vycGEZ2fTAa9x2B3Sz
	 YOUKdSkpLIecvb4am1EzoOgkOzYIYGAK9HnwTZpYOVKlMNw3k8Ma4n55lrQXUQq9Se
	 IGyCGShjm64ek26GWlivSqdSreqAwlrnBoBjSdwTs/59UVZ5kvRCEpvyOnnCLSpJwM
	 y3NoxUMjtS9FLIZWyf7Er2WX+vHcNSnj2KveScgn14W0CyUWyz/jtqgpr5ni6pTqxy
	 r15X0wMLPq6Qw==
Date: Tue, 26 Aug 2025 08:57:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christian Kujau <lists@nerdbynature.de>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@redhat.com>
Subject: Re: xfsprogs: fix utcnow deprecation warning in xfs_scrub_all.py
Message-ID: <20250826155747.GB19817@frogsfrogsfrogs>
References: <ce844705-550d-3eb2-0d08-d779f9ebc029@nerdbynature.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce844705-550d-3eb2-0d08-d779f9ebc029@nerdbynature.de>

On Tue, Aug 26, 2025 at 03:15:42PM +0200, Christian Kujau wrote:
> Running xfs_scrub_all under Python 3.13.5 prints the following warning:
> 
> ----------------------------------------------
> $ /usr/sbin/xfs_scrub_all --auto-media-scan-stamp \
>    /var/lib/xfsprogs/xfs_scrub_all_media.stamp \
>    --auto-media-scan-interval 1d
> /usr/sbin/xfs_scrub_all:489: DeprecationWarning: 
> datetime.datetime.utcnow() is deprecated and scheduled for removal in a 
> future version. Use timezone-aware objects to represent datetimes in UTC: 
> datetime.datetime.now(datetime.UTC).
>   dt = datetime.utcnow()
> Automatically enabling file data scrub.
> ----------------------------------------------
> 
> Python documentation for context: 
> https://docs.python.org/3/library/datetime.html#datetime.datetime.utcnow
> 
> Fix this by using datetime.now() instead.
> 
> NB: Debian/13 ships Python 3.13.5 and has a xfs_scrub_all.timer active, 
> I'd assume that many systems will have that warning now in their logs :-)
> 
> Signed-off-by: Christian Kujau <lists@nerdbynature.de>

Heh heh heh.  That old code was for compatibility with RHEL6(?) back
when I started writing online fsck.  That's indeed no longer needed
because even RHEL7 supports datetime.now, so thank you for the update!

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> 
> diff --git a/scrub/xfs_scrub_all.py.in b/scrub/xfs_scrub_all.py.in
> index 515cc144..a94b1b71 100644
> --- a/scrub/xfs_scrub_all.py.in
> +++ b/scrub/xfs_scrub_all.py.in
> @@ -496,8 +496,7 @@ def scan_interval(string):
>  def utcnow():
>  	'''Create a representation of the time right now, in UTC.'''
>  
> -	dt = datetime.utcnow()
> -	return dt.replace(tzinfo = timezone.utc)
> +	return datetime.now(timezone.utc)
>  
>  def enable_automatic_media_scan(args):
>  	'''Decide if we enable media scanning automatically.'''
> 
> 
> -- 
> BOFH excuse #360:
> 
> Your parity check is overdrawn and you're out of cache.
> 
