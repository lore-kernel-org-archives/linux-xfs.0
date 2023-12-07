Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9F21845
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VH1rb5ey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A01CC433C9;
	Thu,  7 Dec 2023 02:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701915778;
	bh=/yE4K2dGPpg7XJVWVKSrobddXAQ1S8XDCaf8B1lZC5w=;
	h=Date:Subject:From:To:Cc:From;
	b=VH1rb5eyBJdWmy1a/yyrzGKbXKQEeogcUGm+utSqlgvuDIuB3fYahDuNiougJ3PK6
	 R45wSTjIXiVVPllQunYPTNwTU6I7v/WlSP/MsOLhRoGqhxkmumlsgEPdQ4Lvc1H6yC
	 G9/9djvjiahePBf8udg2+UdPilOz65ceWBtf9xqw9WxMCPdPvYdFc28Gs+3wFez9c2
	 GkbIiyv7xZfgQ1910SoQbMxgHpwh+j+2zejN2g3jBnFl3hmb1IJ1y9l8LIf4sr6bfK
	 ALoN18Z4w/Ssr3Jbm/m41G1Y7r+CE2azDHr+FpLoyxv5Cnvsrpfiy92MSgn82vz1mt
	 0edcTX3a38/BQ==
Date: Wed, 06 Dec 2023 18:22:56 -0800
Subject: [PATCHSET v2 0/9] xfs: continue removing defer item boilerplate
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, hch@lst.de, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170191562370.1133395.5436656395520338293.stgit@frogsfrogsfrogs>
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

Now that we've restructured log intent item recovery to reconstruct the
incore deferred work state, apply further cleanups to that code to
remove boilerplate that is duplicated across all the _item.c files.
Having done that, collapse a bunch of trivial helpers to reduce the
overall call chain.  That enables us to refactor the relog code so that
the ->relog_item implementations only have to know how to format the
implementation-specific data encoded in an intent item and don't
themselves have to handle the log item juggling.

v2: pick up rvb tags

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=reconstruct-defer-cleanups-6.8
---
 fs/xfs/libxfs/xfs_defer.c  |   55 ++++++++++
 fs/xfs/libxfs/xfs_defer.h  |    3 +
 fs/xfs/xfs_attr_item.c     |  137 +++++++------------------
 fs/xfs/xfs_bmap_item.c     |  115 ++++++---------------
 fs/xfs/xfs_extfree_item.c  |  242 ++++++++++++++++----------------------------
 fs/xfs/xfs_refcount_item.c |  113 ++++++---------------
 fs/xfs/xfs_rmap_item.c     |  113 ++++++---------------
 fs/xfs/xfs_trans.h         |   10 --
 8 files changed, 284 insertions(+), 504 deletions(-)

