Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC1CC2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uDBNOSp3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA2BC433C8;
	Sun, 31 Dec 2023 23:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065751;
	bh=VLEEEL+brq0fY1eCPkIo4kRZkUZRogQKkxQjxhhir+c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uDBNOSp3JOzWYEIt0e3LhztmAIRFFoRppEaJO23TqgnhF3rN/NymYXkMQyXh/0cVl
	 AXKO995tpMDQ/6oU9bmgFDEUeNKcX7O9zOyz+6hLdolN5Ou4LcpQ+bFhpkITHvvlgn
	 OEsLmjQM8W8HJIyj1LDHdQQIqkrPgC6mi8xGTVxOXdVi/TpETmmYZLKQOKY8/0hp+c
	 /Q1pI5T67oj5gjDGYY86kAM0ayfhTSXtxtVEnR9Gy7NRZrNJPrNk5gSUAI/76XeTQW
	 cRBI7Lsa+dWCF2e9ma7oMJVuvbAF8fMW9GR63+QLsLkMBhQoaNqmWhEKdAYuE9zzcf
	 mV0lgMnQsZNKw==
Date: Sun, 31 Dec 2023 15:35:50 -0800
Subject: [PATCH 24/58] libfrog: allow METADIR in xfrog_bulkstat_single5
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010267.1809361.12271360880102247710.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
References: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
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

This is a valid flag for a single-file bulkstat, so add that to the
filter.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/bulkstat.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
index c863bcb6bf8..6eceef2a8fa 100644
--- a/libfrog/bulkstat.c
+++ b/libfrog/bulkstat.c
@@ -53,7 +53,8 @@ xfrog_bulkstat_single5(
 	struct xfs_bulkstat_req		*req;
 	int				ret;
 
-	if (flags & ~(XFS_BULK_IREQ_SPECIAL | XFS_BULK_IREQ_NREXT64))
+	if (flags & ~(XFS_BULK_IREQ_SPECIAL | XFS_BULK_IREQ_NREXT64 |
+		      XFS_BULK_IREQ_METADIR))
 		return -EINVAL;
 
 	if (xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64)

