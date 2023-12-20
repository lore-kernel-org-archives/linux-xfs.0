Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24FD247A45
	for <linux-xfs@vger.kernel.org>; Wed, 20 Dec 2023 17:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pAWCvTzL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E930C433C7;
	Wed, 20 Dec 2023 17:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703092442;
	bh=RmLNErv4jcB6L6bZqUF3NZIt+8DWdERjOrgk5Kn2mCQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pAWCvTzL5oCGKB4YsbS1CL+h3zWdCC0KPAzG4u1j+nSdoAdBgHL3vMlBzFKTVdOTg
	 i3wIVWR5tYIOJCMuAhdJHQlGAhfErMEQmqFbUEtP6vRkXOz3RunQoPROc9qo0MZjjo
	 adlZpzuH6blRl9IQf2qeV4y2j+R49KFLGA8k25Ek0FOKixbNmEXtPFT6d2DfSwK41/
	 b6TqotmyjNIR8GLOyJYdOQQujArk8iLKFKMSN6XuByWCawlEFJ8/RxLbDGoP+0qJHU
	 +zHIVgglPDGuEvyfdd18YNlrqMJKyuUGcsq1+o9Wm+HaiIExoF+mwtMzmBVvs1XeW4
	 ZhT/hsmUTPIRg==
Date: Wed, 20 Dec 2023 09:14:02 -0800
Subject: [PATCH 5/6] xfs_mdrestore: fix missed progress reporting
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <170309218782.1607943.11655026394109868162.stgit@frogsfrogsfrogs>
In-Reply-To: <170309218716.1607943.7868749567386210342.stgit@frogsfrogsfrogs>
References: <170309218716.1607943.7868749567386210342.stgit@frogsfrogsfrogs>
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

Currently, the progress reporting only triggers when the number of bytes
read is exactly a multiple of a megabyte.  This isn't always guaranteed,
since AG headers can be 512 bytes in size.  Fix the algorithm by
recording the number of megabytes we've reported as being read, and emit
a new report any time the bytes_read count, once converted to megabytes,
doesn't match.

Fix the v2 code to emit one final status message in case the last
extent restored is more than a megabyte.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chandan Babu R <chandanbabu@kernel.org>
---
 mdrestore/xfs_mdrestore.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)


diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 1d65765d..685ca4c1 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -7,6 +7,7 @@
 #include "libxfs.h"
 #include "xfs_metadump.h"
 #include <libfrog/platform.h>
+#include "libfrog/div64.h"
 
 union mdrestore_headers {
 	__be32				magic;
@@ -160,6 +161,7 @@ restore_v1(
 	int			mb_count;
 	xfs_sb_t		sb;
 	int64_t			bytes_read;
+	int64_t			mb_read = 0;
 
 	block_size = 1 << h->v1.mb_blocklog;
 	max_indices = (block_size - sizeof(xfs_metablock_t)) / sizeof(__be64);
@@ -208,9 +210,14 @@ restore_v1(
 	bytes_read = 0;
 
 	for (;;) {
-		if (mdrestore.show_progress &&
-		    (bytes_read & ((1 << 20) - 1)) == 0)
-			print_progress("%lld MB read", bytes_read >> 20);
+		if (mdrestore.show_progress) {
+			int64_t		mb_now = bytes_read >> 20;
+
+			if (mb_now != mb_read) {
+				print_progress("%lld MB read", mb_now);
+				mb_read = mb_now;
+			}
+		}
 
 		for (cur_index = 0; cur_index < mb_count; cur_index++) {
 			if (pwrite(ddev_fd, &block_buffer[cur_index <<
@@ -240,6 +247,9 @@ restore_v1(
 		bytes_read += block_size + (mb_count << h->v1.mb_blocklog);
 	}
 
+	if (mdrestore.show_progress && bytes_read > (mb_read << 20))
+		print_progress("%lld MB read", howmany_64(bytes_read, 1U << 20));
+
 	if (mdrestore.progress_since_warning)
 		putchar('\n');
 
@@ -343,6 +353,7 @@ restore_v2(
 	struct xfs_sb		sb;
 	struct xfs_meta_extent	xme;
 	char			*block_buffer;
+	int64_t			mb_read = 0;
 	int64_t			bytes_read;
 	uint64_t		offset;
 	int			len;
@@ -419,16 +430,18 @@ restore_v2(
 		bytes_read += len;
 
 		if (mdrestore.show_progress) {
-			static int64_t mb_read;
-			int64_t mb_now = bytes_read >> 20;
+			int64_t	mb_now = bytes_read >> 20;
 
 			if (mb_now != mb_read) {
-				print_progress("%lld MB read", mb_now);
+				print_progress("%lld mb read", mb_now);
 				mb_read = mb_now;
 			}
 		}
 	} while (1);
 
+	if (mdrestore.show_progress && bytes_read > (mb_read << 20))
+		print_progress("%lld mb read", howmany_64(bytes_read, 1U << 20));
+
 	if (mdrestore.progress_since_warning)
 		putchar('\n');
 

