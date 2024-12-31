Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342FA1B0425
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735689145; cv=none; b=L878IeKhi98AEc1HROU3DEt9Y/S951bQHXELSAGrVOUzp+lYxIKq5p7PFxjbRmEsjbjWQdWQBjVhnXz1LHmdbYrCfl4vL4Z3ntntkz5Arhum0vZFU3Hoankolqgp/b1VBw2VzOeXSmvIXHsFxWS0g3DQ13yIoFr7kcnSVIziM1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735689145; c=relaxed/simple;
	bh=5JQxrrLr4fiunRkMVSBLEDMh8T+vnd5a0qOAFJMhvtY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Sxnx8scRcjvrP45giF9alHaEcjEkWk0KLCrCL4NShuQwp81wTU/du2C+NwAS52Fvs1AOAltsgH4Q3aNA0LAHOg1WFRiUOAWLlRWgkrHOGXtS5qnt8TZnLKnUkXSQbVhr1uZSGb2JCkp1Mje7m9AdgnJxABjiZnui3XYX9nCf7uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WnAe2Lhp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WnAe2Lhp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4597C4CED2;
	Tue, 31 Dec 2024 23:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735689144;
	bh=5JQxrrLr4fiunRkMVSBLEDMh8T+vnd5a0qOAFJMhvtY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WnAe2Lhpvl8rL8iF209TQ/dJ8/6tiT+CbmNwGj/lX36P8AweTlb7fqKSLb/sHT8r4
	 wl+NREfrUBDZC8tQIxhgy00jlbQHiL8r3shQWB4qTemjztl8fbJmK1avghRk937u9t
	 pd5UGlADVxrTNb6LaJrE0wrfD1u5cT2H9XzzK74Qj1wgNDEy2rj0I+40ctI4ejImkR
	 /Y9Ia2r68CM2/3yxWhywoZ6OkKcOFrrovhNswOrXZ5MZGZL5DfJgaU8Lz6DENHKZDg
	 hVBNRnjPYLy5MIiTE75662Nb/UdLSBfCDKcwJrhsgUa1pHfXbqmVujd0Fjw/QViL7x
	 dPpewE5E2KDBQ==
Date: Tue, 31 Dec 2024 15:52:24 -0800
Subject: [PATCH 18/21] xfs_scrubbed: don't start service if kernel support
 unavailable
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568778738.2710211.17502333103439617688.stgit@frogsfrogsfrogs>
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

Use ExecCondition= in the system service to check if kernel support for
the health monitor is available.  If not, we don't want to run the
service, have it fail, and generate a bunch of silly log messages.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/xfs_scrubbed.in          |   39 ++++++++++++++++++++++++++++++++++++++-
 scrub/xfs_scrubbed@.service.in |    1 +
 2 files changed, 39 insertions(+), 1 deletion(-)


diff --git a/scrub/xfs_scrubbed.in b/scrub/xfs_scrubbed.in
index 9df6f45e53ad80..90602481f64c88 100644
--- a/scrub/xfs_scrubbed.in
+++ b/scrub/xfs_scrubbed.in
@@ -791,6 +791,38 @@ def monitor(mountpoint, event_queue, **kwargs):
 
 	return 0
 
+def check_monitor(mountpoint):
+	'''Check if the kernel can send us health events for the given mountpoint.'''
+	global log
+	global printf_prefix
+	global everything
+	global want_repair
+	global has_parent
+
+	try:
+		fd = os.open(mountpoint, os.O_RDONLY)
+	except OSError as e:
+		# Can't open mountpoint; monitor not available.
+		print(f"{mountpoint}: {e}", file = sys.stderr)
+		return 1
+
+	try:
+		mon_fd = open_health_monitor(fd, verbose = everything)
+	except OSError as e:
+		# Error opening monitor (or it's simply not there); monitor
+		# not available.
+		if e.errno == errno.ENOTTY or e.errno == errno.EOPNOTSUPP:
+			print(f"{mountpoint}: XFS health monitoring not supported.",
+					file = sys.stderr)
+		return 1
+	finally:
+		# Close the mountpoint if opening the health monitor fails;
+		# the handle object will free its own memory.
+		os.close(fd)
+
+	# Monitor available; success!
+	return 0
+
 def __scrub_type(code):
 	'''Convert a "structures" json list to a scrub type code.'''
 	SCRUB_TYPES = {
@@ -923,6 +955,8 @@ def main():
 
 	parser = argparse.ArgumentParser( \
 			description = "XFS filesystem health monitoring demon.")
+	parser.add_argument("--check", help = "Check presense of health monitor.", \
+			action = "store_true")
 	parser.add_argument("--debug", help = "Enabling debugging messages.", \
 			action = "store_true")
 	parser.add_argument("--log", help = "Log health events to stdout.", \
@@ -989,7 +1023,10 @@ def main():
 	printf_prefix = args.mountpoint
 	ret = 0
 	try:
-		ret = monitor(**vars(args))
+		if args.check:
+			ret = check_monitor(args.mountpoint)
+		else:
+			ret = monitor(**vars(args))
 	except KeyboardInterrupt:
 		# Consider SIGINT to be a clean exit.
 		pass
diff --git a/scrub/xfs_scrubbed@.service.in b/scrub/xfs_scrubbed@.service.in
index 9656bdb3cd9a9d..afd5c204327946 100644
--- a/scrub/xfs_scrubbed@.service.in
+++ b/scrub/xfs_scrubbed@.service.in
@@ -18,6 +18,7 @@ RequiresMountsFor=%f
 [Service]
 Type=exec
 Environment=SERVICE_MODE=1
+ExecCondition=@pkg_libexec_dir@/xfs_scrubbed --check %f
 ExecStart=@pkg_libexec_dir@/xfs_scrubbed --log %f
 SyslogIdentifier=%N
 

