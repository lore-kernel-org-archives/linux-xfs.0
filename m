Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588B4B66B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oEVpGUaC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 271D6C433C9;
	Sun, 31 Dec 2023 19:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052145;
	bh=GublhGE/IQU6ZJmky6B4L+vasISZMs6m06Azc/u7JNw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oEVpGUaCDXlnRKx0wuX8nHiI8/4bAtprZX+4taX94r0/BnjrYhwkh3PGhgqCvyzyB
	 SfZXiv5j8eIGEUCIGXYywuA02v/kVGqu/frkmOXhNJbnn/wUSMRSB1zUEtEc1uM8A4
	 yZ9JGPpGgIAn+XMXzU7rM/tHM6cSHEay+xK0PD79rDbnFRTd5wQ6KpeoOCz40O82R7
	 /6E9+fbXzkVOO94efz4x+tYnJsvdymnTGdb3FBTd9UCvP3mcxmwV3q/b3zQvDUqGnJ
	 WNmanRH0hbBNOCLEzY0FnEVTXQNnJ1SqETy7LKNOUx2OjApS0SmWyh4t8Eggeq+tL5
	 bsyayFqpMJoVA==
Date: Sun, 31 Dec 2023 11:49:04 -0800
Subject: [PATCHSET v29.0 36/40] xfs_scrub: tighten security of systemd
 services
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Helle Vaanzinn <glitsj16@riseup.net>,
 linux-xfs@vger.kernel.org
Message-ID: <170405002602.1801298.14531646183046394491.stgit@frogsfrogsfrogs>
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

To reduce the risk of the online fsck service suffering some sort of
catastrophic breach that results in attackers reconfiguring the running
system, I embarked on a security audit of the systemd service files.
The result should be that all elements of the background service
(individual scrub jobs, the scrub_all initiator, and the failure
reporting) run with as few privileges and within as strong of a sandbox
as possible.

Granted, this does nothing about the potential for the /kernel/ screwing
up, but at least we could prevent obvious container escapes.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-service-security
---
 man/man8/xfs_scrub.8             |    9 +++-
 scrub/Makefile                   |    7 ++-
 scrub/phase1.c                   |    4 +-
 scrub/system-xfs_scrub.slice     |   30 ++++++++++++
 scrub/vfs.c                      |    2 -
 scrub/xfs_scrub.c                |   11 +++-
 scrub/xfs_scrub.h                |    5 ++
 scrub/xfs_scrub@.service.in      |   97 ++++++++++++++++++++++++++++++++++----
 scrub/xfs_scrub_all.service.in   |   66 ++++++++++++++++++++++++++
 scrub/xfs_scrub_fail@.service.in |   59 +++++++++++++++++++++++
 10 files changed, 270 insertions(+), 20 deletions(-)
 create mode 100644 scrub/system-xfs_scrub.slice

