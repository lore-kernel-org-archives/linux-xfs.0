Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455C61863F;
	Fri, 11 Oct 2024 01:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610953; cv=none; b=r596fhMORxsqc+x9EhUimNvhl6VTcs1sScX7Ujs9zEfMRuFaIGPVxngbTMPzGdERWKjCaGsPilfZtMYKifV2PXcFTlZlThm+eVNTOCjnKQ0DUpt6RExMPM5tqAiNH7u4KVg+Ek53mh4ldRuEehUIDmxhQQJe+hxxEm87WPrpInI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610953; c=relaxed/simple;
	bh=9uS+FRvC54Qbjz2xOqOvPAQvuAx82CWG+RhdjpJr3Ic=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QVAMXeQpwAr/448CMrt3Rf2DAANXLed+Kquk8jcpOKfbhQiO/7ClTIfixz7MSbDp53rxii2FDTlr0lKrs29yPCoslSSBq2iSmJQluMqSlSU8VxINhMYD9A/aUcSjEo0SO0tjx+73UtD9Z8A7JpM7bK6DtP4tiFVGYVj+WUCUOkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=opmY0cis; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="opmY0cis"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D214C4CEC5;
	Fri, 11 Oct 2024 01:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610953;
	bh=9uS+FRvC54Qbjz2xOqOvPAQvuAx82CWG+RhdjpJr3Ic=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=opmY0cisJ20w/jruJZ2/1e3UP3V5rYb6RrKs4yI0kCazAwWIKhTrvOpGGsmczyerT
	 7ZZNVz9C1Dpb2j5rpGXBB5hiDjmKtW6IWAPv2C2V7oNJuWWsZeqSK12WTsEmNBUpyM
	 g9qIYzpf0fequNInUQynDAAhhFCJv0a3/W7d+cbLYtPPSI3UvnKCgWM3OKXywap/rR
	 fX41YklntPnrZm6ZJhJ/GBf9QjddFkzLjZdC7akyUY7YXMs9bdzwllvYkeAmPUqYaZ
	 Miz0rjQ9qAC6mXcMCBDuH7va1n8T/QxZvL4j5vJgXIEJdTYg9XX4YfAXcyOwwJdgDm
	 fEdbi39hkFM2g==
Date: Thu, 10 Oct 2024 18:42:32 -0700
Subject: [PATCH 06/16] xfs/122: update for rtgroups
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org
Message-ID: <172860658613.4188964.8366659246490667877.stgit@frogsfrogsfrogs>
In-Reply-To: <172860658506.4188964.2073353321745959286.stgit@frogsfrogsfrogs>
References: <172860658506.4188964.2073353321745959286.stgit@frogsfrogsfrogs>
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
 tests/xfs/122.out |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index f47904bc75e6de..ff501d027612ee 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -45,6 +45,9 @@ offsetof(xfs_sb_t, sb_rbmino) = 64
 offsetof(xfs_sb_t, sb_rextents) = 24
 offsetof(xfs_sb_t, sb_rextsize) = 80
 offsetof(xfs_sb_t, sb_rextslog) = 125
+offsetof(xfs_sb_t, sb_rgblklog) = 280
+offsetof(xfs_sb_t, sb_rgcount) = 272
+offsetof(xfs_sb_t, sb_rgextents) = 276
 offsetof(xfs_sb_t, sb_rootino) = 56
 offsetof(xfs_sb_t, sb_rrmapino) = 264
 offsetof(xfs_sb_t, sb_rsumino) = 72
@@ -93,7 +96,7 @@ sizeof(struct xfs_dir3_leaf) = 64
 sizeof(struct xfs_dir3_leaf_hdr) = 64
 sizeof(struct xfs_disk_dquot) = 104
 sizeof(struct xfs_dqblk) = 136
-sizeof(struct xfs_dsb) = 272
+sizeof(struct xfs_dsb) = 280
 sizeof(struct xfs_dsymlink_hdr) = 56
 sizeof(struct xfs_exchange_range) = 40
 sizeof(struct xfs_extent_data) = 24
@@ -121,9 +124,11 @@ sizeof(struct xfs_refcount_key) = 4
 sizeof(struct xfs_refcount_rec) = 12
 sizeof(struct xfs_rmap_key) = 20
 sizeof(struct xfs_rmap_rec) = 24
+sizeof(struct xfs_rtgroup_geometry) = 128
 sizeof(struct xfs_rtrmap_key) = 24
 sizeof(struct xfs_rtrmap_rec) = 32
 sizeof(struct xfs_rtrmap_root) = 4
+sizeof(struct xfs_rtsb) = 56
 sizeof(struct xfs_rud_log_format) = 16
 sizeof(struct xfs_rui_log_format) = 16
 sizeof(struct xfs_scrub_metadata) = 64

