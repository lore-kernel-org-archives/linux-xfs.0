Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7071B65B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VOzpXsbr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 222E9C433C7;
	Sun, 31 Dec 2023 19:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051973;
	bh=+XOM8ho9ZPpvludIPh0uVdLxcFFtuk1ZfDDaN4L6Z4E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VOzpXsbrwehax/MXW0129vxNr4coQRrDQYvFfsG7Y8N6MF8+4kGsU7PXGLP/JCiXq
	 7RLC7/iPuXqLlSUbhjhGc9yJ6VIfjH5KKZT5vZoHvZn3Y3A2cRsS2VGN7Lo+G36JUr
	 M14DFQVOp9k3sz8NQq2gx5Rw1xgkfr7jgUUDLgqov9xmx6DAsFnw26HRYvuRQZFbSk
	 imfsjT+T5THE/wtZZcII4ECuWY8tUblsFX8nYOK0SXhj4ten+kILp3YA25R3YmWD7V
	 zpFc+gW/wqR0hVt+u73bhf+cY9gYnIGfOXh8BCNnLtMNrXC7Qv15EG8YF/6VH1Fw7w
	 m2XJ7fJybJ7Jw==
Date: Sun, 31 Dec 2023 11:46:12 -0800
Subject: [PATCHSET v29.0 25/40] xfsprogs: inode-related repair fixes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404998289.1797172.11188208357520292150.stgit@frogsfrogsfrogs>
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

While doing QA of the online fsck code, I made a few observations:
First, nobody was checking that the di_onlink field is actually zero;
Second, that allocating a temporary file for repairs can fail (and
thus bring down the entire fs) if the inode cluster is corrupt; and
Third, that file link counts do not pin at ~0U to prevent integer
overflows.

This scattered patchset fixes those three problems.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=inode-repair-improvements

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=inode-repair-improvements
---
 include/xfs_inode.h    |    2 ++
 libxfs/util.c          |   24 ++++++++++++++++++++++++
 libxfs/xfs_format.h    |    6 ++++++
 libxfs/xfs_ialloc.c    |   40 ++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_inode_buf.c |    8 ++++++++
 mkfs/proto.c           |    4 ++--
 repair/incore_ino.c    |    3 ++-
 repair/phase6.c        |   10 +++++-----
 8 files changed, 89 insertions(+), 8 deletions(-)

