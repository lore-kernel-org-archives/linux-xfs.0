Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5539132132;
	Tue, 27 Aug 2024 18:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724784321; cv=none; b=tVEyTKSuyxu1wI+3p7saa2AwFSEwKMo77kd7XzuwBOn22CQiku6vhY1e53VSBaUM+DDJEPIcvPm0aHCzxUitu68sQYkWy+9bl1gqEE0yvbgmtLdhd9vyR/zLt2vZjZ/IxdjNNlXM09GYBtR/JAjHQ9sCufDQclOxnPatIVBlIHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724784321; c=relaxed/simple;
	bh=MIThHditLAJ4t7AY6C+pd0PUdqzAu20QOJZpUakepik=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JbCLnXTqzg1ye+A74dR8Xblr3t1IawxvMobw8aXMe2C28sFJyOdnEYCE1sbSX/NWk9yz3VnJht9A/DXZWB9+A5WBJUbQ92IpT3+QuSx2UcJG+OtU5rwEcSuny+jOtOAqTXC3DMpnYLu/XchzYXEvagmY2h8rFcH5qrq7+Y/TiC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TZ2IjwEB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TZ2IjwEB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F54AC4FEA0;
	Tue, 27 Aug 2024 18:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724784321;
	bh=MIThHditLAJ4t7AY6C+pd0PUdqzAu20QOJZpUakepik=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TZ2IjwEBfYdCPTt9IDZdhgMXYDJnHOw/GX7pVfAw5C6kTQnF0KzWf8TusWMFMwBhA
	 MasOLAP+6QTWfQa2RGEeeABvlVRSQ60B1TMbxJdnNCMu1QMXOsPlOLTFpt4fneLWsq
	 PbZeUqRkvel4U49pP0qAII5N1J0R1pil0MOU+FD1ovIQBDlmPj1AVz2lsf6EKNp/mF
	 q5deRKpJlchNAK9yOcX5gbv4DhfYMS07ez1fkhAdARycV32I54/H9jUTWMkZszplZw
	 0TYYS3zOPfQBmBtdX8eGYcUlys7gBn3MXeeuaEUyZMG+NFDj03/IUog3q7yqnO5UzM
	 uGpRrBcWbkRmA==
Date: Tue, 27 Aug 2024 11:45:20 -0700
Subject: [PATCHSET v4.1 4/5] fstests: enable FITRIM for the realtime section
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <172478423382.2039664.3766932721854273834.stgit@frogsfrogsfrogs>
In-Reply-To: <20240827184204.GM6047@frogsfrogsfrogs>
References: <20240827184204.GM6047@frogsfrogsfrogs>
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

One thing that's been missing for a long time is the ability to tell
underlying storage that it can unmap the unused space on the realtime
device.  This short series exposes this functionality through FITRIM.
Callers that want ranged FITRIM should be aware that the realtime space
exists in the offset range after the data device.  However, it is
anticipated that most callers pass in offset=0 len=-1ULL and will not
notice or care.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-discard

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-discard
---
Commits in this patchset:
 * xfs: refactor statfs field extraction
 * common/xfs: FITRIM now supports realtime volumes
---
 common/xfs    |   46 ++++++++++++++++++++++++++++++++++++++++++++--
 tests/xfs/176 |    4 ++--
 tests/xfs/187 |    6 +++---
 tests/xfs/541 |    6 ++----
 4 files changed, 51 insertions(+), 11 deletions(-)

