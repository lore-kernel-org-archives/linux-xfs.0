Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E59D50F
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 00:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719881547; cv=none; b=MHa8h73Atltk94zHIzAAUv1R2b61Rx54E5ZDOQjWZVN5CYHLmbVCJ62qiQOPj7YHl5XtTOeLt7vNw7BOhn/dBJ63lLRBKZqDb2VJmSmhaxKNP+GszA35UI9Me7Q9gFsTTHpo1RS+PL1WGVY9QIbZP/qQpLFSP6O3xlRU+Kt12Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719881547; c=relaxed/simple;
	bh=4YgrKIBSqVGpFhTBphgHGWJBrnShdMQ1df2LB895xGM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iFjI2lt+Jd2yEcSnjrWUQkppgUVNGEAo22so+ocl/J95Bdh4KmZv5UsLTEE2JqNL2BBqJqh0yyGVhuxRUMxkhBshXEYc46ew6R8ODLCQTib8IE1tACiGaqiwcRQ12xehXB0jkAcwRZOQCy03miHb7lT+S/KnB4ln8BXoeArkCRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EsCJMHBY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EsCJMHBY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F317AC116B1;
	Tue,  2 Jul 2024 00:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719881547;
	bh=4YgrKIBSqVGpFhTBphgHGWJBrnShdMQ1df2LB895xGM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EsCJMHBY5AH3Q0AlnDqMTiPu8MAcWYAMUVZqkK8grvNj3mIZA5fRzqCWHBdC6Kt/K
	 H76Dn4CwpxGB+m/EOZsRL+ESRZyoBT405iEbjX8hiUDV7yA8Emnaz/s/afGQIslblc
	 kXHRjztqG7r3QE/t0YwdwNhHseayg0HiG9wxj2VoaGawyQLrWXaV4f1j8abw+1f03Z
	 2KOLhRlymNV2JmOgvqreMTBfOd+WrLv+MABnkcpIKaDm9YRWrS+XblMovQX41kx12A
	 iKq1OHbkWvqOdtuo6Y17Xh500G4PmNkRTNKhn2FjYUYbodrpmvQ0jT+u7BCVygMOmf
	 7sds7zgRJjW7A==
Date: Mon, 01 Jul 2024 17:52:26 -0700
Subject: [PATCHSET v13.7 12/16] xfsprogs: scrubbing for parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, hch@lst.de
Message-ID: <171988121771.2010091.1149497683237429955.stgit@frogsfrogsfrogs>
In-Reply-To: <20240702004322.GJ612460@frogsfrogsfrogs>
References: <20240702004322.GJ612460@frogsfrogsfrogs>
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

Teach online fsck to use parent pointers to assist in checking
directories, parent pointers, extended attributes, and link counts.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-pptrs

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-pptrs
---
Commits in this patchset:
 * xfs: create a blob array data structure
 * man2: update ioctl_xfs_scrub_metadata.2 for parent pointers
---
 libxfs/Makefile                     |    2 
 libxfs/xfblob.c                     |  147 +++++++++++++++++++++++++++++++++++
 libxfs/xfblob.h                     |   24 ++++++
 libxfs/xfile.c                      |   11 +++
 libxfs/xfile.h                      |    1 
 man/man2/ioctl_xfs_scrub_metadata.2 |   20 ++++-
 6 files changed, 201 insertions(+), 4 deletions(-)
 create mode 100644 libxfs/xfblob.c
 create mode 100644 libxfs/xfblob.h

