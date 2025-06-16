Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13812E424D
	for <linux-xfs@vger.kernel.org>; Mon, 16 Jun 2025 12:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750077106; cv=none; b=GM2JapouX2Z1cHDMwRe9pBkxIeMUgULun81UIBy1ASovi88E9EG0KJMWdfvccNJRzvJzUsK5SaOvm/AZgMJHSXait5xxZcLSdyPDB91Q5ys5GC+cvEOu4toZkNQ2Z8Rmr0GI7E4n4IKTmlJgYtqQ33MXrgB2KurP7+LnzJOaEso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750077106; c=relaxed/simple;
	bh=7iGFBhplf/9ONvpTiAv3m7QinEdELklIgYCWhQY0X8o=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=lJM2u7BEl1SOebSRcwsIhaeSSztjCrdG9HIcT3PE0kbxS31N9m6uDaWY2RQsWgzrcjrOjL8QH4roz/Hd8U1DCSB0rRHhaFmMpXtFn/xoDEKiV/++SkUvEZ4/XzoyXRt2KWsL0hfGbI3EZ6VqSRGQuKN5zt/a5lSFwwmgT8J14QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tKnni7r9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tKnni7r9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74FD2C4CEEA;
	Mon, 16 Jun 2025 12:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750077106;
	bh=7iGFBhplf/9ONvpTiAv3m7QinEdELklIgYCWhQY0X8o=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=tKnni7r9fxkmgEdKpqLCnyf75rEJ267zAh2x3M3FwziGQ3d9KIedh9p+yyjPguGfh
	 GNhEJeuffMNBmu5a5VOisrbJMN+g/SdtpNxKkOWQpIWO20tZcCbtVXeAmKQBrre9CW
	 nuH5Ohhyxlgi8vLxhXVktY5T4yXQ6+BRmsan2CWGsgZDIjSP5Jc0rWKXox4zpI1gpC
	 rM0Otlqs1yPGMYQgHVQ2YrMFWkwpXAV3Tqk80ArZFT6wOLorebri5YNxO1DB4DzJDo
	 aLHhSAFvFkt/6Bj9rcGAHB7ojUGVPJp/S9Cam/AI4HdBQRgmxGxZX8aoYPmmbkzDOi
	 W9flOk8h1gAeQ==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Hans Holmberg <Hans.Holmberg@wdc.com>
In-Reply-To: <20250605061638.993152-1-hch@lst.de>
References: <20250605061638.993152-1-hch@lst.de>
Subject: Re: misc fixes
Message-Id: <175007710514.485207.10175203177628003185.b4-ty@kernel.org>
Date: Mon, 16 Jun 2025 14:31:45 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Thu, 05 Jun 2025 08:16:26 +0200, Christoph Hellwig wrote:
> a few misc fixes for the zoned code infrastructure updated by it.
> 
> Diffstat:
>  xfs_mru_cache.c  |    4 ----
>  xfs_super.c      |    5 ++---
>  xfs_zone_alloc.c |   42 +++++++++++++++++++++---------------------
>  3 files changed, 23 insertions(+), 28 deletions(-)
> 
> [...]

Applied to for-next, thanks!

[1/4] xfs: check for shutdown before going to sleep in xfs_select_zone
      commit: b0f77d301eb2b4e1fc816f33ade8519ae7f894f4
[2/4] xfs: remove NULL pointer checks in xfs_mru_cache_insert
      commit: a593c89ac5a417605b165cbc9768b3663ab4d8ad
[3/4] xfs: use xfs_readonly_buftarg in xfs_remount_rw
      commit: df3b7e2b56d271f93e2d1f395c13235a1a277639
[4/4] xfs: move xfs_submit_zoned_bio a bit
      commit: 0989dfa61f438150c4f1110604ba0787856fe8b0

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

