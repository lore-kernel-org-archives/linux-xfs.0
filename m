Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76CAB13FD72
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688003; cv=none; b=N/Pm7O5a+7YK4ekS3C5dSNQegu4l64pNO8xwikpU+iOJAkO3YeK6X36SInDETgkK8tpB7vOs9z4jNFpC1uG9bej40ifCFTi8rsmcEHTATRpgC6g6dceSmJ5Fz0Fb1BmeZdlYxzC6KqVhIe5O5u+33quK74D6MCrxYgDUHJT3/7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688003; c=relaxed/simple;
	bh=rSRBioCJMhBV2Yf48hDhoyAU+axveLmC4Lvv+0qQmLY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j6pejwO10FZjvh9j1ObpzIuNLQyjPAYGpoj1V9Wk7WmDVageS3d7TXglzNcI7ql/XgkOt0u+OvyctIGXa80ba9zo6gOSoUtsDbYeCuc7lFNpqRGOBFouMUcEin10M3M0ok7EwpojUOCJah8osIs69bF5eS8q5/k1HCnVEjTFgXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vGsl3EzO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vGsl3EzO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E0DC4CED2;
	Tue, 31 Dec 2024 23:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688003;
	bh=rSRBioCJMhBV2Yf48hDhoyAU+axveLmC4Lvv+0qQmLY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=vGsl3EzOgbFpTRerIdwQsBtr/bWwE8fBLTv4ocdDxf1ODmulnrJb9Jjk+ZYfq5A2p
	 exhE24VlcgP+5nE7P+d8O3iwXLyPQ5r+Yx3PF2Na9zqEErnBoZjTIJBoMfMeb3g773
	 W7lUt7KgBPl3HasHEvGKPlYKl/ryUvRj6V4ksRhAzMzc9uQ6U3dF+TtxFMmtWstD+w
	 tk9/AwZvk5TAAIzXje3BEqn/S8e/kOXErpkSIxzMi66zetyOBinsvL6vS4BcR4LJDm
	 lpYqgVlpehNcjuhZAWWKwfPoPbSBg2vnTQYsVAjWKLyFOiSIC+qpRAlAPDDDar2bZo
	 1vH6unu2TzOTw==
Date: Tue, 31 Dec 2024 15:33:22 -0800
Subject: [PATCHSET 5/5] xfs: live health monitoring of filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568754700.2704911.10879727466774074251.stgit@frogsfrogsfrogs>
In-Reply-To: <20241231232503.GU6174@frogsfrogsfrogs>
References: <20241231232503.GU6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This patchset builds off of Kent Overstreet's thread_with_file code to
deliver live information about filesystem health events to userspace.
This is done by creating a twf file and hooking internal operations so
that the event information can be queued to the twf without stalling the
kernel if the twf client program is nonresponsive.  This is a private
ioctl, so events are expressed using simple json objects so that we can
enrich the output later on without having to rev a ton of C structs.

In userspace, we create a new daemon program that will read the json
event objects and initiate repairs automatically.  This daemon is
managed entirely by systemd and will not block unmounting of the
filesystem unless repairs are ongoing.  It is autostarted via some
horrible udev rules.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=health-monitoring

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=health-monitoring

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=health-monitoring
---
Commits in this patchset:
 * xfs: create debugfs uuid aliases
 * xfs: create hooks for monitoring health updates
 * xfs: create a filesystem shutdown hook
 * xfs: create hooks for media errors
 * iomap, filemap: report buffered read and write io errors to the filesystem
 * iomap: report directio read and write errors to callers
 * xfs: create file io error hooks
 * xfs: create a special file to pass filesystem health to userspace
 * xfs: create event queuing, formatting, and discovery infrastructure
 * xfs: report metadata health events through healthmon
 * xfs: report shutdown events through healthmon
 * xfs: report media errors through healthmon
 * xfs: report file io errors through healthmon
 * xfs: allow reconfiguration of the health monitoring device
 * xfs: add media error reporting ioctl
 * xfs: send uevents when mounting and unmounting a filesystem
---
 Documentation/filesystems/vfs.rst       |    7 
 fs/iomap/buffered-io.c                  |   26 +
 fs/iomap/direct-io.c                    |    4 
 fs/xfs/Kconfig                          |    8 
 fs/xfs/Makefile                         |    7 
 fs/xfs/libxfs/xfs_fs.h                  |   31 +
 fs/xfs/libxfs/xfs_health.h              |   47 +
 fs/xfs/libxfs/xfs_healthmon.schema.json |  595 +++++++++++++
 fs/xfs/xfs_aops.c                       |    2 
 fs/xfs/xfs_file.c                       |  167 ++++
 fs/xfs/xfs_file.h                       |   36 +
 fs/xfs/xfs_fsops.c                      |   57 +
 fs/xfs/xfs_fsops.h                      |   14 
 fs/xfs/xfs_health.c                     |  202 +++++
 fs/xfs/xfs_healthmon.c                  | 1372 +++++++++++++++++++++++++++++++
 fs/xfs/xfs_healthmon.h                  |  102 ++
 fs/xfs/xfs_ioctl.c                      |    7 
 fs/xfs/xfs_linux.h                      |    3 
 fs/xfs/xfs_mount.h                      |   13 
 fs/xfs/xfs_notify_failure.c             |  137 +++
 fs/xfs/xfs_notify_failure.h             |   44 +
 fs/xfs/xfs_super.c                      |   55 +
 fs/xfs/xfs_trace.c                      |    4 
 fs/xfs/xfs_trace.h                      |  369 ++++++++
 include/linux/fs.h                      |    4 
 include/linux/iomap.h                   |    2 
 26 files changed, 3301 insertions(+), 14 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_healthmon.schema.json
 create mode 100644 fs/xfs/xfs_healthmon.c
 create mode 100644 fs/xfs/xfs_healthmon.h

