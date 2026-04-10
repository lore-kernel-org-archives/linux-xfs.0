Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6BE3446CA
	for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2026 06:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775801765; cv=none; b=sARd5NHcfA4idMsyNAuN4F2PlTwonJ6jx/nNHPxx8Wa4jivilaXZmbLODNR/8l7/90wbn2I5G23iiv57gGPhQA1b2FU3yO60S7XBn7XG3HDFZmXygYamvN00fnMFqGXwbaWp9xWLmKn1xY1WCZDJrPc/lPbe5ylnlpz1XaekAHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775801765; c=relaxed/simple;
	bh=/JjN8I1cy+xbBReJb4vOWBeouZhVEVZov1fE+Xn9mCM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mzKmIuFeYN7EFzTxAnjIgdduJr4qwrQwot5W1f5FhrT68PTB1yjBAh43QLr7i1MPdHxM/6lKnRtCXSy5ZMFfUMKbJIFlccv9k4vPMFabbvesJu367VCX54XjGVbnKeEDm3bHVFc4tCk4hkJG7un9K8ypAplrX6iou4tRnRIOkTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TkMnfRDd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TkMnfRDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 415A4C19421;
	Fri, 10 Apr 2026 06:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775801765;
	bh=/JjN8I1cy+xbBReJb4vOWBeouZhVEVZov1fE+Xn9mCM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TkMnfRDde5aWFAEVJ39JuINa0AlzwrwFK0VMzESs2vz7cuSdIVvWyP+lFn6EpGABA
	 qX+Y848dofd1LfLtMqfxpxHz6CTgoyO4qezOdNFwKnatOt7S8KoC15L7yCET66KFrJ
	 Etz83dbhFcXTz5VRYL4LCNtDdCunNuoC43HfapMaYPxiaOe7ulKPu+Oi9pO3hFdlBI
	 4fMrhdu/I9kAMjx9WRIKK8qkpiJBTEsIxh5EJPLg5+ut0ATsr9gIzB2u3T/+FYSSAe
	 EpnD5HGC2K6KoG0z+sAoFwJzJ6/4NRofnFFu8HrqiKyoyDbn21udAiojWTOBtyGlrB
	 It5j5w94WzgKA==
Date: Thu, 09 Apr 2026 23:16:04 -0700
Subject: [PATCH 21/26] xfs_healer: add a manual page
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177577384615.2089237.6313240600261650963.stgit@frogsfrogsfrogs>
In-Reply-To: <177577384104.2089237.6309276904931285911.stgit@frogsfrogsfrogs>
References: <177577384104.2089237.6309276904931285911.stgit@frogsfrogsfrogs>
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
 man/man8/Makefile           |   40 ++++++++++++--
 man/man8/xfs_healer.8       |  121 +++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_healer_start.8 |   37 +++++++++++++
 3 files changed, 192 insertions(+), 6 deletions(-)
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
index 00000000000000..ee6ac9bd22ff8e
--- /dev/null
+++ b/man/man8/xfs_healer.8
@@ -0,0 +1,121 @@
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
+If the property is set to these values:
+
+.RS
+.TP
+.I repair
+Corruptions will be repaired.
+.TP
+.IR check " or " optimize
+Corruptions will be logged.
+.TP
+.I none
+The program will exit.
+.RE
+
+If the property is not set but the filesystem supports any back-reference
+metadata (reverse mappings and parent pointers), then corruptions will be
+logged.
+If no back-reference metadata are present, the program will exit.
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
index 00000000000000..0b755fd56a6edc
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
+.B xfs_healer_start \-V
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

