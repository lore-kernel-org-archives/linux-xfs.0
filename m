Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD00CB65B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XqQCV1Vm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E075C433C7;
	Sun, 31 Dec 2023 19:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051957;
	bh=H/Uyx3aKGU5eUbUxmlUOhWkB126QiTfOGyYQQfaHDjA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XqQCV1VmFU1tKt02LYYdN7pQPr5GKTmt7v5zv7mgmqMiZ+qf5MAMFAZyFJo5A4wMz
	 lDQuhcKMJCf+nIr4gtgKXUC3EhBSwlH5beJJQKCcK8pI92CGzzW9WirHu1L14QWarH
	 j0wG4ErLOFF3oJe/bwxx48ceHzMcmQWrt9s6yUJtzCFil4dIR/sNJF9U5vURY+uwrK
	 RkiNRZIGOkQJD3bAqpv4sgv5cAQnz0yTZQ9hdd5ZJlhEzGdlpiwQds0vzokxU7eYVt
	 P5Tn6Kd0m7IBsh/Mc1H1Ehb5uRC6e9oGwv5+mhGMS0I/L8rgL9hYTG0eXTy3nTiEj9
	 QusaipI/BRxYw==
Date: Sun, 31 Dec 2023 11:45:57 -0800
Subject: [PATCHSET v29.0 24/40] libxfs: cache xfile pages for better
 performance
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404997957.1797094.11986631367429317912.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231181215.GA241128@frogsfrogsfrogs>
References: <20231231181215.GA241128@frogsfrogsfrogs>
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

Congratulations!  You have made it to the final patchset of the main
online fsck feature!  This last series improves the performance of
xfile-backed btrees by teaching the buffer cache to directly map pages
from the xfile.  It also speeds up xfarray operations substantially by
implementing a small page cache to avoid repeated kmap/kunmap calls.
Collectively, these can reduce the runtime of online repair functions by
twenty percent or so.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfile-page-caching

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfile-page-caching
---
 libxfs/xfs_btree_mem.h  |    6 ++++++
 libxfs/xfs_rmap_btree.c |    1 +
 2 files changed, 7 insertions(+)

