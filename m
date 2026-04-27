Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9057E3C9EF8;
	Mon, 27 Apr 2026 13:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777296380; cv=none; b=qzU9BHtoworhAVsFzntPCjPqCtPVfcisOHss2x1bfqyg6zWuweobll8zHH4AJtnVRxGw+wjGzJt0eBvnvw6K0jfj76jcLxm33DCadQUHpIX3B6Q0YE6BEO8B+2sQHJWe2hFRQuCVzHfvYjWfFmtLUJ/gSpyWBVg1AC+s4UlD0cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777296380; c=relaxed/simple;
	bh=xxmNZbRr62SG+VmM9KIzJp6aA1rrP02lPzVgQRiGTtU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=dB6RhIUp9VUl0JwuU1D+XifHFyGuvfwnyv2OUgm6jfeunekg6OpShuF6Yy99fdhiJH3nWgReNAsXXIiGvuMZyEdNoJBAy7svtqTdz+3vx9Ch+TkgaXZty5UUSx15G005ja/ukRDaoAK6xskZUGk4Zl/At3ZHkxrMH5agIFMmHWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HmfAEQRR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HmfAEQRR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349B3C2BCB4;
	Mon, 27 Apr 2026 13:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777296380;
	bh=xxmNZbRr62SG+VmM9KIzJp6aA1rrP02lPzVgQRiGTtU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=HmfAEQRRCJHQ4UREW+v3SNAJ9xWGIPRw8oqknG5m7QysAgBJAiOknBwkSrpgJHLJY
	 c8jbjlUzIQMbroFQeFAPvRk2mXsyhUuyMlWLRKw03vbhcRiV8sWDlv5Gn/LRUwm/el
	 DLWEj0rd1u99EoNwfQRMBIDhimuFowFvq1pbeI1tWwFGdCNoK3YcXPhgAWoNe7Gf4K
	 yHk732DX0G/SDveUDSriAUca7KAR7aX9oy6dBIaF1bo+/ZJkTPmW7f7x3vH88szpSa
	 UiKrBJ+xk1Dswk/kopsmhFmPSjyZjMpwGg7LK0OE3mSQyMs210p1xeVNP++C7ezJQx
	 lTWroB70qiz5Q==
From: Carlos Maiolino <cem@kernel.org>
To: Yuto Ohnuki <ytohnuki@amazon.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>, Dave Chinner <dgc@kernel.org>, 
 linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260411142411.72194-5-ytohnuki@amazon.com>
References: <20260411142411.72194-5-ytohnuki@amazon.com>
Subject: Re: [PATCH v3 0/3] xfs: clean up directory data block header
 padding
Message-Id: <177729637893.100803.1237767680189692342.b4-ty@kernel.org>
Date: Mon, 27 Apr 2026 15:26:18 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Sat, 11 Apr 2026 15:24:12 +0100, Yuto Ohnuki wrote:
> The pad field in xfs_dir3_data_hdr exists for 64-bit alignment and
> should always be zero. Old kernels zeroed only the xfs_dir3_blk_hdr
> portion of the header during initialization and initialized the
> remaining header contents separately.
> 
> This series takes a broader approach as suggested by Dave Chinner:
> zero the entire header region unconditionally, self-heal stale non-zero
> padding during writes, and report remaining non-zero padding in scrub.
> 
> [...]

Applied to for-next, thanks!

[1/3] xfs: zero entire directory data block header region at init
      commit: 00dd8d7ec5253c6273023a0fd6dc08683e0bdfef
[2/3] xfs: zero directory data block padding on write verification
      commit: 8fbb1877dfa5e26bda1baf8cc6abd3f805098486
[3/3] xfs: check directory data block header padding in scrub
      commit: 939919ccddfcc379bb82b1f90f732d9a5cb32cc8

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

