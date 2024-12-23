Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0823A38F82
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734989672; cv=none; b=M+ScSQ6X9tl2NJSNOJMkEsZJv4VdXl/vMliVIaiYMehDwU/r4MgvUfw94uLJB+HAIK7NOjU8EimSRiyu4Jk0UcRjITL8NAbhLcSMTjuC0gNOZr9vriMpfaB+7kr2pHI66h1VFHfiW8EZ5aho0hzBzskI6IcHulVi44qUmYIuUlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734989672; c=relaxed/simple;
	bh=9fcmv8frKdN5LGOUqclxC8ND+t7VbLMYEFN/6qlGXoA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sAu7CErldYet3U2ndDZzkGnMqo/eY3T1lrrUAQNPHItzxGD+H6LqkkepYgthVPfg3snHmLZiERnsivvyD4MepV9Yksb8DJtnxUJ9/1NSkJGaXhTirhnEKdqZJ80Eb7bXu/b9pGy/i56tSNVdzbpMs858KJ/XxpvdPz1jpjJW97s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CfCIkJ+H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CfCIkJ+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79FFAC4CED3;
	Mon, 23 Dec 2024 21:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734989671;
	bh=9fcmv8frKdN5LGOUqclxC8ND+t7VbLMYEFN/6qlGXoA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CfCIkJ+HV5CtYylayMg05OARh+J6viJvBglvGfuksBJ8gwkRXB+i004IzJO+ATjDv
	 1tc3SN3TZzH7oaE6R31rZsrvq9rZcY5pI60i5Ht05FaeudlEWNhGpztx7rPQpWII3X
	 IxlORITL9QGa+fcqKgWyDPykrPJwNoSTy+fr+CXlsML160ppsVJcbzFiLbN6q8K0pV
	 nkjNCvYeLhT6xKrSMlNiG2ro+AYkdViXkK13v+cZGkRHRUhHZWvHMGIwOHd66jy9eQ
	 +DSwQNjFqPCcZPaoK9P9FyMuogac4+K6c8Ufc8mOy/HOKnnwbvhsRr2soKExHk+GUv
	 5tzVW4prdhgAQ==
Date: Mon, 23 Dec 2024 13:34:30 -0800
Subject: [PATCHSET 1/8] xfsprogs: bug fixes for 6.12
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: jpalus@fastmail.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498939477.2292884.7220593538958401281.stgit@frogsfrogsfrogs>
In-Reply-To: <20241223212904.GQ6174@frogsfrogsfrogs>
References: <20241223212904.GQ6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Bug fixes for 6.12.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-6.12-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfs-6.12-fixes
---
Commits in this patchset:
 * xfs_repair: fix maximum file offset comparison
 * man: fix ioctl_xfs_commit_range man page install
 * man: document the -n parent mkfs option
---
 man/man2/ioctl_xfs_commit_range.2 |    2 +-
 man/man8/mkfs.xfs.8.in            |   12 ++++++++++++
 repair/dinode.c                   |    2 +-
 repair/globals.c                  |    1 -
 repair/globals.h                  |    1 -
 repair/prefetch.c                 |    2 +-
 repair/versions.c                 |    7 +------
 7 files changed, 16 insertions(+), 11 deletions(-)

