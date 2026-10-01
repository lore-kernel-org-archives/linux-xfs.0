Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98093A2574
	for <linux-xfs@vger.kernel.org>; Thu,  1 Oct 2026 14:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790865426; cv=none; b=ZIyZl8HtNqLY8vpiauL5WdmSeDJxIGym9719fJvufsqLWKP3ooNBbS33P69hoH1EGffWw7X9hxVqZfuUTkDkkZ5jIReKDBNXhzFW1w4VbXGMj+oOBm3USW7MwYQ3yhIa26HcYCyvhjBT5x+2hsqe9DNi30EDFn5NNXvmZa71RgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790865426; c=relaxed/simple;
	bh=MrUtcE6TRkAtvWpszNm984U1G937jMknviCaZr2h1kM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DgRrhtgUMlemxWwNKRIEog3e810ux/s41NR+iDgrSOcEnCRajZaU/Jgemdwh50w5UvgZRJnnrhxjrtCg3aqd20+G8RqK19rO96KJu4zLt1BmeuCn7dcIrAQ7ry9bqEBa5E0Nxvxe4kVjyW1KSOG9hM9qJ6NBa4vhmQ4zLrV1P/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EE6J2bNU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EE6J2bNU"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 66FAA1F00898;
	Thu,  1 Oct 2026 14:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790865421;
	bh=ylzZXJui9SG/lr6lqcYqy3kBj6VVgrjMCCooUa7ojq4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EE6J2bNUxt1RMPT8a3MQ0MrRqueYPnUIcHes1/uwRdCvhDbIzzgbBhHZhVbO34GEH
	 d/Os68npVMMb3O5WjbNLIIl37vdcQR+QyOiOh/ZxWPHT9REmjwLi7EVc9cfqT0sArf
	 xzrVtiNoepPHd2YbdSrOYgxuz57Begu1wioCdSXZXIAKWePs1lgs3yQyT7S9HTcseA
	 7iE0o+VwkenvZm8njzTQ1iu3y9MAPvl6h2pWw2O79ip/4elDnzHtsOOf3jNZvCQLQq
	 R+Hqh2Lqr0gKClUW7+MjxQKtGHsFdOkJWxw1tRD7laWlrPHtILAhkAICgX766MxPSf
	 PxL7qh9DKO8LA==
Date: Thu, 1 Oct 2026 07:37:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: 1149571@bugs.debian.org, Andrey Albershteyn <aalbersh@redhat.com>,
	biebl@debian.org, Christoph Hellwig <hch@infradead.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: Bug#1149571: [PATCH] xfs_healer: fail earlier on non-xfs
 filesystems
Message-ID: <20261001143700.GW2705364@frogsfrogsfrogs>
References: <179080491253.7201.8697529754428195540.reportbug@mars>
 <20261001062338.GV2705364@frogsfrogsfrogs>
 <ar4v_IGzBRbIYp_B@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ar4v_IGzBRbIYp_B@aalbersh-thinkpadx1carbongen13.rmtcz.csb>

On Thu, Oct 01, 2026 at 12:07:28PM +0200, Andrey Albershteyn wrote:
> On 2026-09-30 23:23:38, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > A Debian user reported that the root filesystem service fails with:
> > 
> >  systemd[1]: Starting xfs_healer@-.service - Self Healing of XFS Metadata for /...
> >  xfs_healer@-[976]: /: Inappropriate ioctl for device
> >  systemd[1]: xfs_healer@-.service: Condition check process exited, code=exited, status=255/EXCEPTION
> >  systemd[1]: xfs_healer@-.service: Failed with result 'exit-code'.
> >  systemd[1]: Failed to start xfs_healer@-.service - Self Healing of XFS Metadata for /.
> > 
> > when the root filesystem is not XFS.  It's most likely ext4 given
> > Debian's defaults.  However, the actual service failure here is a result
> > of the ExecCondition program exiting with 255 instead of EXIT_FAILURE.
> > EXIT_FAILURE is what we're supposed to return to mean "do not run
> > service".
> > 
> > Note that xfs_healer@- is always started by systemd (and not
> > xfs_healer_start) because the root filesystem is usually mounted before
> > systemd starts.
> > 
> > stracing this program a litle further reveals this:
> > 
> >  # strace -e ioctl /usr/libexec/xfsprogs/xfs_healer --supported /
> >  ioctl(3, _IOC(_IOC_READ, 0x58, 0x7e, 0x100), 0x7fffb2c5e6a8) = -1 ENOTTY (Inappropriate ioctl for device)
> >  ioctl(3, _IOC(_IOC_READ, 0x58, 0x7c, 0x70), 0x7fffb2c5e6a8) = -1 ENOTTY (Inappropriate ioctl for device)
> >  ioctl(3, _IOC(_IOC_READ, 0x58, 0x64, 0x70), 0x7fffb2c5e6a8) = -1 ENOTTY (Inappropriate ioctl for device)
> >  /: Inappropriate ioctl for device
> > 
> > All three ioctls are XFS_IOC_FSGEOMETRY calls, and they all fail with
> > ENOTTY because this is an ext4 filesystem.  The fsgeometry call occurs
> > under xfd_open(), so fix this error by special-casing the error return
> > handling.
> > 
> > Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1149571
> > Reported-by: Michael Biebl <biebl@debian.org>
> > Cc: <linux-xfs@vger.kernel.org> # v7.0.0
> > Cc: 1149571@bugs.debian.org
> > Fixes: ea178059ff72c3 ("xfs_healer: don't start service if kernel support unavailable")
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  healer/xfs_healer.c |   10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/healer/xfs_healer.c b/healer/xfs_healer.c
> > index ec402a78d5d2bf..b71695db05876f 100644
> > --- a/healer/xfs_healer.c
> > +++ b/healer/xfs_healer.c
> > @@ -317,6 +317,16 @@ setup_monitor(
> >  
> >  	ret = xfd_open(&ctx->mnt, ctx->mntpoint, O_RDONLY);
> 
> This probably should be ret = -xfd_open(...)? (not sure why xfd_open
> converts errno to negative but all other users convert it back)

Yeah, and the perror() call is incorrect too.  I'll post a second patch
to convert the callsite.

--D

> >  	if (ret) {
> > +		if (ret == -ENOTTY) {
> 
> Then, ret == ENOTTY
> 
> -- 
> - Andrey
> 
