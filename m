Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C480514779
	for <linux-xfs@vger.kernel.org>; Thu,  1 Oct 2026 14:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790866267; cv=none; b=N/VpLsK/6Rv1CDY5s0m75xhKGMlwnwT1hXfdmdFQR9Q2zs/qoM1TfP3wmypCOju9JagpDBkhwvc+ZpYsMOXMnSn2mRFOoBGhZuqictW5pxzQ18I0T/LJKU+4IaVdmhFrcv26ibo+nUL0tAMHkPjG2LGW9/d35f5nnOe6afUfqPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790866267; c=relaxed/simple;
	bh=lTCx5PzSlfXdvhaBiHu+w58WE8yKgLsf331hFxyo7HE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lprwljpB+hbAOjfUsQXeU8HkhGfW5wLRzV66xn/On/GEwKCsgNIJbUK5vPcifY3NV0VJSjyHbA6Gk6XPNQL4ynJWXcSZFiMbxkFYgqmCd4Et/u+M7IvWOhpmV2Dato80ccTpmyIeP0eNK62uu8RIkVkgP+OdukzAOWNw/HVy/6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G5MaeWu6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G5MaeWu6"
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
Subject: [PATCH 2/2] xfs_healer: fail earlier on non-xfs filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: 1149571@bugs.debian.org, biebl@debian.org, linux-xfs@vger.kernel.org,
 hch@infradead.org, linux-xfs@vger.kernel.org
Message-ID: <179086618149.2606256.17998546326648396992.stgit@frogsfrogsfrogs>
In-Reply-To: <179086618105.2606256.7314766956448729435.stgit@frogsfrogsfrogs>
References: <179086618105.2606256.7314766956448729435.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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

