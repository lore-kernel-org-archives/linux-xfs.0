Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92451125A0
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178247; cv=none; b=tXJep2yFrFRDurFsw4j3R9BnQ5EpdoPdLvSRADMiVfQQU2hZFQqqnQ+3qVJi1SH9XNeljQqFhp1uHEPExvUB4kXSZX6gx8PSh+SalSGvTWK20FQL60QafVaokCrtIzIL7S0dVPj+EQ7QF700sEtWV+DyofSWXdm5wqyvuDSzHT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178247; c=relaxed/simple;
	bh=PVj7+Np57awqxmC3jmQCMG9MQyb0vEewKfeBnMAbBY8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lzL7yi9lHwtwGnD43prX2qDmzWWDEzezLVG4m4rwXL9PP6uI1ruqn3+SdN371GvorJCYDtN/a1QjmMCErGYVWCiV/md4K29QIGSzH9+F+HK8suAisS52veMsylR0lg2BXpv9udjVQQFHlU7kTnrubjUCll9Y61cnhKXNo8VylmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PLGq3rCe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PLGq3rCe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17265C4CEE7;
	Thu, 23 Oct 2025 00:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178247;
	bh=PVj7+Np57awqxmC3jmQCMG9MQyb0vEewKfeBnMAbBY8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PLGq3rCepUGRlMjHrv2/Na7H1sC37ivDd7Vzf9l7jvSR21JVM8RZ07jv2vgaKOjtK
	 6O4W6c7+AUds/JqsllXZhZaNIYVQjxM0fepCZPEbIMpWP0zBGVeI60yvsNTLMDdhC7
	 zI715NIXBkM0kYU8Uk/z+T746Ve17XRbAdJntmlxtLap34U79M2uf/Im+GlkCe7pVr
	 iiBsqs5JLqmyluUiNqie9uemI5yBC4GA72he/FmbN1N3FKCwNyVWNlbnR8Vq+zzw5b
	 dCBsRgzYkqezcfYQDyoh7rmIcw0XpORXlCbKBGRWftnl2I1PdG5VkiXIkRgvInIoFv
	 bZdkFuNPXHHMw==
Date: Wed, 22 Oct 2025 17:10:46 -0700
Subject: [PATCH 20/26] xfs_healer: use the autofsck fsproperty to select mode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117747843.1028044.3546314891290477949.stgit@frogsfrogsfrogs>
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

Make the xfs_healer background service query the autofsck filesystem
property to figure out which operating mode it should use.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/xfs_healer.py.in       |   75 +++++++++++++++++++++++++++++++++++++++--
 healer/xfs_healer@.service.in |    2 +
 2 files changed, 72 insertions(+), 5 deletions(-)


diff --git a/healer/xfs_healer.py.in b/healer/xfs_healer.py.in
index df4bd906d530fc..4c6ab2662f6f50 100644
--- a/healer/xfs_healer.py.in
+++ b/healer/xfs_healer.py.in
@@ -632,6 +632,21 @@ def fgetpath(fd, fh = None, mountpoint = None):
 			break
 	return ret
 
+# Filesystem properties
+
+FSPROP_NAMESPACE = "trusted."
+FSPROP_NAME_PREFIX = "xfs:"
+FSPROP_AUTOFSCK_NAME = "autofsck"
+
+def fsprop_attrname(n):
+	'''Construct the xattr name for a filesystem property.'''
+	return f"{FSPROP_NAMESPACE}{FSPROP_NAME_PREFIX}{n}"
+
+def fsprop_getstr(fd, n):
+	'''Return the value of a filesystem property as a string.'''
+	attrname = fsprop_attrname(n)
+	return os.getxattr(fd, attrname).decode('utf-8')
+
 # main program
 
 def health_reports(mon_fp):
@@ -869,6 +884,31 @@ def check_monitor(mountpoint, fd):
 	# Monitor available; success!
 	return 0
 
+def want_repair_from_autofsck(fd):
+	'''Determine want_repair from the autofsck filesystem property.'''
+	global has_parent
+	global has_rmapbt
+
+	try:
+		advice = fsprop_getstr(fd, FSPROP_AUTOFSCK_NAME)
+		if advice == "repair":
+			return True
+		if advice == "check" or advice == "optimize":
+			return False
+		if advice == "none":
+			return None
+	except:
+		# Any OS error (including ENODATA) or string parsing error is
+		# treated the same as an unrecognized value.
+		pass
+
+	# For an unrecognized value, log but do not fix runtime corruption if
+	# backref metadata are enabled.  If no backref metadata are available,
+	# the fs is too old so don't run at all.
+	if has_rmapbt or has_parent:
+		return False
+	return None
+
 def monitor(mountpoint, event_queue, check, **kwargs):
 	'''Monitor the given mountpoint for health events.'''
 	global everything
@@ -877,6 +917,7 @@ def monitor(mountpoint, event_queue, check, **kwargs):
 	global want_repair
 	global has_parent
 	global has_rmapbt
+	use_autofsck = want_repair is None
 
 	def event_loop(mon_fd, event_queue, fh):
 		# Ownership of mon_fd (and hence responsibility for closing it)
@@ -908,12 +949,33 @@ def monitor(mountpoint, event_queue, check, **kwargs):
 		msg = _("detecting fs features")
 		eprintln(_(f'{printf_prefix}: {msg}: {e}'))
 
+	# Does the sysadmin have any advice for us about whether or not to
+	# background scrub?
+	if use_autofsck:
+		want_repair = want_repair_from_autofsck(fd)
+		if want_repair is None:
+			msg = _("Disabling daemon per autofsck directive.")
+			printlogln(f"{mountpoint}: {msg}")
+			os.close(fd)
+			return 0
+		elif want_repair:
+			msg = _("Automatically repairing per autofsck directive.")
+			printlogln(f"{mountpoint}: {msg}")
+		else:
+			msg = _("Only logging errors per autofsck directive.")
+			printlogln(f"{mountpoint}: {msg}")
+
 	# Check that the kernel supports repairs at all.
 	if want_repair and not xfs_repair_is_supported(fd):
-		msg = _("XFS online repair is not supported, exiting")
+		if not use_autofsck:
+			msg = _("XFS online repair is not supported, exiting")
+			printlogln(f"{mountpoint}: {msg}")
+			os.close(fd)
+			return 1
+
+		msg = _("XFS online repair is not supported, will report only")
 		printlogln(f"{mountpoint}: {msg}")
-		os.close(fd)
-		return 1
+		want_repair = False
 
 	# Check for the backref metadata that makes repair effective.
 	if want_repair:
@@ -1114,8 +1176,11 @@ def main():
 	parser.add_argument('--event-schema', type = str, \
 			default = '@pkg_data_dir@/xfs_healthmon.schema.json', \
 			help = argparse.SUPPRESS)
-	parser.add_argument("--repair", action = "store_true", \
+	action_group = parser.add_mutually_exclusive_group()
+	action_group.add_argument("--repair", action = "store_true", \
 			help = _("Always repair corrupt metadata"))
+	action_group.add_argument("--autofsck", action = "store_true", \
+			help = _("Use the \"autofsck\" fs property to decide to repair"))
 	parser.add_argument("--check", action = "store_true", \
 			help = _("Check that health monitoring is supported"))
 	args = parser.parse_args()
@@ -1148,6 +1213,8 @@ def main():
 		everything = True
 	if args.debug_fast:
 		debug_fast = True
+	if args.autofsck:
+		want_repair = None
 	if args.repair:
 		want_repair = True
 
diff --git a/healer/xfs_healer@.service.in b/healer/xfs_healer@.service.in
index 5660050a1aa3e4..e12135b3c808c5 100644
--- a/healer/xfs_healer@.service.in
+++ b/healer/xfs_healer@.service.in
@@ -18,7 +18,7 @@ RequiresMountsFor=%f
 Type=exec
 Environment=SERVICE_MODE=1
 ExecCondition=@pkg_libexec_dir@/xfs_healer --check %f
-ExecStart=@pkg_libexec_dir@/xfs_healer --log %f
+ExecStart=@pkg_libexec_dir@/xfs_healer --autofsck --log %f
 SyslogIdentifier=%N
 
 # Create the service underneath the healer background service slice so that we

