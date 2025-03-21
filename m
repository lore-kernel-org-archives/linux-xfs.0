Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52DD22E412;
	Fri, 21 Mar 2025 21:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742592413; cv=none; b=VGirZ0eF1mjNmDNHYvh/CADgEf51b1G+GNSGFWB4HRfCxRN9+XUWjWhY6CuJXoWBCWsa3Esqb3tPZ/pVx2esvoFGYWcwXgOMdjbEZojD0SOJGP6oGE/os660EWUILEtQ4BC2NYfPP01I87nk5t+DTgQSfEaoYCpvh6RR7Fkdskc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742592413; c=relaxed/simple;
	bh=LTOtOsr1ZaEQJ38OHS3VMPH97ZFbCTK1NeEHct7qbTU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cX66aXCx3egrk42nA+vIN2UCk8153iQaJYZFeQiDhQFP6xZXKUACDOEHBBtTJ9sGkE+PFHwxlFdJKcGRhkE4VEAmGXBGWLpRZ5mU1t798cWzxkfgABwsBOnR2KH+nA/UNk+5Fi0lXZCktrTegUujMMfjT4Nkeu7oUquvtsjEY1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qnEfDw9R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qnEfDw9R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30335C4CEE3;
	Fri, 21 Mar 2025 21:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742592412;
	bh=LTOtOsr1ZaEQJ38OHS3VMPH97ZFbCTK1NeEHct7qbTU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qnEfDw9RFBLezFx2o6Q1iXV1/VxPBTpYRzELqtmXT43u96HkWspix8eSxW+rzFuvz
	 LSQbRTczF6cSihdPXQlCaxGx2i+WxsHPlmWi3ge/q26xLrmif/lWN2DigVnXoLIssx
	 blHwqA45IWP+O6hHDhXRtsr1fSjOyw2TE/gvcdIAsfZQv0ESr/V6oXTw0YDUCTA4uM
	 wEGl8w8egcio2E+DM33rJy9rbQwjJP5WZJ+cUeRzkdS/oejQgjbFtx9rSzmeevUO2M
	 vjsQ9b66xNfKFkACYdr8vO3VJ6ogX4CI2nkiqK++cjJSJ0tL1LPPS3hduwq7RdbL9j
	 0qPcx9Fu9th2w==
Date: Fri, 21 Mar 2025 14:26:51 -0700
Subject: [PATCHSET 3/3] fstests: more random fixes for v2025.03.17
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: hch@lst.de, fstests@vger.kernel.org, hch@lst.de,
 linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <174259233946.743619.993544237516250761.stgit@frogsfrogsfrogs>
In-Reply-To: <20250321212508.GH4001511@frogsfrogsfrogs>
References: <20250321212508.GH4001511@frogsfrogsfrogs>
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
 * xfs/614: determine the sector size of the fs image by doing a test format
 * generic/537: disable quota mount options for pre-metadir rt filesystems
 * common/populate: drop fallocate mode 0 requirement
 * xfs/818: fix some design issues
---
 common/populate   |    1 -
 tests/generic/537 |   17 +++++++++++++++++
 tests/xfs/614     |   13 ++++++++-----
 tests/xfs/818     |   19 ++++++++++++++++---
 4 files changed, 41 insertions(+), 9 deletions(-)

