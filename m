Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9497937EFF4
	for <linux-xfs@vger.kernel.org>; Sat, 30 May 2026 06:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780123244; cv=none; b=ZAPttawR1C3Ri5KWUmhzOI6ewONwPCwJDg/Rhb4fDBhiOO1EcR6t8FXT9zuRXfvRBo/a1fxJAoH1A52O28AHUs8B3WCU8pl7bKPl4hml0oRFyPXaBvjv0GfQb0yVRfOiSqBaIuGQHuQPXRU4SorvBWuOVVy3yzUfY1YBFRIY9Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780123244; c=relaxed/simple;
	bh=PjGF+MadpcImUWJz+2Cyk4hFs4pJRScyPa/b34f08rw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=rykBtzYSgLnwElqf4BeCSkvnTeoqPUkG7itowlDk48/2afXr1x36seECQhOqYxs2nuNgugq3Y1PLXf9Kt4vv1Lvyk6qwOG5sdzjuGKoTFA5KXjJUOg0uvZOU1fWvgzi1ATvGWqVNuHLVFkGapKpeMpfWWRsfZH//K4XjiFaKGww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F7JT2nUd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F7JT2nUd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D111F00899;
	Sat, 30 May 2026 06:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780123242;
	bh=VkpJMUsgDVrv0Aa60Ne0VgJ6LslmSzM5XuIJfav8rAs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=F7JT2nUdOVvhsLno/Tpn+noOYnV4avBXP7zKIx2DfVSyVnFKrQM2uYZIUcFGx4od/
	 aPgcF9Eatzv9ZU7Maehb175IhC61n8mXLpgIs2jPvahTCQbOsGoCk0SPFGqnHUcRNk
	 ZKM7oZCnjG6nK/oWHw770paSgWKSonNDPmyKzCe8gkDcO+eizuSzwwPbfIPaa1WtVn
	 H3YICxYfBgKALqLPPEpDKxwtw+zlaqmgwtGN80XAqm/jhcmYSqAqlwCeZWC7BxKU8A
	 Um8zc1KedzAAzspuXAi++sPmbpqAHnOFahdqPlekcY1X8lhL8upD57pwkm0E9R8PPS
	 140eIh5bEclow==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <20260527123243.2316101-1-hch@lst.de>
References: <20260527123243.2316101-1-hch@lst.de>
Subject: Re: [PATCH] xfs: abort mount if xfs_fs_reserve_ag_blocks fails
Message-Id: <178012324098.23341.2486347612004614486.b4-ty@b4>
Date: Sat, 30 May 2026 08:40:40 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Wed, 27 May 2026 14:32:37 +0200, Christoph Hellwig wrote:
> xfs_mountfs currently ignores all errors from xfs_fs_reserve_ag_blocks,
> which can lead to the mount path continuing on corruption errors.
> Fix the check to only ignore -ENOSPC as in other callers, and unwind for
> all other errors.

Applied to for-next, thanks!

[1/1] xfs: abort mount if xfs_fs_reserve_ag_blocks fails
      commit: 8070a50b88971f9fada55a3ae3330f529bef9adc

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

