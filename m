Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8663B894D
	for <linux-xfs@vger.kernel.org>; Tue,  7 Apr 2026 13:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775569104; cv=none; b=JvJi/TnQistISpzAfqZ6rH7kWrwMRUSXUzceCZs5rsQEtnamFzesm5Jfn1XYa0EbK2StI5x6NadZglHdtQbT+vYisOpf2QE9xKsg/2y6p8O4yLCwaAwUOpo3OpeRmtV5G4GujXxNtOGBts7sMAau+2hdWAFZtQNva4t7xCrLkDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775569104; c=relaxed/simple;
	bh=0ZZai7d/HGkXEJPd6aRFmCLm9aWr/SmlL4TLW1tkc/o=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=TL0EQTUSj6a2UmUlO3KMx4vDORohAAVE6Cq/VHyyytzsDvvAt8Cq5wbXxLKlNrcfWeV1eK7pNECet4jcHogEugnZY1tPF4mVEveRKIwX0btiiC5koABvUlw8j0ih6bdlcj7gyPqvhj0heAFPOtgp9fMs8bsxLU+rEvLgCfh49BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l0J3pHRu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l0J3pHRu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B1C2C4AF09;
	Tue,  7 Apr 2026 13:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775569104;
	bh=0ZZai7d/HGkXEJPd6aRFmCLm9aWr/SmlL4TLW1tkc/o=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=l0J3pHRuDHGz+Lw+chMXllZH4z7CA01KehuOAVcLPJsMXdSqXlzBqiN3/bQgNIbVn
	 2VaPPueuurc7Lhp7aK9rvzZ9wtNn/jhxkoceq1rc1eRZ19sAkz4oQnDK/eFEAQiNet
	 gMBG1nUeQgbjEFFoqRxzSchkTi8Y0LXEHbsRnApd4h5+Z/IXtdqyoSD9xg2cB5K4m+
	 1A6ZxCtbRmD14lfek0TQEYwT1yyRU4VK+FEYo9LzqkM5qz0lmFXq42tzndlaxcQgKQ
	 6w/rlASw26Ck73G6hJvIfPe5o0daG9C3BdjNq7iQnY2t9a8WzBfoCT7Kjr9TipjREb
	 77PV74tnh5z9g==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: dlemoal@kernel.org, hans.holmberg@wdc.com, linux-xfs@vger.kernel.org
In-Reply-To: <20260406055428.470762-1-hch@lst.de>
References: <20260406055428.470762-1-hch@lst.de>
Subject: Re: [PATCH v2] xfs: fix number of GC bvecs
Message-Id: <177556910275.105112.18280406686635136359.b4-ty@kernel.org>
Date: Tue, 07 Apr 2026 15:38:22 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 06 Apr 2026 07:54:17 +0200, Christoph Hellwig wrote:
> GC scratch allocations can wrap around and use the same buffer twice, and
> the current code fails to account for that.  So far this worked due to
> rounding in the block layer, but changes to the bio allocator drop the
> over-provisioning and generic/256 or generic/361 will now usually fail
> when running against the current block tree.
> 
> Simplify the allocation to always pass the maximum value that is easier to
> verify, as a saving of up to one bvec per allocation isn't worth the
> effort to verify a complicated calculated value.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: fix number of GC bvecs
      commit: 2ffc6900d5c3a7cd59becda2aa67581d9bd3858e

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

