Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D956170A3E;
	Wed, 16 Oct 2024 23:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729120517; cv=none; b=VkIh6KktfD7QPgIny75hFjlplq5hhx2joktb1bQv4lXfDXBBi93ZBgdBPItbwYMRRmm7GtS9OAgdQnrIXHHU46PWVZGMAIsavi3/QZElUSEqAao5qXxpIzzKKdyvv0X+RcMZMLFNDMhyJegoX0XCfPvAgb/VtxivA3CVyoZwouY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729120517; c=relaxed/simple;
	bh=nPBzuVmDbErR9epDVF+Ui3A0N5zBno9pCjItZniZqYQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tNpCkjEkhDO0n39/IYjMqLrTbZon+Gh13NPsCPP6yiXdC0mFqytso3PbzMDp0191xY3dfQTs6LuqPC0Sih4hPbBjWrfXIAO9V+fiKbJaeeMAPzR7BOa43jdssU/m6nOKn92fT0ilxDXJ/SitS3GnajGZfdT9HV70BWnWHPjap1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bUA7Uv+u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bUA7Uv+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A059C4CEC5;
	Wed, 16 Oct 2024 23:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729120517;
	bh=nPBzuVmDbErR9epDVF+Ui3A0N5zBno9pCjItZniZqYQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bUA7Uv+uNagpicT+VJeoZce0pONXaiTaHqJe4ztGX5QfVpMkLS+fksUmtEWgOZ7e+
	 xxJ+jgxIwCLW0tKjptpfxRk1Z+I/j0wk59TByALL9nIo8N257u5DnEme6rkYuTEETh
	 Z3sODsto4MtRwWQacHjzjmt2XL8YNr8R0AXuZ3SgJTIfyyB6GjqfvyuMTxJ46M0XAy
	 SGEpbqZbsfDJdFVCdwxh3OM8NFPNeFqz0XqpXMePMLhUcMkGmnh40DP57svrl47par
	 gF/Skzf/M0aZcwskhwU3RNvWj1vKBcicYpqS+yAL2M0CI/79vPYe6hY/O4MOfB/mLO
	 pVwDMN+pom78w==
Date: Wed, 16 Oct 2024 16:15:16 -0700
Subject: [PATCH 1/2] common/xfs: _notrun tests that fail due to block size <
 sector size
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <172912045609.2583984.9245803618825626168.stgit@frogsfrogsfrogs>
In-Reply-To: <172912045589.2583984.11028192955246574508.stgit@frogsfrogsfrogs>
References: <172912045589.2583984.11028192955246574508.stgit@frogsfrogsfrogs>
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

It makes no sense to fail a test that failed to format a filesystem with
a block size smaller than the sector size since the test preconditions
are not valid.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/common/xfs b/common/xfs
index 62e3100ee117a7..53d55f9907fbb0 100644
--- a/common/xfs
+++ b/common/xfs
@@ -172,6 +172,11 @@ _try_scratch_mkfs_xfs()
 		mkfs_status=$?
 	fi
 
+	if [ $mkfs_status -ne 0 ] && grep -q '^block size [0-9]* cannot be smaller than sector size' "$tmp.mkfserr"; then
+		errormsg="$(grep '^block size [0-9]* cannot be smaller than sector size' "$tmp.mkfserr" | head -n 1)"
+		_notrun "_scratch_mkfs_xfs: $errormsg"
+	fi
+
 	# output mkfs stdout and stderr
 	cat $tmp.mkfsstd
 	cat $tmp.mkfserr >&2

