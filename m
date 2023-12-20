Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3239647789
	for <linux-xfs@vger.kernel.org>; Wed, 20 Dec 2023 17:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SLGnRFnD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B98C433C8;
	Wed, 20 Dec 2023 17:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703092270;
	bh=61clwxclXttygEIz8p6Tp91OJeMsX9SwVHCR0xQCsOY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SLGnRFnDX66SRuP9M0j3b7pY5JW9Kd8E+2F2+FC535Sxr3Asn1BJ9RQOgjDj0XdEl
	 D7TC8rjREmnFIqGlHe8qhir9GB/gQoqs39nwZO/c16zw31HChHqTR86sylnciq7wIj
	 fMf0rjrmC/eAmD9/0P/DqDga8eaGh5qwiXO3PJkja0QqnjoGcZYbXw+4Iebxrrapxo
	 2H64Cifp2duXInBojQJ6eoblyhgpdeeCmEjfGESpO6oI83UeyQK6gN07GWGqQmLV2s
	 2HfwM9LPsQaHJSysV8JHH6e4jzsVS5s1cJTEBlHKhlRB5mqwmtL1lJutHuXyw8MSZA
	 Lx+l/g8a6tS7g==
Date: Wed, 20 Dec 2023 09:11:10 -0800
Subject: [PATCHSET v28.3 3/4] xfs_io: clean up scrub subcommand code
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Carlos Maiolino <cmaiolino@redhat.com>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
Message-ID: <170309219080.1608142.737701463093437769.stgit@frogsfrogsfrogs>
In-Reply-To: <20231220170641.GQ361584@frogsfrogsfrogs>
References: <20231220170641.GQ361584@frogsfrogsfrogs>
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

This series cleans up the code in io/scrub.c so that argument parsing is
more straightforward and there are fewer indirections.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=io-scrub-cleanups-6.6
---
 io/scrub.c        |  259 ++++++++++++++++++++++++++++-------------------------
 man/man8/xfs_io.8 |    3 +
 2 files changed, 140 insertions(+), 122 deletions(-)

