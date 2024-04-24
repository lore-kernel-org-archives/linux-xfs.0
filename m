Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E1E28DDA
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713927980; cv=none; b=qnTD8xvgnPwVO+CwZupuIjPpIBUOTIsJaNjQ6ujDIWNnfYs+7ba6fBCZRxHsofmXCOIByDgCjSZ/DTiNKM0oM9OhemoNbMt3vIXHIpvr7U9/jhVr8Qv7uy+elXKkKrL4j1OMJwKXy1vSQZBHBExRPvHGFj+SjmFHOnBUCZ6eCdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713927980; c=relaxed/simple;
	bh=Ym+tNtKQZpjmW4aDeS3KqmZfZ7WqN8GCXwOhjIDC3w4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=drZuhxiG0ItmKJZtVzO+u/NV3RyNDgX8W103RTrD8M1QgOoYYHcdPZFk4GW7w7lcRlo+ILd0rNgEyVbXDCweZf29OwwiQcUf72o+93N+Ors7D7JcaF8da5tPsNb+QqA/1zibAx9D2nlaOhLHrwAsJxAps6dL3517CP00TJEhH9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pUysKUwf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pUysKUwf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2148C116B1;
	Wed, 24 Apr 2024 03:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713927979;
	bh=Ym+tNtKQZpjmW4aDeS3KqmZfZ7WqN8GCXwOhjIDC3w4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pUysKUwfr3kNITX0W433NEd8bmRYtk7qFUYLdooyfiaT8nTYzSj42LKEROTo0hDgS
	 q5rH98aQdkrEcEswaMwbK+z7lOvo2Amif3NkFaWLZQFbAr1YZr5N0yNZ1pfpu2OGni
	 i8/2QVlOWNcA1uGFgBeebpmYY3dUhTS+Ir0K4+pc6pos1myORvpIPVxcGbB4SgyoNI
	 q6FCMsqNkIKTN3So4XccgR2cPUbmyXiQxXCzXaC3tIlyj5T04+za4BrfUH8u6BfAhz
	 XE9pV+doaIcRUzxTW/4UpBs18omdtgKTX3AbNtFKSbueeCS2bdIh5bp70E2BvjC62M
	 cvAqoP6L4INXQ==
Date: Tue, 23 Apr 2024 20:06:19 -0700
Subject: [PATCHSET v13.4 4/9] xfs: scrubbing for parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392784119.1906133.5675060874223948555.stgit@frogsfrogsfrogs>
In-Reply-To: <20240424030246.GB360919@frogsfrogsfrogs>
References: <20240424030246.GB360919@frogsfrogsfrogs>
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
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-pptrs-6.10
---
Commits in this patchset:
 * xfs: revert commit 44af6c7e59b12
 * xfs: check dirents have parent pointers
 * xfs: deferred scrub of dirents
 * xfs: scrub parent pointers
 * xfs: deferred scrub of parent pointers
 * xfs: walk directory parent pointers to determine backref count
 * xfs: check parent pointer xattrs when scrubbing
---
 fs/xfs/Makefile              |    2 
 fs/xfs/libxfs/xfs_parent.c   |   22 +
 fs/xfs/libxfs/xfs_parent.h   |    5 
 fs/xfs/scrub/attr.c          |   27 +-
 fs/xfs/scrub/common.h        |    1 
 fs/xfs/scrub/dir.c           |  342 +++++++++++++++++++++
 fs/xfs/scrub/nlinks.c        |   85 +++++
 fs/xfs/scrub/nlinks_repair.c |    2 
 fs/xfs/scrub/parent.c        |  685 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/readdir.c       |   78 +++++
 fs/xfs/scrub/readdir.h       |    3 
 fs/xfs/scrub/trace.c         |    1 
 fs/xfs/scrub/trace.h         |   65 ++++
 13 files changed, 1307 insertions(+), 11 deletions(-)

