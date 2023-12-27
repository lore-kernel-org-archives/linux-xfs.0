Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056F97ED;
	Mon,  1 Jan 2024 00:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A8oWNevI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864A9C433C8;
	Mon,  1 Jan 2024 00:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070742;
	bh=MgFLUXCk5rf9uB5i0V7IUBLm99Hr2qikmIU5DayRiA8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=A8oWNevIgjUnZPwSz0RF0i9GQWM+Ns3kHvcXw61JhqazCZcW6FuQGjn/g7SDE7PFH
	 wNLVjYMBHpBBHDvoHHwCJUBYSI9clRPnfw+NnYBGBpIJuO4edzbOn9+3zykhXPhkgo
	 KVsNl9Rq2QkhUPEZjuYpUXDCv2TnYltVEMhhZntLgrajab81voIwzoA0hwJPIqyQ0J
	 nTW5AzHsqIAj1VzuEaMpHG1eUz5a4vmM8qUH5e1s6VbZK1ghNs68SnnEhY/FdMew1y
	 A/kQ8rzgNZ3jeIfF3HbkqcsDbF+n6js11hpx+gBNMwkWj69mcc9+aOyDrAI2w0aEdN
	 URax+x6o1aWRg==
Date: Sun, 31 Dec 2023 16:59:02 +9900
Subject: [PATCH 05/13] xfs/122: update for rtgroups-based realtime rmap btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405031300.1826914.17433169728736943917.stgit@frogsfrogsfrogs>
In-Reply-To: <170405031226.1826914.14340556896857027512.stgit@frogsfrogsfrogs>
References: <170405031226.1826914.14340556896857027512.stgit@frogsfrogsfrogs>
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

Now that we've redesigned realtime rmap to require that the rt section
be sharded into allocation groups of no more than 2^31 blocks, we've
reduced the size of the ondisk structures and therefore need to update
this test.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/122.out |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 837286a9d3..f5621cac12 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -120,8 +120,8 @@ sizeof(struct xfs_rmap_key) = 20
 sizeof(struct xfs_rmap_rec) = 24
 sizeof(struct xfs_rtbuf_blkinfo) = 48
 sizeof(struct xfs_rtgroup_geometry) = 128
-sizeof(struct xfs_rtrmap_key) = 24
-sizeof(struct xfs_rtrmap_rec) = 32
+sizeof(struct xfs_rtrmap_key) = 20
+sizeof(struct xfs_rtrmap_rec) = 24
 sizeof(struct xfs_rtrmap_root) = 4
 sizeof(struct xfs_rtsb) = 104
 sizeof(struct xfs_rud_log_format) = 16

