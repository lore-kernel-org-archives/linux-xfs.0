Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53AF22FF49
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881039; cv=none; b=rF3RVLQQt8Vj3mzkh7Lyr/hdMaTDJBR7xyDgIKr8oQE1vPTaefLK61KAYIXgzAkzbCXrj9z8JYx1guwi+WsII54L3szMLb2ZXIIhSKlmYrpUhIE9qgfacvE6DbIsO/g6yEqjN8fOATRoJGwRMGnhAlgPLmT5xX765bTAjXc7Vhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881039; c=relaxed/simple;
	bh=QuGZW4IxBW3Jl09QrO1tLRPdMjCmfG7JzTTqTqNkNpo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FtdpTQ8Z9Fh9NHjI9CGyn+d3kPL57nTWt6BucghF/8iamGXJ8Hosehwn1wbjo6VC1lWhh2VkLeu07mfgMKuRdVwmyF19wChK7Ax5HCmbzqa1G0XPsm3KrBCQnuOYf5S3Ck4xIb7l6Juyy7smwXYBCOp026SpeoBxIIMEUXvu2+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q3UJ5yQK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q3UJ5yQK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C895C4CEDD;
	Thu,  6 Feb 2025 22:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881039;
	bh=QuGZW4IxBW3Jl09QrO1tLRPdMjCmfG7JzTTqTqNkNpo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Q3UJ5yQKRYxxFazcJidVla6IaFXgZ+ZPFiVvMfs78EEQ9rVqoTRyIPYUe4CC34jTq
	 cOQztHBcKpCb7+zyPIaKlNnxtNDNmPGNzRV81dZo/ZhnHyfmurj/WLUt4Xj0G1FyzU
	 jdz0DHmolG7Lessgir4sSXCQTwOpJQo86HJI2SJyCgK+A3zGOvMa6I7OqJqaC/fjKr
	 VgdPk5Fjac/Qzp5VH5N56Uuch/H6OnCyMdUmZvOpapSa9/49wTL7xlqkM9g20wqT24
	 MIo3hCB3EWMn5x7TdN+YP8kEacgSaE27Til1FYnNQD1Bnvj6FcRiFBf2MZmSQpMect
	 wl4uyOazSUZzw==
Date: Thu, 06 Feb 2025 14:30:39 -0800
Subject: [PATCHSET 5/5] xfsprogs: dump fs directory trees
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888089597.2742734.4600497543125166516.stgit@frogsfrogsfrogs>
In-Reply-To: <20250206222122.GA21808@frogsfrogsfrogs>
References: <20250206222122.GA21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Before we disable XFS V4 support by default in the kernel ahead of
abandoning the old ondisk format in 2030, let's create a userspace
extraction tool so that in the future, people can extract their files
without needing to load an old kernel or figure out how to set up
lklfuse.  This also enables at least partial data recovery from
filesystems that cannot be mounted due to severe or unfixable
inconsistencies.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=rdump

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=rdump
---
Commits in this patchset:
 * xfs_db: pass const pointers when we're not modifying them
 * xfs_db: use an empty transaction to try to prevent livelocks in path_navigate
 * xfs_db: make listdir more generally useful
 * xfs_db: add command to copy directory trees out of filesystems
---
 db/Makefile              |    3 
 db/command.c             |    1 
 db/command.h             |    1 
 db/namei.c               |  115 ++++-
 db/namei.h               |   18 +
 db/rdump.c               |  999 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/libxfs_api_defs.h |    2 
 man/man8/xfs_db.8        |   26 +
 8 files changed, 1126 insertions(+), 39 deletions(-)
 create mode 100644 db/namei.h
 create mode 100644 db/rdump.c

