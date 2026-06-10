Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E229E3B8124
	for <linux-xfs@vger.kernel.org>; Wed, 10 Jun 2026 15:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781105831; cv=none; b=cqN1U/94P9MspIORWwmvidGVCDlQmBZ/NW5mVxg7+WTdgh7IjujHwrTgIItgCjJDDrvCCNuM7lw7m+dpLDYy/YetEonpRYEzGIQ5CxkJVy9+5E4YTNMNpncnh1CapGAi7rJqPKmOelgcBx+EOUYjhdAIdzGQDBVg0JLUpN7NKyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781105831; c=relaxed/simple;
	bh=MbmTcIW1D1AmsYRD3Bd4LkaA2Dq+zL3RMj7gdiKAy9w=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=iGkFKgxzBL2I6hl6QuLXnluxEjdMgIPDfjjnB722iyxihOsV+Y+WPrxipSr45DrPqorWuyBvmen/mNckLkMZgIYlko+nvq941O6dWAD/jZyByYWFGLqJMhlT/svhPuXdRDaNTcL9M72oyB0zXyRDyldXUBmjak3qtML3E2YhwJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fCoMjOJP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fCoMjOJP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 553311F00898;
	Wed, 10 Jun 2026 15:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781105830;
	bh=fSqeKIc1Y05Qnd9oXnMuIshv7NQ+aV1VHR34A8qaXcE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=fCoMjOJPoLB5TrPIs8cMGpq3tyilWv9yeqHG2BKGwj5ksyJS4RHcHVoT/uwWl+VyQ
	 NxGGLxMY+Wp6AUaZ1BOZWs96gaUCvFLQjiNnXgp3fhRun6Px6a3+VKqYyTCtT6SlD8
	 9o1W8cOCX8zKG8VlxoHVEjiznnITMQiWJ3ROWvsXXtkWwb96JWDuijDlEGlzz8Ht+k
	 4Ugbh91oXBzmfMc/IBfWtE3+obkY182L8W5wHU2Ud0QG5tDoUoRoNa7iFmmbZRJ+ql
	 vI6ALSOlB+qkk0R8TKZeKL0mmschBMXwJmLTK0pPPzJMjAJvNCHjHrJNlEVX6x1S3/
	 uGInJ0DiXqDAA==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Nirjhar Roy <nirjhar.roy.lists@gmail.com>, 
 "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
In-Reply-To: <20260609075254.1698464-1-hch@lst.de>
References: <20260609075254.1698464-1-hch@lst.de>
Subject: Re: fix dblocks adjustment in growfs v3
Message-Id: <178110582901.150581.17928748673729463764.b4-ty@b4>
Date: Wed, 10 Jun 2026 17:37:09 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Tue, 09 Jun 2026 09:52:43 +0200, Christoph Hellwig wrote:
> the first patch fixes a possible incorrect sb_dblocks when growfs gits
> the maximum agcount or a too small AG.  The second then cleans up the
> surrounding code to be better readable.
> 
> Btw, is there any reason to have this code in xfs_ag.c?  It is only used
> by growfs and not at all in userspace, so having it in xfs_fsops.c would
> seem more natural.
> 
> [...]

Applied to for-next, thanks!

[1/2] xfs: pass back updated nb from xfs_growfs_compute_deltas
      commit: 4cb6e89a3d901d4da515977e55f9a9a779238660
[2/2] xfs: cleanup xfs_growfs_compute_deltas
      commit: dfac6ba84819bd12535943c4090766bbc6c5ea7e

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

