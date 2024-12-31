Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C7229415
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735689098; cv=none; b=NBG3hY5RRmz32Afm/LKTrHv5ax4+dkOqHug3A5O57nPHlMv33Gbg+FoevJ++BfFMeIFrt6pHFGiOB74sCpKFoW7BGMkxFigN177W9D0/XXY4CSiRqI7V7yewV+Do19M3tZ7cT+yHvI6jA2kYE2jbFB+FpheRg51zMRoFbQPBqMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735689098; c=relaxed/simple;
	bh=l+oO4mt446s0+HcpIOPO7+yiBqbcvwjSBBpKjTBtokQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pJdpLPz5y1U17F4Xl9UPdM4PIjh8k+jOEPVDpCMgGWHFdoigtj21ogT0v5rhu9uMWp7bIf26M1OjXA4/WaTIk3UMH0FbYfE3xsYWeyh0xM6PDtSFqpjyj6MeQEzoMX4oQtHOmYJJTvJXGChXoJETvPecX33UYcTCN2yrl2ms7lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ufdLMi4H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ufdLMi4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2781C4CED2;
	Tue, 31 Dec 2024 23:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735689097;
	bh=l+oO4mt446s0+HcpIOPO7+yiBqbcvwjSBBpKjTBtokQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ufdLMi4HhBaO9V3blUOSrcxXXiFG1VUZCeML4RDnm1IbtIDdoABq6U5jqFwzQRCpd
	 48h+9QUpk5PZ+jZNdBP1mQdKqhf9hsiaTPHItVLhJB/V+CdA8aEeQpGxAVbhnwZfl3
	 SUZYXZaxzXBVo89AVtmu3thgFyfXmLAdp4J/IAPEoM25UR7cddQXXfr5U2Q6njyO6y
	 SCrXrgV46VXAMVEVGqjupWCVRXn34j0xAAgZEV/fW1RGxDR0pn+rrUxEyZtwkt1QAb
	 Xw5wYx4nZCEzB5sTl5OzW9W2IO8f7ZlgV/5xw1BKNshVw8ssZE7XsZUkLEVpZzRPV1
	 kwVvnkZov1S6g==
Date: Tue, 31 Dec 2024 15:51:37 -0800
Subject: [PATCH 15/21] xfs_scrubbed: use getparents to look up file names
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568778691.2710211.10922863184869748991.stgit@frogsfrogsfrogs>
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

If the kernel tells about something that happened to a file, use the
GETPARENTS ioctl to try to look up the path to that file for more
ergonomic reporting.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/xfs_scrubbed.in |  235 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 230 insertions(+), 5 deletions(-)


diff --git a/scrub/xfs_scrubbed.in b/scrub/xfs_scrubbed.in
index 25465128864583..a4e073b3098f7a 100644
--- a/scrub/xfs_scrubbed.in
+++ b/scrub/xfs_scrubbed.in
@@ -18,6 +18,7 @@ import ctypes
 import gc
 from concurrent.futures import ProcessPoolExecutor
 import ctypes.util
+import collections
 
 try:
 	# Not all systems will have this json schema validation libarary,
@@ -171,12 +172,18 @@ class xfs_handle(ctypes.Structure):
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
 			raise Exception('fshandle needs a mountpoint')
 
@@ -233,6 +240,11 @@ class fshandle(object):
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
@@ -396,6 +408,170 @@ def xfs_has_rmapbt(fd):
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
 
 def health_reports(mon_fp, fh):
@@ -429,11 +605,23 @@ def health_reports(mon_fp, fh):
 			lines = []
 		buf = mon_fp.readline()
 
+def inode_printf_prefix(event):
+	'''Compute the logging prefix for this event.'''
+	global printf_prefix
+
+	if 'path' not in event:
+		return printf_prefix
+
+	if printf_prefix.endswith(os.sep):
+		return f"{printf_prefix}{event['path']}"
+
+	return f"{printf_prefix}{os.sep}{event['path']}"
+
 def log_event(event):
 	'''Log a monitoring event to stdout.'''
 	global printf_prefix
 
-	print(f"{printf_prefix}: {event}")
+	print(f"{inode_printf_prefix(event)}: {event}")
 	sys.stdout.flush()
 
 def report_lost(event):
@@ -480,6 +668,39 @@ def handle_event(e):
 
 	global log
 	global repair_queue
+	global has_parent
+
+	def pathify_event(event, fh):
+		'''Come up with a directory tree path for a file event.'''
+		try:
+			path_fd = fh.open()
+		except Exception as e:
+			# Not the end of the world if we get nothing
+			if e.errno != errno.EOPNOTSUPP and e.errno != errno.ENOTTY:
+				print(f'{printf_prefix}: opening file handle: {e}', file = sys.stderr)
+			return
+
+		try:
+			fh2 = fshandle(fh)
+		except OSError as e:
+			if e.errno != errno.EOPNOTSUPP:
+				print(f'{printf_prefix}: making new file handle: {e}', file = sys.stderr)
+			os.close(path_fd)
+			return
+		except Exception as e:
+			print(f'{printf_prefix}: making new file handle: {e}', file = sys.stderr)
+			os.close(path_fd)
+			return
+
+		try:
+			fh2.subst(event['inumber'], event['generation'])
+			components = [x.decode('utf-8') for x in fgetpath(path_fd, fh2)]
+			event['path'] = os.sep.join(components)
+		except OSError as e:
+			if e.errno != errno.EOPNOTSUPP:
+				print(f'{printf_prefix}: constructing path: {e}', file = sys.stderr)
+		finally:
+			os.close(path_fd)
 
 	# Use a separate subprocess to handle the repairs so that the event
 	# processing worker does not block on the GIL of the repair workers.
@@ -498,6 +719,8 @@ def handle_event(e):
 		return
 
 	stringify_timestamp(event)
+	if event['domain'] == 'inode' and has_parent and not debug_fast:
+		pathify_event(event, fh)
 	if log:
 		log_event(event)
 	if event['type'] == 'lost':
@@ -536,7 +759,7 @@ def monitor(mountpoint, event_queue, **kwargs):
 	sys.stdout.flush()
 
 	try:
-		if want_repair:
+		if want_repair or has_parent:
 			fh = fshandle(fd, mountpoint)
 		mon_fd = open_health_monitor(fd, verbose = everything)
 	except OSError as e:
@@ -653,6 +876,8 @@ def repair_group(event, fd, group_type):
 
 def repair_inode(event, fd):
 	'''React to a inode-domain corruption event by repairing it.'''
+	ipp = inode_printf_prefix(event)
+
 	for s in event['structures']:
 		type = __scrub_type(s)
 		if type is None:
@@ -660,10 +885,10 @@ def repair_inode(event, fd):
 		try:
 			oflags = xfs_repair_inode_metadata(fd, type,
 				      event['inumber'], event['generation'])
-			print(f"{printf_prefix}: {s}: {report_outcome(oflags)}")
+			print(f"{ipp}: {s}: {report_outcome(oflags)}")
 			sys.stdout.flush()
 		except Exception as e:
-			print(f"{printf_prefix}: {s}: {e}", file = sys.stderr)
+			print(f"{ipp}: {s}: {e}", file = sys.stderr)
 
 def repair_metadata(event, fh):
 	'''Repair a metadata corruption.'''

