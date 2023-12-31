Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2A5B65B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B91yfh4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E32C433C7;
	Sun, 31 Dec 2023 19:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051707;
	bh=2aO4LvO0YsLDJZStIX/SGidOFVn1nkhBebFSRX3xk5o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=B91yfh4Mse+iCu3z/vwgMkahMOmgXdCVZ+pElWt3UqhR+P1gZ+J6Bz03+OvCJMDm8
	 vjEeQokAyo7g5n+aia+XKq6ZI9z91Rmu/hWkm7V+vEbM0uOn3Y+z2Am1thCbo+cSS3
	 O9TEBHTcMCH9/77jIn4QZWP4ZbQkQP49g6tXpRbWGsQMfiZ/CsYjN50jwD7RGltcl1
	 oeVZVxzNzQRGiWoz2T7wgvc5w3k4b9oL6P61V10jRYYhAptcx1NRG2m0ai4MMQM0vd
	 G5XThXg4Qpkp3hY/BgKGFqkUBQ+eTSQnRf/+w2HL272cbZ4gkwtFMFkFce0Cev37/s
	 ci/kJpdfGXbAA==
Date: Sun, 31 Dec 2023 11:41:46 -0800
Subject: [PATCHSET v29.0 08/40] xfsprogs: online repair of file link counts
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404991573.1793944.10238192046951704393.stgit@frogsfrogsfrogs>
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

Now that we've created the infrastructure to perform live scans of every
file in the filesystem and the necessary hook infrastructure to observe
live updates, use it to scan directories to compute the correct link
counts for files in the filesystem, and reset those link counts.

This patchset creates a tailored readdir implementation for scrub
because the regular version has to cycle ILOCKs to copy information to
userspace.  We can't cycle the ILOCK during the nlink scan and we don't
need all the other VFS support code (maintaining a readdir cursor and
translating XFS structures to VFS structures and back) so it was easier
to duplicate the code.


If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-nlinks

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-nlinks

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=scrub-nlinks
---
 libfrog/scrub.c                     |    5 +
 libxfs/xfs_fs.h                     |    4 +
 libxfs/xfs_health.h                 |    4 +
 man/man2/ioctl_xfs_scrub_metadata.2 |    4 +
 scrub/phase5.c                      |  150 ++++++++++++++++++++++++++++++++---
 scrub/scrub.c                       |   18 ++--
 scrub/scrub.h                       |    1 
 spaceman/health.c                   |    4 +
 8 files changed, 164 insertions(+), 26 deletions(-)

