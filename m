Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDFEC2D4
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DTNYxNBm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 716CFC433C8;
	Sun, 31 Dec 2023 19:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052567;
	bh=+/6RYGjb35yFzTDStbgZPa/rNA6doWaWLbugaLs5PlY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DTNYxNBmZAYZ64TlO6EweYEA2IOnvm68N/Ud0EP/pEGRq9IexH2j/AUlWeGyYVnkI
	 WbXEV6lBPFE4Owqbm3gHp45a4xK5/xu6CBRm9fSY5+cGf61UQ8O1NcTNGwtF4wm9qv
	 dud61Tww58wQ+CIvrBUfKgBhOiVOwaGpJzDeKXuKFFslsdhirZcpEt5Rl48Ll1Yb8E
	 7PbSgR6lsDHVZ9IXyfsyFvnLxeTU9yriC1KspJSbmh7f9CS2i8YIRqGm0MHjjVcWlD
	 ApILE8ZyOmATWth7/pdHB9nwmJQ9HbcYMqlfkXMaRL+WJpl7PqRuwmgqZK0ZRPYe3b
	 uegRy+wlJO01w==
Date: Sun, 31 Dec 2023 11:56:06 -0800
Subject: [PATCHSET v2.0 17/17] xfsprogs: enable quota for realtime voluems
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405018382.1818295.12964444180016025240.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231182323.GU361584@frogsfrogsfrogs>
References: <20231231182323.GU361584@frogsfrogsfrogs>
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

At some point, I realized that I've refactored enough of the quota code
in XFS that I should evaluate whether or not quota actually works on
realtime volumes.  It turns out that with two exceptions, it actually
does seem to work properly!  There are three broken pieces that I've
found so far: chown doesn't work, the quota accounting goes wrong when
the rt bitmap changes size, and the VFS quota ioctls don't report the
realtime warning counts or limits.  Hence this series fixes two things
in XFS and re-enables rt quota after a break of a couple decades.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-quotas

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-quotas

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-quotas
---
 include/xqm.h |    5 ++++-
 quota/state.c |    1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

