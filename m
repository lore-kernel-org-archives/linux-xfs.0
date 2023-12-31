Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E81FB65B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TMAV1ZF8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB4BC433C8;
	Sun, 31 Dec 2023 19:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051457;
	bh=t7mVDF9yZWRpfu+tsLR7xgdu+xPCdXQgVERfHpE00Bk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TMAV1ZF8yIkxsr7u4gxx4jYRomgHEodmAlqDDVhHdzkHT1gi/eczUWbgNy0y++FkZ
	 AF7z+AYTCofn+kb6GeBimK8YJU+821R1WO40ZZGpDQKUg9FrDLt9LPAoJ9odgU8yBV
	 IRF23Bua5ycO+6BKQnsAJ9C0h3OZpEF0YJ4eK3gUN8I9ni9kHWSrXdLJKvBbMiNNRy
	 CIwth9M/oIA4ik0LAUi3F9gPqbXLmDZHAbJABayfKvy+oVbrwWuHcBcrtJtuMZIby/
	 PviGEY+l4IATUhVhNN3YHSkVs7flk6kJfNZbrRgiMEHpmauxE1JqfZlELrT16GFQ2d
	 iu7pEK8NAag8w==
Date: Sun, 31 Dec 2023 11:37:36 -0800
Subject: [PATCHSET v2.0 12/15] xfs: refcount log intent cleanups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404850874.1765989.3728283509894891914.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231182323.GU361584@frogsfrogsfrogs>
References: <20231231182323.GU361584@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This series cleans up the refcount intent code before we start adding
support for realtime devices.  Similar to previous intent cleanup
patchsets, we start transforming the tracepoints so that the data
extraction are done inside the tracepoint code, and then we start
passing the intent itself to the _finish_one function.  This reduces the
boxing and unboxing of parameters.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=refcount-intent-cleanups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=refcount-intent-cleanups
---
 fs/xfs/libxfs/xfs_refcount.c |  150 ++++++++--------------------
 fs/xfs/libxfs/xfs_refcount.h |   11 +-
 fs/xfs/xfs_refcount_item.c   |  107 ++++++++++----------
 fs/xfs/xfs_refcount_item.h   |    5 +
 fs/xfs/xfs_trace.c           |    1 
 fs/xfs/xfs_trace.h           |  229 ++++++++++++++++++++----------------------
 6 files changed, 222 insertions(+), 281 deletions(-)

