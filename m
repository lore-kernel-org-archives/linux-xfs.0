Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6121292D6
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423313; cv=none; b=BxKoWxARarlPYYkmB7vF1MpzDq6J/xKHNtiP/bSQ+24M5ooJaLfbsR9/zzNLraZFd2alYPikd0NkWh+SQpfuG6wFTbzaQfrYS1nZQZCR3CNrHvWWh7D8BIJTDhMFyTdg2SucTqqg0cfzsxmBuMs7fxhlUbDZgwtNeie64CBJC88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423313; c=relaxed/simple;
	bh=e2citnO+J7GOy6sAtpcJAD8C/+7NhA2p4IsjpgPNTU0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TTl1XE1kPog9i5+JIKqYgwM6X5ZIeyQWlVvJOfEPtg1tAjPmqmqeuEoDwCqjWjNFLq+yoOq2/AP3qBDM9HCBQ07bKLSfjQfMVUrL+j6TK9qwZda94yzS+iwhYiEF4Ipf2EpSj6sIb2gseOjiMiFZtBddYWPeBRdcxLKuW5mo7Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OZXExwin; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OZXExwin"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BAC5C43394;
	Tue, 26 Mar 2024 03:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423313;
	bh=e2citnO+J7GOy6sAtpcJAD8C/+7NhA2p4IsjpgPNTU0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OZXExwin5lMRzbV360316My7TzW99IJ3IybeUu58kDyxSpnDfUg+WIyjIJUbPbrQ4
	 SPkyLSz342aqRPwupAQOfwi4p4GLryzyu7O0VqcdMelpFWxygD89xYuF3gx8y1F0/G
	 pZZsgC0a1D6UvdrACpUVfh5aejQh9/8qwAUv70oPbfiWEKWegvRN64bFLSagyRgCfk
	 5E6YsLJSgd4j9i02SGKiyNPxbHb7rRxNs51tJ6NZb09ZUG7D/2u/S/rhpuD98p6z30
	 KNZGz2txo7XOPewSBghA/t1uYYHlqB/7BxV6AZ+uU1QFZlyVHu7cpfUZDjexU0UatP
	 6WOu+29dbh4NQ==
Date: Mon, 25 Mar 2024 20:21:53 -0700
Subject: [PATCH 4/5] xfs_scrub: don't fail while reporting media scan errors
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171142128620.2214086.9691663764474963447.stgit@frogsfrogsfrogs>
In-Reply-To: <171142128559.2214086.13647333402538596.stgit@frogsfrogsfrogs>
References: <171142128559.2214086.13647333402538596.stgit@frogsfrogsfrogs>
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
---
 scrub/phase6.c |   26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index 98d6f08e4727..9ef700d50834 100644
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

