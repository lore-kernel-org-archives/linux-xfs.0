Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFEA211294
	for <linux-xfs@vger.kernel.org>; Mon,  3 Feb 2025 22:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738622419; cv=none; b=tc7stF5phW8Y8mA74w6L9gI3ssl6DJH5BlgudDvNhp56W7/LetpOGmlHCs9JK3dR9HdLjWE0+yfvnGn+jKyJnvGv2wJjkTVoxsCJk6vMlU2dTE/fzefvbkIla0rgKn8z4G08GJmqk2BehWlSzBDCWfUFwkLQXK8x3RPiKu+oNRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738622419; c=relaxed/simple;
	bh=QzbVFcI74GreWi3W2Gdn9JUC2Dfu4QQJONIUWBIrzkU=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=SH6aSp0tAPKf8u6ywzRzcfdkQQchjbHOQ+WqOkRBpr0yPAss/+QYKum18er/bxvmWzQ0uoLJSRBL1xm33GZSAPlt7+7QTi6YcDLjvLgDkzNfKQkri5G86Reftfy3sog2nzvVs1/3wfqEfccksZMcOV8aCGCqcXqJWJQuk8Ac0yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UQf8NOwt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UQf8NOwt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE09BC4CED2;
	Mon,  3 Feb 2025 22:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738622419;
	bh=QzbVFcI74GreWi3W2Gdn9JUC2Dfu4QQJONIUWBIrzkU=;
	h=Date:Subject:From:To:Cc:From;
	b=UQf8NOwtttNGV+ZRL+sMU0ndYn12F3TjNKenKc7aslEEnv9y0o7G5UgFI78ZLdMMy
	 JkMA/6bNmyRaQv+tqBvYnbRmx6LSaEfDwTh19YJxpMnwF1kaUnO7MOkKe2WPqQ7Y+G
	 xpNAMz6s1O0P35PpAEUInFuNHyzrZHfi+Xa4YV6mdZfB5oZnVRPngErCNViouvgaGf
	 exPp16MDPu8oKMf1aChHUgMsMSARYOcx1nDmgVEQwXYDf+EkRQd1fWi3/R4C+TryYr
	 E+OMR8lKP8jfQVJ7xsMT2+so+jFkSBO9oBNsFEdXPRt39u4ZcNdI73WgM9tIyKAQN5
	 LxmB55iy8xlfA==
Date: Mon, 03 Feb 2025 14:40:18 -0800
Subject: [PATCHSET] xfsprogs: random bug fixes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173862239029.2460098.9677559939449638172.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Apologies for the late pile of assorted bug fixes.  I discovered a few
bugs relating to protofiles because I failed to notice that my
functional test for xfs_protofile didn't quite cover enough cases and
didn't get back to this for a month while fstests was in disarray.

I'm hoping that as the commits being fixed were merged for 6.13, could we
please review and merge them before tagging xfsprogs 6.13?  Pretty please?  :)

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
Commits in this patchset:
 * libxfs-apply: allow stgit users to force-apply a patch
 * fs: turn on more warnings for the filesystem code we modify most
 * mkfs: fix file size setting when interpreting a protofile
 * xfs_protofile: fix mode formatting error
 * xfs_protofile: fix device number encoding
---
 mkfs/proto.c          |    5 +----
 mkfs/xfs_protofile.in |    4 ++--
 2 files changed, 3 insertions(+), 6 deletions(-)

