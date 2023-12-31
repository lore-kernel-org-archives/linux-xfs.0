Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43298BE50
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gF5UHoFg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF60CC433C8;
	Sun, 31 Dec 2023 20:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055960;
	bh=bmXyXVFD8TGEn6d0AVvfwWb4bH1hbwzQr9k747LhqaQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gF5UHoFgVZVOtE5vsyZWwz1TGubQOXWSuxbCsrm8oQJwmPZVxRNWHXNq+He4RywVE
	 sKXzxSQB3VGlmUF2k4Tfzl5TlNZ2l0h/pPONkE6y2XyRifq6mFHYPazwixtR314tkf
	 QNQ6WPellLUriJUZrcWiu+dd8unz4P7LG8tDqUKbucjwxgP7dZY2X6d9N75VLIRSVW
	 DKb6/KFn3GtX9MH9+wczNorDQd0WE52SW39/VsGzTyk95rWAgVPqhuVr/wiWb5TTpP
	 VlVEnHyjLfQstisvxg3Mzc8t9eaggONnA5OyM+lr4TBv9Z7xbrzsq0XQ3iKlYcXpY2
	 J6Pk9vpBpMBIg==
Date: Sun, 31 Dec 2023 12:52:40 -0800
Subject: [PATCH 16/18] xfs: drop compatibility minimum log size computations
 for reflink
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <170404841296.1756905.7666232213618503816.stgit@frogsfrogsfrogs>
In-Reply-To: <170404840995.1756905.18018727013229504371.stgit@frogsfrogsfrogs>
References: <170404840995.1756905.18018727013229504371.stgit@frogsfrogsfrogs>
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

Having established that we can reduce the minimum log size computation
for filesystems with parent pointers or any newer feature, we should
also drop the compat minlogsize code that we added when we reduced the
transaction reservation size for rmap and reflink.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_log_rlimit.c |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index b836de0de5b95..1ccd4aa921756 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
@@ -81,6 +81,16 @@ xfs_log_calc_trans_resv_for_minlogblocks(
 {
 	unsigned int		rmap_maxlevels = mp->m_rmap_maxlevels;
 
+	/*
+	 * Starting with the parent pointer feature, every new fs feature
+	 * drops the oversized minimum log size computation introduced by the
+	 * original reflink code.
+	 */
+	if (xfs_has_parent_or_newer_feature(mp)) {
+		xfs_trans_resv_calc(mp, resv);
+		return;
+	}
+
 	/*
 	 * In the early days of rmap+reflink, we always set the rmap maxlevels
 	 * to 9 even if the AG was small enough that it would never grow to

