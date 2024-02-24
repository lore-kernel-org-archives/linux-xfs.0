Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A78625
	for <linux-xfs@vger.kernel.org>; Sat, 24 Feb 2024 01:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708738545; cv=none; b=b2FhjB750G0vgqARGY/6+QmbWtV0rw9ZQ/6rOneB66yDDeuI2KPwoEjBAPOUH5mK/OSJzoyb/Tjl75COFmbIgRPfHxLbfmiCpxCYCAGLDYYUdOlAqZFAS5X/PNEqxU1KTNVT385gE3w/JAco1+himXz78QeFno1IeGnRcSlLyJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708738545; c=relaxed/simple;
	bh=1Jd7+5jj0i5e+64xlaTWMyHh5Zb2qyWyWN991Taamz8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UNLNst84qOpVlQeBJ44Hy0AQjg3e1+lKD3v/xXQo5FkeCF1CX7CZt91nwpN7TxYyG1azANRxSOJAfnFF22V/hskaJsgJPQbC39KWn3NVrfU5HcF57y2izL/Zjr7Y8tvcMEI4FE6+J1gBPx2Bg7IIWPPXx931xsseQw11LwqjZ0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u5rCXvB/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u5rCXvB/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2842C433C7;
	Sat, 24 Feb 2024 01:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708738544;
	bh=1Jd7+5jj0i5e+64xlaTWMyHh5Zb2qyWyWN991Taamz8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=u5rCXvB/5/r00GDdeCTETjWc8K91hFLBP5xDZGr/AVy2q4CF4Nc4m9GSn6kZtr0RH
	 /vc/OcsNOTuKm5OIK+m7UZb9YkwaaoBSeJpIFWbolpdtTtRgdHTuyYvvLa+5VxkWrD
	 6sMZPB4cZwqLEqVlVMKIMw8TRHl47CpOBzFAlFmA8h+O26laI58nTqBtig1s0FJvcn
	 J34p96yZT2FPhcUuL0oM+JXs3zD1gSfoHLxE44/mtyD1uYAyLGKzRPOSOduGQq+5LD
	 6z5m4slWOtLfh5ZoYNv04vnSvRGZG0HvpwhZuy6pV1WeH5WIAVQvr867YV6gUWCqSP
	 ODME0wAbBbnkQ==
Date: Fri, 23 Feb 2024 17:35:44 -0800
Subject: [PATCH 6/7] xfs_scrubbed: enable repairing filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, kent.overstreet@linux.dev, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170873836640.1902540.11585752615140112025.stgit@frogsfrogsfrogs>
In-Reply-To: <170873836546.1902540.13109376239205481967.stgit@frogsfrogsfrogs>
References: <170873836546.1902540.13109376239205481967.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrubbed.in |  300 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 297 insertions(+), 3 deletions(-)


diff --git a/scrub/xfs_scrubbed.in b/scrub/xfs_scrubbed.in
index 0c72f5c54a78..5458d39486bc 100644
--- a/scrub/xfs_scrubbed.in
+++ b/scrub/xfs_scrubbed.in
@@ -15,11 +15,16 @@ import struct
 import json
 import datetime
 import errno
+import ctypes
+import ctypes.util
 
 debug = False
 log = False
 everything = False
 printf_prefix = ''
+want_repair = False
+libhandle = None
+libc = None
 
 # ioctl encoding stuff
 _IOC_NRBITS   =  8
@@ -45,6 +50,9 @@ def _IOC(direction, type, nr, size):
 def _IOR(type, number, size):
 	return _IOC(_IOC_READ, type, number, size)
 
+def _IOWR(type, number, size):
+	return _IOC(_IOC_READ | _IOC_WRITE, type, number, size)
+
 # xfs health monitoring ioctl stuff
 XFS_HEALTH_MONITOR_FMT_JSON = 1
 XFS_HEALTH_MONITOR_VERBOSE = 1 << 0
@@ -69,6 +77,159 @@ def open_health_monitor(fd, verbose = False):
 	ret = fcntl.ioctl(fd, XFS_IOC_HEALTH_MONITOR, bytearray(arg))
 	return ret
 
+# libhandle stuff
+class xfs_weak_handle(object):
+	def __init__(self, fd, mountpoint):
+		global libhandle, printf_prefix
+
+		self.mountpoint = mountpoint
+		self.hanp = ctypes.c_void_p()
+		self.hlen = ctypes.c_size_t()
+		self.has_handle = False
+
+		# Create the file and fs handles for the open mountpoint
+		# so that we can compare them later
+		ret = libhandle.fd_to_handle(fd, self.hanp, self.hlen)
+		if ret != 0:
+			raise OSError(ctypes.get_errno(),
+					f"{printf_prefix}: cannot create handle")
+		self.has_handle = True
+
+	def __del__(self):
+		if self.has_handle:
+			libhandle.free_handle(self.hanp, self.hlen)
+
+	def open(self):
+		'''Reopen a file handle obtained via weak reference.'''
+		global libhandle, libc, printf_prefix
+
+		nhanp = ctypes.c_void_p()
+		nhlen = ctypes.c_size_t()
+
+		fd = os.open(self.mountpoint, os.O_RDONLY)
+
+		# Create the file and fs handles for the open mountpoint
+		# so that we can compare them later
+		ret = libhandle.fd_to_handle(fd, nhanp, nhlen)
+		if ret != 0:
+			raise OSError(ctypes.get_errno(),
+					f"{printf_prefix}: cannot resample handle")
+
+		# Did we get the same handle?
+		if nhlen.value != self.hlen.value or \
+		   libc.memcmp(self.hanp, nhanp, nhlen) != 0:
+			os.close(fd)
+			libhandle.free_handle(nhanp, nhlen)
+			raise OSError(errno.ENOENT,
+					f"{printf_prefix}: filesystem has changed")
+
+		libhandle.free_handle(nhanp, nhlen)
+		return fd
+
+def libc_load():
+	'''Load libc and set things up.'''
+	global libc
+
+	libc_name = ctypes.util.find_library("c")
+	libc = ctypes.cdll.LoadLibrary(libc_name)
+	libc.memcmp.argtypes = (
+			ctypes.c_void_p,
+			ctypes.c_void_p,
+			ctypes.c_size_t)
+	libc.errno
+
+def libhandle_load():
+	'''Load libhandle and set things up.'''
+	global libhandle
+
+	libhandle = ctypes.cdll.LoadLibrary('libhandle.so')
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
+xfs_scrub_metadata = struct.Struct('IIQII' + ('x' * 40))
+XFS_IOC_SCRUB_METADATA		= _IOWR(0x58, 60, xfs_scrub_metadata.size)
+
+def xfs_repair_fs_metadata(fd, type):
+	'''Call the kernel to repair some whole-fs metadata.'''
+	arg = bytearray(xfs_scrub_metadata.pack(type, XFS_SCRUB_IFLAG_REPAIR,
+					0, 0, 0))
+	fcntl.ioctl(fd, XFS_IOC_SCRUB_METADATA, arg)
+	return xfs_scrub_metadata.unpack(arg)[1]
+
+def xfs_repair_group_metadata(fd, type, group):
+	'''Call the kernel to repair some group metadata.'''
+	arg = bytearray(xfs_scrub_metadata.pack(type, XFS_SCRUB_IFLAG_REPAIR,
+					 0, 0, group))
+	fcntl.ioctl(fd, XFS_IOC_SCRUB_METADATA, bytearray(arg))
+	return xfs_scrub_metadata.unpack(arg)[1]
+
+def xfs_repair_inode_metadata(fd, type, ino, gen):
+	'''Call the kernel to repair some inode metadata.'''
+	arg = bytearray(xfs_scrub_metadata.pack(type, XFS_SCRUB_IFLAG_REPAIR,
+					 ino, gen, 0))
+	fcntl.ioctl(fd, XFS_IOC_SCRUB_METADATA, bytearray(arg))
+	return xfs_scrub_metadata.unpack(arg)[1]
+
 # main program
 
 def health_reports(mon_fp):
@@ -138,10 +299,12 @@ def report_shutdown(event):
 
 def monitor(mountpoint):
 	'''Monitor the given mountpoint for health events.'''
-	global log, everything
+	global log, printf_prefix, everything, want_repair
 
 	fd = os.open(mountpoint, os.O_RDONLY)
 	try:
+		if want_repair:
+			handle = xfs_weak_handle(fd, mountpoint)
 		mon_fd = open_health_monitor(fd, verbose = everything)
 	except OSError as e:
 		if e.errno != errno.ENOTTY:
@@ -150,7 +313,8 @@ def monitor(mountpoint):
 				file = sys.stderr)
 		return 1
 	finally:
-		# Close the mountpoint if opening the health monitor fails
+		# Close the mountpoint if opening the health monitor fails;
+		# the handle object will free its own memory.
 		os.close(fd)
 
 	# Ownership of mon_fd (and hence responsibility for closing it) is
@@ -170,11 +334,131 @@ def monitor(mountpoint):
 				report_lost(event)
 			elif event['type'] == 'shutdown':
 				report_shutdown(event)
+			elif want_repair and event['type'] == 'sick':
+				repair_metadata(event, handle)
 
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
+			print(f"{printf_prefix}: {e}", file = sys.stderr)
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
+			print(f"{printf_prefix}: {e}", file = sys.stderr)
+
+def repair_inode(event, fd):
+	'''React to a inode-domain corruption event by repairing it.'''
+	for s in event['structures']:
+		type = __scrub_type(s)
+		if type is None:
+			continue
+		try:
+			oflags = xfs_repair_inode_metadata(fd, type,
+				      event['inode'], event['generation'])
+			print(f"{printf_prefix}: {s}: {report_outcome(oflags)}")
+			sys.stdout.flush()
+		except Exception as e:
+			print(f"{printf_prefix}: {e}", file = sys.stderr)
+
+def repair_metadata(event, handle):
+	'''Repair a metadata corruption.'''
+	global debug, printf_prefix
+
+	if debug:
+		print(f'repair {event}')
+	fd = handle.open()
+
+	if event['domain'] in ['fs', 'realtime']:
+		repair_wholefs(event, fd)
+	elif event['domain'] in ['ag', 'rtgroup']:
+		repair_group(event, fd, event['domain'])
+	elif event['domain'] == 'inode':
+		repair_inode(event, fd)
+	else:
+		raise Exception(f"{printf_prefix}: Unknown metadata domain \"{event['domain']}\".")
+
+	os.close(fd)
+	return
+
 def main():
-	global debug, log, printf_prefix, everything
+	global debug, log, printf_prefix, everything, want_repair
 	ret = 0
 
 	parser = argparse.ArgumentParser( \
@@ -185,6 +469,8 @@ def main():
 			action = "store_true")
 	parser.add_argument("--everything", help = "Capture all events.", \
 			action = "store_true")
+	parser.add_argument("--repair", help = "Automatically repair corrupt metadata.", \
+			action = "store_true")
 	parser.add_argument("-V", help = "Report version and exit.", \
 			action = "store_true")
 	parser.add_argument('mountpoint', default = None, nargs = '?',
@@ -205,6 +491,14 @@ def main():
 		log = True
 	if args.everything:
 		everything = True
+	if args.repair:
+		try:
+			libc_load()
+			libhandle_load()
+			want_repair = True
+		except OSError as e:
+			print(e, file = sys.stderr)
+			sys.exit(1)
 
 	printf_prefix = args.mountpoint
 	try:

