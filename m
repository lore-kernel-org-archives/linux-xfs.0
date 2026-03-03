Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21764374E7C
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498093; cv=none; b=abBxXVz5QKMm9kdeq6vE7v9Hd6ZasCWCFALimfMU7F8D+eTHlnsF8LPt28oly8t+7ElyLPFdEs3vq6yHLoBJP0pNPd8s2AxRQZ2E+N0UZXa3T4GKY8EcSR+5E8lacJsIOIUKmrpn/43e40M5WaQypvCDVxyhpYH/UO9karAYtLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498093; c=relaxed/simple;
	bh=cy3+aZz8VmwlSziuq1OV2SW6uOncKuITctguXMlY7tM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JtkESoJKhvltv63Vo9Rm24P8gD/NCJiZcYt2kIJhXrhrw1VHMsq6tETdT4p3zLJBzLbFtyV/wa617y1/OOqiXru6pvEHzl31LnR8c0IbuY8XaHmKlLg3tvSkdT65ObaQRzETDY0oAwd58Gkg+KxDBYRiS269ATiYUIjiWHJZc+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vyx025Y3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vyx025Y3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5112C19423;
	Tue,  3 Mar 2026 00:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498092;
	bh=cy3+aZz8VmwlSziuq1OV2SW6uOncKuITctguXMlY7tM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Vyx025Y3Y6Bnf0BREmqgm6jScEKhP6EKrvKyQRtdmX/BBB8mgOx7Vl7TLK8ro66Or
	 YCidjQEiZc3IhjrETTxaaRE+D12ymgqiGLp/shNrv7nJHkwLEbfQ0dZsf4RYDZhwOY
	 hfBMI+rjmvQAwZM+NmmLcyA5D6cb+9xXe4RQyjMApabVuAsTt0gUKChT97IV6JSCLl
	 C/Au/7aOuVj7jvyR6ky5y5ROzgHe5EUe12sX/d7Ewl92pbMDiEtaCST1Bll+Psq8jq
	 +uWwJV3utIFDTw9qRRrSPrTvuOPVEjSlQGPWbV3aAEUxTnwZVv4rejVuq9Z7ZWwAsD
	 vf+EdIylJvfXA==
Date: Mon, 02 Mar 2026 16:34:52 -0800
Subject: [PATCH 04/26] libfrog: hoist a couple of service helper functions
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177249783366.482027.6931104577818307338.stgit@frogsfrogsfrogs>
In-Reply-To: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Hoist a couple of service/daemon-related helper functions to libfrog so
that we can share the code between xfs_scrub and xfs_healer.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libfrog/systemd.h |   28 ++++++++++++++++++++++++++++
 scrub/xfs_scrub.c |   32 +++++++++-----------------------
 2 files changed, 37 insertions(+), 23 deletions(-)


diff --git a/libfrog/systemd.h b/libfrog/systemd.h
index 4f414bc3c1e9c3..c96df4afa39aa6 100644
--- a/libfrog/systemd.h
+++ b/libfrog/systemd.h
@@ -17,4 +17,32 @@ enum systemd_unit_manage {
 
 int systemd_manage_unit(enum systemd_unit_manage how, const char *unitname);
 
+static inline bool systemd_is_service(void)
+{
+	return getenv("SERVICE_MODE") != NULL;
+}
+
+/* Special processing for a service/daemon program that is exiting. */
+static inline int
+systemd_service_exit(int ret)
+{
+	/*
+	 * We have to sleep 2 seconds here because journald uses the pid to
+	 * connect our log messages to the systemd service.  This is critical
+	 * for capturing all the log messages if the service fails, because
+	 * failure analysis tools use the service name to gather log messages
+	 * for reporting.
+	 */
+	sleep(2);
+
+	/*
+	 * If we're being run as a service, the return code must fit the LSB
+	 * init script action error guidelines, which is to say that we
+	 * compress all errors to 1 ("generic or unspecified error", LSB 5.0
+	 * section 22.2) and hope the admin will scan the log for what actually
+	 * happened.
+	 */
+	return ret != 0 ? EXIT_FAILURE : EXIT_SUCCESS;
+}
+
 #endif /* __LIBFROG_SYSTEMD_H__ */
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 3dba972a7e8d2a..79937aa8cce4c4 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -19,6 +19,7 @@
 #include "unicrash.h"
 #include "progress.h"
 #include "libfrog/histogram.h"
+#include "libfrog/systemd.h"
 
 /*
  * XFS Online Metadata Scrub (and Repair)
@@ -866,8 +867,7 @@ main(
 	if (stdout_isatty && !progress_fp)
 		progress_fp = fdopen(1, "w+");
 
-	if (getenv("SERVICE_MODE"))
-		is_service = true;
+	is_service = systemd_is_service();
 
 	/* Initialize overall phase stats. */
 	error = phase_start(&all_pi, 0, NULL);
@@ -960,29 +960,15 @@ main(
 	hist_free(&ctx.datadev_hist);
 	hist_free(&ctx.rtdev_hist);
 
-	/*
-	 * If we're being run as a service, the return code must fit the LSB
-	 * init script action error guidelines, which is to say that we
-	 * compress all errors to 1 ("generic or unspecified error", LSB 5.0
-	 * section 22.2) and hope the admin will scan the log for what
-	 * actually happened.
-	 *
-	 * We have to sleep 2 seconds here because journald uses the pid to
-	 * connect our log messages to the systemd service.  This is critical
-	 * for capturing all the log messages if the scrub fails, because the
-	 * fail service uses the service name to gather log messages for the
-	 * error report.
-	 *
-	 * Note: We don't count a lack of kernel support as a service failure
-	 * because we haven't determined that there's anything wrong with the
-	 * filesystem.
-	 */
 	if (is_service) {
-		sleep(2);
+		/*
+		 * Note: We don't count a lack of kernel support as a service
+		 * failure because we haven't determined that there's anything
+		 * wrong with the filesystem.
+		 */
 		if (!ctx.scrub_setup_succeeded)
-			return 0;
-		if (ret != SCRUB_RET_SUCCESS)
-			return 1;
+			ret = 0;
+		return systemd_service_exit(ret);
 	}
 
 	return ret;

