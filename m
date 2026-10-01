Received: from buxtehude.debian.org (buxtehude.debian.org [209.87.16.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED165221DE
	for <linux-xfs@vger.kernel.org>; Thu,  1 Oct 2026 14:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790866385; cv=none; b=bSQUsuPe7oy2bz18mOc23kUuxjRiazDj55TlnMc+s4TfX5rD2eXlVKXry7oRcuwmJ4ZikymCSpVxwhcUR109NhX8c+hEX6kMDAeQtYLEk+b6Ylt32DNgdrGWj+1sxa3JTpemw2oEAYWmH7GUaLsvcxxgNJyPWL9Q1LMzRWbf68o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790866385; c=relaxed/simple;
	bh=lTCx5PzSlfXdvhaBiHu+w58WE8yKgLsf331hFxyo7HE=;
	h=Subject:References:Date:From:To:Cc:Message-ID:In-Reply-To:
	 MIME-Version:Content-Type; b=l0jzIC4bYBFEpdzz/lHaMuuE4bZ4QIrYjZgsJtHO8ZihtQBAK8FTrN7ut75r2v4WHDH35H4BMbMQHh/FdcpZrEvDOOdxwAX6ygfnNZb5iKzCDlPAKpIVTpNQWah5YP+o2k/W2TvPGgsdlwpUNoOlLSvQUIehtLQY3MwJCsKZhD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=buxtehude.debian.org; dkim=fail (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G5MaeWu6 reason="signature verification failed"; arc=none smtp.client-ip=209.87.16.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=buxtehude.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G5MaeWu6"
Received: from debbugs by buxtehude.debian.org with local (Exim 4.96)
	(envelope-from <debbugs@buxtehude.debian.org>)
	id 1xCI9f-000Crn-08;
	Thu, 01 Oct 2026 14:53:03 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#1149571: [PATCH 2/2] xfs_healer: fail earlier on non-xfs filesystems
Reply-To: "Darrick J. Wong" <djwong@kernel.org>, 1149571@bugs.debian.org
Resent-From: "Darrick J. Wong" <djwong@kernel.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-CC: linux-xfs@vger.kernel.org
X-Loop: owner@bugs.debian.org
Resent-Date: Thu, 01 Oct 2026 14:53:03 +0000
Resent-Message-ID: <handler.1149571.B1149571.179086626548699@bugs.debian.org>
X-Debian-PR-Message: followup 1149571
X-Debian-PR-Package: xfsprogs
X-Debian-PR-Keywords: 
References: <179086618105.2606256.7314766956448729435.stgit@frogsfrogsfrogs> <179080491253.7201.8697529754428195540.reportbug@mars>
X-Debian-PR-Source: xfsprogs
Received: via spool by 1149571-submit@bugs.debian.org id=B1149571.179086626548699
          (code B ref 1149571); Thu, 01 Oct 2026 14:53:03 +0000
Received: (at 1149571) by bugs.debian.org; 1 Oct 2026 14:51:05 +0000
X-Spam-Level: 
X-Spam-Bayes: score:0.0000 Tokens: new, 19; hammy, 150; neutral, 146; spammy,
	0. spammytokens: hammytokens:0.000-+--Signed-off-by,
	0.000-+--Signedoffby, 0.000-+--libexec, 0.000-+--fprintf,
	0.000-+--exitcode
Received: from tor.source.kernel.org ([2600:3c04:e001:324:0:1991:8:25]:48766)
	by buxtehude.debian.org with utf8esmtps (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <djwong@kernel.org>)
	id 1xCI7k-000CfG-1p
	for 1149571@bugs.debian.org;
	Thu, 01 Oct 2026 14:51:05 +0000
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 4A3A46021D;
	Thu,  1 Oct 2026 14:51:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E69671F000FF;
	Thu,  1 Oct 2026 14:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790866264;
	bh=Um0GLFJpMcu7Xyz7Ia84HrHcpIkW7HQ6sKBacZTYi6s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=G5MaeWu6lOxYtxGAm5trPLKLaNVYVUNjG7IHopHhDDblVcKvYFDlvyXWOPuI+PIRW
	 DfgNEqnmhUpcQb3cy22x5Ha9hnQnumKXmpYP6siB3bAUaeVNtL5SQoUfCBG6U6Y/QK
	 28pBa01evYuCzy6mdfrqc/Ur9yCqvS+lDbKrn5HIbZV4AcxVN0tqlPcW955JJJMqA6
	 PgAu7ltMDz1wp1qx6lkEEuH9lQy9B53cAk1l6P+WgEfhsB/vgqCdAHzIyMX4IsgtFw
	 9XI1LW0QONZQ1Xm33cH8tbWigmQD4HbssVcbh36oi30lrM/cnC4zv+3QUc0ZYrRQSa
	 VyfT1SZtqCP2g==
Date: Thu, 01 Oct 2026 07:51:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: 1149571@bugs.debian.org, biebl@debian.org, linux-xfs@vger.kernel.org,
 hch@infradead.org, linux-xfs@vger.kernel.org
Message-ID: <179086618149.2606256.17998546326648396992.stgit@frogsfrogsfrogs>
In-Reply-To: <179086618105.2606256.7314766956448729435.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261001145103.rg9DHZ6d19YDuudNnMiNhN299mdc6jz2Poui8ZQbDJs@z>

From: Darrick J. Wong <djwong@kernel.org>

A Debian user reported that the root filesystem service fails with:

 systemd[1]: Starting xfs_healer@-.service - Self Healing of XFS Metadata for /...
 xfs_healer@-[976]: /: Inappropriate ioctl for device
 systemd[1]: xfs_healer@-.service: Condition check process exited, code=exited, status=255/EXCEPTION
 systemd[1]: xfs_healer@-.service: Failed with result 'exit-code'.
 systemd[1]: Failed to start xfs_healer@-.service - Self Healing of XFS Metadata for /.

when the root filesystem is not XFS.  It's most likely ext4 given
Debian's defaults.  However, the actual service failure here is a result
of the ExecCondition program exiting with 255 instead of EXIT_FAILURE.
EXIT_FAILURE is what we're supposed to return to mean "do not run
service".

Note that xfs_healer@- is always started by systemd (and not
xfs_healer_start) because the root filesystem is usually mounted before
systemd starts.

stracing this program a litle further reveals this:

 # strace -e ioctl /usr/libexec/xfsprogs/xfs_healer --supported /
 ioctl(3, _IOC(_IOC_READ, 0x58, 0x7e, 0x100), 0x7fffb2c5e6a8) = -1 ENOTTY (Inappropriate ioctl for device)
 ioctl(3, _IOC(_IOC_READ, 0x58, 0x7c, 0x70), 0x7fffb2c5e6a8) = -1 ENOTTY (Inappropriate ioctl for device)
 ioctl(3, _IOC(_IOC_READ, 0x58, 0x64, 0x70), 0x7fffb2c5e6a8) = -1 ENOTTY (Inappropriate ioctl for device)
 /: Inappropriate ioctl for device

All three ioctls are XFS_IOC_FSGEOMETRY calls, and they all fail with
ENOTTY because this is an ext4 filesystem.  The fsgeometry call occurs
under xfd_open(), so fix this error by special-casing the error return
handling.

Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1149571
Reported-by: Michael Biebl <biebl@debian.org>
Cc: <linux-xfs@vger.kernel.org> # v7.0.0
Cc: 1149571@bugs.debian.org
Fixes: bf8b99270c6be1 ("xfs_healer: use the autofsck fsproperty to select mode")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/xfs_healer.c |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff --git a/healer/xfs_healer.c b/healer/xfs_healer.c
index 8fa58b742aea49..0a55e3b5755056 100644
--- a/healer/xfs_healer.c
+++ b/healer/xfs_healer.c
@@ -317,6 +317,16 @@ setup_monitor(
 
 	ret = -xfd_open(&ctx->mnt, ctx->mntpoint, O_RDONLY);
 	if (ret) {
+		if (ret == ENOTTY) {
+			/*
+			 * If the fsgeometry call returns ENOTTY, this isn't
+			 * even an XFS filesystem.
+			 */
+			fprintf(stderr, "%s: %s\n", ctx->mntpoint,
+ _("XFS health monitoring not supported."));
+			return MON_UNSUPPORTED;
+		}
+
 		fprintf(stderr, "%s: %s\n", ctx->mntpoint, strerror(ret));
 		return outcome;
 	}
