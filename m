Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7622F29415
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735689160; cv=none; b=TwcOmAGuFM2kqT5gxktJQj5JWRHbu/13uUO/LnXyx78InSuUOpOFPUMpfcnzrEM8j0cStAafqImbM37NeK/9CghBc7DPQv1zgCML3tzK3zzQXikd8Z9tumewLvTG881ufGXmDHIpZetbxZ27rkoOIe05IfdKRyMv2C5fDf1T7VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735689160; c=relaxed/simple;
	bh=s9bc2zPQx9Gk8KOTK/NDAHWKvm/aECuECysXqFiupUI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NAu6OtkR0wKeXrOHUfqKUJt7P1Ud0yAl0iy/oJu6aGeC5jPTs/ighSEiXr1+gp39D15ANx93GCNPPAnRQvuMyIxrW4MKRxUpW2KpGeH0iGiZjel4d2PfM/snmwRocfmxxFCKHk2nC28AjCVZw7XpNOhWL2jCTRR62xsqhRalCbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QMpfUWSK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QMpfUWSK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF8DC4CED2;
	Tue, 31 Dec 2024 23:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735689160;
	bh=s9bc2zPQx9Gk8KOTK/NDAHWKvm/aECuECysXqFiupUI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QMpfUWSKTcKt79BqtMemDFbzVHoNCp2J4nbv/17O0xum9u9xeOMdxXxnbyNDeqhEq
	 Xw/McDHsAFTquXFrwxlZzXUxnDPftQkd+yq9ScuJUJA6JwYsS1+k8tZDifa4CS+e06
	 /uF60bTtcP3Lj0NQGsbcWSP5oTRr8oOWouF+Ubl4VKOilCCdtrIu/csYQe4FyvjOq8
	 P4aY/tFIi6566EOt2MN/qlzhNup+Tg5QreQ5p2ld0h2zGq+emyKRLA1jr7iojEWpEt
	 JprOeL8dJMMLjSlmrgyyPTHnhydaq7xFK1RYe0upGonq58eAGC+oXrhnj4lsoxkIYv
	 EKyUdDNfK/s8A==
Date: Tue, 31 Dec 2024 15:52:39 -0800
Subject: [PATCH 19/21] xfs_scrubbed: use the autofsck fsproperty to select
 mode
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568778754.2710211.11864841620520710404.stgit@frogsfrogsfrogs>
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

Make the xfs_scrubbed background service query the autofsck filesystem
property to figure out which operating mode it should use.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/xfs_scrubbed.in |   62 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 61 insertions(+), 1 deletion(-)


diff --git a/scrub/xfs_scrubbed.in b/scrub/xfs_scrubbed.in
index 90602481f64c88..2b34603cb361e2 100644
--- a/scrub/xfs_scrubbed.in
+++ b/scrub/xfs_scrubbed.in
@@ -573,6 +573,21 @@ def fgetpath(fd, fh = None, mountpoint = None):
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
 
 def health_reports(mon_fp, fh):
@@ -731,6 +746,31 @@ def handle_event(e):
 	elif want_repair and event['type'] == 'sick':
 		repair_queue.submit(repair_metadata, event, fh)
 
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
 def monitor(mountpoint, event_queue, **kwargs):
 	'''Monitor the given mountpoint for health events.'''
 	global everything
@@ -749,6 +789,20 @@ def monitor(mountpoint, event_queue, **kwargs):
 		# Don't care if we can't detect parent pointers or rmap
 		print(f'{printf_prefix}: detecting fs features: {e}', file = sys.stderr)
 
+	# Does the sysadmin have any advice for us about whether or not to
+	# background scrub?
+	if want_repair is None:
+		want_repair = want_repair_from_autofsck(fd)
+		if want_repair is None:
+			print(f"{mountpoint}: Disabling daemon per autofsck directive.")
+			os.close(fd)
+			return 0
+		elif want_repair:
+			print(f"{mountpoint}: Automatically repairing per autofsck directive.")
+		else:
+			print(f"{mountpoint}: Only logging errors per autofsck directive.")
+
+
 	# Check for the backref metadata that makes repair effective.
 	if want_repair:
 		if not has_rmapbt:
@@ -963,7 +1017,11 @@ def main():
 			action = "store_true")
 	parser.add_argument("--everything", help = "Capture all events.", \
 			action = "store_true")
-	parser.add_argument("--repair", help = "Automatically repair corrupt metadata.", \
+	action_group = parser.add_mutually_exclusive_group()
+	action_group.add_argument("--repair", \
+			help = "Automatically repair corrupt metadata.", \
+			action = "store_true")
+	action_group.add_argument("--autofsck", help = argparse.SUPPRESS, \
 			action = "store_true")
 	parser.add_argument("-V", help = "Report version and exit.", \
 			action = "store_true")
@@ -1004,6 +1062,8 @@ def main():
 		everything = True
 	if args.debug_fast:
 		debug_fast = True
+	if args.autofsck:
+		want_repair = None
 	if args.repair:
 		want_repair = True
 

