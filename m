Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44ECE27453
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178153; cv=none; b=BP7nd33sVlPLTDnRJ7qYUiMJYGA5+9dYjeRyQM/9RpieiND2OyC4gfurduj9TA8NePMGw9XlKIuR3HMIE45lTxKiBwXCx9k+tZwavpvN65403ucR2mAbs4Mbhs7hNjTZR085im6RUPFpT+rn/pkCa2WVXN9cH9xoIqc0/YrGG78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178153; c=relaxed/simple;
	bh=DhNwnM/UPcVSD0PzI3pAQgD7SqJ2uQgWILLdzIwdfHo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=toPl/ApcVtYJmjhp0NfZU48YzzIW3U7coL1CYgHaYagzOx8gdyU8242lCXrOxeTm9ux8XOZxXt/AekIcGGISC7bbXS4ssPqfgOQ4HeX1HRJXeyj3ia5zfjS2j0axqiOEb9g5t+oqPo5i7sfTbni4l/gnjwuSGVCmq9a4CvSpNQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AKOAYNVI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AKOAYNVI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB2CC4CEE7;
	Thu, 23 Oct 2025 00:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178153;
	bh=DhNwnM/UPcVSD0PzI3pAQgD7SqJ2uQgWILLdzIwdfHo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AKOAYNVISPSakeiM+Nmu8D5yC264rYht8p27sPGIJxjWZgwGebYmMNtzD70fJGcUo
	 m6jBYnLYEnnMzfcQFWnJ6v68hOX8Hi5WiX3BV0r0E8DTWjfYsSRQNQvcB+a5i7/PC2
	 6l9AlPYLfq8hKgxp4beiNAmI5esgS5UYvORwC/JpaKSTr47oSYOkOVMonMe/4nqcYo
	 XxxWAFqP8Z4ZxdbZzOBtlelqLiAIhkXsbDs0+z3dv2qgvkUlN1AuY+12mXLHNOpYPd
	 PKySb/a/g0WQKQg7o21AUapfZnuz2UpEzlkQth5CZ+MUhFOTA48tc5WxQdSQR5qg81
	 8RaqMjiL8k4ZQ==
Date: Wed, 22 Oct 2025 17:09:12 -0700
Subject: [PATCH 14/26] xfs_healer: enable repairing filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117747731.1028044.2190784564978724892.stgit@frogsfrogsfrogs>
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

Make it so that our health monitoring daemon can initiate repairs.
Because repairs can take a while to run, so we don't actually want to be
doing that work in the event thread because the kernel queue can drop
events if userspace doesn't respond in time.

Therefore, create a subprocess executor to run the repairs in the
background, and do the repairs from there.  The subprocess executor is
similar in concept to what a libfrog workqueue does, but the workers do
not share address space, which eliminates GIL contention.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/xfs_healer.py.in |  395 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 390 insertions(+), 5 deletions(-)


diff --git a/healer/xfs_healer.py.in b/healer/xfs_healer.py.in
index 459a07d3804ab5..f12e84aff8d177 100644
--- a/healer/xfs_healer.py.in
+++ b/healer/xfs_healer.py.in
@@ -19,6 +19,8 @@ import ctypes
 import pathlib
 import gc
 from concurrent.futures import ProcessPoolExecutor
+import ctypes.util
+from enum import Enum
 
 try:
 	# Not all systems will have this json schema validation libarary,
@@ -71,6 +73,8 @@ log = False
 everything = False
 debug_fast = False
 printf_prefix = ''
+want_repair = False
+libhandle = None
 
 def printlogln(*args, **kwargs):
 	'''Print a log message to stdout and flush it.'''
@@ -123,6 +127,9 @@ def _IOW(type, number, size):
 def _IOWR(type, number, size):
 	return _IOC(_IOC_READ | _IOC_WRITE, type, number, size)
 
+def _IOWR(type, number, size):
+	return _IOC(_IOC_READ | _IOC_WRITE, type, number, size)
+
 # xfs health monitoring ioctl stuff
 XFS_HEALTH_MONITOR_FMT_JSON = 1
 XFS_HEALTH_MONITOR_VERBOSE = 1 << 0
@@ -150,6 +157,238 @@ def open_health_monitor(fd, verbose = False):
 	ret = fcntl.ioctl(fd, XFS_IOC_HEALTH_MONITOR, arg)
 	return ret
 
+# libhandle stuff
+class xfs_fsid(ctypes.Structure):
+	_fields_ = [
+		("_val0",	ctypes.c_uint),
+		("_val1",	ctypes.c_uint)
+	]
+
+class xfs_fid(ctypes.Structure):
+	_fields_ = [
+		("fid_len",	ctypes.c_ushort),
+		("fid_pad",	ctypes.c_ushort),
+		("fid_gen",	ctypes.c_uint),
+		("fid_ino",	ctypes.c_ulonglong)
+	]
+
+class xfs_handle(ctypes.Structure):
+	_fields_ = [
+		("_ha_fsid",	xfs_fsid),
+		("ha_fid",	xfs_fid)
+	]
+assert ctypes.sizeof(xfs_handle) == 24
+
+class fshandle(object):
+	def __init__(self, fd, mountpoint):
+		global libhandle
+		global printf_prefix
+
+		self.handle = xfs_handle()
+
+		if mountpoint is None:
+			raise Exception(_('fshandle needs a mountpoint'))
+
+		self.mountpoint = mountpoint
+
+		# Create the file and fs handles for the open mountpoint
+		# so that we can compare them later
+		buf = ctypes.c_void_p()
+		buflen = ctypes.c_size_t()
+		ret = libhandle.fd_to_handle(fd, buf, buflen)
+		if ret < 0:
+			errcode = ctypes.get_errno()
+			errstr = os.strerror(errcode)
+			msg = _("cannot create handle")
+			raise OSError(errcode, f'{msg}: {errstr}',
+					printf_prefix)
+		expected_size = ctypes.sizeof(xfs_handle)
+		if buflen.value != expected_size:
+			libhandle.free_handle(buf, buflen.value)
+			msg = _("Bad file handle size")
+			raise Exception(f"{msg}: {buflen.value}")
+
+		hanp = ctypes.cast(buf, ctypes.POINTER(xfs_handle))
+		self.handle = hanp.contents
+
+	def reopen(self):
+		'''Reopen a file handle obtained via weak reference.'''
+		global libhandle
+		global printf_prefix
+
+		buf = ctypes.c_void_p()
+		buflen = ctypes.c_size_t()
+
+		fd = os.open(self.mountpoint, os.O_RDONLY)
+
+		# Create the file and fs handles for the open mountpoint
+		# so that we can compare them later
+		ret = libhandle.fd_to_handle(fd, buf, buflen)
+		if ret < 0:
+			errcode = ctypes.get_errno()
+			errstr = os.strerror(errcode)
+			os.close(fd)
+			msg = _("resampling handle")
+			raise OSError(errcode, f'{msg}: {errstr}',
+					printf_prefix)
+
+		hanp = ctypes.cast(buf, ctypes.POINTER(xfs_handle))
+
+		# Did we get the same handle?
+		if buflen.value != ctypes.sizeof(xfs_handle) or \
+		   bytes(hanp.contents) != bytes(self.handle):
+			os.close(fd)
+			libhandle.free_handle(buf, buflen)
+			msg = _("reopening")
+			errstr = os.strerror(errno.ESTALE)
+			raise OSError(errno.ESTALE, f'{msg}: {errstr}',
+					printf_prefix)
+
+		libhandle.free_handle(buf, buflen)
+		return fd
+
+def libhandle_load():
+	'''Load libhandle and set things up.'''
+	global libhandle
+
+	soname = ctypes.util.find_library('handle')
+	if soname is None:
+		errstr = os.strerror(errno.ENOENT)
+		msg = _("while finding library")
+		raise OSError(errno.ENOENT, f'{msg}: {errstr}', 'libhandle')
+
+	libhandle = ctypes.CDLL(soname, use_errno = True)
+	libhandle.fd_to_handle.argtypes = (
+			ctypes.c_int,
+			ctypes.POINTER(ctypes.c_void_p),
+			ctypes.POINTER(ctypes.c_size_t))
+	libhandle.handle_to_fshandle.argtypes = (
+			ctypes.c_void_p,
+			ctypes.c_size_t,
+			ctypes.POINTER(ctypes.c_void_p),
+			ctypes.POINTER(ctypes.c_size_t))
+	libhandle.path_to_fshandle.argtypes = (
+			ctypes.c_char_p,
+			ctypes.c_void_p,
+			ctypes.c_size_t)
+	libhandle.free_handle.argtypes = (
+			ctypes.c_void_p,
+			ctypes.c_size_t)
+
+# metadata scrubbing stuff
+XFS_SCRUB_TYPE_PROBE		= 0
+XFS_SCRUB_TYPE_SB		= 1
+XFS_SCRUB_TYPE_AGF		= 2
+XFS_SCRUB_TYPE_AGFL		= 3
+XFS_SCRUB_TYPE_AGI		= 4
+XFS_SCRUB_TYPE_BNOBT		= 5
+XFS_SCRUB_TYPE_CNTBT		= 6
+XFS_SCRUB_TYPE_INOBT		= 7
+XFS_SCRUB_TYPE_FINOBT		= 8
+XFS_SCRUB_TYPE_RMAPBT		= 9
+XFS_SCRUB_TYPE_REFCNTBT		= 10
+XFS_SCRUB_TYPE_INODE		= 11
+XFS_SCRUB_TYPE_BMBTD		= 12
+XFS_SCRUB_TYPE_BMBTA		= 13
+XFS_SCRUB_TYPE_BMBTC		= 14
+XFS_SCRUB_TYPE_DIR		= 15
+XFS_SCRUB_TYPE_XATTR		= 16
+XFS_SCRUB_TYPE_SYMLINK		= 17
+XFS_SCRUB_TYPE_PARENT		= 18
+XFS_SCRUB_TYPE_RTBITMAP		= 19
+XFS_SCRUB_TYPE_RTSUM		= 20
+XFS_SCRUB_TYPE_UQUOTA		= 21
+XFS_SCRUB_TYPE_GQUOTA		= 22
+XFS_SCRUB_TYPE_PQUOTA		= 23
+XFS_SCRUB_TYPE_FSCOUNTERS	= 24
+XFS_SCRUB_TYPE_QUOTACHECK	= 25
+XFS_SCRUB_TYPE_NLINKS		= 26
+XFS_SCRUB_TYPE_HEALTHY		= 27
+XFS_SCRUB_TYPE_DIRTREE		= 28
+XFS_SCRUB_TYPE_METAPATH		= 29
+XFS_SCRUB_TYPE_RGSUPER		= 30
+XFS_SCRUB_TYPE_RGBITMAP		= 31
+XFS_SCRUB_TYPE_RTRMAPBT		= 32
+XFS_SCRUB_TYPE_RTREFCBT		= 33
+
+XFS_SCRUB_IFLAG_REPAIR			= 1 << 0
+XFS_SCRUB_OFLAG_CORRUPT			= 1 << 1
+XFS_SCRUB_OFLAG_PREEN			= 1 << 2
+XFS_SCRUB_OFLAG_XFAIL			= 1 << 3
+XFS_SCRUB_OFLAG_XCORRUPT		= 1 << 4
+XFS_SCRUB_OFLAG_INCOMPLETE		= 1 << 5
+XFS_SCRUB_OFLAG_WARNING			= 1 << 6
+XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED	= 1 << 7
+XFS_SCRUB_IFLAG_FORCE_REBUILD		= 1 << 8
+
+class xfs_scrub_metadata(ctypes.Structure):
+	_fields_ = [
+		('sm_type',	ctypes.c_uint),
+		('sm_flags',	ctypes.c_uint),
+		('sm_ino',	ctypes.c_ulonglong),
+		('sm_gen',	ctypes.c_uint),
+		('sm_agno',	ctypes.c_uint),
+		('_pad',	ctypes.c_ulonglong * 5),
+	]
+assert ctypes.sizeof(xfs_scrub_metadata) == 64
+
+XFS_IOC_SCRUB_METADATA		= _IOWR(0x58, 60, xfs_scrub_metadata)
+
+def __xfs_repair_metadata(fd, type, group, ino, gen):
+	'''Call the kernel to repair some inode metadata.'''
+
+	arg = xfs_scrub_metadata()
+	arg.sm_type = type
+	arg.sm_flags = XFS_SCRUB_IFLAG_REPAIR
+	arg.sm_ino = ino
+	arg.sm_gen = gen
+	arg.sm_agno = group
+
+	fcntl.ioctl(fd, XFS_IOC_SCRUB_METADATA, arg)
+	return arg.sm_flags
+
+def xfs_repair_fs_metadata(fd, type):
+	'''Call the kernel to repair some whole-fs metadata.'''
+	return __xfs_repair_metadata(fd, type, 0, 0, 0)
+
+def xfs_repair_group_metadata(fd, type, group):
+	'''Call the kernel to repair some group metadata.'''
+	return __xfs_repair_metadata(fd, type, group, 0, 0)
+
+def xfs_repair_inode_metadata(fd, type, ino, gen):
+	'''Call the kernel to repair some inode metadata.'''
+	return __xfs_repair_metadata(fd, type, 0, ino, gen)
+
+class RepairOutcome(Enum):
+	Success = 1,
+	Unnecessary = 2,
+	MightBeOk = 3,
+	Failed = 4,
+
+	def from_oflags(oflags):
+		'''Translate scrub output flags to outcome.'''
+		if oflags & (XFS_SCRUB_OFLAG_CORRUPT | \
+			     XFS_SCRUB_OFLAG_INCOMPLETE):
+			return RepairOutcome.Failed
+
+		if oflags & XFS_SCRUB_OFLAG_XFAIL:
+			return RepairOutcome.MightBeOk
+
+		if oflags & XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED:
+			return RepairOutcome.Unnecessary
+
+		return RepairOutcome.Success
+
+	def report(self):
+		if self == RepairOutcome.Failed:
+			return _("Repair unsuccessful; offline repair required.")
+		if self == RepairOutcome.MightBeOk:
+			return _("Seems correct but cross-referencing failed; offline repair recommended.")
+		if self == RepairOutcome.Unnecessary:
+			return _("No modification needed.")
+		if self == RepairOutcome.Success:
+			return _("Repairs successful.")
+
 # main program
 
 def health_reports(mon_fp):
@@ -263,7 +502,7 @@ def report_shutdown(event):
 	msg = _("filesystem shut down due to")
 	printlogln(f"{printf_prefix}: {msg} {some_reasons}")
 
-def handle_event(lines):
+def handle_event(lines, fh):
 	'''Handle an event asynchronously.'''
 	global log
 
@@ -306,17 +545,23 @@ def handle_event(lines):
 		except Exception as e:
 			eprintln(f"event reporting: {e}")
 
+	if want_repair and event['type'] == 'sick':
+		repair_metadata(event, fh)
+
 def monitor(mountpoint, event_queue, **kwargs):
 	'''Monitor the given mountpoint for health events.'''
 	global everything
+	global log
+	global printf_prefix
+	global want_repair
 
-	def event_loop(mon_fd, event_queue):
+	def event_loop(mon_fd, event_queue, fh):
 		# Ownership of mon_fd (and hence responsibility for closing it)
 		# is transferred to the mon_fp object.
 		with os.fdopen(mon_fd) as mon_fp:
 			nr = 0
 			for lines in health_reports(mon_fp):
-				event_queue.submit(handle_event, lines)
+				event_queue.submit(handle_event, lines, fh)
 
 				# Periodically run the garbage collector to
 				# constrain memory usage in the main thread.
@@ -332,6 +577,13 @@ def monitor(mountpoint, event_queue, **kwargs):
 		eprintln(f"{mountpoint}: {e}")
 		return 1
 
+	try:
+		fh = fshandle(fd, mountpoint) if want_repair else None
+	except Exception as e:
+		eprintln(f"{mountpoint}: {e}")
+		os.close(fd)
+		return 1
+
 	try:
 		mon_fd = open_health_monitor(fd, verbose = everything)
 	except OSError as e:
@@ -345,18 +597,140 @@ def monitor(mountpoint, event_queue, **kwargs):
 		eprintln(f"{mountpoint}: {e}")
 		return 1
 	finally:
-		# Close the mountpoint if opening the health monitor fails
+		# Close the mountpoint if opening the health monitor fails;
+		# the handle object will free its own memory.
 		os.close(fd)
 
 	try:
 		# mon_fd is consumed by this function
-		event_loop(mon_fd, event_queue)
+		event_loop(mon_fd, event_queue, fh)
 	except Exception as e:
 		eprintln(f"{mountpoint}: {e}")
 		return 1
 
 	return 0
 
+def __scrub_type(code):
+	'''Convert a "structures" json list to a scrub type code.'''
+	SCRUB_TYPES = {
+		"probe":	XFS_SCRUB_TYPE_PROBE,
+		"sb":		XFS_SCRUB_TYPE_SB,
+		"agf":		XFS_SCRUB_TYPE_AGF,
+		"agfl":		XFS_SCRUB_TYPE_AGFL,
+		"agi":		XFS_SCRUB_TYPE_AGI,
+		"bnobt":	XFS_SCRUB_TYPE_BNOBT,
+		"cntbt":	XFS_SCRUB_TYPE_CNTBT,
+		"inobt":	XFS_SCRUB_TYPE_INOBT,
+		"finobt":	XFS_SCRUB_TYPE_FINOBT,
+		"rmapbt":	XFS_SCRUB_TYPE_RMAPBT,
+		"refcountbt":	XFS_SCRUB_TYPE_REFCNTBT,
+		"inode":	XFS_SCRUB_TYPE_INODE,
+		"bmapbtd":	XFS_SCRUB_TYPE_BMBTD,
+		"bmapbta":	XFS_SCRUB_TYPE_BMBTA,
+		"bmapbtc":	XFS_SCRUB_TYPE_BMBTC,
+		"directory":	XFS_SCRUB_TYPE_DIR,
+		"xattr":	XFS_SCRUB_TYPE_XATTR,
+		"symlink":	XFS_SCRUB_TYPE_SYMLINK,
+		"parent":	XFS_SCRUB_TYPE_PARENT,
+		"rtbitmap":	XFS_SCRUB_TYPE_RTBITMAP,
+		"rtsummary":	XFS_SCRUB_TYPE_RTSUM,
+		"usrquota":	XFS_SCRUB_TYPE_UQUOTA,
+		"grpquota":	XFS_SCRUB_TYPE_GQUOTA,
+		"prjquota":	XFS_SCRUB_TYPE_PQUOTA,
+		"fscounters":	XFS_SCRUB_TYPE_FSCOUNTERS,
+		"quotacheck":	XFS_SCRUB_TYPE_QUOTACHECK,
+		"nlinks":	XFS_SCRUB_TYPE_NLINKS,
+		"healthy":	XFS_SCRUB_TYPE_HEALTHY,
+		"dirtree":	XFS_SCRUB_TYPE_DIRTREE,
+		"metapath":	XFS_SCRUB_TYPE_METAPATH,
+		"rgsuper":	XFS_SCRUB_TYPE_RGSUPER,
+		"rgbitmap":	XFS_SCRUB_TYPE_RGBITMAP,
+		"rtrmapbt":	XFS_SCRUB_TYPE_RTRMAPBT,
+		"rtrefcountbt":	XFS_SCRUB_TYPE_RTREFCBT,
+	}
+
+	if code not in SCRUB_TYPES:
+		return None
+
+	return SCRUB_TYPES[code]
+
+def repair_wholefs(event, fd):
+	'''React to a fs-domain corruption event by repairing it.'''
+	for structure in event['structures']:
+		struct = _(structure)
+		scrub_type = __scrub_type(structure)
+		if scrub_type is None:
+			continue
+		try:
+			oflags = xfs_repair_fs_metadata(fd, scrub_type)
+			outcome = RepairOutcome.from_oflags(oflags)
+			report = outcome.report()
+			printlogln(f"{printf_prefix}: {struct}: {report}")
+		except Exception as e:
+			eprintln(f"{printf_prefix}: {struct}: {e}")
+
+def repair_group(event, fd, group_type):
+	'''React to a group-domain corruption event by repairing it.'''
+	for structure in event['structures']:
+		struct = _(structure)
+		scrub_type = __scrub_type(structure)
+		if scrub_type is None:
+			continue
+		try:
+			oflags = xfs_repair_group_metadata(fd, scrub_type,
+				      event['group'])
+			outcome = RepairOutcome.from_oflags(oflags)
+			report = outcome.report()
+			printlogln(f"{printf_prefix}: {struct}: {report}")
+		except Exception as e:
+			eprintln(f"{printf_prefix}: {struct}: {e}")
+
+def repair_inode(event, fd):
+	'''React to a inode-domain corruption event by repairing it.'''
+	for structure in event['structures']:
+		struct = _(structure)
+		scrub_type = __scrub_type(structure)
+		if scrub_type is None:
+			continue
+		try:
+			oflags = xfs_repair_inode_metadata(fd, scrub_type,
+				      event['inumber'], event['generation'])
+			outcome = RepairOutcome.from_oflags(oflags)
+			report = outcome.report()
+			printlogln(f"{printf_prefix}: {struct}: {report}")
+		except Exception as e:
+			eprintln(f"{printf_prefix}: {struct}: {e}")
+
+def repair_metadata(event, fh):
+	'''Repair a metadata corruption.'''
+	global debug
+	global printf_prefix
+
+	if debug:
+		printlogln(f'repair {event}')
+
+	try:
+		fd = fh.reopen()
+	except Exception as e:
+		eprintln(f"{printf_prefix}: {e}")
+		return
+
+	try:
+		if event['domain'] in ['fs', 'realtime']:
+			repair_wholefs(event, fd)
+		elif event['domain'] in ['perag', 'rtgroup']:
+			repair_group(event, fd, event['domain'])
+		elif event['domain'] == 'inode':
+			repair_inode(event, fd)
+		else:
+			domain = event['domain']
+			msg = _("Unknown metadata domain")
+			raise Exception(f"{msg} \"{domain}\".")
+	except Exception as e:
+		eprintln(f"{printf_prefix}: {e}")
+	finally:
+		os.close(fd)
+
 def main():
 	global debug
 	global log
@@ -364,6 +738,7 @@ def main():
 	global everything
 	global debug_fast
 	global validator_fn
+	global want_repair
 
 	parser = argparse.ArgumentParser( \
 			description = _("Automatically heal damage to XFS filesystem metadata"))
@@ -384,6 +759,8 @@ def main():
 	parser.add_argument('--event-schema', type = str, \
 			default = '@pkg_data_dir@/xfs_healthmon.schema.json', \
 			help = argparse.SUPPRESS)
+	parser.add_argument("--repair", action = "store_true", \
+			help = _("Always repair corrupt metadata"))
 	args = parser.parse_args()
 
 	if args.V:
@@ -400,6 +777,12 @@ def main():
 	if not validator_fn:
 		return 1
 
+	try:
+		libhandle_load()
+	except OSError as e:
+		eprintln(f"libhandle: {e}")
+		return 1
+
 	if args.debug:
 		debug = True
 	if args.log:
@@ -408,6 +791,8 @@ def main():
 		everything = True
 	if args.debug_fast:
 		debug_fast = True
+	if args.repair:
+		want_repair = True
 
 	# Use a separate subprocess to handle the events so that the main event
 	# reading process does not block on the GIL of the event handling

