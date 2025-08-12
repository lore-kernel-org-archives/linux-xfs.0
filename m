Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53791A9F99
	for <linux-xfs@vger.kernel.org>; Tue, 12 Aug 2025 07:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754984002; cv=none; b=A2LElo1neCD3RYAXg5HduTuYLEeBo00tOnZ4z6zExNNBGW3CZ8X9PrHkNfyw70fuVlcPJdOmmi/l/onJJVZt22yMSbtOo3TOldDDoYLzJVjHE2UgAbp3CpgzjX/Pb9V2IG86kp41cCNOwDOD99TVErCCU96cQbCHP8XaAyCkdT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754984002; c=relaxed/simple;
	bh=SAA2fAGcShQNqlddo83E+u+laYhfOzVGkmNJu4nCjvM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ScvmW6+Ka23yZhGAcb6sIWF6hsDp4gm1BE6inm53uQk9UJuYFHg/FxrEsu2HT4vZTpmeaCICQf0Vo7zdycF22zEEyrEdIhqcYpX6tgVlj827BlIykmWVqvIXWqK5t23DKIUqLAgJZteVv+8M/XdmLuGTpq5Bc3S8peiZA8Esyj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EpwBMP+w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EpwBMP+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E580AC4CEF1;
	Tue, 12 Aug 2025 07:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754984002;
	bh=SAA2fAGcShQNqlddo83E+u+laYhfOzVGkmNJu4nCjvM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=EpwBMP+wAD14JSWO2SeoLikdyCFRIRaKTgKNJIPhiEG4NH13ebtxdpxohxiozG53c
	 l7EHDvG6P6S6dYTpZ31XE/iKc5ivrjuzKhQXLGAeu3uIbFMjG4tI8JyFm22gDUNA/k
	 beCvJpt0Pu51jY07wCFNz8hTz6ArXq0X6DVXeOy++LHMVzXPO4yEu8QNpEekW8KWRS
	 bnHFtp4iVKuWB5hCNh0l4Fi41YOXGUarZqAgHBwqpk54DOiY6rnjJl5g3ROrvGHFpD
	 AlZVOcENea4cfRpTDZGVnvuGMduzWw685YkkVWZJkiAvxROs4sR9AkHhurhj0jitA6
	 u4YYgs8HLKVrw==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cen zhang <zzzccc427@gmail.com>, linux-xfs@vger.kernel.org
In-Reply-To: <20250723122011.3178474-1-hch@lst.de>
References: <20250723122011.3178474-1-hch@lst.de>
Subject: Re: fix XFS_IBULK_* vs XFS_IWALK_* confusion
Message-Id: <175498400163.824422.7373728260565245975.b4-ty@kernel.org>
Date: Tue, 12 Aug 2025 09:33:21 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Wed, 23 Jul 2025 14:19:43 +0200, Christoph Hellwig wrote:
> this fixes a syzcall triggered assert due to the somewhat sloppy split
> between the XFS_IBULK and XFS_IWALK flags.  The first is the minimal
> fix for the reported problem, and the second one cleans up the
> interface to avoid problems like this in the future.
> 
> Diffstat:
>  xfs_ioctl.c  |    2 +-
>  xfs_itable.c |    8 ++------
>  xfs_itable.h |   10 ++++------
>  3 files changed, 7 insertions(+), 13 deletions(-)
> 
> [...]

Applied to for-next, thanks!

[1/2] xfs: fully decouple XFS_IBULK* flags from XFS_IWALK* flags
      commit: d2845519b0723c5d5a0266cbf410495f9b8fd65c
[2/2] xfs: remove XFS_IBULK_SAME_AG
      commit: 82efde9cf2e4ce25eac96a20e36eae7c338df1e0

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

