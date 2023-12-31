Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E786BBA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oFtLy2su"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D407C433C7;
	Sun, 31 Dec 2023 21:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058151;
	bh=olALTGXawKdwNBj5JMVpGVnNUJa3+JiZRwWr0xnIDSU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oFtLy2suisjv1Y0rmdWfvm6Wlj9+Q7xooUjwgne2xkO0/GZ0ZouKbN0fF6tgkoonk
	 SDE4jiZXreEQKtGnDSdT7zTkB1kbv3EvhUABK6aLJSR0Rjwr/7ChA0TeCSAvAu//8p
	 0m/4ZiP7D3vuAQl4Rdf2h3lb3jFUejB30B7B6QxKDo+TCcz3eJ+n/It27mD4J1cy6Y
	 aGoqD0+WwHkOoaJvZHc7k68bSD/AaC1crrmouPfT6hNds2htAzL7olhm97jyfVSpr8
	 UBfoP3qEljJlvsvJS2NjbQ+XvgEzGoO65qd9faMN6y1jz0D82fqjHOrncv37y38RI+
	 7TfSYclDrBypw==
Date: Sun, 31 Dec 2023 13:29:10 -0800
Subject: [PATCH 2/2] xfs: support error injection when freeing rt extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404848860.1764600.374216547666381718.stgit@frogsfrogsfrogs>
In-Reply-To: <170404848822.1764600.16492021865539804027.stgit@frogsfrogsfrogs>
References: <170404848822.1764600.16492021865539804027.stgit@frogsfrogsfrogs>
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

A handful of fstests expect to be able to test what happens when extent
free intents fail to actually free the extent.  Now that we're
supporting EFIs for realtime extents, add to xfs_rtfree_extent the same
injection point that exists in the regular extent freeing code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 0ef14157e8157..16471ad8365d4 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -20,6 +20,7 @@
 #include "xfs_health.h"
 #include "xfs_log.h"
 #include "xfs_buf_item.h"
+#include "xfs_errortag.h"
 
 /*
  * Realtime allocator bitmap functions shared with userspace.
@@ -1040,6 +1041,9 @@ xfs_rtfree_extent(
 	ASSERT(mp->m_rbmip->i_itemp != NULL);
 	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
 
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_FREE_EXTENT))
+		return -EIO;
+
 	error = xfs_rtcheck_alloc_range(&args, start, len);
 	if (error)
 		return error;

