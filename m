Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2ECD2F87B
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jun 2026 18:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782324950; cv=none; b=X7ytuUKWV/QNqJ3NAbL3Bb5E8rKwSITXDbbTcfu1oshsYMu1b54VL5WADgC+UHODwJLMojtj8jY0u+OhjMNl6grXVpc6llND1bGcnIiftM3PPP0DX3OVdtS4Ulup83lFa4tptWtnK9yk2evUEPk7UXtIChyAMJCA+j2cV0q8Usc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782324950; c=relaxed/simple;
	bh=5ePdcgl3ZFveAGZpk3kdfSUJYP+kspQ/qWM/a5YBark=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A+4KDi59surtWvg7M0Ay0z6Im/2/McdgNFR2z2r61jv1xg1G/6pyCgEB9Wf3yxxheBrIEwA+OG466IRRv+hzS9RiGeB9WMSOzGeygNvh0ePMGmmJxpmW73o7iiHTMem3emC5YpUXncqckxHc4IJQAP3NQ1CU9P+CBCMymaM1x8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c+QCdt3l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c+QCdt3l"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3A5331F000E9;
	Wed, 24 Jun 2026 18:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782324949;
	bh=luVGY/lufUQz0/emy95Hp+BPmYrGb5QPbmAUYdaDOfw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=c+QCdt3lQ92vvxtfShYF/RE/N9AcX8hQ4kwfz6hvz/2JQtRfz7Hwy5twT2t3UbhCz
	 X3K/cxP6bVYTDB615VfmgCuC6KNMWur6elr2s+PNYlPGp2MrhhLByYxugflXqENqKV
	 n2RtIDZjJWdYp0eiN7KYCFIYmHITNPdHnuZfd6ifSFP99f2ECQ4K7fHtvtB6zns/4/
	 nQ7nLi2KWbYM20ce+651mYUmK6k0lW71yAdgwVZb1RbFWK55c1K4pxNbZQ3BH3bkVK
	 DjrezFV8guKfHnl1PmAvhjGvW5GFm/32S5QEX2vgp0mOKBPuTilFt5bzMOtSyy7mDg
	 0F8gdnT+kdxkA==
Date: Wed, 24 Jun 2026 11:15:48 -0700
Subject: [PATCH 05/11] xfs_scrub: don't skip bulkstat batch when
 scrub_scan_user_files helper returns ESTALE
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <178232484531.915780.36902609750018112.stgit@frogsfrogsfrogs>
In-Reply-To: <178232484383.915780.8675173410074139317.stgit@frogsfrogsfrogs>
References: <178232484383.915780.8675173410074139317.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Codex complains that the ESTALE in the switch statement results in the
rest of the bulkstat batch being skipped, and that ECANCELED doesn't
actually abort the walk immediately.  scrub_scan_user_files is only
called during phases 5 and 6, which is after we've verified all the file
metadata in the filesystem.  Therefore, an ESTALE here means that the
file was deleted, so we skip it and move on to the next file.  Fix both
issues.

Cc: <linux-xfs@vger.kernel.org> # v6.14.0
Fixes: 279b0d0e8d73f1 ("xfs_scrub: call bulkstat directly if we're only scanning user files")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/inodes.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)


diff --git a/scrub/inodes.c b/scrub/inodes.c
index bf1cbdd6c7698b..7ce5f7ffeb62a1 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -360,6 +360,7 @@ bulkstat_for_inumbers(
 enum abort_state {
 	RUNNING = 0,
 	ABORTED,
+	CANCELLED,
 };
 
 static inline int abort_state_ret(enum abort_state s)
@@ -544,8 +545,8 @@ _("Changed too many times during scan; giving up."));
 			goto out;
 		}
 		case ECANCELED:
-			error = 0;
-			fallthrough;
+			si->aborted = CANCELLED;
+			goto out;
 		default:
 			goto err;
 		}
@@ -761,9 +762,22 @@ scan_user_files(
 		case 0:
 			break;
 		case ESTALE:
-		case ECANCELED:
+			/*
+			 * scrub_scan_user_files is only called during phases
+			 * 5 and 6, which is after we've verified all the file
+			 * metadata in the filesystem.  Therefore, an ESTALE
+			 * here means that the file was deleted, so we skip it
+			 * and move on to the next file.
+			 */
 			error = 0;
-			fallthrough;
+			break;
+		case ECANCELED:
+			/*
+			 * Helper function wants us to stop iterating, so stop
+			 * the walk immediately.
+			 */
+			si->aborted = CANCELLED;
+			goto out;
 		default:
 			goto err;
 		}

