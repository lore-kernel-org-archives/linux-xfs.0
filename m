Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36FE1DF25F
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 03:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773114483; cv=none; b=QR+iBMba2PgNQHiQS37RaVFLYAAjspGrJCBgf7Kzz6mdqCfj29K6fRuGVo0RKzbJY2Fw3aseqNslF5cbyxXaeLHSTd/CmafzGqdymBTFR3wVZ1nUw5TrQkA7pJ324eBvgQaimn1Ok1V/9W+oMolwMy/oihh2snDJvhJSNNyH4c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773114483; c=relaxed/simple;
	bh=gNLcxXvZ1oAd5HrriM/vWAHjDo/rFnJ4H4JoTJmEKvM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yy4n76ygGMLYRb+8/tiHexCOISAM5CRMIaw8b8J4fS60ECpvfhQG1cx24UFmJg64Rhbf2pITUH/01EZN6bqRoixgmhmPbveFHj7fyNeUwLVeIzNlNrA0dMpXlDDSMdX5/QGLRfK52a3zgOVDhxb5zrUAHUSbA+VZcfGClx1i8z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SHdWBisI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SHdWBisI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA7CC19423;
	Tue, 10 Mar 2026 03:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773114483;
	bh=gNLcxXvZ1oAd5HrriM/vWAHjDo/rFnJ4H4JoTJmEKvM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SHdWBisIG456WQH4HyHHzfOKEEicT8FPre1D15xl66wrofg8NDsYfgALMBJ3Sth3m
	 NGcbnRbMtm76XLrrLQIvmAsy1zs5umSgaJ2OQI6NO2Oz9dAXyB+n6VxTWkMMA4+W2I
	 PY0OV3HL27mhs0/q3qkQhHoyC7U4vnL/UZjtOOrLaYEdA6d0Q7CPHw6T7ATG1fnCYW
	 iFXDhK2UvYXL77FsfEj6Ame+34UPAO0sJrglgcf0cSa/yVkCfzdyUlQnpvJd//+s2q
	 bhBf+N8UO6VF4scWmcyydckvn8/gb9cmJgL0MdGee0hY/8AW4yOXUlIBlAj6xJYXV+
	 r1oabm3gtqkrA==
Date: Mon, 09 Mar 2026 20:48:03 -0700
Subject: [PATCH 21/28] xfs_healer: add a manual page
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177311401842.1183235.18251247850049435922.stgit@frogsfrogsfrogs>
In-Reply-To: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
References: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 man/man8/Makefile           |   40 +++++++++++++---
 man/man8/xfs_healer.8       |  109 +++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_healer_start.8 |   37 +++++++++++++++
 3 files changed, 180 insertions(+), 6 deletions(-)
 create mode 100644 man/man8/xfs_healer.8
 create mode 100644 man/man8/xfs_healer_start.8


diff --git a/man/man8/Makefile b/man/man8/Makefile
index 5be76ab727a1fe..05710f85ae89ad 100644
--- a/man/man8/Makefile
+++ b/man/man8/Makefile
@@ -7,13 +7,41 @@ include $(TOPDIR)/include/builddefs
 
 MAN_SECTION	= 8
 
-ifneq ("$(ENABLE_SCRUB)","yes")
-  MAN_PAGES = $(filter-out xfs_scrub%,$(shell echo *.$(MAN_SECTION)))
-else
-  MAN_PAGES = $(shell echo *.$(MAN_SECTION))
-  MAN_PAGES += xfs_scrub_all.8
+MAN_PAGES = \
+	fsck.xfs.8 \
+	mkfs.xfs.8 \
+	xfs_admin.8 \
+	xfs_bmap.8 \
+	xfs_copy.8 \
+	xfs_db.8 \
+	xfs_estimate.8 \
+	xfs_freeze.8 \
+	xfs_fsr.8 \
+	xfs_growfs.8 \
+	xfs_info.8 \
+	xfs_io.8 \
+	xfs_logprint.8 \
+	xfs_mdrestore.8 \
+	xfs_metadump.8 \
+	xfs_mkfile.8 \
+	xfs_ncheck.8 \
+	xfs_property.8 \
+	xfs_protofile.8 \
+	xfs_quota.8 \
+	xfs_repair.8 \
+	xfs_rtcp.8 \
+	xfs_spaceman.8
+
+ifeq ($(ENABLE_HEALER),yes)
+  MAN_PAGES += xfs_healer.8
 endif
-MAN_PAGES	+= mkfs.xfs.8
+ifeq ($(HAVE_HEALER_START_DEPS),yes)
+  MAN_PAGES += xfs_healer_start.8
+endif
+ifeq ($(ENABLE_SCRUB),yes)
+  MAN_PAGES += xfs_scrub.8 xfs_scrub_all.8
+endif
+
 MAN_DEST	= $(PKG_MAN_DIR)/man$(MAN_SECTION)
 LSRCFILES	= $(MAN_PAGES)
 DIRT		= mkfs.xfs.8 xfs_scrub_all.8
diff --git a/man/man8/xfs_healer.8 b/man/man8/xfs_healer.8
new file mode 100644
index 00000000000000..eea799f7811a4d
--- /dev/null
+++ b/man/man8/xfs_healer.8
@@ -0,0 +1,109 @@
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
+The service is activated via the
+.I xfs_healer_start
+service if systemd is supported.
+
+The kernel may not support repairing or optimizing the filesystem.
+If this is the case, the filesystem must be unmounted and
+.BR xfs_repair (8)
+run on the filesystem to fix the problems.
+.SH OPTIONS
+.TP
+.BI \-\-everything
+Ask the kernel to send us good metadata health events, not only events related
+to metadata corruption, media errors, shutdowns, and I/O errors.
+.TP
+.B \-\-foreground
+Start enough event handling threads to allow consumption of all online CPUs.
+If not specified, start exactly one event handling thread.
+.TP
+.B \-\-no-autofsck
+Do not use the
+.I autofsck
+filesystem property to decide whether or not to repair corrupt metadata.
+If the
+.B \-\-repair
+option is given, then all corruptions will be repaired.
+If the
+.B \-\-repair
+option is not given, then the program will never try to repair the filesystem.
+.TP
+.B \-\-quiet
+Do not print every event to standard output.
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
+.B \-\-supported
+Check if the filesystem supports sending health events.
+Exits with 0 if it does, and non-zero if not.
+.TP
+.BI \-V
+Prints the version number and exit.
+
+.SH AUTOFSCK
+By default, this program will read the
+.I autofsck
+filesystem property to decide if it should try to repair corruptions.
+If the property is set to the value
+.B repair
+then corruptions will be repaired.
+If the property is not set but the filesystem supports all back-reference
+metadata (reverse mappings and parent pointers), then corruptions will be
+repaired.
+
+See the
+.BR xfs_scrub (8)
+manual page for more details on this filesystem property.
+
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
+.BR xfs_repair (8)
+and
+.BR xfs_scrub (8).
diff --git a/man/man8/xfs_healer_start.8 b/man/man8/xfs_healer_start.8
new file mode 100644
index 00000000000000..9e424432a513fe
--- /dev/null
+++ b/man/man8/xfs_healer_start.8
@@ -0,0 +1,37 @@
+.TH xfs_healer_start 8
+.SH NAME
+xfs_healer_start \- starts xfs_healer instances
+.SH SYNOPSIS
+.B xfs_healer_start
+[
+.B OPTIONS
+]
+.br
+.B xfs_healer \-V
+.SH DESCRIPTION
+.B xfs_healer_start
+starts the xfs_healer service whenever the kernel mounts an XFS filesystem in
+the current mount namespace.
+.PP
+.B WARNING!
+This program is
+.BR EXPERIMENTAL ","
+which means that its behavior and interface
+could change at any time!
+
+Normally this program runs as a systemd service.
+
+.SH OPTIONS
+.TP
+.B \-\-supported
+Check if the kernel supports listening for mount events.
+Exits with 0 if it does, and non-zero if not.
+.TP
+.BI "\-\-mountns " path
+Monitor the given mount namespace.
+Defaults to the mount namespace associated with the process itself.
+.TP
+.BI \-V
+Prints the version number and exit.
+.SH SEE ALSO
+.BR xfs_healer (8).

