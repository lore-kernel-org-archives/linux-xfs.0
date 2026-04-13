Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8102436EA9F;
	Mon, 13 Apr 2026 17:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776102649; cv=none; b=N3dineKLvoFaSFJ9/jOC8YzI9gsR94JMZ8fIuHIQLuuCAnPWVVRnnVnxWnOpnOx/IdljmhKnztMXC1y8kVxBJfKlSbBGgx5Ogouz1Q6eMy1Q1CrRWVdFJoU8fLuP6ZMyYK0p7adzeZ3FcEW3OPC/ws0OPq1L1sfb91Zs/wBHEhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776102649; c=relaxed/simple;
	bh=MTPVWj6YkdcDOa7XNFn1RZc3xCHHmilud5LRtWHdSUM=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=ksIIhL6P9u+fmKfyg8QaAIbH/6HSR6f8W3g7ILgZlUGrg9wbWrP3fxpLjpDUsooUhnm9639807vBg3jNxKSrOuOLEytR0tutpQQLWXfwlSVvArzkdq4pwFz1y9OoVpHEvxYJkFknhE1bOe0FkFNKl/GDjqj8uvqG4dNb7iUXhgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oSTRhpqW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oSTRhpqW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0423C2BCAF;
	Mon, 13 Apr 2026 17:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776102649;
	bh=MTPVWj6YkdcDOa7XNFn1RZc3xCHHmilud5LRtWHdSUM=;
	h=Date:Subject:From:To:Cc:From;
	b=oSTRhpqWOimGSxQpGNydqKEJaqrWsGrRWdJiVTrJbb5SFoMhdawBB0K/6DHDpRD7a
	 Uz8Nis6mZPmNuP+/7ioxqiQxy+CvZHcb0v91VAQKpdJvxyOr+MyVFBCDj+PD5QfQ22
	 ux7hR75RWLaYJ1SRUS3kTGnI+6EOK+XPYzNWg/DdezvdEiscuy7//+D695lxiCZKOU
	 Ehbxb+exQBxeYcR5Z0iRIFdcpXxeLRfcaVDAE6cmfZcIgrEILtA68ueRAxhYVHK1yT
	 3g4zQyjje/H7mzqw9APGSMYBNIx+36GDZ8nWMPTv9DtZte9aDzf5mfocGjOoqwbFm/
	 9D7xuLOrCv84g==
Date: Mon, 13 Apr 2026 10:50:47 -0700
Subject: [PATCHSET 2/2] fstests: capture logs from mount failures
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <177610262399.115381.16343458870133010450.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Whenever a mount fails, we should capture the kernel logs for the last
few seconds before the failure.  If the test fails, retain the log
contents for further analysis.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=capture-mount-failures
---
Commits in this patchset:
 * treewide: convert all $MOUNT_PROG to _mount
 * check: capture dmesg of mount failures if test fails
---
 check                  |   22 +++++++++++++++++++++-
 common/btrfs           |    4 ++--
 common/dmdelay         |    2 +-
 common/dmerror         |    2 +-
 common/dmlogwrites     |    2 +-
 common/overlay         |    6 +++---
 common/rc              |   26 +++++++++++++++++++++++++-
 common/report          |    8 ++++++++
 doc/xunit.xsd          |   12 +++++++++++-
 tests/btrfs/012        |    6 +++---
 tests/btrfs/075        |    2 +-
 tests/btrfs/089        |    2 +-
 tests/btrfs/136        |    4 ++--
 tests/btrfs/208        |    2 +-
 tests/btrfs/330        |    2 +-
 tests/btrfs/335        |    2 +-
 tests/ext4/032         |    2 +-
 tests/generic/067      |    4 ++--
 tests/generic/089      |    2 +-
 tests/generic/120      |    2 +-
 tests/generic/306      |    2 +-
 tests/generic/361      |    2 +-
 tests/generic/373      |    2 +-
 tests/generic/374      |    2 +-
 tests/generic/395      |    4 ++--
 tests/generic/409      |    6 +++---
 tests/generic/410      |    8 ++++----
 tests/generic/411      |    8 ++++----
 tests/generic/504      |    4 ++--
 tests/generic/589      |    8 ++++----
 tests/generic/631      |    2 +-
 tests/generic/717      |    2 +-
 tests/overlay/005      |    4 ++--
 tests/overlay/025      |    2 +-
 tests/overlay/062      |    2 +-
 tests/overlay/083      |    6 +++---
 tests/overlay/086      |   12 ++++++------
 tests/selftest/008     |   20 ++++++++++++++++++++
 tests/selftest/008.out |    1 +
 tests/xfs/044          |    2 +-
 tests/xfs/049          |    8 ++++----
 tests/xfs/149          |    4 ++--
 tests/xfs/206          |    2 +-
 tests/xfs/250          |    2 +-
 tests/xfs/289          |    4 ++--
 tests/xfs/300          |    2 +-
 tests/xfs/507          |    2 +-
 tests/xfs/544          |    2 +-
 48 files changed, 161 insertions(+), 78 deletions(-)
 create mode 100755 tests/selftest/008
 create mode 100644 tests/selftest/008.out

