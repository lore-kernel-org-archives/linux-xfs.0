Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7E71B0428
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735689066; cv=none; b=s3Db9JPLm2+vzpuWOh8ounxaNtA8r9OS8uyiYNYZVTTE5GEjaUw8oEo+Sy8lT11FkewCKZNwmhN5x+ta7VPaROSu5VCAH0xyEGuMsH5lPOQNiwjYLtVrGnkiVKOGn9viWbq5ee4VUYU72U5/WYv9jGaM0myH3wlEcvtDsdun2xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735689066; c=relaxed/simple;
	bh=Z+XOHtJGNyHyCU2B1Ba4LxA2CntKYszeePVRd60Rchg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mF0wSzGjpXTBC15f2OXobESRDCmoeOH2TN895+SPnr4Mr5DVCaQDPGXfNbKfKhBpUbHN+dECSEYaTp1NesV7xM3ViDNWsoNln1C4+eir1hT+OhZwA2Cpz+ks6tSUnafScXasAqqlHE5schUcdzAsUix3Q2F1jaPO4snFeSXrEss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j805Z+SE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j805Z+SE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9157FC4CED2;
	Tue, 31 Dec 2024 23:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735689066;
	bh=Z+XOHtJGNyHyCU2B1Ba4LxA2CntKYszeePVRd60Rchg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=j805Z+SE3+Evok6Gjb3MjEIVBvxPzj4o1ooBPqnJJbpyNiIVbMKxDr2fjqN6oPozx
	 chwjiTvt3ygrAr96jegJAOPmHYK3ikAtKh4Vv9unbXNwE+eujgJGvbaWM4FB7qdjnD
	 SY2ZiYSjHOxVUmgiQCT4ImhElrMcr4ZIVyQMzXI3Ynbxyd0AXuqIg6Z8rw1f3TncqB
	 fZA4ndqRMq8XJ8MAWKOMaG+wxAI0Oh6EsTdvPfyAindkJ6+kE9p/uctEuhgEPr0ym2
	 uTbUP9fdNxohCtLepQwHAu3vpd3wJKL3n1J9DkwG3HVfy1GnNDaC1i2YLTqzrnZrh4
	 zMF7gr71ixzhw==
Date: Tue, 31 Dec 2024 15:51:05 -0800
Subject: [PATCH 13/21] xfs_scrubbed: enable repairing filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568778660.2710211.1025674826117983910.stgit@frogsfrogsfrogs>
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
 scrub/xfs_scrubbed.in |  366 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 360 insertions(+), 6 deletions(-)


diff --git a/scrub/xfs_scrubbed.in b/scrub/xfs_scrubbed.in
index 992797113d6d30..c626c7bd56630c 100644
--- a/scrub/xfs_scrubbed.in
+++ b/scrub/xfs_scrubbed.in
@@ -17,6 +17,7 @@ import errno
 import ctypes
 import gc
 from concurrent.futures import ProcessPoolExecutor
+import ctypes.util
 
 try:
 	# Not all systems will have this json schema validation libarary,
@@ -37,7 +38,7 @@ try:
 			vcls.check_schema(schema_js)
 			validator = vcls(schema_js)
 		except jsonschema.exceptions.SchemaError as e:
-			print(f"{args.event_schema}: invalid event data, {e.message}",
+			print(f"{args.event_schema}: invalid event data: {e.message}",
 					file = sys.stderr)
 			return
 		except Exception as e:
@@ -69,6 +70,9 @@ log = False
 everything = False
 debug_fast = False
 printf_prefix = ''
+want_repair = False
+libhandle = None
+repair_queue = None # placeholder for event queue worker
 
 # ioctl encoding stuff
 _IOC_NRBITS   =  8
@@ -112,6 +116,9 @@ def _IOW(type, number, size):
 def _IOWR(type, number, size):
 	return _IOC(_IOC_READ | _IOC_WRITE, type, number, size)
 
+def _IOWR(type, number, size):
+	return _IOC(_IOC_READ | _IOC_WRITE, type, number, size)
+
 # xfs health monitoring ioctl stuff
 XFS_HEALTH_MONITOR_FMT_JSON = 1
 XFS_HEALTH_MONITOR_VERBOSE = 1 << 0
@@ -139,9 +146,206 @@ def open_health_monitor(fd, verbose = False):
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
+			raise Exception('fshandle needs a mountpoint')
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
+			raise OSError(errcode,
+					f'cannot create handle: {os.strerror(errcode)}',
+					printf_prefix)
+		if buflen.value != ctypes.sizeof(xfs_handle):
+			libhandle.free_handle(buf, buflen.value)
+			raise Exception(f"fshandle expected {ctypes.sizeof(xfs_handle)} bytes, got {buflen.value}.")
+
+		hanp = ctypes.cast(buf, ctypes.POINTER(xfs_handle))
+		self.handle = hanp.contents
+
+	def open(self):
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
+			os.close(fd)
+			raise OSError(errcode,
+					f'resampling handle: {os.strerror(errcode)}',
+					printf_prefix)
+
+		hanp = ctypes.cast(buf, ctypes.POINTER(xfs_handle))
+
+		# Did we get the same handle?
+		if buflen.value != ctypes.sizeof(xfs_handle) or \
+		   bytes(hanp.contents) != bytes(self.handle):
+			os.close(fd)
+			libhandle.free_handle(buf, buflen)
+			raise OSError(errno.ESTALE,
+					os.strerror(errno.ESTALE),
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
+		raise OSError(errno.ENOENT,
+				f'while finding library: {os.strerror(errno.ENOENT)}',
+				'libhandle')
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
 # main program
 
-def health_reports(mon_fp):
+def health_reports(mon_fp, fh):
 	'''Generate python objects describing health events.'''
 	global debug
 	global printf_prefix
@@ -164,7 +368,7 @@ def health_reports(mon_fp):
 			if debug:
 				print(f'new event: {s}')
 			try:
-				yield json.loads(s)
+				yield (json.loads(s), fh)
 			except json.decoder.JSONDecodeError as e:
 				print(f"{printf_prefix}: {e} from {s}",
 						file = sys.stderr)
@@ -208,7 +412,7 @@ def report_shutdown(event):
 	print(f"{printf_prefix}: Filesystem shut down due to {', '.join(reasons)}.")
 	sys.stdout.flush()
 
-def handle_event(event):
+def handle_event(e):
 	'''Handle an event asynchronously.'''
 	def stringify_timestamp(event):
 		'''Try to convert a timestamp to something human readable.'''
@@ -222,6 +426,17 @@ def handle_event(event):
 			print(f'{printf_prefix}: bad timestamp: {e}', file = sys.stderr)
 
 	global log
+	global repair_queue
+
+	# Use a separate subprocess to handle the repairs so that the event
+	# processing worker does not block on the GIL of the repair workers.
+	# The downside is that we cannot pass function pointers and all data
+	# must be pickleable; the upside is that we don't stall processing of
+	# non-sickness events while repairs are in progress.
+	if want_repair and not repair_queue:
+		repair_queue = ProcessPoolExecutor(max_workers = 1)
+
+	event, fh = e
 
 	# Ignore any event that doesn't pass our schema.  This program must
 	# not try to handle a newer kernel that say things that it is not
@@ -236,13 +451,21 @@ def handle_event(event):
 		report_lost(event)
 	elif event['type'] == 'shutdown':
 		report_shutdown(event)
+	elif want_repair and event['type'] == 'sick':
+		repair_queue.submit(repair_metadata, event, fh)
 
 def monitor(mountpoint, event_queue, **kwargs):
 	'''Monitor the given mountpoint for health events.'''
 	global everything
+	global log
+	global printf_prefix
+	global want_repair
 
+	fh = None
 	fd = os.open(mountpoint, os.O_RDONLY)
 	try:
+		if want_repair:
+			fh = fshandle(fd, mountpoint)
 		mon_fd = open_health_monitor(fd, verbose = everything)
 	except OSError as e:
 		if e.errno != errno.ENOTTY and e.errno != errno.EOPNOTSUPP:
@@ -251,14 +474,15 @@ def monitor(mountpoint, event_queue, **kwargs):
 				file = sys.stderr)
 		return 1
 	finally:
-		# Close the mountpoint if opening the health monitor fails
+		# Close the mountpoint if opening the health monitor fails;
+		# the handle object will free its own memory.
 		os.close(fd)
 
 	# Ownership of mon_fd (and hence responsibility for closing it) is
 	# transferred to the mon_fp object.
 	with os.fdopen(mon_fd) as mon_fp:
 		nr = 0
-		for e in health_reports(mon_fp):
+		for e in health_reports(mon_fp, fh):
 			event_queue.submit(handle_event, e)
 
 			# Periodically run the garbage collector to constrain
@@ -271,6 +495,125 @@ def monitor(mountpoint, event_queue, **kwargs):
 
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
+def report_outcome(oflags):
+	if oflags & (XFS_SCRUB_OFLAG_CORRUPT | \
+		     XFS_SCRUB_OFLAG_CORRUPT | \
+		     XFS_SCRUB_OFLAG_INCOMPLETE):
+		return "Repair unsuccessful; offline repair required."
+
+	if oflags & XFS_SCRUB_OFLAG_XFAIL:
+		return "Seems correct but cross-referencing failed; offline repair recommended."
+
+	if oflags & XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED:
+		return "No modification needed."
+
+	return "Repairs successful."
+
+def repair_wholefs(event, fd):
+	'''React to a fs-domain corruption event by repairing it.'''
+	for s in event['structures']:
+		type = __scrub_type(s)
+		if type is None:
+			continue
+		try:
+			oflags = xfs_repair_fs_metadata(fd, type)
+			print(f"{printf_prefix}: {s}: {report_outcome(oflags)}")
+			sys.stdout.flush()
+		except Exception as e:
+			print(f"{printf_prefix}: {s}: {e}", file = sys.stderr)
+
+def repair_group(event, fd, group_type):
+	'''React to a group-domain corruption event by repairing it.'''
+	for s in event['structures']:
+		type = __scrub_type(s)
+		if type is None:
+			continue
+		try:
+			oflags = xfs_repair_group_metadata(fd, type, event['group'])
+			print(f"{printf_prefix}: {s}: {report_outcome(oflags)}")
+			sys.stdout.flush()
+		except Exception as e:
+			print(f"{printf_prefix}: {s}: {e}", file = sys.stderr)
+
+def repair_inode(event, fd):
+	'''React to a inode-domain corruption event by repairing it.'''
+	for s in event['structures']:
+		type = __scrub_type(s)
+		if type is None:
+			continue
+		try:
+			oflags = xfs_repair_inode_metadata(fd, type,
+				      event['inumber'], event['generation'])
+			print(f"{printf_prefix}: {s}: {report_outcome(oflags)}")
+			sys.stdout.flush()
+		except Exception as e:
+			print(f"{printf_prefix}: {s}: {e}", file = sys.stderr)
+
+def repair_metadata(event, fh):
+	'''Repair a metadata corruption.'''
+	global debug
+	global printf_prefix
+
+	if debug:
+		print(f'repair {event}')
+
+	fd = fh.open()
+	try:
+		if event['domain'] in ['fs', 'realtime']:
+			repair_wholefs(event, fd)
+		elif event['domain'] in ['perag', 'rtgroup']:
+			repair_group(event, fd, event['domain'])
+		elif event['domain'] == 'inode':
+			repair_inode(event, fd)
+		else:
+			raise Exception(f"{printf_prefix}: Unknown metadata domain \"{event['domain']}\".")
+	finally:
+		os.close(fd)
+
 def main():
 	global debug
 	global log
@@ -278,6 +621,7 @@ def main():
 	global everything
 	global debug_fast
 	global validator_fn
+	global want_repair
 
 	parser = argparse.ArgumentParser( \
 			description = "XFS filesystem health monitoring demon.")
@@ -287,6 +631,8 @@ def main():
 			action = "store_true")
 	parser.add_argument("--everything", help = "Capture all events.", \
 			action = "store_true")
+	parser.add_argument("--repair", help = "Automatically repair corrupt metadata.", \
+			action = "store_true")
 	parser.add_argument("-V", help = "Report version and exit.", \
 			action = "store_true")
 	parser.add_argument('mountpoint', default = None, nargs = '?',
@@ -312,6 +658,12 @@ def main():
 	if not validator_fn:
 		return 1
 
+	try:
+		libhandle_load()
+	except OSError as e:
+		print(f"libhandle: {e}", file = sys.stderr)
+		return 1
+
 	if args.debug:
 		debug = True
 	if args.log:
@@ -320,6 +672,8 @@ def main():
 		everything = True
 	if args.debug_fast:
 		debug_fast = True
+	if args.repair:
+		want_repair = True
 
 	# Use a separate subprocess to handle the events so that the main event
 	# reading process does not block on the GIL of the event handling

