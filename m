Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59AB04E0B68
	for <linux-xfs@vger.kernel.org>; Thu,  1 Oct 2026 10:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790849266; cv=none; b=dByWgVyYYBo63yI7ME76UUOHN7dHZo+p5jcXMixxuWbK/59CU9ntszmR/9brjsVFfz0urIsTK+5GsGOUGWn0Wyazs/YkvQtUpgbK94oxXPOiNXW9CpMCncpSynBPanV8cuON5ORztV7Owob+VXtrvbLQScnAa6mVT0dbiU/MGKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790849266; c=relaxed/simple;
	bh=5J18B8CZGWnWJnA6DXSTVBivTKe1I3Nr3Sj7hzy2kqw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mtcGZSKPHYVmXXjjUYqMbPNmso9afqeQsAcfya54ZWdlFQ27r29+YqEK6IsbNl9U4ThjCIuonLeM0z7Z+zPkxl4JHCyG0pJCG7WB1W5XKp5auPvfnv9BeW/lisg5RDQa877YnQWw3kbSz5NxsNWqONv5HbU1+zDLH9Rh1elOBlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kEfyijMw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kEfyijMw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E0BC1F000FF;
	Thu,  1 Oct 2026 10:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790849252;
	bh=CUHuIptxIqDehJ6uEpomWWNuBv3pL8dtvDpsCU8cWFc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kEfyijMw2z5rCW6n1bNVDHhXSuUwlYxc4NQZsQqC4IeHwHH7D1PwGB6KAweOFYxFY
	 a0whZxWq45Ad44tkSTJDFrz1k3lgsXazcysk9XIFVWcuiC0NfrMoWNCXVzv5UbP0LK
	 L19zmouPoJh+Z8xRhwj7gCdZIvvjIq8jaBsIPfu+E6GdY2yZtPN0+JFaisAGLLKLFn
	 F9eQ87NNmtGFm9klbyG1jAMrS9LBkZrFoTFBcQ3VjpuL7kPJyR+P4oCdiryuuCV3n1
	 tMAFh/ePP7ULl6JSzT/zntHHnjskabTQ1ZPb6AGvKg5XFUlTmiQbSNsbpZmiaFQnXM
	 IT2/DsC6xN9Vw==
Date: Thu, 1 Oct 2026 12:07:28 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>, 1149571@bugs.debian.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>, biebl@debian.org, 
	Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: Bug#1149571: [PATCH] xfs_healer: fail earlier on non-xfs
 filesystems
Message-ID: <ar4v_IGzBRbIYp_B@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <179080491253.7201.8697529754428195540.reportbug@mars>
 <20261001062338.GV2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001062338.GV2705364@frogsfrogsfrogs>

On 2026-09-30 23:23:38, Darrick J. Wong wrote:
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
> Fixes: ea178059ff72c3 ("xfs_healer: don't start service if kernel support unavailable")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  healer/xfs_healer.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/healer/xfs_healer.c b/healer/xfs_healer.c
> index ec402a78d5d2bf..b71695db05876f 100644
> --- a/healer/xfs_healer.c
> +++ b/healer/xfs_healer.c
> @@ -317,6 +317,16 @@ setup_monitor(
>  
>  	ret = xfd_open(&ctx->mnt, ctx->mntpoint, O_RDONLY);

This probably should be ret = -xfd_open(...)? (not sure why xfd_open
converts errno to negative but all other users convert it back)

>  	if (ret) {
> +		if (ret == -ENOTTY) {

Then, ret == ENOTTY

-- 
- Andrey
