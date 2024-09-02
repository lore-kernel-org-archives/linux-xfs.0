Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D6A19CC03
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301341; cv=none; b=A9Z0Lm+oTWqhbJsxn8yDnAS1MNb0PFiqtoR0H1skjc9/wbHKabgyfRa3rFwv+OMIFVnrjqfRC1aLduocpPmcZSFzkYrqiMMtqEQPVUID800yriqPBrHoY9xs86m1u3oHZn7vb2lVYhk/qkJFUVKE6had3P1wKBICqgNLTMkpAmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301341; c=relaxed/simple;
	bh=o/NpqHshynFLyK85gwmTKxdbiqR/x+0ZnEu0qCkdGtU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QSdKpwFrqulfPnsOx7GefuXLOaWX1/fNqjuIak0CkkDc7mHJdnLUEneComPTgaXW+aN/QUnV3MO5T8I2pdlmmtrsUOVfMukELs8B9hGmKLqXtl2onKtkuLrdjWkeUSysFoqa9DLha+4QbT2BaR5Anq6h1d8nPB7sVCWIj6IMU4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TUYDi45q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TUYDi45q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D04FEC4CEC2;
	Mon,  2 Sep 2024 18:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301340;
	bh=o/NpqHshynFLyK85gwmTKxdbiqR/x+0ZnEu0qCkdGtU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TUYDi45qb8FPJteO/sMcMDV0LoIDDjH/fjoGDh1TNyxRkMMSrVG0km95lAk/NZl8a
	 xpr7Zusdb6FcDc8C/mhx+4h50GM5CW9y9zI7RxksLvryPKL78KcPfuu+veHjuznvno
	 RFWzVswu7bgcoWzXxr9oNotgPQH6h9ePDTws57pyX2FDO0iEN7jHEi5FEusIa3700d
	 anpYxI7Rx4/sBBazCmzM9Mdx8pBnz0LxgqshDFELDyp3Ty+DO94wJ7n3utLrJGJWEk
	 vmLwp2IF16AV6sxz8IMVzTWNudPb1ZtgaBMNKSywbxH45x7wEO4moOtcJav4tqlTil
	 ld/py7h2KTKaw==
Date: Mon, 02 Sep 2024 11:22:20 -0700
Subject: [PATCHSET v4.2 6/8] xfs: cleanups for quota mount
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172530107246.3326467.9171618222594281309.stgit@frogsfrogsfrogs>
In-Reply-To: <20240902181606.GX6224@frogsfrogsfrogs>
References: <20240902181606.GX6224@frogsfrogsfrogs>
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

Refactor the quota file loading code in preparation for adding metadata
directory trees.  Did you know that quotarm works even when quota isn't active?

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=quota-cleanups-6.12
---
Commits in this patchset:
 * xfs: refactor loading quota inodes in the regular case
---
 fs/xfs/xfs_qm.c          |   46 +++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_qm.h          |    3 +++
 fs/xfs/xfs_qm_syscalls.c |   13 +++++------
 fs/xfs/xfs_quotaops.c    |   53 +++++++++++++++++++++++++++-------------------
 4 files changed, 80 insertions(+), 35 deletions(-)

