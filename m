Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776D9B64C
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ty01NZu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4943CC433C7;
	Sun, 31 Dec 2023 19:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052223;
	bh=Dh4dOrjWAqATrArmFQvKCdc3WD8Qatl/nbV/+9JUYGY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ty01NZu35mqkqmhEZXnC9o37dhzmIQodz8RwVkfpwhoWSJWS+nJfk0Ou3uDxwcpQE
	 lVsyttRbi7owbDBBQzUHplGaL0y4lgrdlwN67WudVS8Es5jRvwloHkfShM9jI1H3n6
	 Pn7Xne5v7LBJA44/bV1E4Qum/+IfNFVnYDZcR8Uu0hgWewFeEbhLbHnn+kO7peI9Or
	 CX0Ax0SM+LqnkOckShbvHBZf1qqV1hcMIszMEm8eDgILfBCKQEbr9jPhW2xukziEUj
	 MJNu74SCk/LyIMC4BaXuyrkfeREC8558coKCP13+Yk0zRU61b6KHVVZWtPyaEcB86b
	 ylZtPrsGfxDhw==
Date: Sun, 31 Dec 2023 11:50:22 -0800
Subject: [PATCHSET v13.0 1/6] xfsprogs: retain ILOCK during directory updates
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Catherine Hoang <catherine.hoang@oracle.com>,
 Allison Henderson <allison.henderson@oracle.com>, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Message-ID: <170405005262.1804292.14741989148602077637.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231181849.GT361584@frogsfrogsfrogs>
References: <20231231181849.GT361584@frogsfrogsfrogs>
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

This series changes the directory update code to retain the ILOCK on all
files involved in a rename until the end of the operation.  The upcoming
parent pointers patchset applies parent pointers in a separate chained
update from the actual directory update, which is why it is now
necessary to keep the ILOCK instead of dropping it after the first
transaction in the chain.

As a side effect, we no longer need to hold the IOLOCK during an rmapbt
scan of inodes to serialize the scan with ongoing directory updates.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=retain-ilock-during-dir-ops

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=retain-ilock-during-dir-ops
---
 libxfs/libxfs_priv.h |    2 ++
 libxfs/xfs_defer.c   |    6 +++++-
 libxfs/xfs_defer.h   |    8 +++++++-
 3 files changed, 14 insertions(+), 2 deletions(-)

