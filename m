Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A1DCA6F
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 02:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722307578; cv=none; b=bsgdfLkwbFtncTFn9N7YjkAprsSYVd0KyE3hI/qJwz5Zi3K6O+tAvZ5XctpfC7G5FVS2x4f54A8UlmPJvSThjwhwNUscwkMdhNaqYjjuqJfGPutdn7wxdBz9EE53MP/c21961P72YqNytRAiipMKzjAI15nVuaZDyTRr4JV2Rzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722307578; c=relaxed/simple;
	bh=MTRfib7wbAt5TwZwy3vPUlchmd9WaFe3ICUPtTr5DMs=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=H1+uaOd93SZTmKSTvjvRX3ucJw5QSQ/9Pb9ohSVlSSEsQkhXOW1T5yLmqQ+ejXY+kIw9vCj4hAM2ILkb/28ttzdxqlnRQs23yxrO3+AgRbziu0XNl3Ta+sL9L7/s55wVQJEFJhCb3nBT4L0OZ4Oj9/t3GPaottCV36kd3P80MP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k8etkOtd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k8etkOtd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EAB6C32786;
	Tue, 30 Jul 2024 02:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722307578;
	bh=MTRfib7wbAt5TwZwy3vPUlchmd9WaFe3ICUPtTr5DMs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=k8etkOtdaX3gDptOoAb6o0vi0u86Qy8XM9siNDYLKRs0LMmVFnfxcT6Moq2vmIm27
	 hRfLYgM0Ee9h/eGggMhatoiQVPcl5ySHX0u/XKzEzVJC/ZbFCU/ohTwyUao50kCJIB
	 JTJGOaUtqrl8y7e7GaObDFGUhhEB2wtU19QxOjNc1pzdbtqfZky0u+HXTbdPxo3lwE
	 ZAFV41ViqWG7hjRk+8UIlN+nIiof86zstwrdasBoSLdKRn4UyZR4wiptQVQeA6K/JE
	 tJrIsIvZA5VH4sYcSzh4NQ/H5Lc2rIiQl0lAyRfATiqPgDZvQh1gu0j3+W3y0XLELS
	 SxGPMMR2OMZOg==
Date: Mon, 29 Jul 2024 19:46:18 -0700
Subject: [GIT PULL 23/23] xfs_repair: fixes for kernel 6.10
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172230460123.1455085.10638034565139241088.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240730013626.GF6352@frogsfrogsfrogs>
References: <20240730013626.GF6352@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.10-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit df914edeeb1e1919831192951d657cfc73b46418:

xfs_scrub: try spot repairs of metadata items to make scrub progress (2024-07-29 17:01:13 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/repair-fixes-6.10_2024-07-29

for you to fetch changes up to 5a43a00432ebe9ab8b54155703a9eb9e1a1dd4ec:

xfs_repair: allow symlinks with short remote targets (2024-07-29 17:01:13 -0700)

----------------------------------------------------------------
xfs_repair: fixes for kernel 6.10 [v30.9 23/28]

Fix some incorrect validation problems in xfs_repair.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (1):
xfs_repair: allow symlinks with short remote targets

repair/dinode.c | 5 +++--
1 file changed, 3 insertions(+), 2 deletions(-)

