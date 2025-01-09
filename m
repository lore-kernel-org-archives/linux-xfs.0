Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573782F43
	for <linux-xfs@vger.kernel.org>; Thu,  9 Jan 2025 00:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736384211; cv=none; b=ZMUPE1sUpR82HcLQrcRYx2jC9tvmmYEcW/vtdlF52VY0YT+OCWIcW0kEs/hmqYEEVfPDwSQDg+hGpadbiNM7NCi81QSGYbGXQjJzJCsYI0Y7E6hIGdL0eseTxSQCOS53n+11m0h6CwRHbnobPevt79pAgqRdO9XMf4b/mZV4g5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736384211; c=relaxed/simple;
	bh=fkK/P3VU63Wq5C3m4Ym2PlU2b4XcwyMHjDkL/QoYfCY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=gjw+PCStEhdbgvirwZBYwYpvNUzh+9F4K9xcKi/XklKmlJ7qf0K+Dry2jgQqmFzd8r2sHv+frqy0mejCeposXKqikJc0sQAhzHZNi8fpDwcQkIdl99ly9eV2ohoAC/yDRD3Pxzbrr2al5N8MVYDnLy2P31nDKpXJ55jSbIB8O+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N2RBzMo2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N2RBzMo2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7801C4CED3;
	Thu,  9 Jan 2025 00:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736384210;
	bh=fkK/P3VU63Wq5C3m4Ym2PlU2b4XcwyMHjDkL/QoYfCY=;
	h=Date:From:To:Cc:Subject:From;
	b=N2RBzMo2B/gFY7NhkQUGBJW32Uxw20EXPJxDlK07XIUJIHNXVKRwgmU9kDUjC9mzt
	 v2jub6lJ3gENYV5VR7Y6gNyo015bGNUgxBmjPEm9ZGA+9IInQXYHWgAJqdu+w8euhl
	 QwfQJCO2xEDb8Kw9JOePL5mcIdWBlWhrqa9n9Y5Hjipo1DAwCUrYGyB4HKNSyWHQqc
	 pnOFNkIRtgU0zm/YmdnNjYVVo+qBCbkbuvbqf5u7qMxkzgPBSIYECzFqR6WuQOM+7h
	 NmxLY0HzIPUTvoufOj72wZlQrhrhMn5D7ymlzgHoXLK3eDuIy6QM9qOTvebG5xltdL
	 5JU24uViq8Faw==
Date: Wed, 8 Jan 2025 16:56:50 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs_repair: don't obliterate return codes
Message-ID: <20250109005650.GK1306365@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Don't clobber error here, it's err2 that's the temporary variable.

Coverity-id: 1637363
Fixes: b790ab2a303d58 ("xfs_repair: support quota inodes in the metadata directory")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/quotacheck.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/repair/quotacheck.c b/repair/quotacheck.c
index 8c7339b267d8e6..7953144c3f416b 100644
--- a/repair/quotacheck.c
+++ b/repair/quotacheck.c
@@ -691,7 +691,7 @@ discover_quota_inodes(
 	err2 = mark_quota_inode(tp, dp, XFS_DQTYPE_GROUP);
 	if (err2 && !error)
 		error = err2;
-	error = mark_quota_inode(tp, dp, XFS_DQTYPE_PROJ);
+	err2 = mark_quota_inode(tp, dp, XFS_DQTYPE_PROJ);
 	if (err2 && !error)
 		error = err2;
 
