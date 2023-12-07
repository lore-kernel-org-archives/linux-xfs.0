Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4121846
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YXccJVQ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8927EC433C8;
	Thu,  7 Dec 2023 02:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701915789;
	bh=bsYd8U0+3X6f/qX6ezCY2eM+1tb+Lbcu6jLpru1TMAI=;
	h=Date:Subject:From:To:Cc:From;
	b=YXccJVQ43u/sFo6Xm79SutMUu58nwmOFYYiHfUjj9WmGHdKmufwgO0nHEQPfyO5b9
	 +eR8GBUv597d3l4dnVAGdSpPsAJT/ZG5MXtCjt9d+fbFQezRysmv+e7TOZKU4OpTKF
	 7koQilwNzk4+XQtaZeTWUVpalyUOcQKwEeaVCajmH2B96E9i0o0dLVn/fVvu1F5pFl
	 hBuKD/m4C7QuWLAR5Rz2mD+r3tcoSua5rWrckQH1tJr2U2WiDC/PVF/fXS8PKXanYo
	 QmLCy2sqUDjC93PzwvG9nbxmymP0qc3Na9lxVGrQcN5ZaBJedNTqM1g1rZESC5zVym
	 hKEsv7hdZZ0Bw==
Date: Wed, 06 Dec 2023 18:23:09 -0800
Subject: [PATCHSET v2 0/2] xfs: elide defer work ->create_done if no intent
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, hch@lst.de, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170191563274.1133791.13463182603929465584.stgit@frogsfrogsfrogs>
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

Christoph pointed out that the defer ops machinery doesn't need to call
->create_done if the deferred work item didn't generate a log intent
item in the first place.  Let's clean that up and save an indirect call
in the non-logged xattr update call path.

v2: pick up rvb tags

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=defer-elide-create-done-6.8
---
 fs/xfs/libxfs/xfs_defer.c |    4 ++++
 fs/xfs/xfs_attr_item.c    |    3 ---
 fs/xfs/xfs_sysfs.c        |    9 +++++++++
 3 files changed, 13 insertions(+), 3 deletions(-)

