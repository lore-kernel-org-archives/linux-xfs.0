Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19A632E727
	for <linux-xfs@vger.kernel.org>; Thu,  6 Nov 2025 13:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762435634; cv=none; b=GWsFzfBMtTmQrIZdleC6sZNq00sJWKqp8/aOqIXWM8gMeIbvJxrH6ay8TVImQS/tKqJQShQzvsioGuk3l/pRUs6yroE2lf6M0g10F5zaOvEnM+rRLiACei+G5xlcaMXcM+RTWhIVjKpM4x2OpsOnL71fuHDu+GtF40h1IR/+eAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762435634; c=relaxed/simple;
	bh=z1YLMkRMVDGqWuS6Vnf7FTagTU9S1nOxqvpNDnSmJ/Q=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=kWbtMxedMFWgt8afVzGIdpSephTtRbT0L5KSuOIUGd629IaamuJb8zDTvwZy2JhtCE0lA5wl/tsuTB256Gh7/Izj3cF5yjSIF6Hd9Q0/5oPe+c52jpGdNUrdF6RiGJHeHdtE+mXPgeOJTjfXzH0s+ycbY+DXewYBz4PEAD0IuMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NvV0P4ra; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NvV0P4ra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E10C116C6;
	Thu,  6 Nov 2025 13:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762435633;
	bh=z1YLMkRMVDGqWuS6Vnf7FTagTU9S1nOxqvpNDnSmJ/Q=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=NvV0P4raGQrRF07ibNO3EL7/XdsYtNdzdLJL1raCIXKJsi3mHCIMBfMiYkP7W4xrB
	 N6yHXnmD8p5eh5U72NL8XWEKWZb8udw4T1PxZaH0+gWc/S2K4Iusx1hw/En+3vZ8F3
	 0qVsslKSoH6Fjg2QHKZBGj7gDiekVJvlmzYP6/l4p9IDvp24Qwh4asEFahpLN/ZXXi
	 a+MBp2vUwdz6vs5yeDtHVryMbu/q7/oSg3gMoUOUi+nBIPQuPbSGVhJZIChiXhu2xY
	 MuZ57o332X0ztHe7oFLNTf3x2T+ockCZzTz5fHAaArVxRVd3rtYp1BG9N/Ih3pLnFz
	 27mPGvyDf/Djw==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Hans.Holmberg@wdc.com, linux-xfs@vger.kernel.org
In-Reply-To: <20251103101513.2083084-1-hch@lst.de>
References: <20251103101513.2083084-1-hch@lst.de>
Subject: Re: [PATCH] xfs: fix zone selection in xfs_select_open_zone_mru
Message-Id: <176243563203.345504.14107698306941071996.b4-ty@kernel.org>
Date: Thu, 06 Nov 2025 14:27:12 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 03 Nov 2025 05:15:13 -0500, Christoph Hellwig wrote:
> xfs_select_open_zone_mru needs to pass XFS_ZONE_ALLOC_OK to
> xfs_try_use_zone because we only want to tightly pack into zones of the
> same or a compatible temperature instead of any available zone.
> 
> This got broken in commit 0301dae732a5 ("xfs: refactor hint based zone
> allocation"), which failed to update this particular caller when
> switching to an enum.  xfs/638 sometimes, but not reliably fails due to
> this change.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: fix zone selection in xfs_select_open_zone_mru
      commit: 21ab5179aafa2ded7f3851bfe7e043f8a3b6199d

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

