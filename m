Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7895679F2
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178278; cv=none; b=N4D1MZF8HndbNEhrVbRhx+WjQCIVNfjCQP9T0778r0NY8NopFqILGta2dwJhQuBJ/s/cLfWI73DsmG4E5eLGnakDRKztyBLwSgYz6L0gxqfUzMUvJhShwIa1spxSOFBNorM8izNNZMN2b13NfPhy2sS/A+eURJRaUbR0xnc59Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178278; c=relaxed/simple;
	bh=8AOvR1GwHOx8bHbpqLfkxSf5hkoJSO0UmODUhypuIGA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X4oWSFwnRkT23MF54pezpTkiFctItk4FebkKHCVa3Q2OXDB13KoU6BxnIBerTwiOuc/utvxj8G75EXzwk3wwelX+cYLuerFKw0Sx2YgsZWGjKothV7Uv3BcKrQJkkMmU7eGLPXJB0sAU/yIAGrLo4mBGrZ7alMBeQfQgbQDzNsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mlurJ2vy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mlurJ2vy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502EFC4CEE7;
	Thu, 23 Oct 2025 00:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178278;
	bh=8AOvR1GwHOx8bHbpqLfkxSf5hkoJSO0UmODUhypuIGA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mlurJ2vyQ2bBCESgWztXQyoRWmpfA1n6xgymNsysoOtZhj88MQ5uFjBqKt/A+eIAV
	 xgMvYTOmg/5Rp26kWzkUqsrqz6QRiJGdqmvgjq8jY/hD6skt2Uj1qUEFF8dPIqTT/Y
	 I3Db2URYwdIFoIgk5OAL8plOakgOQ+cCr78HVFSNiBv4e59qN9ugEclSQjRpWs0q1v
	 EhfNYy25pbI3lFqnH8RnFAaWkzspccjiOxPvNE7R/YDZgNeSsMwAxWq6O+UPveIGwq
	 ICcxUqbjNICK5M+L4WXtEsXZaV9M0HIQq8YqNr8R+J+SMila22Ge3KlVnRPjFSoL/T
	 H7gxKskIXSrAA==
Date: Wed, 22 Oct 2025 17:11:17 -0700
Subject: [PATCH 22/26] xfs_healer: use getmntent to find moved filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117747880.1028044.1705735508736088709.stgit@frogsfrogsfrogs>
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

Wrap the libc getmntent function in an iterator.  This enables
xfs_healer to record the fsname (or fs spec) of the mountpoint that it's
running against, and use that fsname to walk /proc/mounts to re-find the
filesystem if the mount has moved elsewhere if it needs to open the fs
to perform repairs.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/xfs_healer.py.in |  117 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 114 insertions(+), 3 deletions(-)


diff --git a/healer/xfs_healer.py.in b/healer/xfs_healer.py.in
index a96c9e812f5791..fac7df9d741cb0 100644
--- a/healer/xfs_healer.py.in
+++ b/healer/xfs_healer.py.in
@@ -80,6 +80,7 @@ want_repair = False
 has_parent = False
 has_rmapbt = False
 libhandle = None
+libc = None
 
 def printlogln(*args, **kwargs):
 	'''Print a log message to stdout and flush it.'''
@@ -184,6 +185,16 @@ class xfs_handle(ctypes.Structure):
 	]
 assert ctypes.sizeof(xfs_handle) == 24
 
+def find_xfs_dev(mountpoint):
+	'''Find the xfs device for a particular mount point or raise exception.'''
+
+	for mnt in some_mount_entries(
+			lambda mnt: mnt.type == 'xfs' and \
+				    mnt.dir == mountpoint):
+		return mnt.fsname
+
+	raise Exception(_('Cannot find xfs device'))
+
 class fshandle(object):
 	def __init__(self, fd, mountpoint = None):
 		global libhandle
@@ -193,6 +204,7 @@ class fshandle(object):
 
 		if isinstance(fd, fshandle):
 			# copy an existing fshandle
+			self.fsname = fd.fsname
 			self.mountpoint = fd.mountpoint
 			ctypes.pointer(self.handle)[0] = fd.handle
 			return
@@ -201,6 +213,7 @@ class fshandle(object):
 			raise Exception(_('fshandle needs a mountpoint'))
 
 		self.mountpoint = mountpoint
+		self.fsname = find_xfs_dev(mountpoint)
 
 		# Create the file and fs handles for the open mountpoint
 		# so that we can compare them later
@@ -222,15 +235,16 @@ class fshandle(object):
 		hanp = ctypes.cast(buf, ctypes.POINTER(xfs_handle))
 		self.handle = hanp.contents
 
-	def reopen(self):
-		'''Reopen a file handle obtained via weak reference.'''
+	def reopen_from(self, mountpoint):
+		'''Reopen a file handle obtained via weak reference, using
+		a specific mount point.'''
 		global libhandle
 		global printf_prefix
 
 		buf = ctypes.c_void_p()
 		buflen = ctypes.c_size_t()
 
-		fd = os.open(self.mountpoint, os.O_RDONLY)
+		fd = os.open(mountpoint, os.O_RDONLY)
 
 		# Create the file and fs handles for the open mountpoint
 		# so that we can compare them later
@@ -258,6 +272,26 @@ class fshandle(object):
 		libhandle.free_handle(buf, buflen)
 		return fd
 
+	def reopen(self):
+		'''Reopen a file handle obtained via weak reference.'''
+
+		# First try the original mountpoint
+		try:
+			return self.reopen_from(self.mountpoint)
+		except Exception as e:
+			# Now scan /proc/self/mounts for any other bind mounts
+			# of this filesystem
+			for mnt in some_mount_entries(
+					lambda mnt: mnt.type == 'xfs' and \
+						    mnt.fsname == self.fsname):
+				try:
+					return self.reopen_from(mnt.dir)
+				except:
+					pass
+
+			# Return original error
+			raise e
+
 	def subst(self, ino, gen):
 		'''Substitute the inode and generation components of a handle.'''
 		self.handle.ha_fid.fid_ino = ino
@@ -302,6 +336,77 @@ def libhandle_load():
 			ctypes.c_void_p,
 			ctypes.c_size_t)
 
+class libc_mntent(ctypes.Structure):
+	_fields_ = [
+		("mnt_fsname",	ctypes.c_char_p),
+		("mnt_dir",	ctypes.c_char_p),
+		("mnt_type",	ctypes.c_char_p),
+		("mnt_opts",	ctypes.c_char_p),
+		("mnt_freq",	ctypes.c_int),
+		("mnt_passno",	ctypes.c_int),
+	]
+
+class MountEntry(object):
+	'''Description of a mounted filesystem.'''
+	def __init__(self, fsname, dir, type, opts):
+		self.fsname = fsname
+		self.dir = pathlib.Path(dir.decode('utf-8'))
+		self.type = type.decode('utf-8')
+		self.opts = opts
+
+def mount_entries():
+	'''Iterate all mounted filesystems in the system.'''
+	try:
+		fp = libc.setmntent(b"/proc/self/mounts", b"r")
+		mntbuf = libc_mntent()
+		namebuflen = 4096
+		namebuf = ctypes.create_string_buffer(namebuflen)
+		mnt = libc.getmntent_r(fp, mntbuf, namebuf, namebuflen);
+		while mnt:
+			yield MountEntry(mnt.contents.mnt_fsname,
+					 mnt.contents.mnt_dir,
+					 mnt.contents.mnt_type,
+					 mnt.contents.mnt_opts)
+			mnt = libc.getmntent_r(fp, mntbuf, namebuf, namebuflen);
+	finally:
+		libc.endmntent(fp);
+
+def some_mount_entries(filter_fn):
+	'''Iterate some of the mounted filesystems in the system.'''
+	return filter(filter_fn, mount_entries())
+
+def libc_load():
+	'''Load libc and set things up.'''
+	global libc
+
+	soname = ctypes.util.find_library('c')
+	if soname is None:
+		errstr = os.strerror(errno.ENOENT)
+		msg = _("while finding library")
+		raise OSError(errno.ENOENT, f'{msg}: {errstr}', 'libc')
+
+	libc = ctypes.CDLL(soname, use_errno = True)
+
+	libc.setmntent.argtypes = (
+			ctypes.c_char_p,
+			ctypes.c_char_p)
+	libc.setmntent.restype = ctypes.c_void_p
+
+	libc.getmntent_r.argtypes = (
+			ctypes.c_void_p,
+			ctypes.POINTER(libc_mntent),
+			ctypes.POINTER(ctypes.c_char),
+			ctypes.c_int)
+	libc.getmntent_r.restype = ctypes.POINTER(libc_mntent)
+
+	libc.getmntent.argtypes = (
+			ctypes.c_void_p,)
+	libc.getmntent.restype = ctypes.POINTER(libc_mntent)
+
+	libc.endmntent.argtypes = (
+			ctypes.c_void_p,)
+	libc.endmntent.restype = ctypes.c_int
+
 # metadata scrubbing stuff
 XFS_SCRUB_TYPE_PROBE		= 0
 XFS_SCRUB_TYPE_SB		= 1
@@ -1244,6 +1349,12 @@ def main():
 	if not validator_fn:
 		return 1
 
+	try:
+		libc_load()
+	except OSError as e:
+		eprintln(f"libc: {e}")
+		return 1
+
 	try:
 		libhandle_load()
 	except OSError as e:

