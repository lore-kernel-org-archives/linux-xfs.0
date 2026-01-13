Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C0C38F928
	for <linux-xfs@vger.kernel.org>; Tue, 13 Jan 2026 13:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768309842; cv=none; b=M6W/V2omarzegwYdHPsG5UnQ62wQk7ajn7VSP8/ifEpMmXcYBMXxWQGmfPhW26vEiEjpky49qitWoA6hs1/pRCi5+Uj0Ahu9SEWNnFxwdiIJ4FUJe78Prw4U+OueydloiCZOXCiy8MdQdvnxzF1QsOpp9ojjKWjkjukOepzok6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768309842; c=relaxed/simple;
	bh=XQCBqYh3+cjYCEYXGQ3b6Jgx5WGmrSU26M+fPDW9G0c=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=a1jYwijotTJNxMAEt61FkyDg++OwDNVHD1NPq2/VEQNUneLY3jqSDlEoNRG0z0sWaSZTJThGZfoTzK0KH3lqHOjBeQhTIfeLb54+yD0oK1t+bgXdCvmB2iV54z0fXgFqcG3yX16XsNCRL58BvnhuZZMO84+4K82bq7p1v2MPWpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q6LMIIH8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q6LMIIH8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87740C116C6;
	Tue, 13 Jan 2026 13:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768309841;
	bh=XQCBqYh3+cjYCEYXGQ3b6Jgx5WGmrSU26M+fPDW9G0c=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=q6LMIIH8A4Hzeqc+kfvq5oK5bRI8Jzn2ZXdJaKu12SeXVAtfsoOgQFMa32akHVfkP
	 kXbOPjs+bvWqQmFZY69SgfSLDgRiZlKSNm0l1RMsKz9vJ8l41PkE+wC6cZ86fF9o3D
	 SOa1hKeYMIymE6/f5lEakEU8cl3Ja+aXBvQLvT4uNPTXwrNWEfzCLNPEqXfIjcNPhr
	 87S6Kr4b6Q0lITG5VRGuHvHE1tEvS+wx9uoepMD7SoVKOqzTWFG9bMfCry3eEgw4Fr
	 qbjibT78WuzMNvoaW+CZb/7NTFjZKwqTCdXKoM377ts8gcG0LEuWCyPtyrwwbh1Qar
	 hYZyoXGF9MUDA==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, 
 "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: ritesh.list@gmail.com, ojaswin@linux.ibm.com, djwong@kernel.org, 
 hch@infradead.org
In-Reply-To: <9b2e055a1e714dacf37b4479e2aab589f3cec7f6.1768205975.git.nirjhar.roy.lists@gmail.com>
References: <9b2e055a1e714dacf37b4479e2aab589f3cec7f6.1768205975.git.nirjhar.roy.lists@gmail.com>
Subject: Re: [PATCH v2] xfs: Fix xfs_grow_last_rtg()
Message-Id: <176830984026.127908.1608705723447538666.b4-ty@kernel.org>
Date: Tue, 13 Jan 2026 14:10:40 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 12 Jan 2026 13:54:02 +0530, Nirjhar Roy (IBM) wrote:
> The last rtg should be able to grow when the size of the last is less
> than (and not equal to) sb_rgextents. xfs_growfs with realtime groups
> fails without this patch. The reason is that, xfs_growfs_rtg() tries
> to grow the last rt group even when the last rt group is at its
> maximal size i.e, sb_rgextents. It fails with the following messages:
> 
> XFS (loop0): Internal error block >= mp->m_rsumblocks at line 253 of file fs/xfs/libxfs/xfs_rtbitmap.c.  Caller xfs_rtsummary_read_buf+0x20/0x80
> XFS (loop0): Corruption detected. Unmount and run xfs_repair
> XFS (loop0): Internal error xfs_trans_cancel at line 976 of file fs/xfs/xfs_trans.c.  Caller xfs_growfs_rt_bmblock+0x402/0x450
> XFS (loop0): Corruption of in-memory data (0x8) detected at xfs_trans_cancel+0x10a/0x1f0 (fs/xfs/xfs_trans.c:977).  Shutting down filesystem.
> XFS (loop0): Please unmount the filesystem and rectify the problem(s)
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: Fix xfs_grow_last_rtg()
      commit: a65fd81207669367504b6da7758e130ee23a7dfe

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

