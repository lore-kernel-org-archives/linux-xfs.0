Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFC97ED;
	Mon,  1 Jan 2024 00:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wp+BcVQ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB996C433C8;
	Mon,  1 Jan 2024 00:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070460;
	bh=C0TfiZlEap7l3zpoW2EHNWrVoATyl3RYZMZXYP+DhKY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Wp+BcVQ0zd7T1wko80VRqAAn7dgjWcUDNwEApGmpOSr+pHmAihTtSH1Mrr4CqkCwv
	 z1+za2YXI/CsvvPoIgGyIp2/6tlPcUiWXTMs9JsXbPMk3GughJJdqGR9paxBehtRil
	 9Ixo/CoWdFkmKxfyK3dP13naqomAG1dy7HDM2iOEUZYEKQGexMsTrO7kxpuSGGW0Ud
	 glAwVntv7QUkQYESRanPWuC99n9nO3u3ZNYd4tuKqBawIruEq+HTdlg7hmFkS9zZOT
	 NnuEaiHWCQ1bQT/kEUo/oDjvMc/FJU2vykrVreJOrBaN8qbMhAnmwpGpwe+2ag3lB9
	 O0wjazmaY97CA==
Date: Sun, 31 Dec 2023 16:54:20 +9900
Subject: [PATCH 06/17] xfs/122: update for rtgroups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405030416.1826350.1854166515093314531.stgit@frogsfrogsfrogs>
In-Reply-To: <170405030327.1826350.709349465573559319.stgit@frogsfrogsfrogs>
References: <170405030327.1826350.709349465573559319.stgit@frogsfrogsfrogs>
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

Add our new metadata for realtime allocation groups to the ondisk checking.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/122.out |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 430b805792..21b139d838 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -44,6 +44,9 @@ offsetof(xfs_sb_t, sb_rbmino) = 64
 offsetof(xfs_sb_t, sb_rextents) = 24
 offsetof(xfs_sb_t, sb_rextsize) = 80
 offsetof(xfs_sb_t, sb_rextslog) = 125
+offsetof(xfs_sb_t, sb_rgblklog) = 280
+offsetof(xfs_sb_t, sb_rgblocks) = 272
+offsetof(xfs_sb_t, sb_rgcount) = 276
 offsetof(xfs_sb_t, sb_rootino) = 56
 offsetof(xfs_sb_t, sb_rrmapino) = 264
 offsetof(xfs_sb_t, sb_rsumino) = 72
@@ -116,9 +119,11 @@ sizeof(struct xfs_refcount_key) = 4
 sizeof(struct xfs_refcount_rec) = 12
 sizeof(struct xfs_rmap_key) = 20
 sizeof(struct xfs_rmap_rec) = 24
+sizeof(struct xfs_rtgroup_geometry) = 128
 sizeof(struct xfs_rtrmap_key) = 24
 sizeof(struct xfs_rtrmap_rec) = 32
 sizeof(struct xfs_rtrmap_root) = 4
+sizeof(struct xfs_rtsb) = 104
 sizeof(struct xfs_rud_log_format) = 16
 sizeof(struct xfs_rui_log_format) = 16
 sizeof(struct xfs_scrub_metadata) = 64

