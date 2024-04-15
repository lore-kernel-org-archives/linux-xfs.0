Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C5A1DA21
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713224246; cv=none; b=CLktEStS+w8d62NjocTsTICGtmEGM8FhC7kne4csSp/TJ1DHhVc1F7lv3p0BK7BShhqv4Ab1UBWJ7EbRcMwcPPxNtP1+kcGiw0zbw60KEcr+3MESln5rgvA/DRTtZPHCRnITXCE/kV6BD+xuzCTDQcZ3OZGY3RjrEndwGnewhM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713224246; c=relaxed/simple;
	bh=ti3Id+QnxZymGHR/Mj+zHKGM1pBjmtM1oxD5tx4jhYw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m9+N9UGKTCH+WvRjnAxCIdhe3H4t4ypKYioLS6Gnc30QgLY6b8lTe5p3pBwFxNfo6M0enGqvKe3DMfVTcotxE4yDKHHGA8pFjav2X5ufrgukpO+xnUKq6pDPbMRpMKQ3Puy4upw3yuksCRF1putEf0iQW7fxNSJnIx0Nx8OuExg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xw1qp3dR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xw1qp3dR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5EEC113CC;
	Mon, 15 Apr 2024 23:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713224245;
	bh=ti3Id+QnxZymGHR/Mj+zHKGM1pBjmtM1oxD5tx4jhYw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Xw1qp3dRztU4gNKiklDzia9h6sZhiLys2BphDehWT7lUEY5B+1V3qPyuygk2ic+wk
	 THhKPRiEa3imMFwz22iJUZZtaEdRTuetENmmt+Zu1uRKVzmKUEklpfHmklgV19M7v5
	 2xwUMgAKuJAVPDgMNhtx1UeVUWPGkSfH2uL4Cn3sVH9G6Nz/+GtDoHQaAu1x6gjs+8
	 O+Tcop+g+VK5OGrNHTEMLXGQZlChRPV/4MGuU39pr61a6VfXK+YLsbxoeIpuZVJ5LM
	 LZkgB0fuHv4Tx1fADG2eYD/aHTUS6wuWiYr3ZzAnUGXPZdoVQZDBdyhMRMGfaNT12Z
	 y14M6PKiv+BEg==
Date: Mon, 15 Apr 2024 16:37:25 -0700
Subject: [PATCHSET v13.2 15/16] xfs: design documentation for online fsck,
 part 2
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322386102.91896.17539357886365049977.stgit@frogsfrogsfrogs>
In-Reply-To: <20240415232853.GE11948@frogsfrogsfrogs>
References: <20240415232853.GE11948@frogsfrogsfrogs>
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

This series updates the design documentation for online fsck to reflect
the final design of the parent pointers feature as well as the
implementation of online fsck for the new metadata.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=online-fsck-design-6.10
---
Commits in this patchset:
 * docs: update the parent pointers documentation to the final version
 * docs: update online directory and parent pointer repair sections
 * docs: update offline parent pointer repair strategy
 * docs: describe xfs directory tree online fsck
---
 .../filesystems/xfs/xfs-online-fsck-design.rst     |  354 +++++++++++++++-----
 1 file changed, 266 insertions(+), 88 deletions(-)

