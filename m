Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1763E7ED;
	Mon,  1 Jan 2024 01:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DyJlwtMc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A222C433C8;
	Mon,  1 Jan 2024 01:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070836;
	bh=hA+qaCTrGF0ZydHSDWX/oGQSqrmn1rmcf5eC/q17aoY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DyJlwtMceWKF+qMIZl7ZRYA5b3pq/Kkq5wzGyr7gv2tfHo+zdARguY5cz0RISpG5L
	 g9Jtfb/6oJag3lCeRjW30SGyHuSreBxBiDEdUG3kfSBaFCzF/7ueUV40uiWRLyLlpa
	 IYxSFd2aFSGNkLPujWAyI+6tc4PPvOrxrkkfh3wQZtNTM8uVjrxjA07gkZSfOK2lAz
	 kQk6GOsXgk2CYGE5YeCe95cyCtXr+lcWkeVZkXhmnzYeZnnzBAbksPCUq7PxghMyl4
	 eVSXbYldjUVHt/gKm/rKgQrEE9YnEHxgs5kCYGEVEtlwe7P8cc/mZsJecYA8VW8kCJ
	 p82WfJG1eI/lQ==
Date: Sun, 31 Dec 2023 17:00:36 +9900
Subject: [PATCH 11/13] populate: adjust rtrmap calculations for rtgroups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405031378.1826914.2094696976335341988.stgit@frogsfrogsfrogs>
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

Now that we've sharded the realtime volume and created per-group rmap
btrees, we need to adjust downward the size of rtrmapbt records since
the block counts are now 32-bit instead of 64-bit.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/populate |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/common/populate b/common/populate
index dc89eee70e..d8d19bf782 100644
--- a/common/populate
+++ b/common/populate
@@ -450,7 +450,7 @@ _scratch_xfs_populate() {
 	is_rt="$(_xfs_get_rtextents "$SCRATCH_MNT")"
 	if [ $is_rmapbt -gt 0 ] && [ $is_rt -gt 0 ]; then
 		echo "+ rtrmapbt btree"
-		nr="$((blksz * 2 / 32))"
+		nr="$((blksz * 2 / 24))"
 		$XFS_IO_PROG -R -f -c 'truncate 0' "${SCRATCH_MNT}/RTRMAPBT"
 		__populate_create_file $((blksz * nr)) "${SCRATCH_MNT}/RTRMAPBT"
 	fi

