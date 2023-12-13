Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744BDBA49
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 23:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vJF73nLe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46614C433C7;
	Wed, 13 Dec 2023 23:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702508458;
	bh=qrPl42Xa/flpgL+6MsJflJhn4KrjVOdGLO5+sRNKECE=;
	h=Date:Subject:From:To:Cc:From;
	b=vJF73nLeCYy6fHSa6eesNOcjpcQCY1N82WCOpL6hQPDvEwbGC2BJsCbCEF0MUCQ+3
	 Ua5E3iBWpG1mTmEOrNiwE8Qqu0H7RvpeBj3bk3yZ17oBiXqk4j9jFnGLpVAF9szBHG
	 4Yot0HZFpd7Qkivjw2XclBhuwX+pxfPWvx0CSDQMXVjjo2xGKWuxNyOvYlMLKq2ZNI
	 JuvlP7Bvfw57gebxGNF3ubmkXs99AUTyai9ntP2ZttTb0Akl2zmQE9OFi4BZ+7RDxl
	 hJrQXllQZPiNAlaRP/K98mEOlm3FlqyVEw+IzoxumyyNX3Rf0N6HnGDK0yM/O8het9
	 Oo1zxEh++XCfA==
Date: Wed, 13 Dec 2023 15:00:57 -0800
Subject: [GIT PULL] xfs: fix growfsrt failure during rt volume attach
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org, hch@lst.de
Cc: linux-xfs@vger.kernel.org
Message-ID: <170250841594.1407007.16675519012126410551.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.8-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 18793e050504288345eb455a471677b57117bcc6:

xfs: move xfs_ondisk.h to libxfs/ (2023-12-07 15:15:29 +0530)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/fix-growfsrt-failures-6.8_2023-12-13

for you to fetch changes up to 578bd4ce7100ae34f98c6b0147fe75cfa0dadbac:

xfs: recompute growfsrtfree transaction reservation while growing rt volume (2023-12-13 14:16:27 -0800)

----------------------------------------------------------------
xfs: fix growfsrt failure during rt volume attach
One more series to fix a transaction reservation overrun while
trying to attach a very large rt volume to a filesystem.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (1):
xfs: recompute growfsrtfree transaction reservation while growing rt volume

fs/xfs/xfs_rtalloc.c | 5 +++++
1 file changed, 5 insertions(+)

