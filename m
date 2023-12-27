Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EACF33ED;
	Mon,  1 Jan 2024 01:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lj0Qrvma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1921C433C7;
	Mon,  1 Jan 2024 01:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704071180;
	bh=sBv4u4zKJohS8nuo3foqBHDqzW4VVsu9qg0IUy5eBEk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lj0QrvmamA55e++dwm0PuicpP1fdHPx5zMdWdDLX3Ug+yag+bIKzNll5yI2l9/APX
	 ZcoJINgXqqqLQ2QshwCqRhrDlZWycbL9U//kj5+U5AshHyeGMys/gGGDRcffOmPKk5
	 96zYfaVaZZDofu7AZa7zBeGduQ3qqQsmt0+RHlYlcyTXrNFUbvDNs9cxqdpbWNTJOV
	 rlDsDbka4kYMrT++lB+WPMmTvDRF9ESqhuQVFsVGpQGzQ4aEKZx92gZCHbS/qUdIZj
	 /K328itDvpxLzUwIvgXFNb7ldHSK9ahkxYMhp79bcyLlLwOcXj92fIIm9lCdOKaA8I
	 /wKtRDW6Ti/KQ==
Date: Sun, 31 Dec 2023 17:06:20 +9900
Subject: [PATCH 1/2] xfs/122: update for the getfsrefs ioctl
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405033746.1828671.7290167831667515266.stgit@frogsfrogsfrogs>
In-Reply-To: <170405033732.1828671.2206987916120651051.stgit@frogsfrogsfrogs>
References: <170405033732.1828671.2206987916120651051.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add this new ioctl here too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/122.out |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 9c2d2fffb4..4d7e6c1eb4 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -101,6 +101,8 @@ sizeof(struct xfs_fsop_ag_resblks) = 64
 sizeof(struct xfs_fsop_geom) = 256
 sizeof(struct xfs_fsop_geom_v1) = 112
 sizeof(struct xfs_fsop_geom_v4) = 112
+sizeof(struct xfs_getfsrefs) = 64
+sizeof(struct xfs_getfsrefs_head) = 192
 sizeof(struct xfs_getparents) = 96
 sizeof(struct xfs_getparents_rec) = 24
 sizeof(struct xfs_icreate_log) = 28

