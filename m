Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9E3B666
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="apLphteQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C25DC433C8;
	Sun, 31 Dec 2023 19:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051848;
	bh=Nhk3H4Q407rQ7me0/8CZFRtG3aze6g4264YUQFkU6oI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=apLphteQJw8H0474V+SjasvFPZyUP95w1ueEVqu9jAEi8c4YCytFaLV0LL2BxCMiX
	 J/XoHXK7ATBBA+ahIZ3/eX3N2HtJ7Q7CgqFM//x80RwazX/mKEnrd8LhfNJQ1SRuVu
	 5wNvt2I6td92nkaC7Wy/iFov9XI0lJaaR6ji1q4wjFZqOD8zLJOGEIgwv7xNrC4gHx
	 zzDqjzZMM/HAhoi+AmnnDuSFH+jb6fn8rDQek1hv/lH3z20lcM0PBuHknxSXDx0Ek0
	 Wr9qwmrelHkisA4icYAEn2nUU+bPbX73hU5NOlEIK2DzVtlzQoabAIogohFLyAaiQ+
	 21b7RYgGN8nfQ==
Date: Sun, 31 Dec 2023 11:44:07 -0800
Subject: [PATCHSET v29.0 17/40] xfsprogs: widen BUI formats to support
 realtime
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404995199.1795774.9776541526454187305.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231181215.GA241128@frogsfrogsfrogs>
References: <20231231181215.GA241128@frogsfrogsfrogs>
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

Atomic extent swapping (and later, reverse mapping and reflink) on the
realtime device needs to be able to defer file mapping and extent
freeing work in much the same manner as is required on the data volume.
Make the BUI log items operate on rt extents in preparation for atomic
swapping and realtime rmap.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-bmap-intents

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-bmap-intents
---
 libxfs/defer_item.c     |    6 ++++++
 libxfs/xfs_bmap.c       |    4 ++--
 libxfs/xfs_log_format.h |    4 +++-
 3 files changed, 11 insertions(+), 3 deletions(-)

