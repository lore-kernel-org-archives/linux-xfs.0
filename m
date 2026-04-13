Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720B0386443;
	Mon, 13 Apr 2026 17:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776102752; cv=none; b=Vgd3RqGGlnfpqVKgZVbc0BwzMJCvDhvwQ0cy7YzC9xZfj9rgp8NaWN2haL2bWbGyvgnhEQ/06yN/5D0tGCRQa2nX1er/JM0vQ6bahlcRvfIDzbWheKVt8mmdiiKIsDZsjsJwtyjRmCGC/X50uez4oUPqaRcPgbXiiG22QY4oHNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776102752; c=relaxed/simple;
	bh=YUndfSkjwtcHwHY9ZchV59/3zXRbjcno6Y0bRoC64AI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZiM0Xi69FFT1SZSFEGsXdjmPjfs0JjozQDGn9RWhzaJY1ll9M7HfYiHVVNXK4vEIta4eN8ir8/WQ2Ge/KEX408UNnUNdLTJtccUhlE4qg0tEq/CvMIZa3svuP+QyHHJkrD/C9jGefl0++InVmULbBr1+u91Xv+Qlvx6L44CSjVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vM5q8Ze5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vM5q8Ze5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B2EC2BCAF;
	Mon, 13 Apr 2026 17:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776102752;
	bh=YUndfSkjwtcHwHY9ZchV59/3zXRbjcno6Y0bRoC64AI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vM5q8Ze5qNHDGFiyvS12TE+G5y1sRwtjUBaSzkv0aAvdaCGBhZA1qbMM4dGrhcDLU
	 NWn3bPWW7OpjFd3b29HOiFguCxWFFNt/+/Lm/qke69YWVGsjuD215qV1IkPAWYLFes
	 DwEyi/umQK65uZZSQ2OSbqeUR6bGEA3n3rAwzvA5szzXjjWANXSbKrQcj3iT/mqVvS
	 qLxES3hoY0BtnAG1NxIqRy3iuVLHUecFkp8m3hKpHRBPKnfsp4N0ltXeI+3EC1KWpx
	 aPKho4Q0R4g3wLWyJI3F/u1pinqvaAYheSvnEanJ2Socl1Z4WowSYjHS7rbpIeOmPI
	 fmN653aqsFqQg==
Date: Mon, 13 Apr 2026 10:52:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET 1/2] fstests: more random fixes for v2026.02.26
Message-ID: <20260413175231.GW6212@frogsfrogsfrogs>
References: <177610246638.110415.16445576460857112820.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177610246638.110415.16445576460857112820.stgit@frogsfrogsfrogs>

Bah, wrong tag.  Ignore this thread, please.

--D

On Mon, Apr 13, 2026 at 10:48:35AM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> Here's the usual odd fixes for fstests.
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> With a bit of luck, this should all go splendidly.
> Comments and questions are, as always, welcome.
> 
> --D
> 
> kernel git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes
> 
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes
> 
> fstests git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
> ---
> Commits in this patchset:
>  * xfs/841: actually compare the new filesystem contents to the proto dir
> ---
>  tests/xfs/841 |   25 ++++++++++++++++++++++++-
>  1 file changed, 24 insertions(+), 1 deletion(-)
> 
> 
