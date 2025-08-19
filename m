Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC2A33A019
	for <linux-xfs@vger.kernel.org>; Tue, 19 Aug 2025 13:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755609063; cv=none; b=Fj7rdQ/PStP9KTMdwygTzZjFrk/x4rHW0ah4CI9T8+wm2N22jySXGquUiigPUMtYUjYis6VjtCb+MQ0ldrKuR1kqbEHgXS6CMeeA37iLRHvbgL7GbYodnOty6D1De07uYuC2hRPZx1f074F5fegKq+p39ijNbEDANyy6e23lfBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755609063; c=relaxed/simple;
	bh=SBUzHVbvBfqdnyk3PR+hdyPe13W34eBWiOjwZcJ8IyA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=cxQAQE7WxiuivOuIUnKVVEGrDnuECamaDKheIwc4SB1os4+SWC6WEZNRw2I2j6gSBrNxIUc9fJABjMkxLgEmICevkpeF6EgdfiWjaXYa+heJ7fVuDnwZHsV/yG5yykZlFd4WiPHJ8KfzuNOJF9TT9FEhCO1QZX/g920FbE6+Fos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NxcFxbnm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NxcFxbnm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2373C113D0;
	Tue, 19 Aug 2025 13:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755609063;
	bh=SBUzHVbvBfqdnyk3PR+hdyPe13W34eBWiOjwZcJ8IyA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=NxcFxbnmjfWHM+Gn0WQrNigkcPqGjVOcUGvmK8HiDDvffjVXaK0O8tvUwqjuKKhq7
	 PaTZjtJGzfv3b6AFJz98ayOd+kbbBMmuiAMWPSYn8Ax7S+xvxkhXXqkKKwAe8GAfHG
	 C4pjvteskvm+D75g0wx04kqHzIba2334BDpsdtykhCt0LV9T3o7awprejl7E4jy1+f
	 d2huoxgY39apj/1jbdx6QUuWqjwlAzjpxOyjJdv0fpGr2sb00GLUflMG6f3pSAmDV7
	 60sll0UWgA2xna5NFHU58S6/We9HESkw5FY5Cc5dst6cebcooQmXiljclh2Ff+sz7v
	 yhjbEAIvJRZLQ==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
In-Reply-To: <20250812025519.141486-1-dlemoal@kernel.org>
References: <20250812025519.141486-1-dlemoal@kernel.org>
Subject: Re: [PATCH] xfs: Default XFS_RT to Y if CONFIG_BLK_DEV_ZONED is
 enabled
Message-Id: <175560906231.126210.18067705164822718709.b4-ty@kernel.org>
Date: Tue, 19 Aug 2025 15:11:02 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Tue, 12 Aug 2025 11:55:19 +0900, Damien Le Moal wrote:
> XFS support for zoned block devices requires the realtime subvolume
> support (XFS_RT) to be enabled. Change the default configuration value
> of XFS_RT from N to CONFIG_BLK_DEV_ZONED to align with this requirement.
> This change still allows the user to disable XFS_RT if this feature is
> not desired for the user use case.
> 
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: Default XFS_RT to Y if CONFIG_BLK_DEV_ZONED is enabled
      commit: 9ce43caa4b7be707638d49ad4fb358b6ff646e91

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

