Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A6BCA78
	for <linux-xfs@vger.kernel.org>; Tue,  5 Dec 2023 05:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XgmVfcBY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E485C433C8;
	Tue,  5 Dec 2023 05:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701754568;
	bh=P3O9oWQt14fBbgSQlpZuIpXr7oS948w+/ItnHlQMah4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=XgmVfcBYL2yGZUY9NWO4X1W/WTcMmTTpoRR/x4CX9iGm9JNf93LyJ4OX/Or4oRrlm
	 t4ZYEAKHfUxUrucD80nYg7pH23W9uRYUx0/e8DgSIp4nQYfDchQqVLz91t5vxFu+B2
	 xsKqVDomzZVGjVjlO0ZbBk0F6v6bc78J18vCSB08eiSxoJo+mYc9PFr/gmE5Q/G88A
	 nMkQrrdxXUFPNjlTejiNHCkV//Jn6dXjVZJtkQHyCMhTNzckIHfWnb00X0qyNYruOK
	 R6lWjmpWIzLEM+hHnCC8mvHk31vdr6nRiPlNKhU6qL4SsNRhk0eZzRy8Uq+R1CwUTl
	 DuMqU2s5J5QIA==
Subject: [PATCH 1/2] xfs: document what LARP means
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, chandanbabu@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Date: Mon, 04 Dec 2023 21:36:07 -0800
Message-ID: <170175456779.3910588.8343836136719400292.stgit@frogsfrogsfrogs>
In-Reply-To: <170175456196.3910588.9712198406317844529.stgit@frogsfrogsfrogs>
References: <170175456196.3910588.9712198406317844529.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/xfs_sysfs.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index a3c6b1548723..59869a1ee49f 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -229,6 +229,13 @@ pwork_threads_show(
 }
 XFS_SYSFS_ATTR_RW(pwork_threads);
 
+/*
+ * The "LARP" (Logged extended Attribute Recovery Persistence) debugging knob
+ * sets the XFS_DA_OP_LOGGED flag on all xfs_attr_set operations performed on
+ * V5 filesystems.  As a result, the intermediate progress of all setxattr and
+ * removexattr operations are tracked via the log and can be restarted during
+ * recovery.
+ */
 static ssize_t
 larp_store(
 	struct kobject	*kobject,

