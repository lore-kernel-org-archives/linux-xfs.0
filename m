Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B721C2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ga65hIQu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFFA9C433C8;
	Sun, 31 Dec 2023 23:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064250;
	bh=ONKqpcv+oQlR7yVDHoU17xVpTj9B0y3wwUvTkGaSEx0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ga65hIQuXJGhJvvpue31/dP362+WQ2k0lvBmX0AQvXDRlOiSddShDaRxulAiJ73ij
	 VvcwHVOPgYbpo4yBayO+D1wQQSAV8ovMZ8tKzJHEvlwoMAi5W9bq//eBh6jpTH/Pe2
	 of8g5wRdh3zLm77MBxMSuZlPnSUIPw3IHAHtqaLjFd7rpPUB+0oC766TRkSHKMmswy
	 YAGf5Putbelbh21nKtlMECb0AiWfMXJVHKc7y4VvNlju3X3sEy4oxYrJYYUDs+AC52
	 E/bZTAyOeroBkcOJTpRApGM+5dZz4HcoCnd0+A2weXvgljE7f/TB+ENX9IKoQv+cl7
	 hdJJlAx2Y17Qg==
Date: Sun, 31 Dec 2023 15:10:50 -0800
Subject: [PATCH 22/32] xfs_scrub: use parent pointers when possible to report
 file operations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405006394.1804688.6501111294241060516.stgit@frogsfrogsfrogs>
In-Reply-To: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
References: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
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

If parent pointers are available, use them to supply file paths when
doing things to files, instead of merely printing the inode number.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/common.c |   41 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)


diff --git a/scrub/common.c b/scrub/common.c
index aca59648711..248a33ef324 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -9,6 +9,7 @@
 #include <syslog.h>
 #include "platform_defs.h"
 #include "libfrog/paths.h"
+#include "libfrog/getparents.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "progress.h"
@@ -405,19 +406,55 @@ scrub_render_ino_descr(
 	...)
 {
 	va_list			args;
+	size_t			pathlen = 0;
 	uint32_t		agno;
 	uint32_t		agino;
 	int			ret;
 
+	if (ctx->mnt.fsgeom.flags & XFS_FSOP_GEOM_FLAGS_PARENT) {
+		struct xfs_handle handle;
+
+		memcpy(&handle.ha_fsid, ctx->fshandle, sizeof(handle.ha_fsid));
+		handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
+				sizeof(handle.ha_fid.fid_len);
+		handle.ha_fid.fid_pad = 0;
+		handle.ha_fid.fid_ino = ino;
+		handle.ha_fid.fid_gen = gen;
+
+		ret = handle_to_path(&handle, sizeof(struct xfs_handle), buf,
+				buflen);
+		if (ret)
+			goto report_inum;
+
+		/*
+		 * Leave at least 16 bytes for the description of what went
+		 * wrong.  If we can't do that, we'll use the inode number.
+		 */
+		pathlen = strlen(buf);
+		if (pathlen >= buflen - 16)
+			goto report_inum;
+
+		if (format) {
+			buf[pathlen] = ' ';
+			buf[pathlen + 1] = 0;
+			pathlen++;
+		}
+
+		goto report_format;
+	}
+
+report_inum:
 	agno = cvt_ino_to_agno(&ctx->mnt, ino);
 	agino = cvt_ino_to_agino(&ctx->mnt, ino);
 	ret = snprintf(buf, buflen, _("inode %"PRIu64" (%"PRIu32"/%"PRIu32")%s"),
 			ino, agno, agino, format ? " " : "");
 	if (ret < 0 || ret >= buflen || format == NULL)
 		return ret;
+	pathlen = ret;
 
+report_format:
 	va_start(args, format);
-	ret += vsnprintf(buf + ret, buflen - ret, format, args);
+	pathlen += vsnprintf(buf + pathlen, buflen - pathlen, format, args);
 	va_end(args);
-	return ret;
+	return pathlen;
 }

