Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A5C381B02;
	Mon, 13 Apr 2026 17:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776102642; cv=none; b=I4L5q9dqFzR8Q6OQcaJbrKpxvdZRBRVFzw1YK635/3HdQJG/zSYh8k/c+R7oTiiE5Mm95Y9P+McWnxELrMibeEaDUTRksMPQnEkBdwrj4Xf6YPvDfAfa2YCS3ga79cPFOVYiNEG8xZPw1D0a80KsEN3GCUkVSV4sLIjxVhVY5SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776102642; c=relaxed/simple;
	bh=EX3Qcx6NExmcWUP2t4ZSGuwfXRfMPiU39qnoThi/uoc=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=aVW0AibgH8sXv/cQts0zyDqvhm/YhzFgHTcBQiaZG6e5ysHezZCRUW+kKhfOqs8tSfzPS+mz0VDeZmxmEMIabRivppRIezrrHCQbNYOQceTNwx9ukJS+aEjdYg6Te3NADh2xf+Sw8VZIbsu4TBXRiF1nKXv5moilkXdq32/+MNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KmGnzKCD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KmGnzKCD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D3AC2BCAF;
	Mon, 13 Apr 2026 17:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776102642;
	bh=EX3Qcx6NExmcWUP2t4ZSGuwfXRfMPiU39qnoThi/uoc=;
	h=Date:Subject:From:To:Cc:From;
	b=KmGnzKCDeaabMD/Ak8dfsN+gYbKSjpiXSnqWhBTgrN/r5EwzsipbH/n0u4YlMgwDR
	 ShjI3+sLpc0N0qTAzZnckHzyENDz9IL3DwJ0iwSV5NSaAhikBVqiY4kdzm+izqePrR
	 x/jTKkYFbsSIwveRt1ifQ4sVTdojcp48dXaPqfwufZvLYUAZrUNP4UPy1C1h1xIR9v
	 nSrCQFNEzxJUtDGEJ0ElEnyMXQT8UMJ8NBLZwWECFWra9/apF2PIYqPArjeReYMaMJ
	 6slzldWU8rGNlOGhqB7lKqfB+0Ovmfbj2N0RE0uSsC9Re75Jr2gJUS+LIC14/CsOPA
	 LUTWy1TF5Fb/w==
Date: Mon, 13 Apr 2026 10:50:41 -0700
Subject: [PATCHSET 1/2] fstests: more random fixes for v2026.03.20
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <177610262208.115281.12661076175365005191.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's the usual odd fixes for fstests.

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
 * xfs/841: actually compare the new filesystem contents to the proto dir
---
 tests/xfs/841 |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

