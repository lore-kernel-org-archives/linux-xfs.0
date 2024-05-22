Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25592C138
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716345939; cv=none; b=BAGfJKxoMpwOYAzLeZdDv0JP0vcXMqk3nLabsX5kirm23TyHTDAOfoOgN1nsDpUm2K4JBJUBDs/U+o3VSRCQG2OcTK10iTX0q8UwdXp5pe3/KSgYCsLWPutG4LIR4LOMj0NJzi1JOqtg6XpdA1aB/7q0xpyPoHyG3oCBwcxeAuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716345939; c=relaxed/simple;
	bh=k/+sFQSzWuJpaeBohM8eakGnx20B1Z5Be03w7FV+EuQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BbnIXJCqVKrPqWDQ+mKrxGC98Qy6OLGctReDkofTM7xUDBt86vNkSKyZsQEDOZszgV/Y20+HQ/dwsaMrQPDk477qafwYFwW8rpvUXQWd0kxctD56CGdf0Z0yVWBO+joll2EMdZ4OVIl4Ybq3ePIPTD07QNAPncWqVtgasNCTjhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=osx+pDOk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="osx+pDOk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0BAC2BD11;
	Wed, 22 May 2024 02:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716345938;
	bh=k/+sFQSzWuJpaeBohM8eakGnx20B1Z5Be03w7FV+EuQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=osx+pDOkb7zWMUNpy3FJ/B32XDhq5p54CTnJ7Qm1sPwjYfXZ5zipIvE9yS1O+Bko5
	 gXCBvzNF32sGKGegs9Jesdvd/LteTNUvQypdf+v0xq3OGqXERUtBX/RScR5Pp0gj28
	 gsa6V2JFdm0OQXCBwnyWdmqd/KgzJvkhPkh8T3fuVrXKQpsZCxqKeij4pFIG0h+JcI
	 yjVpmfzrwDqlFTTfc5mAb1pHzxz6kAJznZyoQnyXxuSImaaHXgYJJqXZhwGJqQeeAF
	 Nca2lbUmm7f0RG0B9jtTa0lmSN2S7zJDHahFkNNHA5EKgIL3B7I+t+Mmn5w74uxxe4
	 p/AK/Bsrn19uw==
Date: Tue, 21 May 2024 19:45:38 -0700
Subject: [PATCHSET v30.4 01/10] libxfs: prepare to sync with 6.9
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634531139.2478774.17043099852261356412.stgit@frogsfrogsfrogs>
In-Reply-To: <20240522023341.GB25546@frogsfrogsfrogs>
References: <20240522023341.GB25546@frogsfrogsfrogs>
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

