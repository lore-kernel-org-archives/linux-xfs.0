Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A9D1D6AA
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178184; cv=none; b=nB5QuyEr6NVosEPFcfiU/CzbCB5RZzuZNu7TS37f4T8lvP87RBn5gTkV9spaCQhqLWABbgPVhi01Hv3xcEulqA6wjgZYohj9MjwgAU7gFR8f21F8/o6g81BZ5adRDvG0tajEmYy2joiWXVWB+abV/MyH9C19kuglLP24LIWOufQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178184; c=relaxed/simple;
	bh=AR4hcBfqQCQ+eVcxPK9y6wGNqn8NTOSiPgnkZc8zej8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tAZAPF+FgUGTSn1nvxN7gYELdxcnOkc6+Gp8EZV8e+KyWQ7ZgGZK9pCzACmxsqtBYR5yy3rYEFNb1NOlK69ym6mekm7fi5IoWhzILLTlQVF+LYL6A56iK6AhHCfNWS+NLjD/K2pE8VO8Z9A4AALba+7TTnapI+X2Pd8VyiJvTBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S5W/B746; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S5W/B746"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54702C4CEE7;
	Thu, 23 Oct 2025 00:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178184;
	bh=AR4hcBfqQCQ+eVcxPK9y6wGNqn8NTOSiPgnkZc8zej8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=S5W/B7466vR/ecnWSettvCVCzM38Y7F0DxkRgeczRiFk96tEsEuPKOYzid3upWljz
	 CHNrXRiLvZFOSLrXMRgnCG6s1ZroHam5AdTHBfYvdozrP6+LgpISOKyzhItANaOf9C
	 jkvauk/ziixXeR0k8UrpKGzaff609jAES2kAIegwQeUEwBdZPTnYYv76fZDysOQEMl
	 ROpZ8Nxo2E3RaYVB9VbCXwrsWsOCoc2whI985zi46dzGuDk/D6I4T2s1nrfDMUNs4l
	 6v/XCcBVue/zSVvm7VwTUjS+6x8zpbapXWluiEEeGWFbmN4/5jrGqk0pPZXrDGltB7
	 lq+yjfVuTC/Lg==
Date: Wed, 22 Oct 2025 17:09:43 -0700
Subject: [PATCH 16/26] xfs_healer: use getparents to look up file names
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117747768.1028044.17742053640587321558.stgit@frogsfrogsfrogs>
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

If the kernel tells about something that happened to a file, use the
GETPARENTS ioctl to try to look up the path to that file for more
ergonomic reporting.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/xfs_healer.py.in |  248 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 242 insertions(+), 6 deletions(-)


diff --git a/healer/xfs_healer.py.in b/healer/xfs_healer.py.in
index 5098193bb86ac9..5ed2198a0c1687 100644
--- a/healer/xfs_healer.py.in
+++ b/healer/xfs_healer.py.in
@@ -21,6 +21,7 @@ import gc
 from concurrent.futures import ProcessPoolExecutor
 import ctypes.util
 from enum import Enum
+import collections
 
 try:
 	# Not all systems will have this json schema validation libarary,
@@ -182,12 +183,18 @@ class xfs_handle(ctypes.Structure):
 assert ctypes.sizeof(xfs_handle) == 24
 
 class fshandle(object):
-	def __init__(self, fd, mountpoint):
+	def __init__(self, fd, mountpoint = None):
 		global libhandle
 		global printf_prefix
 
 		self.handle = xfs_handle()
 
+		if isinstance(fd, fshandle):
+			# copy an existing fshandle
+			self.mountpoint = fd.mountpoint
+			ctypes.pointer(self.handle)[0] = fd.handle
+			return
+
 		if mountpoint is None:
 			raise Exception(_('fshandle needs a mountpoint'))
 
@@ -249,6 +256,11 @@ class fshandle(object):
 		libhandle.free_handle(buf, buflen)
 		return fd
 
+	def subst(self, ino, gen):
+		'''Substitute the inode and generation components of a handle.'''
+		self.handle.ha_fid.fid_ino = ino
+		self.handle.ha_fid.fid_gen = gen
+
 def libhandle_load():
 	'''Load libhandle and set things up.'''
 	global libhandle
@@ -455,6 +467,170 @@ def xfs_has_rmapbt(fd):
 	fcntl.ioctl(fd, XFS_IOC_FSGEOMETRY, arg)
 	return arg.flags & XFS_FSOP_GEOM_FLAGS_RMAPBT != 0
 
+# getparents ioctl
+class xfs_attrlist_cursor(ctypes.Structure):
+	_fields_ = [
+		("_opaque0",		ctypes.c_uint),
+		("_opaque1",		ctypes.c_uint),
+		("_opaque2",		ctypes.c_uint),
+		("_opaque3",		ctypes.c_uint)
+	]
+
+class xfs_getparents_rec(ctypes.Structure):
+	_fields_ = [
+		("gpr_parent",		xfs_handle),
+		("gpr_reclen",		ctypes.c_uint),
+		("_gpr_reserved",	ctypes.c_uint),
+	]
+
+xfs_getparents_tuple = collections.namedtuple('xfs_getparents_tuple', \
+		['gpr_parent', 'gpr_reclen', 'gpr_name'])
+
+class xfs_getparents_rec_array(object):
+	def __init__(self, nr_bytes):
+		self.nr_bytes = nr_bytes
+		self.bytearray = (ctypes.c_byte * int(nr_bytes))()
+
+	def __slice_to_record(self, bufslice):
+		'''Compute the number of bytes in a getparents record that contain a null-terminated directory entry name.'''
+		rec = ctypes.cast(bytes(bufslice), \
+				ctypes.POINTER(xfs_getparents_rec))
+		fixedlen = ctypes.sizeof(xfs_getparents_rec)
+		namelen = rec.contents.gpr_reclen - fixedlen
+
+		for i in range(0, namelen):
+			if bufslice[fixedlen + i] == 0:
+				namelen = i
+				break
+
+		if namelen == 0:
+			return
+
+		return xfs_getparents_tuple(
+				gpr_parent = rec.contents.gpr_parent,
+				gpr_reclen = rec.contents.gpr_reclen,
+				gpr_name = bufslice[fixedlen:fixedlen + namelen])
+
+	def get_buffer(self):
+		'''Return a pointer to the bytearray masquerading as an int.'''
+		return ctypes.addressof(self.bytearray)
+
+	def __iter__(self):
+		'''Walk the getparents records in this array.'''
+		off = 0
+		nr = 0
+		buf = bytes(self.bytearray)
+		while off < self.nr_bytes:
+			bufslice = buf[off:]
+			t = self.__slice_to_record(bufslice)
+			if t is None:
+				break
+			yield t
+			off += t.gpr_reclen
+			nr += 1
+
+class xfs_getparents(ctypes.Structure):
+	_fields_ = [
+		("_gp_cursor",		xfs_attrlist_cursor),
+		("gp_iflags",		ctypes.c_ushort),
+		("gp_oflags",		ctypes.c_ushort),
+		("gp_bufsize",		ctypes.c_uint),
+		("_pad",		ctypes.c_ulonglong),
+		("gp_buffer",		ctypes.c_ulonglong)
+	]
+
+	def __init__(self, fd, nr_bytes):
+		self.fd = fd
+		self.records = xfs_getparents_rec_array(nr_bytes)
+		self.gp_buffer = self.records.get_buffer()
+		self.gp_bufsize = nr_bytes
+
+	def __call_kernel(self):
+		if self.gp_oflags & XFS_GETPARENTS_OFLAG_DONE:
+			return False
+
+		ret = fcntl.ioctl(self.fd, XFS_IOC_GETPARENTS, self)
+		if ret != 0:
+			return False
+
+		return self.gp_oflags & XFS_GETPARENTS_OFLAG_ROOT == 0
+
+	def __iter__(self):
+		ctypes.memset(ctypes.pointer(self._gp_cursor), 0, \
+				ctypes.sizeof(xfs_attrlist_cursor))
+
+		while self.__call_kernel():
+			for i in self.records:
+				yield i
+
+class xfs_getparents_by_handle(ctypes.Structure):
+	_fields_ = [
+		("gph_handle",		xfs_handle),
+		("gph_request",		xfs_getparents)
+	]
+
+	def __init__(self, fd, fh, nr_bytes):
+		self.fd = fd
+		self.records = xfs_getparents_rec_array(nr_bytes)
+		self.gph_request.gp_buffer = self.records.get_buffer()
+		self.gph_request.gp_bufsize = nr_bytes
+		self.gph_handle = fh.handle
+
+	def __call_kernel(self):
+		if self.gph_request.gp_oflags & XFS_GETPARENTS_OFLAG_DONE:
+			return False
+
+		ret = fcntl.ioctl(self.fd, XFS_IOC_GETPARENTS_BY_HANDLE, self)
+		if ret != 0:
+			return False
+
+		return self.gph_request.gp_oflags & XFS_GETPARENTS_OFLAG_ROOT == 0
+
+	def __iter__(self):
+		ctypes.memset(ctypes.pointer(self.gph_request._gp_cursor), 0, \
+				ctypes.sizeof(xfs_attrlist_cursor))
+		while self.__call_kernel():
+			for i in self.records:
+				yield i
+
+assert ctypes.sizeof(xfs_getparents) == 40
+assert ctypes.sizeof(xfs_getparents_by_handle) == 64
+assert ctypes.sizeof(xfs_getparents_rec) == 32
+
+XFS_GETPARENTS_OFLAG_ROOT	= 1 << 0
+XFS_GETPARENTS_OFLAG_DONE	= 1 << 1
+
+XFS_IOC_GETPARENTS		= _IOWR(0x58, 62, xfs_getparents)
+XFS_IOC_GETPARENTS_BY_HANDLE	= _IOWR(0x58, 63, xfs_getparents_by_handle)
+
+def fgetparents(fd, fh = None, bufsize = 1024):
+	'''Return all the parent pointers for a given fd and/or handle.'''
+
+	if fh is not None:
+		return xfs_getparents_by_handle(fd, fh, bufsize)
+	return xfs_getparents(fd, bufsize)
+
+def fgetpath(fd, fh = None, mountpoint = None):
+	'''Return a list of path components up to the root dir of the filesystem for a given fd.'''
+	ret = []
+	if fh is None:
+		nfh = fshandle(fd, mountpoint)
+	else:
+		# Don't subst into the caller's handle
+		nfh = fshandle(fh)
+
+	while True:
+		added = False
+		for pptr in fgetparents(fd, nfh):
+			ret.insert(0, pptr.gpr_name)
+			nfh.subst(pptr.gpr_parent.ha_fid.fid_ino, \
+				  pptr.gpr_parent.ha_fid.fid_gen)
+			added = True
+			break
+		if not added:
+			break
+	return ret
+
 # main program
 
 def health_reports(mon_fp):
@@ -479,14 +655,29 @@ def health_reports(mon_fp):
 				lines = []
 		buf = mon_fp.readline()
 
+def file_event_to_prefix(event):
+	'''Compute the logging prefix for this event.'''
+	global printf_prefix
+
+	if 'path' in event:
+		path = event['path']
+		return f"{printf_prefix}{os.sep}{path}:"
+
+	inumber = event['inumber']
+	igen = event['generation']
+	inom = _("ino")
+	igenm = _("gen")
+	return f"{printf_prefix}: {inom} {inumber} {igenm} {igen:#x}"
+
 def report_event(event):
 	'''Log a monitoring event to stdout.'''
 	global printf_prefix
 
 	if event['domain'] == 'inode':
+		prefix = file_event_to_prefix(event)
 		structures = ', '.join([_(x) for x in event['structures']])
 		status = _(event['type'])
-		printlogln(f"{printf_prefix}: {structures} {status}")
+		printlogln(f"{prefix} {structures} {status}")
 
 	elif event['domain'] == 'perag':
 		structures = ', '.join([_(x) for x in event['structures']])
@@ -517,12 +708,13 @@ def report_event(event):
 		printlogln(f"{printf_prefix}: {msg} {device} {daddrm} {daddr:#x} {bbcountm} {bbcount:#x}")
 
 	elif event['domain'] == 'filerange':
+		prefix = file_event_to_prefix(event)
 		event_type = _(event['type'])
 		pos = event['pos']
 		length = event['length']
 		posm = _("pos")
 		lenm = _("len")
-		printlogln(f"{printf_prefix}: {event_type} {posm} {pos} {lenm} {length}")
+		printlogln(f"{prefix} {event_type} pos {pos} len {length}")
 
 def report_lost(event):
 	'''Report that the kernel lost events.'''
@@ -571,6 +763,40 @@ def report_shutdown(event):
 def handle_event(lines, fh):
 	'''Handle an event asynchronously.'''
 	global log
+	global has_parent
+
+	def pathify_event(event, fh):
+		'''Come up with a directory tree path for a file event.'''
+		try:
+			path_fd = fh.reopen()
+		except Exception as e:
+			# Not the end of the world if we get nothing
+			return
+
+		try:
+			fh2 = fshandle(fh)
+		except OSError as e:
+			if e.errno != errno.EOPNOTSUPP:
+				msg = _("making new file handle")
+				eprintln(f'{printf_prefix}: {msg}: {e}')
+			os.close(path_fd)
+			return
+		except Exception as e:
+			# Not the end of the world if we get nothing
+			os.close(path_fd)
+			return
+
+		try:
+			fh2.subst(event['inumber'], event['generation'])
+			components = [x.decode('utf-8') for x in fgetpath(path_fd, fh2)]
+			event['path'] = os.sep.join(components)
+		except Exception as e:
+			# Path walking might be unavailable if the directory
+			# tree is corrupt.  Since this is optional, we don't
+			# report anything.
+			pass
+		finally:
+			os.close(path_fd)
 
 	# Convert array of strings into a json object
 	try:
@@ -605,13 +831,21 @@ def handle_event(lines, fh):
 		return
 
 	# Deal with everything else.
+	maybe_pathify = event['domain'] in ('inode', 'filerange') and has_parent
 	if log:
+		if maybe_pathify and not debug_fast:
+			pathify_event(event, fh)
+			maybe_pathify = False
+
 		try:
 			report_event(event)
 		except Exception as e:
 			eprintln(f"event reporting: {e}")
 
 	if want_repair and event['type'] == 'sick':
+		if maybe_pathify:
+			pathify_event(event, fh)
+
 		repair_metadata(event, fh)
 
 def monitor(mountpoint, event_queue, **kwargs):
@@ -670,7 +904,7 @@ def monitor(mountpoint, event_queue, **kwargs):
 			printlogln(f"{mountpoint}: {msg}")
 
 	try:
-		fh = fshandle(fd, mountpoint) if want_repair else None
+		fh = fshandle(fd, mountpoint) if want_repair or has_parent else None
 	except Exception as e:
 		eprintln(f"{mountpoint}: {e}")
 		os.close(fd)
@@ -779,6 +1013,8 @@ def repair_group(event, fd, group_type):
 
 def repair_inode(event, fd):
 	'''React to a inode-domain corruption event by repairing it.'''
+	prefix = file_event_to_prefix(event)
+
 	for structure in event['structures']:
 		struct = _(structure)
 		scrub_type = __scrub_type(structure)
@@ -789,9 +1025,9 @@ def repair_inode(event, fd):
 				      event['inumber'], event['generation'])
 			outcome = RepairOutcome.from_oflags(oflags)
 			report = outcome.report()
-			printlogln(f"{printf_prefix}: {struct}: {report}")
+			printlogln(f"{prefix} {structure}: {report}")
 		except Exception as e:
-			eprintln(f"{printf_prefix}: {struct}: {e}")
+			eprintln(f"{prefix} {structure}: {e}")
 
 def repair_metadata(event, fh):
 	'''Repair a metadata corruption.'''

