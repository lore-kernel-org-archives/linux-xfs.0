Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689CE29415
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735689082; cv=none; b=QTk+MFtnYiQhyolEMGqbN01jdqnFMS86i9TPSwxnoXM9I2VwKUvY/DUNNPZjjMd2ekmiq0lZMtTiyEWcB2gQ+CErsRU9iFB30P2chJXlFlrljxbB3hMthxZO77W2Ho3e2wi59vbtKoX2UJg6knRY8OwJcBkb00V/tn6mGR8oO38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735689082; c=relaxed/simple;
	bh=CEbDRD88kIXr3wkBiz3lWfRHee3gP2KV8LQtslWyixg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FGrr39Li7ZdHiCAv4/2O9t8PP6LCI5MaaVT4Hz588c0mLRI92CT0NYk85IQR+XmqnLtNAxCQOueZqDoynVoxaP00ArTAIckKmT59KHxzukOqBj0AwfqpzlceoJKW5zFBBt1oTYdkwjjYrsovw2w8luE8wRcBX0gpZeVwZm/CYB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dlrLEex6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dlrLEex6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F32C4CED2;
	Tue, 31 Dec 2024 23:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735689082;
	bh=CEbDRD88kIXr3wkBiz3lWfRHee3gP2KV8LQtslWyixg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dlrLEex68DMP7zYt4XJX/2nWOPmwciChnjXZC6fZqPgz6sszn0WpQaWYYR9YMOvtQ
	 vnMqBlrrsX1QUQr/hW4MXGyhyShGZITNJPgnKFnwaf+yeC4uJbk6PYtXLFDhLV1jZn
	 UdgE0g8td1PMQ+Ovcl6eRrBfNyEpeBBB2paFf7J3Rir8sUj7NcvT7CawqoRmeWXOh0
	 DLSmJQO5eEjOfLvMmZcI2Ryjg0SXTU4ookWxw8T1CrE3Aan20dyC/iPPmuCN/YGWpb
	 SNFAc2fzW/U4/88LHyHe1r8txG/XHeREB1nA2zue4N5B4424tXyOexIiQvrVWC8Dqe
	 ikYqkSbjHKgog==
Date: Tue, 31 Dec 2024 15:51:21 -0800
Subject: [PATCH 14/21] xfs_scrubbed: check for fs features needed for
 effective repairs
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568778676.2710211.10139562694492141808.stgit@frogsfrogsfrogs>
In-Reply-To: <173568778426.2710211.10173859713748230492.stgit@frogsfrogsfrogs>
References: <173568778426.2710211.10173859713748230492.stgit@frogsfrogsfrogs>
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
 scrub/xfs_scrubbed.in |   72 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)


diff --git a/scrub/xfs_scrubbed.in b/scrub/xfs_scrubbed.in
index c626c7bd56630c..25465128864583 100644
--- a/scrub/xfs_scrubbed.in
+++ b/scrub/xfs_scrubbed.in
@@ -71,6 +71,8 @@ everything = False
 debug_fast = False
 printf_prefix = ''
 want_repair = False
+has_parent = False
+has_rmapbt = False
 libhandle = None
 repair_queue = None # placeholder for event queue worker
 
@@ -343,6 +345,57 @@ def xfs_repair_inode_metadata(fd, type, ino, gen):
 	'''Call the kernel to repair some inode metadata.'''
 	return __xfs_repair_metadata(fd, type, 0, ino, gen)
 
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
 
 def health_reports(mon_fp, fh):
@@ -460,9 +513,28 @@ def monitor(mountpoint, event_queue, **kwargs):
 	global log
 	global printf_prefix
 	global want_repair
+	global has_parent
+	global has_rmapbt
 
 	fh = None
 	fd = os.open(mountpoint, os.O_RDONLY)
+	try:
+		has_parent = xfs_has_parent(fd)
+		has_rmapbt = xfs_has_rmapbt(fd)
+	except Exception as e:
+		# Don't care if we can't detect parent pointers or rmap
+		print(f'{printf_prefix}: detecting fs features: {e}', file = sys.stderr)
+
+	# Check for the backref metadata that makes repair effective.
+	if want_repair:
+		if not has_rmapbt:
+			print(f"{mountpoint}: XFS online repair is less effective without rmap btrees.")
+		if not has_parent:
+			print(f"{mountpoint}: XFS online repair is less effective without parent pointers.")
+
+	# Flush anything that we may have printed about operational state.
+	sys.stdout.flush()
+
 	try:
 		if want_repair:
 			fh = fshandle(fd, mountpoint)

