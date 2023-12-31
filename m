Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75A6B645
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kK4VneRS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844DFC433C8;
	Sun, 31 Dec 2023 19:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051003;
	bh=3JT47urqJ/XfCxGwC/d5NrMX32m6our1rpljLslRE4Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kK4VneRSdCqxTd2qurU0gZTZrjQqBdCwJKX9XOjC+jorY4B2jCCYgfvmEKbrelU15
	 wHXCKIHQq7w/FrgqhMymx1beea1nDCGWbGvLM++iO6+KPZTHMgvOeKZQQmgQJNNvTg
	 n+LN4dw6Jgb2sJlV3YuiFqfsbe+PIIqJKmqYcM1T7Rw2IFnwRodppgdwIlfeJWcDM9
	 l6983ha9+5pZ5NCJPZ49arGGfYpHJ0bwLgCQiPpyUymTz9lb9nDn8wkUgTh6r40O1u
	 SAizimnkEiia2zOlMHt4qdWDwQ2pw0eOco8Ljo8fz9ig0D6C3iVTR9eLoGQeQE0vxb
	 CnWob13fLRxsw==
Date: Sun, 31 Dec 2023 11:30:03 -0800
Subject: [PATCHSET v29.0 18/28] xfs: online repair of realtime summaries
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404834278.1752917.3964733922134331052.stgit@frogsfrogsfrogs>
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

We now have all the infrastructure we need to repair file metadata.
We'll begin with the realtime summary file, because it is the least
complex data structure.  To support this we need to add three more
pieces to the temporary file code from the previous patchset --
preallocating space in the temp file, formatting metadata into that
space and writing the blocks to disk, and swapping the fork mappings
atomically.

After that, the actual reconstruction of the realtime summary
information is pretty simple, since we can simply write the incore
copy computed by the rtsummary scrubber to the temporary file, swap the
contents, and reap the old blocks.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-rtsummary

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-rtsummary

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-rtsummary
---
 fs/xfs/Makefile                 |    1 
 fs/xfs/scrub/common.c           |    1 
 fs/xfs/scrub/repair.h           |    3 
 fs/xfs/scrub/rtsummary.c        |   33 ++-
 fs/xfs/scrub/rtsummary.h        |   37 ++++
 fs/xfs/scrub/rtsummary_repair.c |  177 +++++++++++++++++
 fs/xfs/scrub/scrub.c            |   14 +
 fs/xfs/scrub/scrub.h            |    7 +
 fs/xfs/scrub/tempfile.c         |  401 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/tempfile.h         |   15 +
 fs/xfs/scrub/tempswap.h         |   21 ++
 fs/xfs/scrub/trace.h            |   40 ++++
 12 files changed, 731 insertions(+), 19 deletions(-)
 create mode 100644 fs/xfs/scrub/rtsummary.h
 create mode 100644 fs/xfs/scrub/rtsummary_repair.c
 create mode 100644 fs/xfs/scrub/tempswap.h

