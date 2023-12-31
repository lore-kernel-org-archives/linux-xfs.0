Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE07C13B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VqkMWEEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B12BC433C8;
	Sun, 31 Dec 2023 22:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063031;
	bh=kNOJPAybs4rduIY4cRV6niX6HFC1S42BbrEyJTtlhZo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VqkMWEEcxqsUQ29Pbpi79RcCl/ACkR5WG7SgjWGmIeIjFOurbtIWeOAg1R8NuRifi
	 Xfujm0FG++u+yIKMm4cYSGqFCuQYSLyRQ8uIjcGsvtp+1czZbn+Fj0+KILZTNI+YOx
	 eKUynYfGVr8W0oHHrPCVJvWligda7HuLEOUjX1/x4eZ1F+uhGRJis+L+hTY3VtQZ35
	 j8dDTzi0NJlC82fuzG3zciD/gJ0TSGb42zO7PbDNtYI3sBxfMx03xpTyZCp+5ONLx7
	 L8cHWtDxGLzIZ+yAltY96H0eiPl+e/ffxETDLXJX8X0Lv66xRP+5tFPmpIJW/nh2iY
	 WJUCphyNLrxpw==
Date: Sun, 31 Dec 2023 14:50:30 -0800
Subject: [PATCH 8/8] xfs_scrub: improve progress meter for phase 8 fstrimming
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405001155.1798752.5966040935670328891.stgit@frogsfrogsfrogs>
In-Reply-To: <170405001045.1798752.4380751003208751209.stgit@frogsfrogsfrogs>
References: <170405001045.1798752.4380751003208751209.stgit@frogsfrogsfrogs>
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

Currently, progress reporting in phase 8 is awful, because we stall at
0% until jumping to 100%.  Since we're now performing sub-AG fstrim
calls to limit the latency impacts to the rest of the system, we might
as well limit the FSTRIM scan size so that we can report status updates
to the user more regularly.  Doing so also facilitates CPU usage control
during phase 8.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase8.c |   59 ++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 40 insertions(+), 19 deletions(-)


diff --git a/scrub/phase8.c b/scrub/phase8.c
index 570083be9d8..f1a854a3e56 100644
--- a/scrub/phase8.c
+++ b/scrub/phase8.c
@@ -45,6 +45,13 @@ fstrim_ok(
 	return true;
 }
 
+/*
+ * Limit the amount of fstrim scanning that we let the kernel do in a single
+ * call so that we can implement decent progress reporting and CPU resource
+ * control.  Pick a prime number of gigabytes for interest.
+ */
+#define FSTRIM_MAX_BYTES	(11ULL << 30)
+
 /* Trim a certain range of the filesystem. */
 static int
 fstrim_fsblocks(
@@ -56,18 +63,31 @@ fstrim_fsblocks(
 	uint64_t		len = cvt_off_fsb_to_b(&ctx->mnt, fsbcount);
 	int			error;
 
-	error = fstrim(ctx, start, len);
-	if (error == EOPNOTSUPP)
-		return 0;
-	if (error) {
-		char		descr[DESCR_BUFSZ];
-
-		snprintf(descr, sizeof(descr) - 1,
-				_("fstrim start 0x%llx len 0x%llx"),
-				(unsigned long long)start,
-				(unsigned long long)len);
-		str_liberror(ctx, error, descr);
-		return error;
+	while (len > 0) {
+		uint64_t	run;
+
+		run = min(len, FSTRIM_MAX_BYTES);
+
+		error = fstrim(ctx, start, run);
+		if (error == EOPNOTSUPP) {
+			/* Pretend we finished all the work. */
+			progress_add(len);
+			return 0;
+		}
+		if (error) {
+			char		descr[DESCR_BUFSZ];
+
+			snprintf(descr, sizeof(descr) - 1,
+					_("fstrim start 0x%llx run 0x%llx"),
+					(unsigned long long)start,
+					(unsigned long long)run);
+			str_liberror(ctx, error, descr);
+			return error;
+		}
+
+		progress_add(run);
+		len -= run;
+		start += run;
 	}
 
 	return 0;
@@ -90,13 +110,13 @@ fstrim_datadev(
 		 * partial-AG discard implementation, which cycles the AGF lock
 		 * to prevent foreground threads from stalling.
 		 */
+		progress_add(geo->blocksize);
 		fsbcount = min(geo->datablocks - fsbno + 1, geo->agblocks);
 		error = fstrim_fsblocks(ctx, fsbno + 1, fsbcount);
 		if (error)
 			return error;
 	}
 
-	progress_add(1);
 	return 0;
 }
 
@@ -119,12 +139,13 @@ phase8_estimate(
 	unsigned int		*nr_threads,
 	int			*rshift)
 {
-	*items = 0;
-
-	if (fstrim_ok(ctx))
-		*items = 1;
-
+	if (fstrim_ok(ctx)) {
+		*items = cvt_off_fsb_to_b(&ctx->mnt,
+				ctx->mnt.fsgeom.datablocks);
+	} else {
+		*items = 0;
+	}
 	*nr_threads = 1;
-	*rshift = 0;
+	*rshift = 30; /* GiB */
 	return 0;
 }

