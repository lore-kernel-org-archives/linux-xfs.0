Received: from buxtehude.debian.org (buxtehude.debian.org [209.87.16.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0A3471244
	for <linux-xfs@vger.kernel.org>; Fri,  2 Oct 2026 08:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790931544; cv=none; b=tTsrwEmzopAcVEthIWbXZy58ncTGkKmAjdyMnTrtI7U25Zw4qvRKGgr6Tk8z184Do0Z/FYVmo3mLd3UuJikAXK4Y6/sOp5VwGDgYtyagzocbvwtHh8qjezYC22HmSuvLdh/f2rADzTLEfR/0NE+m0AvgfBPyRmZbAQ18QmU6LIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790931544; c=relaxed/simple;
	bh=PeL1TmLSUdfIe+x09VtCaJZgJhUemFenN7aPXWyzeh8=;
	h=Subject:References:Date:From:To:Cc:Message-ID:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qa4Vk6qQD7LZJQYnYzYLgxN8nIWMEcf+D9emgzbIVpKOcqSaSRhYe7wiT/BQiu68vS6Jf18qfEbT7OvUObdLUtmds5ZetSaBu7KEXzCTMvnJb+Rsh663q0IocaQ2eCd3lhiPhWmfXsQ0Zzktq96ZK0DFA+M0EaZjGpaiWhrM54s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=buxtehude.debian.org; dkim=fail (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R5RgaH8P reason="signature verification failed"; arc=none smtp.client-ip=209.87.16.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=buxtehude.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R5RgaH8P"
Received: from debbugs by buxtehude.debian.org with local (Exim 4.96)
	(envelope-from <debbugs@buxtehude.debian.org>)
	id 1xCZ6b-002npx-1b;
	Fri, 02 Oct 2026 08:59:01 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#1149571: [PATCH 2/2] xfs_healer: fail earlier on non-xfs filesystems
Reply-To: Andrey Albershteyn <aalbersh@kernel.org>, 1149571@bugs.debian.org
Resent-From: Andrey Albershteyn <aalbersh@kernel.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-CC: linux-xfs@vger.kernel.org
X-Loop: owner@bugs.debian.org
Resent-Date: Fri, 02 Oct 2026 08:59:01 +0000
Resent-Message-ID: <handler.1149571.B1149571.1790931424666618@bugs.debian.org>
X-Debian-PR-Message: followup 1149571
X-Debian-PR-Package: xfsprogs
X-Debian-PR-Keywords: 
References: <179086618105.2606256.7314766956448729435.stgit@frogsfrogsfrogs> <179080491253.7201.8697529754428195540.reportbug@mars> <179086618149.2606256.17998546326648396992.stgit@frogsfrogsfrogs> <179080491253.7201.8697529754428195540.reportbug@mars>
X-Debian-PR-Source: xfsprogs
Received: via spool by 1149571-submit@bugs.debian.org id=B1149571.1790931424666618
          (code B ref 1149571); Fri, 02 Oct 2026 08:59:01 +0000
Received: (at 1149571) by bugs.debian.org; 2 Oct 2026 08:57:04 +0000
X-Spam-Level: 
X-Spam-Bayes: score:0.0000 Tokens: new, 6; hammy, 150; neutral, 140; spammy,
	0. spammytokens: hammytokens:0.000-+--Signed-off-by,
	0.000-+--Signedoffby, 0.000-+--libexec, 0.000-+--exitcode,
	0.000-+--0x100
Received: from tor.source.kernel.org ([172.105.4.254]:59850)
	by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <aalbersh@kernel.org>)
	id 1xCZ4h-002nPO-0W
	for 1149571@bugs.debian.org;
	Fri, 02 Oct 2026 08:57:04 +0000
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EAA9A60A70;
	Fri,  2 Oct 2026 08:57:01 +0000 (UTC)
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
Message-ID: <ar9xxaIlBMqu3jjV@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179086618149.2606256.17998546326648396992.stgit@frogsfrogsfrogs>
Message-ID: <20261002085658.HQpTlzIS8qjhI6AiUrjvBfC9l1wqf9PuyMxvw2WVw_4@z>

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
