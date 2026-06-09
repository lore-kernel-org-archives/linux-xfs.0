Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FE540D576
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jun 2026 23:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781047144; cv=none; b=H7kn+h3qmdy4sVSy7qYPCrCPag+0cX99r9b5onZJbmaR2Br+OTlmgaaMGDOq3bKwYUj56ZGfTHGXxsB95DGJguarT5U4hPO4F5XZPtmxkkmwdKOHRdllWgFbrDFZH+4rOp2FF33TGMMtLuQazFSzFJFU53H93ahEP94AMlQEtYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781047144; c=relaxed/simple;
	bh=MtpFa67XVsWTu9MmXbEvdL0/Fwoa3Li0gg1jkX2AX+4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Of0pFaLLGr1S9ioQASMqex0OL+ZA41xR40iVm7etqjyRaGAcuzjGTVdXmUJpBAyr/H5ZZ3kGQeAaUwxmcD9O7aWgC/XrDgY1wzoe/GIrj9kgh1d6Koqeb45sKGza0Y2x2lZgTJHCyF7ZVi31jNpl4vtY7TRksrdpKmOGioCu0b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yb7L/K3j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yb7L/K3j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421D11F00893;
	Tue,  9 Jun 2026 23:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781047142;
	bh=K4kQ3Fp1gbhmfA3kMyXbYtR0m3dtUg7IvYcRwCeXGU0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Yb7L/K3jFZNgBmu0byWmAVpre9uMaVROCzdq4ogceUkZUO5+0QqaNwVSHdLOErSH5
	 l1IOmt2H2eg1fCC7wfWo1RR3W598+qnmPTZTz4n0+P0pnxFqzq3+r1XJZrJsGMXkx0
	 23XP1CPDk1T7kPUL8VpyyubAbToPaYjAwqJusRCoa6UkTiiBYo3FOy+3vtgkRxihcx
	 /MXWETK9/a/oTXpO18Jnz5Ej3+Lbo8jJF9VivxONiNpyH9fSHEM1eqhzSCT8oJNZvo
	 Xc2G4aA0Tmvwn7eXWvT+4APibb4PpT3J1xQvZxYTQn9ZxBzguhT4LMjGwaeFUa+bx+
	 cqKyQuQ3TsGoA==
Message-ID: <cd3ae4f6-e51e-4cd6-b438-f1493fb88ad0@kernel.org>
Date: Wed, 10 Jun 2026 07:18:46 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] xfs: account newly added RTGs as free zones in growfs
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
References: <20260609075655.1698743-1-hch@lst.de>
 <20260609075655.1698743-3-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260609075655.1698743-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/06/09 15:56, Christoph Hellwig wrote:
> When growing a zoned RT section, the newly added RTGs also need to be
> tagged as free in the radix tree and add to the nr_free_zones counters.
> Call xfs_add_free_zone to do that, otherwise using up the newly added
> space will wait for free zones forever.
> 
> Fixes: 01b71e64bb87 ("xfs: support growfs on zoned file systems")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
