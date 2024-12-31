Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189EE13FD72
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688066; cv=none; b=RAZLAlRVoCoR9pZWPabVTT0xAM0ssC4TYWomql+/unkXKLbixY34MM0jJ9xQXikoGwp/X+npp0jUtxSfL2f4ApQ+qqTob2EJ8/Pa0w4wKoNHQ6Amf8c/0kMdnmOOL94AncFXm5DrwpnIsmyo+wlYAaaDCh3dhkN41OEYOO6HnPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688066; c=relaxed/simple;
	bh=pr5hgmG6qBWVWOJVxpLBoyXAwlfkJCyn8pBII5JlnsA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z0A2Mczj4omA8Da8gEHrxfvKoxi7bliTvLBrnJ42HPagKj4dXU/DIRTD0ax/wa26zQWxbJHN5mmUZskQhJgz0/BCtP1Pp2pEWCHlnWeq62bBiER0mQREVc6c3Zw1okEL9BtbPA7P5KPU+gPH0gaeGeeApSgyHn1JAgh2wiLRlvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GJRQwDu3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GJRQwDu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D5BC4CED2;
	Tue, 31 Dec 2024 23:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688065;
	bh=pr5hgmG6qBWVWOJVxpLBoyXAwlfkJCyn8pBII5JlnsA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GJRQwDu3rElLFKChgbfPvND8315/AocyN4SCY5XZj5/3bdHffVDOwuttqe68J1Kpw
	 pKJAH8dhtoZoHZ13ddFpa4umM0ZQSplmE1antS6eZwYRI1m9BK1gKg2EOs4ysQ1RiY
	 bnVXvB4BlXlgVDD5yCeZWGGis9mF2H5MWeF2x7sC2lAm/mC6ag01pwhriOyqi4lcxF
	 5HI12oEqcFttlzWJ92PAvf3A8HTY9AKnhJY13Xw4gA8E38tKbSkWuH+0vsgDWWETee
	 jl92FZI536IZ89ngI+2z+XlB8ZkL2B/sWwTKc4yzhLIttHPQbl79VZG2iKC6nSGQwk
	 kU8huENWezeJw==
Date: Tue, 31 Dec 2024 15:34:25 -0800
Subject: [PATCHSET 4/5] xfsprogs: live health monitoring of filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568778426.2710211.10173859713748230492.stgit@frogsfrogsfrogs>
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
 * xfs: create hooks for monitoring health updates
 * xfs: create a special file to pass filesystem health to userspace
 * xfs: create event queuing, formatting, and discovery infrastructure
 * xfs: report metadata health events through healthmon
 * xfs: report shutdown events through healthmon
 * xfs: report media errors through healthmon
 * xfs: report file io errors through healthmon
 * xfs: add media error reporting ioctl
 * xfs_io: monitor filesystem health events
 * xfs_io: add a media error reporting command
 * xfs_scrubbed: create daemon to listen for health events
 * xfs_scrubbed: check events against schema
 * xfs_scrubbed: enable repairing filesystems
 * xfs_scrubbed: check for fs features needed for effective repairs
 * xfs_scrubbed: use getparents to look up file names
 * builddefs: refactor udev directory specification
 * xfs_scrubbed: create a background monitoring service
 * xfs_scrubbed: don't start service if kernel support unavailable
 * xfs_scrubbed: use the autofsck fsproperty to select mode
 * xfs_scrub: report media scrub failures to the kernel
 * debian: enable xfs_scrubbed on the root filesystem by default
---
 configure.ac                     |    2 
 debian/control                   |    2 
 debian/postinst                  |    8 
 debian/prerm                     |   13 
 include/builddefs.in             |    3 
 io/Makefile                      |    1 
 io/healthmon.c                   |  183 ++++++
 io/init.c                        |    1 
 io/io.h                          |    1 
 io/shutdown.c                    |  113 ++++
 libxfs/Makefile                  |   10 
 libxfs/xfs_fs.h                  |   31 +
 libxfs/xfs_health.h              |   47 ++
 libxfs/xfs_healthmon.schema.json |  595 ++++++++++++++++++++
 m4/package_services.m4           |   30 +
 man/man8/xfs_io.8                |   46 ++
 scrub/Makefile                   |   34 +
 scrub/phase6.c                   |   25 +
 scrub/xfs_scrubbed.in            | 1106 ++++++++++++++++++++++++++++++++++++++
 scrub/xfs_scrubbed.rules         |    7 
 scrub/xfs_scrubbed@.service.in   |  104 ++++
 scrub/xfs_scrubbed_start         |   17 +
 22 files changed, 2354 insertions(+), 25 deletions(-)
 create mode 100644 debian/prerm
 create mode 100644 io/healthmon.c
 create mode 100644 libxfs/xfs_healthmon.schema.json
 create mode 100644 scrub/xfs_scrubbed.in
 create mode 100644 scrub/xfs_scrubbed.rules
 create mode 100644 scrub/xfs_scrubbed@.service.in
 create mode 100755 scrub/xfs_scrubbed_start

