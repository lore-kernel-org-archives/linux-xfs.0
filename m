Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1834817C8;
	Sat, 24 Feb 2024 01:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708736944; cv=none; b=Hmsc5F0S3Gmqwl05WR/AtHbQdu/WHxPUGnVHDH/W9i2WaynM9R+enUGqYK/FohHS22x7vEdsLXYIYo947Ya+nFp/7kACMGbmqeDvVE16Ri8vTTS8+YEIEupR1FIqPi7bK4F1VPbmU7r3c3tp1F/OD82vejKs1uf/TA1gWfU1UWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708736944; c=relaxed/simple;
	bh=4LiiyaCDVw05UOIQcH5rFbHwycaLxeEFin0q+6gm2jI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AA68FAPWFMKTmJD/YYfKBfFJlM9lAMj5E2ZTmm6Dn6LVSHicvTcAIM486bzgj9b7mMkzFGO29VfusU+lgoUDPB77HiZESOaYV8Y9pLvw+tSuqq26BIxNFDbyALBrOrOp/siKVNpzggPysNfiMas1v2uZNxmWZM+ckBNe91rJk7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J5DjohUK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J5DjohUK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93756C433C7;
	Sat, 24 Feb 2024 01:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708736943;
	bh=4LiiyaCDVw05UOIQcH5rFbHwycaLxeEFin0q+6gm2jI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=J5DjohUKFXe7toJbBix+WFp/aVLa7rychfxqlfMxMWN+g2/gtsfF3cHNFcDnAjUwq
	 BevgL5KPqzJDwAWnVYc+2Vbutmpg0UNKfquOv29kuUJdcWFw9XoFZdD0Fvsjtl/cUu
	 bj8oGdwOG5SX0lQ6BYtLVyzFw48usv+XqALjhOBOJG9TEtWTUDzq7zAEoHqCNEenvX
	 QGPe1jvwLvY43MqempTY8i8iFlUIgLUPNzQvpGavxvAslOIUdxj0CzPeEHlKxBBB/Z
	 V7IpR3ypLle7eW9lrrtQz66oI2ILlmCTpjLc93KcYXRfVgl/CCKFZkqglxt84usZcj
	 lAGRMHr8WRPPQ==
Date: Fri, 23 Feb 2024 17:09:03 -0800
Subject: [PATCHSET RFC 6/6] xfs: live health monitoring of filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: kent.overstreet@linux.dev, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-bcachefs@vger.kernel.org
Message-ID: <170873669843.1861872.1241932246549132485.stgit@frogsfrogsfrogs>
In-Reply-To: <20240224010017.GM6226@frogsfrogsfrogs>
References: <20240224010017.GM6226@frogsfrogsfrogs>
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
 * xfs: use thread_with_file to create a monitoring file
 * xfs: create hooks for monitoring health updates
 * xfs: create a filesystem shutdown hook
 * xfs: report shutdown events through healthmon
 * xfs: report metadata health events through healthmon
 * xfs: report media errors through healthmon
 * xfs: allow reconfiguration of the health monitoring device
 * xfs: send uevents when mounting and unmounting a filesystem
---
 fs/xfs/Kconfig                 |    9 
 fs/xfs/Makefile                |    1 
 fs/xfs/libxfs/xfs_fs.h         |    1 
 fs/xfs/libxfs/xfs_fs_staging.h |   18 +
 fs/xfs/libxfs/xfs_health.h     |   48 ++
 fs/xfs/xfs_buf.c               |    1 
 fs/xfs/xfs_fsops.c             |   57 ++
 fs/xfs/xfs_fsops.h             |   14 +
 fs/xfs/xfs_health.c            |  266 ++++++++++
 fs/xfs/xfs_healthmon.c         | 1108 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_healthmon.h         |   86 +++
 fs/xfs/xfs_ioctl.c             |   21 +
 fs/xfs/xfs_linux.h             |    3 
 fs/xfs/xfs_mount.h             |    9 
 fs/xfs/xfs_notify_failure.c    |  161 +++++-
 fs/xfs/xfs_notify_failure.h    |   42 ++
 fs/xfs/xfs_super.c             |   43 ++
 fs/xfs/xfs_super.h             |    1 
 fs/xfs/xfs_trace.c             |    3 
 fs/xfs/xfs_trace.h             |  240 +++++++++
 20 files changed, 2098 insertions(+), 34 deletions(-)
 create mode 100644 fs/xfs/xfs_healthmon.c
 create mode 100644 fs/xfs/xfs_healthmon.h
 create mode 100644 fs/xfs/xfs_notify_failure.h

