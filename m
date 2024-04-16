Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAEE18D
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 00:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713227620; cv=none; b=qPbe187lN62JG2MxUW5pnKCPJBTgyjk3Qej1AWRgynW3K2swfKNVQYZUcTts87mmoBKuXSu1Kgg/ugFfqnmeAIBWk5paxt9lqK6UxWWkTh+oWE7jVY5jSpMReCHeFnk1fsu+GuPYGjhfbig4i3t6J6Nar0NlVdW3tXMmgLyBw1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713227620; c=relaxed/simple;
	bh=DhFQZbcEPh33qjVJKsJmZbD+GxOy62sLW3l3J+sPZKM=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=gGatnEukPzGkFPprMGwThulGr4bZ/uyatMUNaTQaV4H84+ZBGmN65fy+btAmyaMVxtCM4OEIJpCAMaIx+m1v1aVEXn/ti2i8WVCAlZC0xwR+tUochZK9OFIRcBtNZmtqhVpPnwSOFJ8PB8URDx1zlc+5z4zTd5uEB8igjGuCsSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qL6Ctjrb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qL6Ctjrb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2990AC113CC;
	Tue, 16 Apr 2024 00:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713227620;
	bh=DhFQZbcEPh33qjVJKsJmZbD+GxOy62sLW3l3J+sPZKM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qL6CtjrbnnuIliDrar0bYAQk9ybaSlx0bD9Phml3e86ZHM1WSKLJgIEXnCDLBMACc
	 4zDC1hfI+n/uhXcNx614TnytKXWXcqbd8tbGDEBy9+RHJveZOHoj/Y2zt3D9vrTpFz
	 NVqC7x7d9T1B//+SpWb2v9Ln3c2gLoUI8KhKPlksKDIP4U/ZGUnLiomf+qm29M0aEl
	 C1FpVhXM/pTt5ZipVsZ5vyY+BQVYeFu4/Cbb+gwYMzyD25OB6dVICgANA+1ki97XCt
	 CPx0ozfajFQNBImv6V3CUB6QfpZCUmcI4XdOXqTTYaXEhDy+6K1dNsalG5J/skIfxU
	 IyTVge1KZlr3A==
Date: Mon, 15 Apr 2024 17:33:39 -0700
Subject: [GIT PULL 15/16] xfs: design documentation for online fsck, part 2
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322719661.141687.4087002222718920659.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240416002427.GB11972@frogsfrogsfrogs>
References: <20240416002427.GB11972@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.10-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit b0ffe661fab4b939e4472ef96b8dac3c74e0e03e:

xfs: fix performance problems when fstrimming a subset of a fragmented AG (2024-04-15 14:59:00 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/online-fsck-design-6.10_2024-04-15

for you to fetch changes up to 67bdcd499909708195b9408c106b94250955c5ff:

docs: describe xfs directory tree online fsck (2024-04-15 14:59:01 -0700)

----------------------------------------------------------------
xfs: design documentation for online fsck, part 2 [v13.2 15/16]

This series updates the design documentation for online fsck to reflect
the final design of the parent pointers feature as well as the
implementation of online fsck for the new metadata.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (4):
docs: update the parent pointers documentation to the final version
docs: update online directory and parent pointer repair sections
docs: update offline parent pointer repair strategy
docs: describe xfs directory tree online fsck

.../filesystems/xfs/xfs-online-fsck-design.rst     | 354 ++++++++++++++++-----
1 file changed, 266 insertions(+), 88 deletions(-)

