Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E49179F2
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178294; cv=none; b=kO+K6+yzpYJhprACxtgOUW2pOy/Jvf50++Tc8EJiSyBw8sbkT4qDRkWiU4ywOr5U1Cf2/lb4dtKQJBE6lFkU2Ycg2v9w1NGXCGIFaaF0kTGTJZKTWMCFYHC4jRu/nJCKExEKXx4R39DjIjY9gnk3ODeDfKYnSDVL2RFVktNBJwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178294; c=relaxed/simple;
	bh=5khURQ+DP0yUIiJslAzAG6DBZoGEGP+vx/7RIEz8oOY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=daEE5MUnVrcQMUxm/I5eLG6qLmK3B1NdNzLA7opM8E7mFADkFNN7Lw2otfCs4+PsbSW1pdZZSjhoCNTaG2qeBQHUczqrqBCKthCCrk11FgVYLyTnfE2tfwtAWsovHsNSjWy6Q5b+1vzJ8oeY+8KnAT0yL8jYe5pV5NJwgOXCCls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UVfICYfk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UVfICYfk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9CE4C4CEE7;
	Thu, 23 Oct 2025 00:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178294;
	bh=5khURQ+DP0yUIiJslAzAG6DBZoGEGP+vx/7RIEz8oOY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UVfICYfkNRsQ71Kr0Debj/Z0TGih/KwMQ0Osxez6rGn4ygDDHAiWfi32MoZu2/CCf
	 hG8tQ/4ZZfWT3+FV0GwhI+eZqdNFwLHf0qyKmZmUBA7I/PzKVTdxSK09szhEBSnlDv
	 5sEmhUVB9eWaGbpdNro+6Vj29dXtKExO3jgdJ3AYIAo7cQw4TrJERzQozZXKOctNbZ
	 O/zgNdRaESxK1W01zv77euYK01U+j8HzlX5Yo+salJhbDEtugPbUtCbQ1YBrDYozCH
	 WtqvwrzAZnW4lR3KmUVq3tUL7GmVUhEB1NhGH+IbtVZNXsD/5P6duVp6OcwLuw8RsG
	 3e9zeCp+d7PIA==
Date: Wed, 22 Oct 2025 17:11:33 -0700
Subject: [PATCH 23/26] xfs_healer: validate that repair fds point to the
 monitored fs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117747899.1028044.10768971355033550.stgit@frogsfrogsfrogs>
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

When xfs_healer reopens a mountpoint to perform a repair, it should
validate that the opened fd points to a file on the same filesystem as
the one being monitored.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/xfs_healer.py.in |   53 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 41 insertions(+), 12 deletions(-)


diff --git a/healer/xfs_healer.py.in b/healer/xfs_healer.py.in
index fac7df9d741cb0..ea7f1bb5ab45bc 100644
--- a/healer/xfs_healer.py.in
+++ b/healer/xfs_healer.py.in
@@ -163,6 +163,28 @@ def open_health_monitor(fd, verbose = False):
 	ret = fcntl.ioctl(fd, XFS_IOC_HEALTH_MONITOR, arg)
 	return ret
 
+class xfs_health_samefs(ctypes.Structure):
+	_fields_ = [
+		('fd',		ctypes.c_int),
+		('flags',	ctypes.c_uint),
+	]
+assert ctypes.sizeof(xfs_health_samefs) == 8
+
+XFS_IOC_HEALTH_SAMEFS = _IOW(0x58, 69, xfs_health_samefs)
+
+def is_same_fs(mon_fd, fd):
+	'''Does fd point to the same filesystem as the monitor fd?'''
+	arg = xfs_health_samefs()
+	arg.fd = fd
+	arg.flags = 0
+
+	try:
+		fcntl.ioctl(mon_fd, XFS_IOC_HEALTH_SAMEFS, arg)
+	except OSError as e:
+		# any error means this isn't the right fs mount
+		return False
+	return True
+
 # libhandle stuff
 class xfs_fsid(ctypes.Structure):
 	_fields_ = [
@@ -235,7 +257,7 @@ class fshandle(object):
 		hanp = ctypes.cast(buf, ctypes.POINTER(xfs_handle))
 		self.handle = hanp.contents
 
-	def reopen_from(self, mountpoint):
+	def reopen_from(self, mountpoint, is_acceptable):
 		'''Reopen a file handle obtained via weak reference, using
 		a specific mount point.'''
 		global libhandle
@@ -261,7 +283,8 @@ class fshandle(object):
 
 		# Did we get the same handle?
 		if buflen.value != ctypes.sizeof(xfs_handle) or \
-		   bytes(hanp.contents) != bytes(self.handle):
+		   bytes(hanp.contents) != bytes(self.handle) or \
+		   not is_acceptable(fd):
 			os.close(fd)
 			libhandle.free_handle(buf, buflen)
 			msg = _("reopening")
@@ -270,14 +293,15 @@ class fshandle(object):
 					printf_prefix)
 
 		libhandle.free_handle(buf, buflen)
+
 		return fd
 
-	def reopen(self):
+	def reopen(self, is_acceptable = lambda x: True):
 		'''Reopen a file handle obtained via weak reference.'''
 
 		# First try the original mountpoint
 		try:
-			return self.reopen_from(self.mountpoint)
+			return self.reopen_from(self.mountpoint, is_acceptable)
 		except Exception as e:
 			# Now scan /proc/self/mounts for any other bind mounts
 			# of this filesystem
@@ -285,7 +309,8 @@ class fshandle(object):
 					lambda mnt: mnt.type == 'xfs' and \
 						    mnt.fsname == self.fsname):
 				try:
-					return self.reopen_from(mnt.dir)
+					return self.reopen_from(mnt.dir,
+							is_acceptable)
 				except:
 					pass
 
@@ -893,7 +918,7 @@ def report_shutdown(event):
 	msg = _("filesystem shut down due to")
 	printlogln(f"{printf_prefix}: {msg} {some_reasons}")
 
-def handle_event(lines, fh, everything):
+def handle_event(lines, fh, everything, mon_fd):
 	'''Handle an event asynchronously.'''
 	global log
 	global has_parent
@@ -981,7 +1006,7 @@ def handle_event(lines, fh, everything):
 		if maybe_pathify:
 			pathify_event(event, fh)
 
-		repair_metadata(event, fh)
+		repair_metadata(event, fh, mon_fd)
 
 def check_monitor(mountpoint, fd):
 	'''Check if the kernel can send us health events for the given mountpoint.'''
@@ -1045,7 +1070,7 @@ def monitor(mountpoint, event_queue, check, **kwargs):
 			nr = 0
 			for lines in health_reports(mon_fp):
 				event_queue.submit(handle_event, lines, fh,
-						everything)
+						everything, mon_fd)
 
 				# Periodically run the garbage collector to
 				# constrain memory usage in the main thread.
@@ -1055,6 +1080,12 @@ def monitor(mountpoint, event_queue, check, **kwargs):
 					gc.collect()
 				nr += 1
 
+			# Once we run out of events to process, shut down all
+			# the workers and wait for them to complete before we
+			# close mon_fp so that repair reopen can't walk off
+			# freed mon_fd.
+			event_queue.shutdown(wait = True, cancel_futures = True)
+
 	try:
 		fd = os.open(mountpoint, os.O_RDONLY)
 	except Exception as e:
@@ -1244,7 +1275,7 @@ def repair_inode(event, fd):
 		except Exception as e:
 			eprintln(f"{prefix} {structure}: {e}")
 
-def repair_metadata(event, fh):
+def repair_metadata(event, fh, mon_fd):
 	'''Repair a metadata corruption.'''
 	global debug
 	global printf_prefix
@@ -1253,7 +1284,7 @@ def repair_metadata(event, fh):
 		printlogln(f'repair {event}')
 
 	try:
-		fd = fh.reopen()
+		fd = fh.reopen(lambda fdx: is_same_fs(mon_fd, fdx))
 	except Exception as e:
 		eprintln(f"{printf_prefix}: {e}")
 		return
@@ -1388,8 +1419,6 @@ def main():
 		# Consider SIGINT to be a clean exit.
 		pass
 
-	args.event_queue.shutdown()
-
 	# See the service mode comments in xfs_scrub.c for why we sleep and
 	# compress all nonzero exit codes to 1.
 	if 'SERVICE_MODE' in os.environ:

