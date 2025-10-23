Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40300EACD
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178169; cv=none; b=YuV8l1LkAOG/EW84jpvUJsSrXMhJ0Fc6PaffjZmBYlHm+Lr7XrFKnJ9P7xjQsWVxDrbd/j/t0dTg1R3k4b+/bBO23ANixJia3mmeQqfX3zP4Vn5UDaD6bzDjmrw5BscLzlzrYnXaqdz8Vi2dftnbdE8qnHPWeO87ypuLTeDTTOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178169; c=relaxed/simple;
	bh=fqxPjICuQwk5TVRzlcmVy1NcnRqYGQEGHwX0nHSSKcM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t3yiGTvKc0NcyeI0YN8Uy65KmxklpkOvYKehnC3Ayw2plxCl3MVscgR8+5kuGR8vsLhiTqnvC3WphXKXuyamOxEtjTacYHOtkakuCJiJa9lzAiJxrQ9sN3bO2cbb4XFBffOs2KmuqFRiB659TU8ONpP6/9H81SkO4Ua4sQ/lVTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C2kcAL/m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C2kcAL/m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B430DC4CEE7;
	Thu, 23 Oct 2025 00:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178168;
	bh=fqxPjICuQwk5TVRzlcmVy1NcnRqYGQEGHwX0nHSSKcM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=C2kcAL/mQBLIETjIBgpoq4LO0FnReX3D9A4U7bMaTdNeKb3ipmRiAHttQ/n1I0+Mt
	 ycFZXrW4Au1lDmGS6eKpLsNlfQaxnFS+eVu2f3vvcDr45ss68YgsNUI4+W82K1WnJq
	 StSam+Ro6wSrS9uWY+S9an/I+8IMTRQeWAIRkYB93kDQ6Yo08c24NhfFq9GLqMbszB
	 vZvJiGbXN/TDTNtBsCvB0UKasNfS15uESdt5utmVrTgAf2IkQpuAAycimszNckSOrk
	 aP7S3q83XFSmvx3lLWPnOxuKIEiKrq3aauazAYBXn9nB7PiMKwo77MQBJnGtVL/uM1
	 8aVyGRrS9AosQ==
Date: Wed, 22 Oct 2025 17:09:28 -0700
Subject: [PATCH 15/26] xfs_healer: check for fs features needed for effective
 repairs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117747749.1028044.11852124073967514426.stgit@frogsfrogsfrogs>
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

Online repair relies heavily on back references such as reverse mappings
and directory parent pointers to add redundancy to the filesystem.
Check for these two features and whine a bit if they are missing.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/xfs_healer.py.in |   92 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)


diff --git a/healer/xfs_healer.py.in b/healer/xfs_healer.py.in
index f12e84aff8d177..5098193bb86ac9 100644
--- a/healer/xfs_healer.py.in
+++ b/healer/xfs_healer.py.in
@@ -74,6 +74,8 @@ everything = False
 debug_fast = False
 printf_prefix = ''
 want_repair = False
+has_parent = False
+has_rmapbt = False
 libhandle = None
 
 def printlogln(*args, **kwargs):
@@ -347,6 +349,19 @@ def __xfs_repair_metadata(fd, type, group, ino, gen):
 	fcntl.ioctl(fd, XFS_IOC_SCRUB_METADATA, arg)
 	return arg.sm_flags
 
+def xfs_repair_is_supported(fd):
+	'''Ask the kernel if it supports repairs.'''
+
+	arg = xfs_scrub_metadata()
+	arg.sm_type = XFS_SCRUB_TYPE_PROBE
+	arg.sm_flags = XFS_SCRUB_IFLAG_REPAIR
+
+	try:
+		fcntl.ioctl(fd, XFS_IOC_SCRUB_METADATA, arg)
+	except:
+		return False
+	return True
+
 def xfs_repair_fs_metadata(fd, type):
 	'''Call the kernel to repair some whole-fs metadata.'''
 	return __xfs_repair_metadata(fd, type, 0, 0, 0)
@@ -389,6 +404,57 @@ class RepairOutcome(Enum):
 		if self == RepairOutcome.Success:
 			return _("Repairs successful.")
 
+# fsgeometry ioctl
+class xfs_fsop_geom(ctypes.Structure):
+	_fields_ = [
+		("blocksize",		ctypes.c_uint),
+		("rtextesize",		ctypes.c_uint),
+		("agblocks",		ctypes.c_uint),
+		("agcount",		ctypes.c_uint),
+		("logblocks",		ctypes.c_uint),
+		("sectsize",		ctypes.c_uint),
+		("inodesize",		ctypes.c_uint),
+		("imaxpct",		ctypes.c_uint),
+		("datablocks",		ctypes.c_ulonglong),
+		("rtblocks",		ctypes.c_ulonglong),
+		("rtextents",		ctypes.c_ulonglong),
+		("logstart",		ctypes.c_ulonglong),
+		("uuid",		ctypes.c_ubyte * 16),
+		("sunit",		ctypes.c_uint),
+		("swidth",		ctypes.c_uint),
+		("version",		ctypes.c_uint),
+		("flags",		ctypes.c_uint),
+		("logsectsize",		ctypes.c_uint),
+		("rtsectsize",		ctypes.c_uint),
+		("dirblocksize",	ctypes.c_uint),
+		("logsunit",		ctypes.c_uint),
+		("sick",		ctypes.c_uint),
+		("checked",		ctypes.c_uint),
+		("rgblocks",		ctypes.c_uint),
+		("rgcount",		ctypes.c_uint),
+		("_pad",		ctypes.c_ulonglong * 16),
+	]
+assert ctypes.sizeof(xfs_fsop_geom) == 256
+
+XFS_FSOP_GEOM_FLAGS_RMAPBT	= 1 << 19
+XFS_FSOP_GEOM_FLAGS_PARENT	= 1 << 25
+
+XFS_IOC_FSGEOMETRY		= _IOR (0x58, 126, xfs_fsop_geom)
+
+def xfs_has_parent(fd):
+	'''Does this filesystem have parent pointers?'''
+
+	arg = xfs_fsop_geom()
+	fcntl.ioctl(fd, XFS_IOC_FSGEOMETRY, arg)
+	return arg.flags & XFS_FSOP_GEOM_FLAGS_PARENT != 0
+
+def xfs_has_rmapbt(fd):
+	'''Does this filesystem have reverse mapping?'''
+
+	arg = xfs_fsop_geom()
+	fcntl.ioctl(fd, XFS_IOC_FSGEOMETRY, arg)
+	return arg.flags & XFS_FSOP_GEOM_FLAGS_RMAPBT != 0
+
 # main program
 
 def health_reports(mon_fp):
@@ -554,6 +620,8 @@ def monitor(mountpoint, event_queue, **kwargs):
 	global log
 	global printf_prefix
 	global want_repair
+	global has_parent
+	global has_rmapbt
 
 	def event_loop(mon_fd, event_queue, fh):
 		# Ownership of mon_fd (and hence responsibility for closing it)
@@ -577,6 +645,30 @@ def monitor(mountpoint, event_queue, **kwargs):
 		eprintln(f"{mountpoint}: {e}")
 		return 1
 
+	try:
+		has_parent = xfs_has_parent(fd)
+		has_rmapbt = xfs_has_rmapbt(fd)
+	except Exception as e:
+		# Don't care if we can't detect parent pointers or rmap
+		msg = _("detecting fs features")
+		eprintln(_(f'{printf_prefix}: {msg}: {e}'))
+
+	# Check that the kernel supports repairs at all.
+	if want_repair and not xfs_repair_is_supported(fd):
+		msg = _("XFS online repair is not supported, exiting")
+		printlogln(f"{mountpoint}: {msg}")
+		os.close(fd)
+		return 1
+
+	# Check for the backref metadata that makes repair effective.
+	if want_repair:
+		if not has_rmapbt:
+			msg = _("XFS online repair is less effective without rmap btrees.")
+			printlogln(f"{mountpoint}: {msg}")
+		if not has_parent:
+			msg = _("XFS online repair is less effective without parent pointers.")
+			printlogln(f"{mountpoint}: {msg}")
+
 	try:
 		fh = fshandle(fd, mountpoint) if want_repair else None
 	except Exception as e:

