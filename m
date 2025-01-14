Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96931B86D5
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jan 2025 10:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736850631; cv=none; b=lB+5a4KooWRynjzNE3j109V5AnAKA+1mQkTIHEYY2leXubxFTk93TBNOk9afVFj5TDQWwtBBpqGSqqhvMCRR1oP2LeL6CgMsKMud9KpcM+BDrzx0lOMMTTxmNb4EBHRBtokbqe1q30w+xFy53wEOuGBQZI08MTIqG6hZoxAuL+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736850631; c=relaxed/simple;
	bh=osRD3iMK3OrQmNyrBo5mwjnHWH+iQLaD7kTV/q/dkx0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=dDX5U0vv7ddw1UEh25R8dp1Rx9RvW+6VC/mo+1nIvWsaBSAWZONEvksIRjIaMIRkIj8UnjYFsEA8XmDWAQZ6DEkLyOsB+MGa2JqC4THXbXXtSqCJCGSSvuxlTLG2OB3yodCU3EKQK627FdF1RuKXE6TvDL+npX0P4Cs3Pr+6FrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uhNdfrIy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uhNdfrIy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699D9C4CEE4;
	Tue, 14 Jan 2025 10:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736850631;
	bh=osRD3iMK3OrQmNyrBo5mwjnHWH+iQLaD7kTV/q/dkx0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=uhNdfrIyYaMF6IjUboLIL3ijwg8ZEYnzvtVeRhzDc7t5uJRVUMv8p/ykcUel9S7Df
	 pb6WN0BDDh7ax3yDKMurDDkbRwOIvBCi39YIRBl6/1uQq1Rg8DzkQizSheeaUeCPqV
	 jMLbDSU2ATsYhZrVx4l5sgQ8Wj6VnraZkr4gfKk2/HwUz8cP/lFP4XJu8Tg6jpsdZN
	 0+va6AM2ul7Q0Io75nAeuN1lZpnoUUXmW3teYNqECv+1S/5TnT+gQ244YVLWl58mKH
	 B5gmKN1oEyyzfqdBFm4MRhEhkCXVqKo6B4WrGzC1+gGs9ppYp/t5KApA3lPE7wdefI
	 cBHnLk4ROgFNA==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
In-Reply-To: <20250106095044.847334-1-hch@lst.de>
References: <20250106095044.847334-1-hch@lst.de>
Subject: Re: trivial cleanups
Message-Id: <173685063013.121209.11054121070124254959.b4-ty@kernel.org>
Date: Tue, 14 Jan 2025 11:30:30 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 06 Jan 2025 10:50:28 +0100, Christoph Hellwig wrote:
> this series has a few very trivial cleanups.
> 
> Diffstt:
>  libxfs/xfs_dir2.c       |    6 +++---
>  libxfs/xfs_dir2.h       |    1 -
>  libxfs/xfs_log_format.h |    6 ------
>  xfs_trans.c             |    2 --
>  xfs_trans.h             |    1 -
>  5 files changed, 3 insertions(+), 13 deletions(-)
> 
> [...]

Applied to for-next, thanks!

[1/3] xfs: mark xfs_dir_isempty static
      commit: 23ebf63925989adbe4c4277c8e9b04e0a37f6005
[2/3] xfs: remove XFS_ILOG_NONCORE
      commit: 415dee1e06da431f3d314641ceecb9018bb6fa53
[3/3] xfs: remove the t_magic field in struct xfs_trans
      commit: 471511d6ef7d00b40e65902ff47acfc194c6a952

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

