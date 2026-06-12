Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763043563F0
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 08:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781253417; cv=none; b=EcxVEdlECzgUGZ5c2lGskT8HvIN7ggVyHqLQ6+uDWMzGWMe2A7rHrIEz0IwuuO/WsTrEGflcDBGLgDxWKUk8KErB51HXFPApRfeQ4Oj2NKuCTAxpufDumyKDQHRvl9N24Onl958IK29byZM8YhqApn+d4HhkdgkFDQAiHoVnZrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781253417; c=relaxed/simple;
	bh=5vmmSeFxxX9r4mJKmb/l+wY0EyWaLBgE6tKE14wk0dw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=MXjo4pv27UU+t2kUs6pV7Nxm2ZQW01j+Jz1lLiJ19wvJuRY8n0keD47+3oYiu3JAMVmbrdT0jJ0BZ/jnI/fpXvwCdrzWKURYWenkXrEFjfcg7o5X187WoLe3O175dEnJxrra/qejFOb8rfQVk21sK65T6GE897Ylr0tvB8LxRAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rk0XEkRj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rk0XEkRj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0E21F00A3A;
	Fri, 12 Jun 2026 08:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781253416;
	bh=VJki/dl8gH4jMkDcwcFqBxYkr086cpGFfMeMMes0vwQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Rk0XEkRjf2nnuRyQnFv2WSi3vVI04A2IbMAwt5OQrBUN581nIiiCyDhDXRI/gVxCi
	 YcnoF3B4tUEAIjR6mInXI9Y0WDDeK1HZ8MGHoKr3oQX6KRdr4ENMu6lAN9L8sBn9Pi
	 jJP9UWHhDOMOoEO7t0jLlLyNvxPw9+048LVgu0bbkCcm1mAcbwojr6ODWdcsHa7N5J
	 LV8w1/lO8FRyGUPndV16T15Ox5Ku5Cu7S9wlXEWiDsc2b+ef/VAe+ta51KU6FIjp0X
	 KFc2LeD766vXG8CHi/S7jmUEeDYMCxd2q3jHX3tpERABntEnt2ToxiIKqOCsm6fJTq
	 nmmwr/Uc4mgZQ==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <20260608050451.1203492-1-hch@lst.de>
References: <20260608050451.1203492-1-hch@lst.de>
Subject: Re: [PATCH] xfs: move XFS_LSN_CMP to xfs_log_format.h
Message-Id: <178125341552.29986.1111501648153785182.b4-ty@b4>
Date: Fri, 12 Jun 2026 10:36:55 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Mon, 08 Jun 2026 07:04:51 +0200, Christoph Hellwig wrote:
> Because CYCLE_LSN/BLOCK_LSN are defined in xfs_log_format.h, XFS_LSN_CMP
> forces a xfs_log_format.h dependency in xfs_log.h.  Move XFS_LSN_CMP
> to xfs_log_format.h and drop the macro/inline indirection to clean up
> our header mess a little bit.
> 
> This also helps xfsprogs, which doesn't have xfs_log.h, but needs
> XFS_LSN_CMP.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: move XFS_LSN_CMP to xfs_log_format.h
      commit: 202ff980a464198616e53e85e5276e68c00a1031

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

