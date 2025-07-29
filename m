Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FB01F956
	for <linux-xfs@vger.kernel.org>; Tue, 29 Jul 2025 20:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753820018; cv=none; b=Z49yCF1J/X/sSorLSf004lW3u27L0jS2jXJ9VNsJjem5lz81hVdfqtSpYGmvIY/Y707h49NY8Hb1LTqq2aF3MV3zZGTPIyeOqf+ksqfcoWbapRutu6PP44xxXFVFar5idqZOrd1briIibnc00zrbN8YalvuThF1szWOoaYPHTZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753820018; c=relaxed/simple;
	bh=GXEYr4Doj+YdqGFAyOakmlJnf+rVxBQjH/htVO+NJ9I=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=fYppY5ZiZ6subFkkO0B1xPFQjPJVfvxw/2GGrLjbIQ7/AZ850rjDFkuYL5RRWo51ErhJdNlFtVA9/Cp410qwwIyS2SHRQZMsfceb1jdlJoMy7gvknznQotgHud/c/mFlrQDgHanKOO5Eth7ojq/3peT6ZGF6q9BvmN8VTaWSGko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m4kIsGRr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m4kIsGRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3123EC4CEEF;
	Tue, 29 Jul 2025 20:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753820018;
	bh=GXEYr4Doj+YdqGFAyOakmlJnf+rVxBQjH/htVO+NJ9I=;
	h=Date:Subject:From:To:Cc:From;
	b=m4kIsGRrUUUTDcFEQNah1lGu3rrRGhrC/mN6A0w/eg3WAoEX+aniMM+fiYdpe3Pux
	 RAb+H0FX9LQfdNFkdS7oRxgEy6JVqMVbzlkNgfFys5w4kT7wXzqMjLRhAP9Mi1a+6K
	 FHo3TxXM36c3Z22AWHy70kHGcdN23I3hdByVSEAp/scu97s00pe+3Grgsw3Xxl4XE/
	 xws8nElRJo+kXTTxdVi/0PKL82gtF1fLJUVvN/dB4jQh68KV6HY+1ZwMWJIBNS7n0n
	 ecp+NCQpNp1B++SVutZNJwx/kaTMbONTD885utfB7sCc1+HZ0p/Vonm6qlEIhDEJrF
	 PeDtI0izR+5Dw==
Date: Tue, 29 Jul 2025 13:13:37 -0700
Subject: [PATCHSET 2/2] xfsprogs: various bug fixes for 6.16
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <175381999056.3030568.12773129144419141720.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Fix some build warnings on gcc 14.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
Commits in this patchset:
 * misc: fix reversed calloc arguments
---
 db/namei.c          |    2 +-
 libxcmd/input.c     |    2 +-
 logprint/log_misc.c |    2 +-
 repair/phase3.c     |    2 +-
 repair/quotacheck.c |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

