Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E1538758A
	for <linux-xfs@vger.kernel.org>; Thu, 12 Mar 2026 08:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773304740; cv=none; b=ANDzLXTiIipaAp+8v3CY/KjHMW78pneOGqX6KlAg9BvToYMHyo16umRydBLN7FRKdL4HMtVhzMrxbSx94JtchVSBQdcxtSf4RPfRvCom/Bi9o8CBULk3FMvDQEMzBU2mYRsGftGeSUfYpxFCcZ5K+ahi/5Mx48w9mSbrrhSPCZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773304740; c=relaxed/simple;
	bh=MEblnn+8/8vG474OwcjxDZOjKiheqwpcz+Fbgk5BJpA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=V6dwUF/F2yhUgiZIk0/yYJ8wduEGEyonRwFKEQVCujKHt6j0rwbQ+Jl/GkXrpzF1XWD6+wbiIoDpcVfOQb+XRtRLIXAL07Ihr+ehpfg9ytfSEyWKv8e6gx9Ir7zLSQ+BbYwqLQcZvLj9icaQ2nWiCoNSgkgM0kkXlujnSWNKMUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tXfyVrRW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tXfyVrRW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6AEAC2BCB2;
	Thu, 12 Mar 2026 08:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773304740;
	bh=MEblnn+8/8vG474OwcjxDZOjKiheqwpcz+Fbgk5BJpA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=tXfyVrRWOfYetanozT2ahPyIqiWLNg8ThSiKyNRXVkSOO713yZKi+yPEnU/YYQ68X
	 HU/pYPGzD04d4prqCaKpvGuHS8TUcublaQYE7Qrs5TD4scOdtv794Px9Gj4HaaYdTG
	 Awv7I8VBXE0x1vLT76kPsWdX+X2arpUO7Cxvr9G9PF8SW+SCeJV/ArUhL2W3pMf6CV
	 MFnMZxzLTChzMVdp6aW2t6d5Tm0sWJ1Z+eso15adqB+8HNs+ISMnpQw7N9Sez5iWr/
	 +RABs3umtjfi1rTV2JwgQ2v/NHtdqsLyc7KWnmS58H5cTf/qdo4xO1B0g5L3RNVJG7
	 vcssnBFNRsAwg==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
In-Reply-To: <20260305042620.GC57948@frogsfrogsfrogs>
References: <20260305042620.GC57948@frogsfrogsfrogs>
Subject: Re: [PATCH] xfs: fix undersized l_iclog_roundoff values
Message-Id: <177330473939.21168.5117477787553199516.b4-ty@kernel.org>
Date: Thu, 12 Mar 2026 09:38:59 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Wed, 04 Mar 2026 20:26:20 -0800, Darrick J. Wong wrote:
> If the superblock doesn't list a log stripe unit, we set the incore log
> roundoff value to 512.  This leads to corrupt logs and unmountable
> filesystems in generic/617 on a disk with 4k physical sectors...
> 
> XFS (sda1): Mounting V5 Filesystem ff3121ca-26e6-4b77-b742-aaff9a449e1c
> XFS (sda1): Torn write (CRC failure) detected at log block 0x318e. Truncating head block from 0x3197.
> XFS (sda1): failed to locate log tail
> XFS (sda1): log mount/recovery failed: error -74
> XFS (sda1): log mount failed
> XFS (sda1): Mounting V5 Filesystem ff3121ca-26e6-4b77-b742-aaff9a449e1c
> XFS (sda1): Ending clean mount
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: fix undersized l_iclog_roundoff values
      commit: 52a8a1ba883defbfe3200baa22cf4cd21985d51a

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

