Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829981B285
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000320; cv=none; b=oI8nipqpjvWv56WJ733OOhrM6z1n6jbnS893gz9gxjNUPFw3vMNWwN4rjn2MMXgja93UVn8OaurZWhvaJPQDsdpBHbUFcfIm1WpFZIplPt0pI5Sy81A4Su/iSTMEPEhYev9w6LuHMzWt0JCa3X8DZBphk6a1O16v7xVD9WT6qlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000320; c=relaxed/simple;
	bh=kH5u4hf4X1t2/QMJvjqTz8iuOKTsIAxeZTaX8TIRkDY=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=ZvFybKcRJAuVXui+tU1f3EQuZyleIoVvrAGOdiwxRxRqqu9M34oJAodcfCKcnQEDY+ml+m0ZhIJKJHmbL08TY2H4HWAB/ArTYhJsQKNSPAYBRfulyB3E1xEeUfcu7IscvDTxJNRvx4Cdx1HHskMmD9Z8J7RVLTJ8mDwBEHKiJBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q/BaeFtE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q/BaeFtE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59588C433C7;
	Tue, 27 Feb 2024 02:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709000320;
	bh=kH5u4hf4X1t2/QMJvjqTz8iuOKTsIAxeZTaX8TIRkDY=;
	h=Date:Subject:From:To:Cc:From;
	b=Q/BaeFtEzfwxnbHBGPN6oimI6VlJ9b2uZyxKNX+gmptXu2gvp2FqVpCfwdnHBFpZl
	 782jslUi34KHsUjxoA1R0DsWEk6potVmlGsvu4kUfRwbU01XYNtSI7PVHUK0214obB
	 siMj78cT/e562hPK0bEzWmHrzkveDLeGtw3k3AXBzvqxaAM2hzRgJtqKJXVgPXqR8T
	 qMoL/o+w0q6hsr6f7MyIASkYEvB2IVQqj+Ta5NuxGxJtQ2EJiHYXfOcCsXztrGlHIU
	 UiDLnuNobpvosM5Tcz0nKOF4dwHJRRYV5uZ5EQgHoTm77hSBFiKkH9j4FkMYtKrXUo
	 Eyve8ERHGGWDg==
Date: Mon, 26 Feb 2024 18:18:39 -0800
Subject: [PATCHSET v29.4 10/13] xfs: move orphan files to lost and found
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170900014852.939668.10415471648919853088.stgit@frogsfrogsfrogs>
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

