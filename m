Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D533171A1
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713390050; cv=none; b=ERdGuc3dnl1e+8U55LOKiUW/+YFdHXa6oCHFS4AJKeu42BKySuCNtC4KXnajy97znj2ejR0ujbfJdUAD98O6RYglnoyRa5hJzCtmrf2ALwnzAtWHbmVbLzrhwblogEtl1G7LvAVw6ACzj1AT08Gp3W86k724john5BsvbA5+20Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713390050; c=relaxed/simple;
	bh=CeUo0ddAFaE14CdVI6ASY2CA5kUhGQae+h7QbQp8Rmw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X3FP9oM9dg3otIydAmU5AvENk5NWqjcnUtm/GfaGxrqXErDT+6JvAk8H9Oill6y2LdqaoImbvTiuU+gTjGzLJywxCOzSUDKysSkblj0SuC2qnDF8vFbi6V2lNKJV9/C9MXW1cgxigMxuvCix9QukFjByYsYsjsoXjf09fvdLR+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cj8Q1Ijw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cj8Q1Ijw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E6AC072AA;
	Wed, 17 Apr 2024 21:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713390050;
	bh=CeUo0ddAFaE14CdVI6ASY2CA5kUhGQae+h7QbQp8Rmw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cj8Q1IjwWV7Tzhu6j+5q7pgyLE5Y70Uh1eFjmIV84Qs0WN4bmuphml5rHMmq3TfG2
	 6RuL4j7XPvvLBQRG647BPfhRtdUbAdVnOK10sQH2KOIlfefK9mYQovYIDjzLEzhqkm
	 yIEW8pBXiQkNxnVupXxQlHKICrtv7DMoHBJZLJrpFew47ZAG2dg5pm3P4V1xVOycmw
	 l4t0zOm+FfhZrKJ5WH9pNS6OVXslLux4tTuxVNnSw/sT6fISX+hB217sl4r1gcPvZQ
	 Qczap8VeVwtTqCAf29ss8/I2opNJ3z+ibGAHdAs2lSzkoEfmnkfu0z6VN7I+3kOMIW
	 5nrNI2p2OTj/Q==
Date: Wed, 17 Apr 2024 14:40:49 -0700
Subject: [PATCH 4/5] xfs_scrub: don't fail while reporting media scan errors
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171338844038.1855783.13633655559187788087.stgit@frogsfrogsfrogs>
In-Reply-To: <171338843974.1855783.10770063375037351343.stgit@frogsfrogsfrogs>
References: <171338843974.1855783.10770063375037351343.stgit@frogsfrogsfrogs>
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

If we can't open a file to report that it has media errors, just log
that fact and move on.  In this case we want to keep going with phase 6
so we report as many errors as possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/phase6.c |   26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index 393d9eaa8..193d3b4e9 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -21,6 +21,7 @@
 #include "read_verify.h"
 #include "spacemap.h"
 #include "vfs.h"
+#include "common.h"
 
 /*
  * Phase 6: Verify data file integrity.
@@ -291,13 +292,14 @@ report_inode_loss(
 	/* Try to open the inode. */
 	fd = scrub_open_handle(handle);
 	if (fd < 0) {
-		error = errno;
-		if (error == ESTALE)
-			return error;
+		/* Handle is stale, try again. */
+		if (errno == ESTALE)
+			return ESTALE;
 
-		str_info(ctx, descr,
-_("Disappeared during read error reporting."));
-		return error;
+		str_error(ctx, descr,
+ _("Could not open to report read errors: %s."),
+				strerror(errno));
+		return 0;
 	}
 
 	/* Go find the badness. */
@@ -353,10 +355,18 @@ report_dirent_loss(
 	fd = openat(dir_fd, dirent->d_name,
 			O_RDONLY | O_NOATIME | O_NOFOLLOW | O_NOCTTY);
 	if (fd < 0) {
+		char		descr[PATH_MAX + 1];
+
 		if (errno == ENOENT)
 			return 0;
-		str_errno(ctx, path);
-		return errno;
+
+		snprintf(descr, PATH_MAX, "%s/%s", path, dirent->d_name);
+		descr[PATH_MAX] = 0;
+
+		str_error(ctx, descr,
+ _("Could not open to report read errors: %s."),
+				strerror(errno));
+		return 0;
 	}
 
 	/* Go find the badness. */

