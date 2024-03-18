Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832CA535D3
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710797452; cv=none; b=sj/VcR/fL3hcxVAuDwr8XTSTMPpqLnmYChv7G0AiukAyT0MNAkAyrZXcO2qo6Mc1G8SwD/KIzq7QZ4HYA52pMoXiTV0XbGNdiruG5y0foFsobjCsVcLKKEcMpUui/gYPPhslODTOCi+Jem2kKKro5dUhXYLQqUHZZPvlQ7dao8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710797452; c=relaxed/simple;
	bh=AVPWje2OVSQOCQWIT0mn9DDdzc2NB9mxj6I4lg6JKcQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tn/OVugNeQcmGyjK4yyw/kc+Z7I3r3UT+cM2R3UNDg4pla2C/341ueaSewV6isulxBbiUpSdn/l+nOFGMVp1urShSoxtS+90cCEJ6x9JS0VwkU6LQ4WNUqPXnsP777glOaId0ilaw2qY69iIGjKj0P+qsjJqZaG+WKG3rYlEa3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u1CU4SSq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u1CU4SSq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0822DC433C7;
	Mon, 18 Mar 2024 21:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710797452;
	bh=AVPWje2OVSQOCQWIT0mn9DDdzc2NB9mxj6I4lg6JKcQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=u1CU4SSqk5ugygob0zdCrj/ISNQbRgK8o4KY0STcmFekut2Qi8qIFLqTV39TAVreA
	 apILLz7ujA9XzZKyMX2FPI0HJ+C3l2hBM6RKIaNxrb+kAqKddiGrpgYrxDho/+p6yj
	 xcMtiEFq2XMJCjINcflCWogxm9i+Mj3Cjo5nrhV6fCMY9pO/5HWlesQjVwV+yZpjo4
	 UHMA7YwJU57oncuv5gDbmPlrdJuGO7cdz3cMVCokBpNXOU94Qi31OIS5E2/pPv/ksc
	 OKizxic4LsKYZeHMZ6Mhh4nnGqiG5LoTMMMlDqa+K1LEpE5oLN1Ya++2e2oqM39Dwc
	 t86ATe4ihAbfQ==
Date: Mon, 18 Mar 2024 14:30:51 -0700
Subject: [PATCH 3/4] xfs_scrub: don't fail while reporting media scan errors
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171079733018.3790235.7889481812512181335.stgit@frogsfrogsfrogs>
In-Reply-To: <171079732970.3790235.16378128492758082769.stgit@frogsfrogsfrogs>
References: <171079732970.3790235.16378128492758082769.stgit@frogsfrogsfrogs>
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
index 98d6f08e4727..daf2fcee3b5c 100644
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

