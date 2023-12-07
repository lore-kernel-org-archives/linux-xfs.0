Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F2015CE
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pfCWIHvV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF141C433C7;
	Thu,  7 Dec 2023 02:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701916113;
	bh=Dl099UIZycXgclKM0a4h4R7bw+ZUha2Pxd2L2oiOOd4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pfCWIHvVswhCfAGpxGDLXyBK201zkxgxw0gXkkb3rvmV9/QcR586oV0NiZnr7NuKt
	 b4DkXTygfqojJX3RWJ8tsu2OC4krvzWLrf2hfXMsxQkHpsuTlZaCS2GdbepDDdDH6v
	 c+pp0SDvkE7tttH/MvC6TXMsA697Yahpgxx5oC7ELnegt0D6WaZOYKlWaLmUvJl889
	 en9JNYB2L/+1oI+nidOnNADv738QqVJbxTH4e3J36pdi1i4WRqIcqFraIsLmkIJfdH
	 YifR/zrRu71LIDV4Sgp8CbiNoXEeNysKkVJXXti4Z7TEWlw6W9Nf2t/svxK/0KXAIF
	 FNq0fVC/80deg==
Date: Wed, 06 Dec 2023 18:28:33 -0800
Subject: [PATCH 1/2] xfs: document what LARP means
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, hch@lst.de, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170191563293.1133791.6107631178744558029.stgit@frogsfrogsfrogs>
In-Reply-To: <170191563274.1133791.13463182603929465584.stgit@frogsfrogsfrogs>
References: <170191563274.1133791.13463182603929465584.stgit@frogsfrogsfrogs>
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

Christoph requested a blurb somewhere explaining exactly what LARP
means.  I don't know of a good place other than the source code (debug
knobs aren't covered in Documentation/), so here it is.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_sysfs.c |    9 +++++++++
 1 file changed, 9 insertions(+)


diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index a3c6b1548723..871f16a4a5d8 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -229,6 +229,15 @@ pwork_threads_show(
 }
 XFS_SYSFS_ATTR_RW(pwork_threads);
 
+/*
+ * The "LARP" (Logged extended Attribute Recovery Persistence) debugging knob
+ * sets the XFS_DA_OP_LOGGED flag on all xfs_attr_set operations performed on
+ * V5 filesystems.  As a result, the intermediate progress of all setxattr and
+ * removexattr operations are tracked via the log and can be restarted during
+ * recovery.  This is useful for testing xattr recovery prior to merging of the
+ * parent pointer feature which requires it to maintain consistency, and may be
+ * enabled for userspace xattrs in the future.
+ */
 static ssize_t
 larp_store(
 	struct kobject	*kobject,

