Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8F346AA9C
	for <linux-xfs@vger.kernel.org>; Fri,  2 Oct 2026 08:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790931423; cv=none; b=OOkdoInJC3PFAmu1oan97WUWhJHcu+QBqKTGsrRzs7KRS0L9zVjAcbhExG2L5B0vPjjnrRCgeC0civCoNx+77gXLIpu8Ih2j6vfB2zahwGR1pPhbnz0RKW9VV/ymrt+0y3wiwAbUOyI8gUGQroKCBrQFBc3NP5ERb5jsqOWursg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790931423; c=relaxed/simple;
	bh=PeL1TmLSUdfIe+x09VtCaJZgJhUemFenN7aPXWyzeh8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ILiL1YketnymPlbANupF6dfhwM1sFEkONmD8miNGWFwgQWrOrNUUysyKbhHP1HzveHamNhIpm1ZVdvTHncL3/qqeb3XPXtHUK7uSvwa54kS0wIHs9U+5hd4kzXG8lghEZ6nHkObZafGdgMPNvL3lZ7OexyeAIYyyo88I+8QoJBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R5RgaH8P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R5RgaH8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F631F000FF;
	Fri,  2 Oct 2026 08:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790931421;
	bh=n0FzpBYT7qAL3kwwQ/rUXxP5vhbajEpmwidDE6uFWX0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=R5RgaH8PiXPiGr0Efa/P8b2SzPxs1wn4LkPFYjMIn6y8E3jKBAXb3ssH6FkrTXLCr
	 IK23SHSK2EP78XnhNsATx5XvUkgTBrm96f6KBKwk+GSuJ+ru9mg2oNCsH8z7dSuNJT
	 lFoPADd7Bjhpp23ivEK21gN93orAyyU11kyHrHZJmnR5M4CObW0ikvDjzPSaaPUUHS
	 iQkFuC3neEiS6+294swBM0DhtNeZxSh3j0CzWEE/r8M5jOuXFCnTbh5cj/553WZs6m
	 /XsJQzZlgMXcy4Y8GPNhedvMteLVCCpHwwF80l0AzpEhNj8xPF/GN3rLmxnVb6XB8d
	 oJcincVrWhdMg==
Date: Fri, 2 Oct 2026 10:56:58 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>, 1149571@bugs.debian.org
Cc: biebl@debian.org, linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: Bug#1149571: [PATCH 2/2] xfs_healer: fail earlier on non-xfs
 filesystems
Message-ID: <ar9xxaIlBMqu3jjV@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <179086618105.2606256.7314766956448729435.stgit@frogsfrogsfrogs>
 <179080491253.7201.8697529754428195540.reportbug@mars>
 <179086618149.2606256.17998546326648396992.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179086618149.2606256.17998546326648396992.stgit@frogsfrogsfrogs>

On 2026-10-01 07:51:03, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> A Debian user reported that the root filesystem service fails with:
> 
>  systemd[1]: Starting xfs_healer@-.service - Self Healing of XFS Metadata for /...
>  xfs_healer@-[976]: /: Inappropriate ioctl for device
>  systemd[1]: xfs_healer@-.service: Condition check process exited, code=exited, status=255/EXCEPTION
>  systemd[1]: xfs_healer@-.service: Failed with result 'exit-code'.
>  systemd[1]: Failed to start xfs_healer@-.service - Self Healing of XFS Metadata for /.
> 
> when the root filesystem is not XFS.  It's most likely ext4 given
> Debian's defaults.  However, the actual service failure here is a result
> of the ExecCondition program exiting with 255 instead of EXIT_FAILURE.
> EXIT_FAILURE is what we're supposed to return to mean "do not run
> service".
> 
> Note that xfs_healer@- is always started by systemd (and not
> xfs_healer_start) because the root filesystem is usually mounted before
> systemd starts.
> 
> stracing this program a litle further reveals this:
> 
>  # strace -e ioctl /usr/libexec/xfsprogs/xfs_healer --supported /
>  ioctl(3, _IOC(_IOC_READ, 0x58, 0x7e, 0x100), 0x7fffb2c5e6a8) = -1 ENOTTY (Inappropriate ioctl for device)
>  ioctl(3, _IOC(_IOC_READ, 0x58, 0x7c, 0x70), 0x7fffb2c5e6a8) = -1 ENOTTY (Inappropriate ioctl for device)
>  ioctl(3, _IOC(_IOC_READ, 0x58, 0x64, 0x70), 0x7fffb2c5e6a8) = -1 ENOTTY (Inappropriate ioctl for device)
>  /: Inappropriate ioctl for device
> 
> All three ioctls are XFS_IOC_FSGEOMETRY calls, and they all fail with
> ENOTTY because this is an ext4 filesystem.  The fsgeometry call occurs
> under xfd_open(), so fix this error by special-casing the error return
> handling.
> 
> Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1149571
> Reported-by: Michael Biebl <biebl@debian.org>
> Cc: <linux-xfs@vger.kernel.org> # v7.0.0
> Cc: 1149571@bugs.debian.org
> Fixes: bf8b99270c6be1 ("xfs_healer: use the autofsck fsproperty to select mode")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
