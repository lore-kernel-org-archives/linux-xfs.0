Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DBBEEB3;
	Tue, 25 Aug 2026 05:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787636096; cv=none; b=tO0Brj5VZAv6My9/lDnvUvSwJAGNXMoMS2PFMr7kwZGgLzZcISyzEmYkrkTZHg7YgypQRCc17S2eglNBYOPl4x0M+tv0aOZEme09+oEI3apdhOXE9x0jJ3wxXw0exaDRTH9qDJD6b8CxULRAnV6e3QRvfV6pxyBux/RSgvBTM4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787636096; c=relaxed/simple;
	bh=EEFlCo3jag+4vHC1mDNruUnH8S7sV4FVbzfKUx2QPNo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wv8d1cZtb8cCbwBBnHcY7zPIjIoeBRgObTMfal5l4a3FNP+0DRKBCGnEGc288rSx219IHRqZS8mIB6ueyTCdauwlIhlDwFaXB4b9fWJN6gPN7rdKHE2Y4EbavOGdHm2C700yTIM9A1ANmuc3OdudambFPdssFg6CqP29CwcHUqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=etDZU6dP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="etDZU6dP"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 421001F000E9;
	Tue, 25 Aug 2026 05:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787636095;
	bh=0SyenpsgTx3tiZv4QInbY1b8VPglhqpE7KqYPMN3nvE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=etDZU6dPEFG1X3Hb+8o64XRjVAFDcrF7hTNbGFAkvJU1TBqnRbsupivHhGtEIvuFU
	 82NCcAtMrF5YdLMd7lUUIRho9K0blg8Zp4t203+iPiE0zg7EtcGQtTgjuZu35tL43Y
	 KlGvmzI/LWNM8Vjz47JaRb4S4rcECA31noMDLmTjux4M5HtCX5BGrodpgGnhpjPG7u
	 HxOP8HvUvUuBaJAFVQOJ83jzhN9RfpM6c4tne3nybUiB6Cb0bwGzDf9ASl2Ov2H3lz
	 cemH4hytt1AbAykN+xXsspxsCZjQe419M18t5ELPQR0yfU3uLHiBkOp6KwyS7Bqzb/
	 ljiuxL5oRGmtg==
Date: Mon, 24 Aug 2026 22:34:54 -0700
Subject: [PATCH 2/6] xfs: don't stash removename operations with unknown ftype
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178760940721.944084.7350116310283813250.stgit@frogsfrogsfrogs>
In-Reply-To: <178760940641.944084.17475223769703836830.stgit@frogsfrogsfrogs>
References: <178760940641.944084.17475223769703836830.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM notices that the behavior of xrep_dir_replay_update changes based
on the ftype recorded in the stashed removename information.  It also
notices that the unlink iops sometimes set that ftype to FT_UNKNOWN
because the regular directory tree update code paths don't need to know
the ftype of the child.

Unfortunately, this results in incorrect link counts, which eventually
trips link count errors in later phases of xfs_scrub, or in xfs_repair.
Fix this.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 8559b21a64d983 ("xfs: implement live updates for directory repairs")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/dir_repair.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 0c1224d05d579a..31a23c5f386ae6 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -1381,9 +1381,24 @@ xrep_dir_live_update(
 		if (p->delta > 0)
 			error = xrep_dir_stash_createname(rd, p->name,
 					I_INO(p->ip));
-		else
-			error = xrep_dir_stash_removename(rd, p->name,
+		else {
+			/*
+			 * xfs_dentry_to_name in unlink or rename-exchange can
+			 * pass us names with ftype FT_UNKNOWN, but we really
+			 * must know the ftype of the child that is being
+			 * removed so that we can do nlink updates correctly
+			 * without holding inode references.
+			 */
+			struct xfs_name	name = {
+				.name	= p->name->name,
+				.len	= p->name->len,
+				.type	= xfs_mode_to_ftype(
+						VFS_IC(p->ip)->i_mode),
+			};
+
+			error = xrep_dir_stash_removename(rd, &name,
 					I_INO(p->ip));
+		}
 		mutex_unlock(&rd->pscan.lock);
 		if (error)
 			goto out_abort;

