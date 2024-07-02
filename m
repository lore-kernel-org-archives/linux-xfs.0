Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461459449
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882814; cv=none; b=QJpLwUPvU9IhKMdbeaEOKm2h4yduxZro6NNu7pbvRdZ4U91IK/Wt4wV9HD85ng9AsS44Pi4+CuG3TrizV4ZHxp2mQ97RxDeeDp3hUcwoJQAyRYL14QssJo1MYLhHRJr421OZ81n9H/j8Akddho8/oN+VJDRCh7Yz49TBU++wrWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882814; c=relaxed/simple;
	bh=VPywzmkvVhI8y9iWxPSYdUURV04jNhKfIULxEyLIndo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p/4iflmPqYdP44dx5qpTzezR2+3qFfYmOhOIrN+ZWRuL5G4ybuBE5EHGRFYE1dONQ2kqboGVW9T76gslu3CvU/xfStElBTs5sRQjYLqco/owi+tWdnmxy3mC9r6ersX5t91C2oTzbw2w1/9kxI2bN6iZSsGC/ldzpvhh7TGhS4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uN6sKxBf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uN6sKxBf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129B2C116B1;
	Tue,  2 Jul 2024 01:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882814;
	bh=VPywzmkvVhI8y9iWxPSYdUURV04jNhKfIULxEyLIndo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uN6sKxBfBblbvtUY2VT6+NYD7ogufJ8+0+HL78YNhayenMh9t3yosUf/oJZBmcbp5
	 BwWS6ZIAai2/D9NSpmUMtmY76FJ29PzSVUx3n9P5st3WF2HuBP34qh6XhdUXrtlq2w
	 lJEhVm5tH295UdAbfuiTkaf9mzDj2macqesgaQEMLjHmxccX0fjGRTo2n8q9Edrh76
	 CXmvK8Rkx1WGfyo5xQIG3rOFNR6UT5PnBg94NpBn2kv9S4xN7UTfG0M/QA8BYeEWjv
	 htsLyj+JZr+3kpKdy7lNhghsRL+UkbSlVqbhH+4ORjTTXw3+9UTtqKrk/z/FDnuTDN
	 5RXJSS0s1i1rg==
Date: Mon, 01 Jul 2024 18:13:33 -0700
Subject: [PATCH 11/24] xfs_scrub: use parent pointers when possible to report
 file operations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, hch@lst.de
Message-ID: <171988121232.2009260.944702210373077283.stgit@frogsfrogsfrogs>
In-Reply-To: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs>
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
index aca596487113..f86546556f46 100644
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

