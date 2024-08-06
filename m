Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E2B28DD1;
	Tue,  6 Aug 2024 18:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722968360; cv=none; b=gD6gn/vgzmrQ/LKThhyqVOOY1E6qDR6ZIVqoOyEIYgZlLn1gKIs49Xo9Fx6c2c7n1L20np7ToRYSJLnSkBIZk0zKXXTeu+kPifMswF7t46nZwO90LiQnl8t9RnJJ4lXCzJmJ6oCj18KEM9yLteAkASbAhNBHgsDE5Uqh75DZQlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722968360; c=relaxed/simple;
	bh=0751bTLRIRfZ/PH3DyJn025BcAs9+07JJKkR40alXpU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qDi06ZpZ/+hQNAQXwQS7YD/PEiTodWh2c8MtKqHnsNlEMAzMTCVQ6JgijoGkboU31DNj3lahRGMUbq4d8uQB/WNNg1GeL1MJRaHuXdPYa3IHIgvcDEQdnA8WctZEPlApM6rFAWfnEUZ6FVIiNo7tUN+rOamodMqBulmTtXeTff0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fVMhpSVX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fVMhpSVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F52C32786;
	Tue,  6 Aug 2024 18:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722968359;
	bh=0751bTLRIRfZ/PH3DyJn025BcAs9+07JJKkR40alXpU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fVMhpSVX6x4KyD4HRkMrT8kvDoq/YAIY8UYxygw07qs7lNeWT8lcZSn71sSuxVqU8
	 Me5hNOb7pvoCBTpwsRmUQ51B7hE/Y5tauEGows0cXZncs3HroP+S5r8jH7++aCgK0r
	 fi8uVhkS+pSA7F2ek2Ttf2CPy6wSk4IuvZFMl6XMQMinpAQTTq60rd3cFRTWsBDMng
	 zunF+E6Vmsl8OiVBfumbf9QAFH0KdVbracxOBYgW7gPYvJhG8Iq1bb5oGxSf6FpEjV
	 YaV9Kvm21JsapoDeWkPArTS/CrMxyO4Mz5sIcpCWfnvn/5zGRXNbkAbfF1N7H/50jH
	 H154DATHEA91g==
Date: Tue, 06 Aug 2024 11:19:19 -0700
Subject: [PATCHSET v30.10] fstests: xfs filesystem properties
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, hch@lst.de, dchinner@redhat.com,
 fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <172296826757.3196011.5410659263017548917.stgit@frogsfrogsfrogs>
In-Reply-To: <20240806181452.GE623936@frogsfrogsfrogs>
References: <20240806181452.GE623936@frogsfrogsfrogs>
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

It would be very useful if system administrators could set properties for a
given xfs filesystem to control its behavior.  This we can do easily and
extensibly by setting ATTR_ROOT (aka "trusted") extended attributes on the root
directory.  To prevent this from becoming a weird free for all, let's add some
library and tooling support so that sysadmins simply run the xfs_property
program to administer these properties.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=filesystem-properties

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=filesystem-properties
---
Commits in this patchset:
 * xfs: functional testing for filesystem properties
---
 common/config       |    1 
 common/xfs          |   14 ++++-
 doc/group-names.txt |    1 
 tests/generic/062   |    4 +
 tests/xfs/1886      |  137 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1886.out  |   53 ++++++++++++++++++++
 tests/xfs/1887      |  122 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1887.out  |   46 +++++++++++++++++
 tests/xfs/1888      |   66 +++++++++++++++++++++++++
 tests/xfs/1888.out  |    9 +++
 tests/xfs/1889      |   63 +++++++++++++++++++++++
 tests/xfs/1889.out  |    8 +++
 12 files changed, 522 insertions(+), 2 deletions(-)
 create mode 100755 tests/xfs/1886
 create mode 100644 tests/xfs/1886.out
 create mode 100755 tests/xfs/1887
 create mode 100644 tests/xfs/1887.out
 create mode 100755 tests/xfs/1888
 create mode 100644 tests/xfs/1888.out
 create mode 100755 tests/xfs/1889
 create mode 100644 tests/xfs/1889.out

