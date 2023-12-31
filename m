Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EFECB645
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VgjaTov2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04E5C433C8;
	Sun, 31 Dec 2023 19:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704050925;
	bh=k11t94AhGzKDFNXFctA5tjtLb20axgUndvsMNZZdfHc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VgjaTov2axcyoFA0tFqx/Tw5Pl0kHTDmCivRNtodaJjUOB9WhoImyg1leXHRWQhbK
	 u4grupieFV/lVvl/KBS4NHrS8aMIxHFxCIaGECEUPhxGfekIqePks1cBs6fjVV+8yL
	 eneIl/h5efK0lYbP0GD5w6xbb2HFfuzt6AmHWC9VgPc4yA8y/S0HpaUfo3FTbMGUu0
	 5UfF3umlTrfydcvtAawaustD5D3Qp8MTEa7nEaKMItDcvDTggouTp24Ogo8rimAKYW
	 jI4HP55afHFjZFOWJwLZlAfQuNKB6Zgaa5/9G6nqI51dkr5YolnbTJA8e41T/1tcYZ
	 qTLTR6vEWHUIA==
Date: Sun, 31 Dec 2023 11:28:44 -0800
Subject: [PATCHSET v29.0 13/28] xfs: widen BUI formats to support realtime
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404831869.1749931.14460733843503552627.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_bmap.c       |    4 ++--
 fs/xfs/libxfs/xfs_log_format.h |    4 +++-
 fs/xfs/xfs_bmap_item.c         |   17 +++++++++++++++++
 fs/xfs/xfs_trace.h             |   23 ++++++++++++++++++-----
 4 files changed, 40 insertions(+), 8 deletions(-)

