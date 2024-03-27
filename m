Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73111CF92
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 01:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504151; cv=none; b=t3VVWPSK9Jydxcyil4Pi/WXaJdoiuRW4KevYAtoImjUVoFZr/u3YOhq/nuG8YOjNOYgeNIgF/LsUo3M8/cKT3FkgtAXwZR3dGLR+8GbRj7GWLVXJ2RVi3LpviKuNa6x8ZGfEIEItOS3OqmynEkSD1IK5XrHA+pVPuev+pY6mGA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504151; c=relaxed/simple;
	bh=kH5u4hf4X1t2/QMJvjqTz8iuOKTsIAxeZTaX8TIRkDY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e+yMPrVU/LkZTb7uq1Z6cWahgC0tntWztYhF633cJUCO0JuAcHRJxClzipb82pF4yRMpQi3YeuPsfSiAhLPSYtBYuIWoWfwkavC5wfjQoZ1fv+vxowCunsfx7zNfkrqGwegskQPSxuJbqJsWRNdGZliqTac8Vd3F3qtWhaqZmng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=noNCNPVd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="noNCNPVd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57920C433C7;
	Wed, 27 Mar 2024 01:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504151;
	bh=kH5u4hf4X1t2/QMJvjqTz8iuOKTsIAxeZTaX8TIRkDY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=noNCNPVddU5mrVNGnAtYwAxD4qBTYUXqZ/9gqYAMDrRPOilYN9xf4VNC7fJJzkcRR
	 reqUP+hmCG2fy/O4cr/3iGdS9A04Y+qW7p9d7eP5KxWBgvnMiyXezuCw0X2QcFmAS8
	 v280md99dxIyM3udyumnN7Cv2dFhgoTCThNWSo5U+NM05zQgbBN9bEyqqE2VR8gniz
	 6y0rOEHGpZx5q2aFJZ4zzaYvyp9Ri9BO6G/D0eUNqzYCEJQxXddb8LbvQS/0IHHReg
	 vkuiq61nZvT8R9JoP8FnTqInKWFZ4gAaWf7D0eFL6xeCSh1s3z3tUo15tY7UnC5JTq
	 6y05gHSgEnZsw==
Date: Tue, 26 Mar 2024 18:49:10 -0700
Subject: [PATCHSET v30.1 11/15] xfs: move orphan files to lost and found
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150383944.3218170.18380002449523163405.stgit@frogsfrogsfrogs>
In-Reply-To: <20240327014040.GU6390@frogsfrogsfrogs>
References: <20240327014040.GU6390@frogsfrogsfrogs>
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

Orphaned files are defined to be files with nonzero ondisk link count
but no observable parent directory.  This series enables online repair
to reparent orphaned files into the filesystem directory tree, and wires
up this reparenting ability into the directory, file link count, and
parent pointer repair functions.  This is how we fix files with positive
link count that are not reachable through the directory tree.

This patch will also create the orphanage directory (lost+found) if it
is not present.  In contrast to xfs_repair, we follow e2fsck in creating
the lost+found without group or other-owner access to avoid accidental
disclosure of files that were previously hidden by an 0700 directory.
That's silly security, but people have been known to do it.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-orphanage
---
Commits in this patchset:
 * xfs: move orphan files to the orphanage
 * xfs: move files to orphanage instead of letting nlinks drop to zero
 * xfs: ensure dentry consistency when the orphanage adopts a file
---
 .../filesystems/xfs/xfs-online-fsck-design.rst     |   20 -
 fs/xfs/Makefile                                    |    1 
 fs/xfs/scrub/dir_repair.c                          |  130 ++++
 fs/xfs/scrub/nlinks.c                              |   11 
 fs/xfs/scrub/nlinks.h                              |    6 
 fs/xfs/scrub/nlinks_repair.c                       |  124 ++++
 fs/xfs/scrub/orphanage.c                           |  587 ++++++++++++++++++++
 fs/xfs/scrub/orphanage.h                           |   75 +++
 fs/xfs/scrub/parent_repair.c                       |   98 +++
 fs/xfs/scrub/repair.h                              |    2 
 fs/xfs/scrub/scrub.c                               |    2 
 fs/xfs/scrub/scrub.h                               |    4 
 fs/xfs/scrub/trace.c                               |    1 
 fs/xfs/scrub/trace.h                               |   96 +++
 fs/xfs/xfs_inode.c                                 |    6 
 fs/xfs/xfs_inode.h                                 |    1 
 16 files changed, 1130 insertions(+), 34 deletions(-)
 create mode 100644 fs/xfs/scrub/orphanage.c
 create mode 100644 fs/xfs/scrub/orphanage.h

