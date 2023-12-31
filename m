Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C3AB64C
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W04YswZF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8199C433C7;
	Sun, 31 Dec 2023 19:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704050940;
	bh=gF6qaktGjDigED+HF/IHnP7eeETQ2QrfKhtbhDKB/is=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=W04YswZFL8CYuI+emRt3B6i5E++HMxUjfLHwUat4jPu2ViQLRYOBTL0+4dJcd+r21
	 v7Tmt+8BRGTRaTJX7iJMCfzIRdHPWUxWGY4+qVh9D0V5zhjjuAOn0JI+8SasE6MUao
	 FNylxclW1e+9MwstPGzHIppo3OcQF017z1AFsu+Y7EX/5+8jWZwtKikl2ZExFr2Xnj
	 vN0CkEp3JwcWRiHe/9SpTXy5IFPgIhIrJ7+JIL3FIILDTbQCiHCzPhXsD+XTFyuQaZ
	 VOYV4BzMauFklQbptabgqpHdYBtK2VGnakbKVkw6EPNlude+1mcITzvvU3qzKVy2L4
	 hzSGMrT2FAnyw==
Date: Sun, 31 Dec 2023 11:29:00 -0800
Subject: [PATCHSET v29.0 14/28] xfs: support attrfork and unwritten BUIs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404832261.1750058.14588057130952880290.stgit@frogsfrogsfrogs>
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

In preparation for atomic extent swapping and the online repair
functionality that wants atomic extent swaps, enhance the BUI code so
that we can support deferred work on the extended attribute fork and on
unwritten extents.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=expand-bmap-intent-usage

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=expand-bmap-intent-usage
---
 fs/xfs/libxfs/xfs_bmap.c |   49 ++++++++++++++++++++--------------------------
 fs/xfs/libxfs/xfs_bmap.h |    4 ++--
 fs/xfs/xfs_bmap_util.c   |    8 ++++----
 fs/xfs/xfs_reflink.c     |    8 ++++----
 4 files changed, 31 insertions(+), 38 deletions(-)

