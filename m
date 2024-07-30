Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441E28BE8
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302504; cv=none; b=VZ82m9BWoi2AVrlURV+d+VaWHYLYapiP2Hj2wdpbTu8g47VgdXEbb8rMryA3W/QLuN5bN4vLwabqHvg5ThefJ4/AfydFjOcegh1dUCNA3vit/tIl+9vgU767+Q94IR/GtgYdSUPuLpZ5C15orZKPQdAiM/0In52Z322F+JIa33g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302504; c=relaxed/simple;
	bh=zZgChOukMqZnZuh3mKUksFxqNAthMJDcAgi37gBFgfQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=frgbTQE7DVoM+Hk50Gq/3KB5dDpAiyrdSN6G+nb3onrwUJT56SmCLjbmLUxgo0wT/3mMLQgu/5iOCRwG29az0EJPRR95vD3083A5m/qfSA/RkzFpSgnaRFZkQ7x2d0SacRZBqrK3LPBKXYqe0GzZmyOo2R808qZlMdp378BX94Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D4+y18Fm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D4+y18Fm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3CAFC32786;
	Tue, 30 Jul 2024 01:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302503;
	bh=zZgChOukMqZnZuh3mKUksFxqNAthMJDcAgi37gBFgfQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=D4+y18FmMjObRzyucLoxGqk7oZSsQyz/6LoETopUOAcPwwwcPpSo41FK7VG2468XR
	 QCSrvHINJN6mI9nzIq1ZZbUhbku2k2L/Me+olTa/eVdWIjQbOcgdD1JByP8BEAzimj
	 QermNPxseX2MKPci9m3jWwhVJ8NvkzUByrzdFZUqDpMeSCQgxYVPfmv6oVDalO5OyI
	 itorVceKWyJrUxdB2M5bYFEFwfZvCi85ERY+yvb9nQ6pH0i+93sAN2WMS8GTJOBL45
	 Kzd82AJsr7XP/gfaXJ6RyO+sKKnBV9hpGqCaUzPXbmqCVQgRd+nuKwdQinjoFRs/EN
	 e3Q5CfT/0RLlw==
Date: Mon, 29 Jul 2024 18:21:43 -0700
Subject: [PATCH 11/24] xfs_scrub: use parent pointers when possible to report
 file operations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
 catherine.hoang@oracle.com, allison.henderson@oracle.com
Message-ID: <172229850664.1350924.16122463502034650359.stgit@frogsfrogsfrogs>
In-Reply-To: <172229850491.1350924.499207407445096350.stgit@frogsfrogsfrogs>
References: <172229850491.1350924.499207407445096350.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/common.c |   41 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)


diff --git a/scrub/common.c b/scrub/common.c
index aca596487..f86546556 100644
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
+		ret = handle_to_path(&handle, sizeof(struct xfs_handle), 4096,
+				buf, buflen);
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

