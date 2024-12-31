Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F7C189BBB;
	Tue, 31 Dec 2024 23:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688144; cv=none; b=so8YJwVfFV2Wo/3c/bcdN0A93CBrf4zMMo1esG8lPX+LlkiPJ3FCWfQDOcW+yzqyulPUbITha3wD7kKvsH7jWsZwhvozdvO6pc++bmc8dAs+bF+I5MPmPsoFVh6xza6m9WGpwAjGZ4uWs9h/dxbqIKCnLCjXfZl9kKtJ0ytYaUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688144; c=relaxed/simple;
	bh=uch8E4AUvgUXtEtL/Ky1gLV0Grwl0BMRMmzGw+cSuQk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E/3ax3ElD7xbHXzsOLlbxvjHYJR3PTFrCJv0AhPs5lxfcXR5OA0pKQgeMLGiL9R3ZoLvVa2BhANEHkgi6cto6fgKkNlRr5jVSE6VN90NyfbajkgvokG+ZlHjNOzfp7cO2pmGVLCflEK3L/OvKIutSYVE5b+SGeGu8AbRRSYoz04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aZYOWswX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aZYOWswX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF48FC4CED2;
	Tue, 31 Dec 2024 23:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688143;
	bh=uch8E4AUvgUXtEtL/Ky1gLV0Grwl0BMRMmzGw+cSuQk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aZYOWswXyuGJ0+2SQrLtLsv3XNRDiPnfF0l0HTBRkWM3s1DxDi7A/KMA0mMD8Ad14
	 BiPOStzHzxSrgaHh4TJPvnxQVckaM3JC/Q0viP3PO10E6SOaP6ez8aq12cZ2H1bX02
	 KneTwtfTeEXQ1gouY1XMc3spUryTb5Api02wWpZjiDBeZVgqZDfehF/qzulhvTmXeV
	 7MfEINGlah6ZrMft4khlkr19kUwcAiGWY8p3HfJgLwvgt8xsCPgtTK7YrBPpJ+lFDT
	 RQcchqruuMcLBad6IKapeyL/uMerNW9G1Rkq2XQ++/ekw7BrOzBB5yHCl2caBeH95L
	 2qB7sR/zWLHhQ==
Date: Tue, 31 Dec 2024 15:35:43 -0800
Subject: [PATCHSET 4/5] fstests: live health monitoring of filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173568783121.2712254.10238353363026075180.stgit@frogsfrogsfrogs>
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
 * misc: convert all $UMOUNT_PROG to a _umount helper
 * misc: convert all umount(1) invocations to _umount
 * xfs: test health monitoring code
 * xfs: test for metadata corruption error reporting via healthmon
 * xfs: test io error reporting via healthmon
 * xfs: test new xfs_scrubbed daemon
---
 common/btrfs        |    2 +
 common/config       |    6 +++
 common/dmdelay      |    4 +-
 common/dmdust       |    4 +-
 common/dmerror      |    4 +-
 common/dmflakey     |    4 +-
 common/dmhugedisk   |    2 +
 common/dmlogwrites  |    4 +-
 common/dmthin       |    4 +-
 common/overlay      |   10 +++---
 common/populate     |    8 ++---
 common/quota        |    2 +
 common/rc           |   47 ++++++++++++++++++---------
 common/systemd      |    9 +++++
 common/xfs          |   18 ++++++++++
 doc/group-names.txt |    1 +
 tests/btrfs/012     |    2 +
 tests/btrfs/020     |    2 +
 tests/btrfs/029     |    2 +
 tests/btrfs/031     |    2 +
 tests/btrfs/060     |    2 +
 tests/btrfs/065     |    2 +
 tests/btrfs/066     |    2 +
 tests/btrfs/067     |    2 +
 tests/btrfs/068     |    2 +
 tests/btrfs/075     |    2 +
 tests/btrfs/089     |    2 +
 tests/btrfs/124     |    2 +
 tests/btrfs/125     |    2 +
 tests/btrfs/185     |    4 +-
 tests/btrfs/197     |    4 +-
 tests/btrfs/199     |    2 +
 tests/btrfs/219     |   12 +++----
 tests/btrfs/254     |    2 +
 tests/btrfs/291     |    2 +
 tests/btrfs/298     |    4 +-
 tests/ext4/006      |    4 +-
 tests/ext4/007      |    4 +-
 tests/ext4/008      |    4 +-
 tests/ext4/009      |    8 ++---
 tests/ext4/010      |    6 ++-
 tests/ext4/011      |    2 +
 tests/ext4/012      |    2 +
 tests/ext4/013      |    6 ++-
 tests/ext4/014      |    6 ++-
 tests/ext4/015      |    6 ++-
 tests/ext4/016      |    6 ++-
 tests/ext4/017      |    6 ++-
 tests/ext4/018      |    6 ++-
 tests/ext4/019      |    6 ++-
 tests/ext4/032      |    4 +-
 tests/ext4/033      |    2 +
 tests/ext4/052      |    4 +-
 tests/ext4/053      |   32 +++++++++---------
 tests/ext4/056      |    2 +
 tests/generic/042   |    4 +-
 tests/generic/067   |    6 ++-
 tests/generic/081   |    2 +
 tests/generic/085   |    4 +-
 tests/generic/108   |    2 +
 tests/generic/171   |    2 +
 tests/generic/172   |    2 +
 tests/generic/173   |    2 +
 tests/generic/174   |    2 +
 tests/generic/306   |    2 +
 tests/generic/330   |    2 +
 tests/generic/332   |    2 +
 tests/generic/361   |    2 +
 tests/generic/373   |    2 +
 tests/generic/374   |    2 +
 tests/generic/395   |    2 +
 tests/generic/459   |    2 +
 tests/generic/563   |    4 +-
 tests/generic/604   |    2 +
 tests/generic/631   |    2 +
 tests/generic/648   |    6 ++-
 tests/generic/698   |    4 +-
 tests/generic/699   |    8 ++---
 tests/generic/704   |    2 +
 tests/generic/717   |    2 +
 tests/generic/730   |    2 +
 tests/generic/731   |    2 +
 tests/generic/732   |    4 +-
 tests/generic/746   |    8 ++---
 tests/overlay/003   |    2 +
 tests/overlay/004   |    2 +
 tests/overlay/005   |    6 ++-
 tests/overlay/014   |    4 +-
 tests/overlay/022   |    2 +
 tests/overlay/025   |    4 +-
 tests/overlay/029   |    6 ++-
 tests/overlay/031   |    8 ++---
 tests/overlay/035   |    2 +
 tests/overlay/036   |    8 ++---
 tests/overlay/037   |    6 ++-
 tests/overlay/040   |    2 +
 tests/overlay/041   |    2 +
 tests/overlay/042   |    2 +
 tests/overlay/043   |    2 +
 tests/overlay/044   |    2 +
 tests/overlay/048   |    4 +-
 tests/overlay/049   |    2 +
 tests/overlay/050   |    2 +
 tests/overlay/051   |    4 +-
 tests/overlay/052   |    2 +
 tests/overlay/053   |    4 +-
 tests/overlay/054   |    2 +
 tests/overlay/055   |    4 +-
 tests/overlay/056   |    2 +
 tests/overlay/057   |    4 +-
 tests/overlay/059   |    2 +
 tests/overlay/060   |    2 +
 tests/overlay/062   |    2 +
 tests/overlay/063   |    2 +
 tests/overlay/065   |   22 ++++++-------
 tests/overlay/067   |    2 +
 tests/overlay/068   |    4 +-
 tests/overlay/069   |    6 ++-
 tests/overlay/070   |    6 ++-
 tests/overlay/071   |    6 ++-
 tests/overlay/076   |    2 +
 tests/overlay/077   |    2 +
 tests/overlay/078   |    2 +
 tests/overlay/079   |    2 +
 tests/overlay/080   |    2 +
 tests/overlay/081   |   14 ++++----
 tests/overlay/083   |    2 +
 tests/overlay/084   |   10 +++---
 tests/overlay/085   |    2 +
 tests/overlay/086   |    8 ++---
 tests/xfs/014       |    4 +-
 tests/xfs/049       |    8 ++---
 tests/xfs/073       |    8 ++---
 tests/xfs/074       |    4 +-
 tests/xfs/078       |    4 +-
 tests/xfs/083       |    6 ++-
 tests/xfs/085       |    4 +-
 tests/xfs/086       |    8 ++---
 tests/xfs/087       |    6 ++-
 tests/xfs/088       |    8 ++---
 tests/xfs/089       |    8 ++---
 tests/xfs/091       |    8 ++---
 tests/xfs/093       |    6 ++-
 tests/xfs/097       |    6 ++-
 tests/xfs/098       |    4 +-
 tests/xfs/099       |    6 ++-
 tests/xfs/100       |    6 ++-
 tests/xfs/101       |    6 ++-
 tests/xfs/102       |    6 ++-
 tests/xfs/105       |    6 ++-
 tests/xfs/112       |    8 ++---
 tests/xfs/113       |    6 ++-
 tests/xfs/117       |    6 ++-
 tests/xfs/120       |    6 ++-
 tests/xfs/123       |    6 ++-
 tests/xfs/124       |    6 ++-
 tests/xfs/125       |    6 ++-
 tests/xfs/126       |    6 ++-
 tests/xfs/130       |    2 +
 tests/xfs/148       |    6 ++-
 tests/xfs/149       |    4 +-
 tests/xfs/152       |    2 +
 tests/xfs/169       |    6 ++-
 tests/xfs/186       |    4 +-
 tests/xfs/1878      |   80 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1878.out  |   10 ++++++
 tests/xfs/1879      |   89 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1879.out  |   12 +++++++
 tests/xfs/1882      |   64 +++++++++++++++++++++++++++++++++++++
 tests/xfs/1882.out  |    2 +
 tests/xfs/1883      |   75 +++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1883.out  |    2 +
 tests/xfs/1884      |   87 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1884.out  |    2 +
 tests/xfs/1885      |   53 ++++++++++++++++++++++++++++++
 tests/xfs/1885.out  |    5 +++
 tests/xfs/206       |    2 +
 tests/xfs/216       |    2 +
 tests/xfs/217       |    2 +
 tests/xfs/235       |    6 ++-
 tests/xfs/236       |    6 ++-
 tests/xfs/239       |    2 +
 tests/xfs/241       |    2 +
 tests/xfs/250       |    4 +-
 tests/xfs/265       |    6 ++-
 tests/xfs/289       |    4 +-
 tests/xfs/310       |    4 +-
 tests/xfs/507       |    2 +
 tests/xfs/513       |    4 +-
 tests/xfs/544       |    2 +
 tests/xfs/716       |    4 +-
 tests/xfs/806       |    4 +-
 192 files changed, 921 insertions(+), 391 deletions(-)
 create mode 100755 tests/xfs/1878
 create mode 100644 tests/xfs/1878.out
 create mode 100755 tests/xfs/1879
 create mode 100644 tests/xfs/1879.out
 create mode 100755 tests/xfs/1882
 create mode 100644 tests/xfs/1882.out
 create mode 100755 tests/xfs/1883
 create mode 100644 tests/xfs/1883.out
 create mode 100755 tests/xfs/1884
 create mode 100644 tests/xfs/1884.out
 create mode 100755 tests/xfs/1885
 create mode 100644 tests/xfs/1885.out

