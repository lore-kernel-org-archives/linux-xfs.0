Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19B257C9F
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 12:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782910213; cv=none; b=BCzaNRyOC1t9TD6Qd8VGjPcSqz7rIH8KZ85aomT2xtifc+UeMOD/ltFRy57tIB0e5R20nawVboDw+wYNfvPljDguBDmR7KEyFElW4/PEbjPYdfHA1m20mc8HoX4/0A0CyHOa8doTBktN7ZhCh9Ua95jkjroNJyCxYSsllyk4DZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782910213; c=relaxed/simple;
	bh=EEIRak46SmRPc1qKBBZJsFEcZGKDMG4I4J48B0rrlhY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=gwqn20+qM16TwE4yG57Lk6JgtTEy0+AyZIemoEnY3si8QbUzxKR5gIya3qfnDaHEfb/fBYaBZIJ7jnBDiXv1mLxUzkqVB0WnrREPW42Z27v92aTkZLgrJc+4QC6SHUWh2vjWpUS1hd+0Zr5Ng8YVfvd3RUUxYvukZdqeZuoA4MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kdANeymK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kdANeymK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D38E1F000E9;
	Wed,  1 Jul 2026 12:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782910212;
	bh=Eb/OAOxRhFAYpvulvltyXrJXiababtp6CIRhn3wpVbQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=kdANeymK5lOvP88XFWnZm0fFHL4BjuDs8hJcm8Cb4qWQ/KmliGr3Se1mDZd4EKqOW
	 dFMtLltMfXiId0E4pop6fSZARtUUERCjitptMOSWw4pxRzqx11AarMmHwiebrT3W9j
	 NOaTsICNJ47/WotNZON9MxHruCRBvBwvp1KYzyL6W11uNBrUofIVbU4CUwMp84eXGm
	 qx6QHhIN0YNpCjI64AwoBCKfr35ValvvUDMw9QEhI1SFPQrvm5DzBiAdJYshoPGxFP
	 by5j7ZgYhI7Qdw7FSYagtTQEtVvvJ1gQV4bEBfBO8ioVv7BGoDhiYpftwsM7hfxoIQ
	 eRWLiveF7RnPA==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <20260617055814.3842058-1-hch@lst.de>
References: <20260617055814.3842058-1-hch@lst.de>
Subject: Re: fix GFP_ flag use in the buffer cache
Message-Id: <178291021008.353898.375557566871303568.b4-ty@b4>
Date: Wed, 01 Jul 2026 14:50:10 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Wed, 17 Jun 2026 07:58:01 +0200, Christoph Hellwig wrote:
> usage of the GFP_ flags in the buffer cache, including mixing
> __GFP_NOFAIL and __GFP_NORETRY which is nonsensical, and passing
> __GFP_NORETRY to the dedicated fallback.
> 
> Diffstat:
>  xfs_buf.c |  105 +++++++++++++++++++++++++++++++++++---------------------------
>  1 file changed, 60 insertions(+), 45 deletions(-)
> 
> [...]

Applied to for-next, thanks!

[1/4] xfs: split up xfs_buf_alloc_backing_mem
      commit: c752838874578b7f0267d9f3e73892b1c7a0d9cc
[2/4] xfs: lift setting __GFP_NOFAIL from xfs_buf_alloc_kmem to the caller
      commit: 27d7d15184d701b6e4db2b7431e4cee67a041a1c
[3/4] xfs: fix incorrect use of gfp flags in xfs_buf_alloc_backing_mem
      commit: 0144bcf619602e82843a514431d3cf2cd13ec08a
[4/4] xfs: simplify the failure path in xfs_buf_alloc_vmalloc
      commit: 19dc95d4b6cf81e1878a3abd587afc967b75d5ce

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

