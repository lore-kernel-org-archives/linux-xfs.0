Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0435FB65B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F9K2Ip7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0A0C433C7;
	Sun, 31 Dec 2023 19:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051988;
	bh=ydNNtOQD9jFDaKq7Cg07CQxYRYAZ6S3gWcS/IaC3ac4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=F9K2Ip7FHbrrtnQqcroi3bFiBPFb+B14MBfd3ARb1L/S/QLwGR4UsZmTKSUikMpRq
	 NWeR4zxh/5OBkGqFaZM1ml40HuTANNXRktZWsOko3QD8WiFe2CVDeorzoPlYuALhc5
	 KT9Xf7ymdGDCoFC74Y2LNaGaV13ZEzeTsVb12FIQC+5Zjn+ZcLP1drILUaW8ZlKua9
	 71JlXvxj2lZP7Xo2H4xSnfIhpafWsCkMIZXb6OjKDd+vvzTlOAwlMm7sKxWrGIMnl+
	 xOpoTh1F4KvU06qcXp7/vy1hL+Hn68OPGo/j04mpric1MNZkANUe0QyoNryDlwym/G
	 l5YEzaqIPB/JQ==
Date: Sun, 31 Dec 2023 11:46:28 -0800
Subject: [PATCHSET v29.0 26/40] xfs_scrub: fixes to the repair code
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404998642.1797322.3177048972598846181.stgit@frogsfrogsfrogs>
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

Now that we've landed the new kernel code, it's time to reorganize the
xfs_scrub code that handles repairs.  Clean up various naming warts and
misleading error messages.  Move the repair code to scrub/repair.c as
the first step.  Then, fix various issues in the repair code before we
start reorganizing things.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-repair-fixes
---
 scrub/phase1.c        |    2 
 scrub/phase2.c        |    3 -
 scrub/phase3.c        |    2 
 scrub/phase4.c        |   22 ++++-
 scrub/phase5.c        |    2 
 scrub/phase6.c        |   13 +++
 scrub/phase7.c        |    2 
 scrub/repair.c        |  177 ++++++++++++++++++++++++++++++++++++++++++-
 scrub/repair.h        |   16 +++-
 scrub/scrub.c         |  204 +------------------------------------------------
 scrub/scrub.h         |   16 ----
 scrub/scrub_private.h |   55 +++++++++++++
 scrub/xfs_scrub.c     |    2 
 13 files changed, 283 insertions(+), 233 deletions(-)
 create mode 100644 scrub/scrub_private.h

