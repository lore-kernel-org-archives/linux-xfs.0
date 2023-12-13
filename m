Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F17224E8;
	Wed, 13 Dec 2023 22:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mLej5KPg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF8C1C433C8;
	Wed, 13 Dec 2023 22:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702506885;
	bh=G/r4/NYCYySyRnGiCZ+YcKN390745JqsVNvZUyyM5EM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=mLej5KPgPhMEb4uJ3MzILXS3iXD8XCVqTH0+2Oi3F/eOgqPlugzeh9u78q33xbq/5
	 tjv3MAM/h+ARah2TybBlwJljDvnzd4FY+6lg7s6aQDXgKsFe3KnujtBlpWd+tslRkO
	 tw4H1VvnxK08mfy3vmI4Ef/JBm1tNBBxbp/6cLVBgIttlBqhVYb3PrMcQnI8d9IK4Q
	 h0asl/ik5PyH0SWm2k4IOmsi2Mq6ueYBjWPsZHafdE+I87JnWYRgr6grl2mR2Xm2M/
	 N9UmUZU/f9S4fHsX/JOdovYYF0yvhumL8j5Uu6KXhOA4oAIZVwl3zU0FyG/DIClfZb
	 2v0FSGcTNRnbg==
Subject: [PATCH 3/3] generic/735: skip this test if we cannot finsert at pos
 1M
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Date: Wed, 13 Dec 2023 14:34:45 -0800
Message-ID: <170250688518.1363584.11932716959963736458.stgit@frogsfrogsfrogs>
In-Reply-To: <170250686802.1363584.16475360795139585624.stgit@frogsfrogsfrogs>
References: <170250686802.1363584.16475360795139585624.stgit@frogsfrogsfrogs>
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

Add a _require_congruent_file_oplen to screen out filesystem
configurations that can't start a finsert operation at file pos 1M
because the fs block size isn't congruent with 1048576.  For example,
xfs realtime with 28k rt extents.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/735 |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/generic/735 b/tests/generic/735
index 44b454771d..75b23d5efc 100755
--- a/tests/generic/735
+++ b/tests/generic/735
@@ -25,6 +25,7 @@ dev_size=$((80 * 1024 * 1024))
 _scratch_mkfs_sized $dev_size >>$seqres.full 2>&1 || _fail "mkfs failed"
 
 _scratch_mount
+_require_congruent_file_oplen $SCRATCH_MNT 1048576	# finsert at 1M
 file_blksz="$(_get_file_block_size ${SCRATCH_MNT})"
 
 # Reserve 1M space

