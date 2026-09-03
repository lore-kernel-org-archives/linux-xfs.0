Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A411A54763;
	Thu,  3 Sep 2026 06:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788415558; cv=none; b=RW3uoA7QDIMDceGdvnOx9NrZ1+tCenP86I+gnh5/MlY1aP2sW7ginzHlBvdaRL6+ZbKR9EADO+MP/QEpmopLFpdGyD4i8goiwGC4KqpK8CEVUAzwv+f+WftJ5zHZKYJCdmhWBUQTKGt8wmAkfRMXa8F5/X9/l0Now3Mb/0tI8Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788415558; c=relaxed/simple;
	bh=RYgjt3wZQOpLbcBBTcyi0fSn3zmDNPfyKGlBl5Q+c5s=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Z9/26Q8/NFzBr/R+AhkK+21FSVWe/hI4j8G47ECBhlE3DV/gg3H5XpUOmCjffCD9ADgRegGk/bQ9qFHBbDXRfw6Vc8QIT3yQooqSKG+yJ3kfDmqZ8pIeWjp9J2M4mIZl459c4PAimT2q4vl/YYFGCQ5DslrqC7h7/wQNByrpRac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OEUUyO2k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OEUUyO2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521D91F000E9;
	Thu,  3 Sep 2026 06:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788415557;
	bh=vZFmNWwx6DAvU+I5D4fDASxryRd0eLjaKuWLNCkSPVQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=OEUUyO2kK/aia0Z5taWv+tOwySeyxaURSkPApahcSzjHnR4Exw4FniF/JqcC4TJH9
	 gRSeA9pDQ8VULx56+8b5E89kZZBVnSWeyQwdSNTiTbAr4Bdzh3afCmZxNsGuFCqClp
	 qMIH0J2Di/pbgXvnIvnINjHxp6faND1el2eeiR1MdHb8TNiBokN8g31xWTjq0ov1+s
	 ao7HuaId2igZX6E3w2nRDnxdMLMW3/WSsyudMnOmQeEMp/ccKa1ahOmBOYEZVL7Hlc
	 8GfXXHM5wFQu3TGN5rg5PrTugnx6Zy731Bd7y0mrwZbTZyanaL9MzUeVt+UdoxgFiP
	 jSyWeJ6+l2j3Q==
From: Carlos Maiolino <cem@kernel.org>
To: hch@lst.de, "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <20260821035806.GJ6072@frogsfrogsfrogs>
References: <20260821035806.GJ6072@frogsfrogsfrogs>
Subject: Re: [PATCH] xfs: fix media verification ioctl for internal rt
 volumes
Message-Id: <178841555597.1198521.3290388172082604109.b4-ty@kernel.org>
Date: Thu, 03 Sep 2026 08:05:55 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Thu, 20 Aug 2026 20:58:06 -0700, Darrick J. Wong wrote:
> A media scan of a filesystem containing an internal rt volume produced
> an error in xfs_scrub phase 6 complaining about a truncated realtime
> device.  The rt device wasn't truncated, but the media scan code thought
> we were trying to start a scan past the end of m_rtdev_targp.  That in
> turn is an alias for m_ddev_targp, but in xfs_configure_buftarg we set
> nr_sectors to the size of the data section.  We don't account for an
> internal realtime section, so the kernel doesn't scan any part of it.
> Oops.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: fix media verification ioctl for internal rt volumes
      commit: 153c75d93cd59268f893f3ed66b62cc81428eef4

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

