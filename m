Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B6A3D25AF;
	Sat, 17 Oct 2026 03:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792206049; cv=none; b=FvnfJaC6jmqyZUy3NihU+HtQndaxdeg0PmjjwwyD5LD79sXgL7r6zOGXKuTOoFOSMrp42k7FxHBc+ff/HweTfSUw2szh3ULlBvaYQy1SKh/XDX/aFI8dD1DGrcszz1FxPV3copEAGm1jE9gAAqVZd1HddcRg5dyot+CaD7o26zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792206049; c=relaxed/simple;
	bh=ZxY2ewvAyCGf0W5oDI0JF6PejlFkx0vbgD3vISr8yec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwqF1OEdIIiT/TvBSUupQPfXXPRvk+ISaYDg6se2TGYISBP7xxgBWLo3mP0OrrIadu9S8k6xHSI/9YNjqqKiwvbrxUVsOwR34HEXPKhNUM/uGUf/HCQI9mKgiHm1FenOLYiTTLcs+LAdT0jX1zljSo4pXiZanHBPewp4++UORyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kiBZRExA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kiBZRExA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3BC81F000C5;
	Sat, 17 Oct 2026 03:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792206043;
	bh=b1w9m2npCpezIUVFXjk38rBt1VNqxZujZbRMYrLkZ24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kiBZRExAd8FraP+Z1ubE/PtGvNUdsALDj27HYD72dvwlR5e/H6kXUVBszrCXmJa7A
	 j4CZxZh82gyg2dbe82b7cN57wpTNkWxrQ+nETA3xzwaj8R41AgMT3cyldHoGylcsoO
	 UZg00PXFXYdYD0oimLkh3IIWMFkBk5k1CF1KKK0VA4JpNuCc3vhYD1N97YRHJ2DULH
	 SAelAvxfO0Ac1Is5yyxy9cQasXROmzP1irFq3EHmCMnXgnNmLJsOEHsVsWwsRVoxhF
	 lvczGh6Tn3g4KoL6j0KEzHlalU2/4i6BljvvOSsgGQeTXjPwbvyNpKpdln4Di6Pwl5
	 5zlTCFjWiblAA==
From: Sasha Levin <sashal@kernel.org>
To: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-kernel@vger.kernel.org,
	Mark Tinguely <mark.tinguely@oracle.com>,
	Siddh Raman Pant <siddh.raman.pant@oracle.com>
Subject: Re: [PATCH RESEND 6.1 v2 0/5] Backport of XFS umount hang fixes
Date: Fri, 16 Oct 2026 23:00:19 -0400
Message-ID: <2026-10-16-1-daily-reply-0014-xfs-umount-hang-6-1@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883290.git.siddh.raman.pant@oracle.com>
References: <cover.1791883290.git.siddh.raman.pant@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Backport of this series:
> https://lore.kernel.org/all/20250625224957.1436116-1-david@fromorbit.com/

Queued the series for 6.1, thanks.

-- 
Thanks,
Sasha
