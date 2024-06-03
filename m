Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFB5F9E9
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 18:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717440536; cv=none; b=IjUU8SLtRwy4k1vXR0dJbeHjIrr9vcf/FZ2tSRaa3XwufHXFJXO/6gn4a+fDmInRUdU5iHi76wmYSzRkV//htzCwXb0j7TrdWcEBEKK8M/BpIUE9gLTtK/fasrMMyUvHxKRdfW7n/FdbAiLaYKV7emNwC/8A1/R7gCEAuA1xLlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717440536; c=relaxed/simple;
	bh=k/+sFQSzWuJpaeBohM8eakGnx20B1Z5Be03w7FV+EuQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=saqnSe1eIcD9fyR5V6+DmVfzpOI0XDenQGNVflLP+nIHFPPSQT+zbbBay20iSf1fhoZFOGSgaQKV/X1H9zGGzQsACtPDiFdoPQw9/0x9Fd7qPBgcs5jbzeXCQtlG3Z1fzmv16+fsb8ZFG/MfWv4yRKV00Bfn50GW2blRY2Gu+6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mi6qOPpt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mi6qOPpt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F92C2BD10;
	Mon,  3 Jun 2024 18:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717440535;
	bh=k/+sFQSzWuJpaeBohM8eakGnx20B1Z5Be03w7FV+EuQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Mi6qOPpt02vAda80SMdG6ClvHkBER3gSnjuCiTz0VNNnqlkygpZNOFfrqIQeQN+o5
	 UkHhVStpSu69O+HEsdytHfVtDBFxo5l6FYYb73Q8UwuIGqxdjrOItlc6Ca3PUibPE/
	 FJvHKcLQIkXDcinHNXcZbM26qBMuuJAey9odzFvrSqmI4dzGSbHvpMyeN3hjyupnp2
	 1VZcqgoP1RK9SncJQWvSAgTbCWO4hnHbgX9fldiGcz80L4sPDub1lshlAiI7EWrgaV
	 v8XNcPcHqs1hYVaTv+0fXENlt+c/rCYmVvd3kQr+4UAQYFAuljsMJXLYIecchW5eSP
	 Pw5aNMmAapCBQ==
Date: Mon, 03 Jun 2024 11:48:55 -0700
Subject: [PATCHSET v30.5 01/10] libxfs: prepare to sync with 6.9
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171744038785.1443816.16653837642691924792.stgit@frogsfrogsfrogs>
In-Reply-To: <20240603184512.GD52987@frogsfrogsfrogs>
References: <20240603184512.GD52987@frogsfrogsfrogs>
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

Apply some cleanups to libxfs before we synchronize it with the kernel.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libxfs-6.9-sync-prep
---
Commits in this patchset:
 * libxfs: actually set m_fsname
 * libxfs: clean up xfs_da_unmount usage
 * libfrog: create a new scrub group for things requiring full inode scans
---
 io/scrub.c        |    1 +
 libfrog/scrub.h   |    1 +
 libxfs/init.c     |   24 +++++++++++++++++-------
 scrub/phase5.c    |   22 ++++++++++++++++++++--
 scrub/scrub.c     |   33 +++++++++++++++++++++++++++++++++
 scrub/scrub.h     |    1 +
 scrub/xfs_scrub.h |    1 +
 7 files changed, 74 insertions(+), 9 deletions(-)

