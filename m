Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39B7185E
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 00:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713229177; cv=none; b=r1n8aAuV+Poof5wbVPCMHM6tsyZZKTOQ3Ln4NifeS5SQQhiIVeJ4QMHqwnc0E9t0+ZERKYOZpAczn2enuQ/Dan6XGjMChcUOxicM/31WAd5NYYSTaxUu/J8IvTS2CBgnDFJOaohLDtujTrriro59OrTYDGH7i9wY4pt3MVcVIZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713229177; c=relaxed/simple;
	bh=85NoDPvYyJnIPeVrFQUgw+9pl3jNppemlgqRvHJgnNw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kDhSTkTM4f2JjYZLknDivBmKVS1ExGeg9MnV26WF4tRKA573rISgEY2PQHLxgcu9MPkvn5r6laIKFyI8aoZYLufzdFGDg/yV+zS+JqO/gSXCwrafDlIkfWqSv1JOmd4AZA5xSL6W8cuDzrvkNerYcJknkxoQ6pvp0DmgO1guxFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kz6D7+nY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kz6D7+nY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 360ECC113CC;
	Tue, 16 Apr 2024 00:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713229177;
	bh=85NoDPvYyJnIPeVrFQUgw+9pl3jNppemlgqRvHJgnNw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kz6D7+nYfMm6I1zgApR3FDHo1v8BHXVH+jyh66IkbqWPt5zGEqjfRVm5tb2TAc19R
	 XnlsjxcHHOmtlvyP4b/8uHLqko/+6KZ+N/p6A2FQw1mlMJKATbsQbLt4mAARlfVtgB
	 I3lJFGVPiMTG7mC/PqIDIhu75+43XTu+xjJxEt0T/70qJ+O02rwjYJsSVWdTnLz+fU
	 RA2xaGzY0ngi4+DzNmiUItt9jMSTmZzunUZNNZJ32+6PyduHkD9Rmls5xA4LvZKXhd
	 EDTV8mtQjrQEop9Zr4OzY40ugSe0OwllaFnWc9GA7411w2/Zi2uu0Z+FEvWxPRqGMx
	 77X537dNQZM7w==
Date: Mon, 15 Apr 2024 17:59:36 -0700
Subject: [PATCH 4/5] xfs_scrub: don't fail while reporting media scan errors
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, cmaiolino@redhat.com,
 linux-xfs@vger.kernel.org, hch@infradead.org
Message-ID: <171322881860.210882.17298350569545046088.stgit@frogsfrogsfrogs>
In-Reply-To: <171322881805.210882.5445286603045179895.stgit@frogsfrogsfrogs>
References: <171322881805.210882.5445286603045179895.stgit@frogsfrogsfrogs>
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
index 393d9eaa83d8..193d3b4e9083 100644
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

