Received: from buxtehude.debian.org (buxtehude.debian.org [209.87.16.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C6C4E0B68
	for <linux-xfs@vger.kernel.org>; Thu,  1 Oct 2026 10:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790849352; cv=none; b=ZXeTl/EjUBJ7uQtnazEhzs0CBHy1TF/ZAO45n1THAx2s6+gYIEyP4QgZiMqHmivAkJCHEWNo6I7PUO87RrJDJ9+DPPP1dlaQq711/su/EIw4mp8pTs/gmA2Mt/l8DOGT6lmXjmrcaFGTlfa3jEHJ3ul+kKIybywOtLGAuJf7NmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790849352; c=relaxed/simple;
	bh=5J18B8CZGWnWJnA6DXSTVBivTKe1I3Nr3Sj7hzy2kqw=;
	h=Subject:References:Date:From:To:Cc:Message-ID:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CCgXbwFWtOufdR95VDcrr6n4Gc3WiqRooT8tpZQqtTAQPx2jpXZtSM1W1EZ/0eioc08Cfv3G3ZN//ZfCg3+/dKKvLyv8xP2001+Bgwje71FVjGFAmVhMXiDamrQH3hl18XNNxgGAXuF9c3SaZC91p6wJNZXGpc9mN33ePFFBib0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=buxtehude.debian.org; dkim=fail (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kEfyijMw reason="signature verification failed"; arc=none smtp.client-ip=209.87.16.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=buxtehude.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kEfyijMw"
Received: from debbugs by buxtehude.debian.org with local (Exim 4.96)
	(envelope-from <debbugs@buxtehude.debian.org>)
	id 1xCDin-000GPo-29;
	Thu, 01 Oct 2026 10:09:01 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#1149571: [PATCH] xfs_healer: fail earlier on non-xfs filesystems
Reply-To: Andrey Albershteyn <aalbersh@kernel.org>, 1149571@bugs.debian.org
Resent-From: Andrey Albershteyn <aalbersh@kernel.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-CC: linux-xfs@vger.kernel.org
X-Loop: owner@bugs.debian.org
Resent-Date: Thu, 01 Oct 2026 10:09:01 +0000
Resent-Message-ID: <handler.1149571.B1149571.179084925661633@bugs.debian.org>
X-Debian-PR-Message: followup 1149571
X-Debian-PR-Package: xfsprogs
X-Debian-PR-Keywords: 
References: <179080491253.7201.8697529754428195540.reportbug@mars> <20261001062338.GV2705364@frogsfrogsfrogs> <179080491253.7201.8697529754428195540.reportbug@mars>
X-Debian-PR-Source: xfsprogs
Received: via spool by 1149571-submit@bugs.debian.org id=B1149571.179084925661633
          (code B ref 1149571); Thu, 01 Oct 2026 10:09:01 +0000
Received: (at 1149571) by bugs.debian.org; 1 Oct 2026 10:07:36 +0000
X-Spam-Level: 
X-Spam-Bayes: score:0.0000 Tokens: new, 25; hammy, 150; neutral, 168; spammy,
	0. spammytokens: hammytokens:0.000-+--Signedoffby,
	0.000-+--Signed-off-by, 0.000-+--libexec, 0.000-+--exitcode,
	0.000-+--0x100
Received: from sea.source.kernel.org ([2600:3c0a:e001:78e:0:1991:8:25]:43618)
	by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <aalbersh@kernel.org>)
	id 1xCDhP-000G1p-2y
	for 1149571@bugs.debian.org;
	Thu, 01 Oct 2026 10:07:35 +0000
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EFEF543D92;
	Thu,  1 Oct 2026 10:07:32 +0000 (UTC)
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
Message-ID: <ar4v_IGzBRbIYp_B@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001062338.GV2705364@frogsfrogsfrogs>
Message-ID: <20261001100728.IZqlaNhPku3TOBE0eavuB5-IyyAEFvwGqlaFQ-a_tSQ@z>

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
