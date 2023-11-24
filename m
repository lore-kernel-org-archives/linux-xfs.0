Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BC63C49E
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 23:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TLLCYKPC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A577C433C7;
	Fri, 24 Nov 2023 23:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700869489;
	bh=XXRy0e300CAKX1SOyETG8VaZs5z6X5p75n8LgsJ97Ns=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TLLCYKPCAGxRFpampRYtdWhC5UX0JEBMFDc5e2sWGCxSgsgNRda8g3lvH6WXBAhnd
	 ry7wuGrsrdldKKsfscHRufO/n3gA9rIu5vM2mTKq6v/Psn3COP1a79hLAzB8ua/ha3
	 Ien/GB1nZ6+D8L/1flFHGv0DxVejEUOBrhlB+S+M2Ji03m+g+KdazHVUM4ouf9R9Kc
	 tmobEQbfDWSRGh1APKkvqz9Qak0tQltboXU3Kk0eDvWp/BGLBjU9wdttn6ZFAJnHcC
	 CZPplO/R61mBKwKdZTKzHVHO0+50ujINJTSzAu9rvZRVmg2iHZkrUkpQn71S+RrjKy
	 KyG8uIzjBv3LQ==
Date: Fri, 24 Nov 2023 15:44:49 -0800
Subject: [PATCHSET v28.0 0/1] xfs: prevent livelocks in xchk_iget
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <170086925757.2768713.18061984370448871279.stgit@frogsfrogsfrogs>
In-Reply-To: <20231124233940.GK36190@frogsfrogsfrogs>
References: <20231124233940.GK36190@frogsfrogsfrogs>
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

Prevent scrub from live locking in xchk_iget if there's a cycle in the
inobt by allocating an empty transaction.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-livelock-prevention
---
 fs/xfs/scrub/common.c |    6 ++++--
 fs/xfs/scrub/common.h |   19 +++++++++++++++++++
 fs/xfs/scrub/inode.c  |    4 ++--
 3 files changed, 25 insertions(+), 4 deletions(-)

