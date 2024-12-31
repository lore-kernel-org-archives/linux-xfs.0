Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A3C189BBB;
	Tue, 31 Dec 2024 23:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688128; cv=none; b=b1xJA9yQte8JqwM2NaKZB1eU6YvWYdJLNMd/oeaCmm7q1T9sHC9zHr6tLjwSDqwr719KybNBkz3km+6X5LOOQK0YXh+P3omdlxRrykdfZ8gIXnIPzyAuHewPduICSXL7YjFrsqQiHEWzVIi0kJieZDxCJTuDxOGtHYgd/lsVLLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688128; c=relaxed/simple;
	bh=bLYnoSpG/KqJ5UEmSQKOe6YodwF6pVox1tYH14JOt6U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ocgVTxIf38qM/4iK6C8S52MxiRfopd4O1BE2bPePTpObBoPUt3j38/uwEuydNuuds3mM0+KPf1OqYy4I3hyQfNLQGcbNSf6RUm8zq/3i7Rcfcz1ybeYCK+JxJTUcy6jU9jyut99bNWkBoLbREjuC67cr7NXTbK4c6g4yWSvMw+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XZBXgYUZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XZBXgYUZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38437C4CED2;
	Tue, 31 Dec 2024 23:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688128;
	bh=bLYnoSpG/KqJ5UEmSQKOe6YodwF6pVox1tYH14JOt6U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XZBXgYUZX+/aAqL3spli7kFpCGWDHkuyHCLsV7HZ+cTA0kEH7stNqbp4TETg2RV2z
	 K8eSIw+qLd4vbIyEntkZkyWZsLZcHHgRHw3rEq3AaEuPhUXG4jQ/MAjqAlJXpmGLPp
	 E+dAx898ROP8f0kgj4z7I5+c6LKgw+Z8bs77XKb7B69CipEanTYCGyusAmc+4HaIYp
	 EKC51lTyP+ZeK6bv8lhbFFtGI1PLak4DairHPHgAIzc/tvh9ALIB9GoXf3xu1+TtIk
	 LdKY3a0YwBlMsaHGm1cSYXhfJG42S+0ARB3+h4uI0EtIzsDvznl5Ex6J1Ktt39ZXi4
	 i3fkPv4oVBl/Q==
Date: Tue, 31 Dec 2024 15:35:27 -0800
Subject: [PATCHSET 3/5] fstests: capture logs from mount failures
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173568782724.2712126.2021149328064840091.stgit@frogsfrogsfrogs>
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

Whenever a mount fails, we should capture the kernel logs for the last
few seconds before the failure.  If the test fails, retain the log
contents for further analysis.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
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
 tests/btrfs/075        |    2 +-
 tests/btrfs/208        |    2 +-
 tests/ext4/032         |    2 +-
 tests/generic/067      |    6 +++---
 tests/generic/085      |    2 +-
 tests/generic/361      |    2 +-
 tests/generic/373      |    2 +-
 tests/generic/374      |    2 +-
 tests/generic/409      |    6 +++---
 tests/generic/410      |    8 ++++----
 tests/generic/411      |    8 ++++----
 tests/generic/589      |    8 ++++----
 tests/overlay/005      |    4 ++--
 tests/overlay/025      |    2 +-
 tests/overlay/035      |    2 +-
 tests/overlay/062      |    2 +-
 tests/overlay/083      |    6 +++---
 tests/overlay/086      |   12 ++++++------
 tests/selftest/008     |   20 ++++++++++++++++++++
 tests/selftest/008.out |    1 +
 tests/xfs/078          |    2 +-
 tests/xfs/149          |    4 ++--
 tests/xfs/289          |    4 ++--
 tests/xfs/544          |    2 +-
 32 files changed, 128 insertions(+), 55 deletions(-)
 create mode 100755 tests/selftest/008
 create mode 100644 tests/selftest/008.out

