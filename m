Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DC8184
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178310; cv=none; b=CTrNqUgu8ylZUMgVKzDdohJ7QJ159goGn/elERisawaN8D/XfQ08aXCeI/Ce/447PRApFA3ZwRmEihnNB//FlfjUXAXQ3lki3uRtbRM8xEF1uwq5Lq/+WQT5yFOfkZX4DB2JX9GrIcNH7ubwPK/fzPVlJMyc91Wgh7muw4BNM34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178310; c=relaxed/simple;
	bh=xiGwfvxSo3VcGKDM3/Dbyb6kjaOfix7xDi4qHxcnoow=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e0t5/FbzV2po4lm7rweFh0Z9emDtPTsIxSmQSM1cmfXFO5obp4yGlt2z/IRHp8XGwOmYDWVh30ZZ6CPWqOW4yqHtqmqor3L6EYHOLVUUplpjulzhoLdymjrTd9VZHq6sSdB1tjs8j763dKl6a+8E7FAbAFcLZknRoHhYJTRQEtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lXPtF3tO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lXPtF3tO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898F2C4CEE7;
	Thu, 23 Oct 2025 00:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178309;
	bh=xiGwfvxSo3VcGKDM3/Dbyb6kjaOfix7xDi4qHxcnoow=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lXPtF3tO1WhHOQhj9SA2nIQPV08DoHi529hK1hQMmrUpJvEMZJG1GxpZ6Z/MunMnD
	 fvKcgTKpgJ/BOKwHKjTumZhIHa+FWzR1CE8PNfSWMp6+wI4njJG+dnW1e1+sQ2O+Uf
	 V1mVe9S5Kfn3KvMLBJCJJd8/vWqb38M1pAMHzJxGogDD3HtyGz24dbqvXxGeRDXpnm
	 RMeY5tfxSYnAlF4zZai6Kk47UiD5bkOna18jyOUCVZFaWlPREJhI1R+SV5VIEPM9//
	 67T9AQgLU9ea1bDLjmwC3WrnbtBBPMCn9mXoBzi4BOGv6SSwlSiWHlr1ISNs2b2jNT
	 FyhrF9k+PMq8w==
Date: Wed, 22 Oct 2025 17:11:49 -0700
Subject: [PATCH 24/26] xfs_healer: add a manual page
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117747917.1028044.800528970855815479.stgit@frogsfrogsfrogs>
In-Reply-To: <176117747330.1028044.14577065342150898892.stgit@frogsfrogsfrogs>
References: <176117747330.1028044.14577065342150898892.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add a new section 8 manpage for this service daemon so others can read
about what this program is supposed to do.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 man/man8/xfs_healer.8 |   85 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)
 create mode 100644 man/man8/xfs_healer.8


diff --git a/man/man8/xfs_healer.8 b/man/man8/xfs_healer.8
new file mode 100644
index 00000000000000..0e6d8e7cd0e658
--- /dev/null
+++ b/man/man8/xfs_healer.8
@@ -0,0 +1,85 @@
+.TH xfs_healer 8
+.SH NAME
+xfs_healer \- automatically heal damage to XFS filesystem metadata
+.SH SYNOPSIS
+.B xfs_healer
+[
+.B OPTIONS
+]
+.I mount-point
+.br
+.B xfs_healer \-V
+.SH DESCRIPTION
+.B xfs_healer
+is a daemon that tries to automatically repair damaged XFS filesystem metadata.
+.PP
+.B WARNING!
+This program is
+.BR EXPERIMENTAL ","
+which means that its behavior and interface
+could change at any time!
+.PP
+.B xfs_healer
+asks the kernel to report all observations of corrupt metadata, media errors,
+filesystem shutdowns, and file I/O errors.
+The program can respond to runtime metadata corruption errors by initiating
+targeted repairs of the suspect metadata or a full online fsck of the
+filesystem.
+
+Normally this program runs as a systemd service.
+The service is activated through udev whenever a filesystem is mounted.
+Only systemd is supported.
+
+The kernel may not support repairing or optimizing the filesystem.
+If this is the case, the filesystem must be unmounted and
+.BR xfs_repair (8)
+run on the filesystem to fix the problems.
+.SH OPTIONS
+.TP
+.B \-\-autofsck
+Use the
+.I autofsck
+filesystem property to decide whether or not to repair corrupt metadata.
+See the
+.B \-\-repair
+option for more details.
+If this option is specified but the kernel does not support repairs, the
+program will report but not act upon corruptions.
+.TP
+.B \-\-check
+Check if the filesystem supports sending health events.
+Exits with 0 if it does, and non-zero if not.
+.TP
+.BI \-\-everything
+Ask the kernel to send us good metadata health events, not only events related
+to metadata corruption, media errors, shutdowns, and I/O errors.
+.TP
+.B \-\-log
+Print every event to standard output.
+.TP
+.B \-\-repair
+Always try to repair each piece of corrupt metadata when the kernel tells us
+about it.
+If an individual repair fails or the kernel tells us that health events were
+lost, the
+.I xfs_scrub
+service for this mount point will be launched.
+The default is not to try to repair anything.
+If this option is specified but the kernel does not support repairs, the
+program will exit.
+.TP
+.BI \-V
+Prints the version number and exit.
+.SH CAVEATS
+.B xfs_healer
+is an immature utility!
+Do not run this program unless you have backups of your data!
+This program takes advantage of in-kernel scrubbing to verify a given
+data structure with locks held and can keep the filesystem busy for a
+long time.
+The kernel must be new enough to support the SCRUB_METADATA ioctl.
+.PP
+If errors are found and cannot be repaired, the filesystem must be
+unmounted and repaired.
+.SH SEE ALSO
+.BR xfs_repair (8).

