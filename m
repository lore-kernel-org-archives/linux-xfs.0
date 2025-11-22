Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6A81E1A05
	for <linux-xfs@vger.kernel.org>; Sat, 22 Nov 2025 10:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763806150; cv=none; b=OzArS02GyulSCmaAQaYA/Q95yhSNDzcM3uzt11TZR4keUMsyFvuc/7oV5XHuTL9KfUEaO9VfRKDkp51ZEDXCE8uxgyM2u/gOkTvoEDrWJ+OQ/7noHu8wi1+EeJHiSQlaJ/DKcnt2ik02AKFN/svHKgFEo34Ri7sC2NkQN9Y7sTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763806150; c=relaxed/simple;
	bh=xYWWTZ9lkTZ3egf7ThkFNDEMirFJVYaUyYK+fttKVd4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=QmdCAFd+iy7IgHqn6b5WyweFJVR7+t5XkZrDzCHwgL9tlewfWSIjLghIPG11K4a7LdTTiX+5Utm8M+8ygkAogXmadj8UUtJcXxl9pujLoehddn9MN8lSak3Sn2Gtqfp1rBTr8rYK0Cf8aE9IRQj8jWjrCX5r1xRy/eoo34taTIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UhnUelWe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UhnUelWe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E133FC4CEF5;
	Sat, 22 Nov 2025 10:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763806149;
	bh=xYWWTZ9lkTZ3egf7ThkFNDEMirFJVYaUyYK+fttKVd4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=UhnUelWeFfQtwk8/rwEUoCS91MTzPOzUU0ojA4qHhe0FGurhS8DFuFJta8RQUyd3C
	 e7vm9P9n1iS9CFIJDsJ2hoMG/1wALbO1tzrPHuSi1gbKR8VBzSkyBe+z4YHEzZmIvQ
	 8PDLLzgaHVWWBJryfJlsa00yzvv66wGzF9eE+tY9IvCcA4gmx5fsUDigTJR1RiFpL5
	 RUD/lOdp75Vt+9R0eDLJJxFG5lwHbVIVrll0idXAQUzB40sZrzUhvoPxkBmFVXJR4O
	 7iV2QlpcWpUOn9J1sAJILVkhJLvgHqRRoCa+az62d5ErnQnxzguwTA3id1+fNI4KEq
	 Tbi612FYwri/w==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
In-Reply-To: <20251112163518.GY196370@frogsfrogsfrogs>
References: <20251112163518.GY196370@frogsfrogsfrogs>
Subject: Re: [PATCH] xfs: fix out of bounds memory read error in symlink
 repair
Message-Id: <176380614861.104488.3812428808059888654.b4-ty@kernel.org>
Date: Sat, 22 Nov 2025 11:09:08 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Wed, 12 Nov 2025 08:35:18 -0800, Darrick J. Wong wrote:
> xfs/286 produced this report on my test fleet:
> 
>  ==================================================================
>  BUG: KFENCE: out-of-bounds read in memcpy_orig+0x54/0x110
> 
>  Out-of-bounds read at 0xffff88843fe9e038 (184B right of kfence-#184):
>   memcpy_orig+0x54/0x110
>   xrep_symlink_salvage_inline+0xb3/0xf0 [xfs]
>   xrep_symlink_salvage+0x100/0x110 [xfs]
>   xrep_symlink+0x2e/0x80 [xfs]
>   xrep_attempt+0x61/0x1f0 [xfs]
>   xfs_scrub_metadata+0x34f/0x5c0 [xfs]
>   xfs_ioc_scrubv_metadata+0x387/0x560 [xfs]
>   xfs_file_ioctl+0xe23/0x10e0 [xfs]
>   __x64_sys_ioctl+0x76/0xc0
>   do_syscall_64+0x4e/0x1e0
>   entry_SYSCALL_64_after_hwframe+0x4b/0x53
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: fix out of bounds memory read error in symlink repair
      commit: 678e1cc2f482e0985a0613ab4a5bf89c497e5acc

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

