Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A7579CC
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302238; cv=none; b=sSRuOhAEWmNuLeRqRHGvv6bKQ8auj4yAmV8H2lMuF1aaEqR4VbPS/MTZbykbdF2omiyM0m8F14sLD674YEq+i7NnxpSZvI/ZnsuGgjnBXLiLMZBwmsEeA6M9pBqAYiUEH1NkRIL3GP8sG6u+G15zJxXDvKfdVqAeXeQ1GEiGmB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302238; c=relaxed/simple;
	bh=nmsqq6k6vUS5Cdk+hijbiB7KqE1P3rTPRNYLaQOeLPY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SZOT5zt1qkvOFjV+9yuI+yLwjZJn8y6PhFB6LFKVK6iH619R+mXO3PJRxSOsF+IbG0ueHMMsNBXYXqsxm1oU40xEf/1m+n1L9W8NnbsIdbMrQS+TlbZJ7CROoCaRR1q2boYcfZdFDqH1eZxkzl2I0yH97tohREBDbc1HQL0b1Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DQ2CLwvW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DQ2CLwvW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591AEC32786;
	Tue, 30 Jul 2024 01:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302237;
	bh=nmsqq6k6vUS5Cdk+hijbiB7KqE1P3rTPRNYLaQOeLPY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DQ2CLwvWgWApgZtPwh20hWaRIbOQay8s3FxwceR3Zw+DEJGcSMYNt5Y3Gpu1EXGls
	 4unrypLFD4yXGEst5Pt5GjrJ9QB7GxLLqLid+yoHLdfSSIncyKXXfewIoepQf6lRm6
	 OcwGIH8KOwQf00b9S7F6BDSFn/B2k5AstVMesTnV++RO2FS0JUdYjf1DnoXF6M2SKw
	 hd4F1JC/vX+HLZEDIaikwhrwBAlD/eoTDhH2WcbjeVZMhn/1jcd/x2oxlTo4y3nXgJ
	 nBydFlS6Gm35Et9d06OdJBRt5CwMfUJARVMrkWudqriyzUWgSkS1Vc2Ozab3x+kCLh
	 Gty2tAhHJGAYw==
Date: Mon, 29 Jul 2024 18:17:16 -0700
Subject: [PATCH 5/5] xfs_scrub_all: implement retry and backoff for dbus calls
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229849719.1350420.4990697396905953343.stgit@frogsfrogsfrogs>
In-Reply-To: <172229849638.1350420.756131243612881227.stgit@frogsfrogsfrogs>
References: <172229849638.1350420.756131243612881227.stgit@frogsfrogsfrogs>
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

Calls to systemd across dbus are remote procedure calls, which means
that they're subject to transitory connection failures (e.g. systemd
re-exec itself).  We don't want to fail at the *first* sign of what
could be temporary trouble, so implement a limited retry with fibonacci
backoff before we resort to invoking xfs_scrub as a subprocess.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/xfs_scrub_all.in |   43 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 40 insertions(+), 3 deletions(-)


diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index f2e916513..5440e51c0 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -165,6 +165,22 @@ def path_to_serviceunit(path, scrub_media):
 	for line in proc.stdout:
 		return line.decode(sys.stdout.encoding).strip()
 
+def fibonacci(max_ret):
+	'''Yield fibonacci sequence up to but not including max_ret.'''
+	if max_ret < 1:
+		return
+
+	x = 0
+	y = 1
+	yield 1
+
+	z = x + y
+	while z <= max_ret:
+		yield z
+		x = y
+		y = z
+		z = x + y
+
 class scrub_service(scrub_control):
 	'''Control object for xfs_scrub systemd service.'''
 	def __init__(self, mnt, scrub_media):
@@ -188,6 +204,25 @@ class scrub_service(scrub_control):
 		self.unit = dbus.Interface(svc_obj,
 				'org.freedesktop.systemd1.Unit')
 
+	def __dbusrun(self, lambda_fn):
+		'''Call the lambda function to execute something on dbus.  dbus
+		exceptions result in retries with Fibonacci backoff, and the
+		bindings will be rebuilt every time.'''
+		global debug
+
+		fatal_ex = None
+
+		for i in fibonacci(30):
+			try:
+				return lambda_fn()
+			except dbus.exceptions.DBusException as e:
+				if debug:
+					print(e)
+				fatal_ex = e
+				time.sleep(i)
+				self.bind()
+		raise fatal_ex
+
 	def state(self):
 		'''Retrieve the active state for a systemd service.  As of
 		systemd 249, this is supposed to be one of the following:
@@ -195,8 +230,10 @@ class scrub_service(scrub_control):
 		or "deactivating".  These strings are not localized.'''
 		global debug
 
+		l = lambda: self.prop.Get('org.freedesktop.systemd1.Unit',
+				'ActiveState')
 		try:
-			return self.prop.Get('org.freedesktop.systemd1.Unit', 'ActiveState')
+			return self.__dbusrun(l)
 		except Exception as e:
 			if debug:
 				print(e, file = sys.stderr)
@@ -231,7 +268,7 @@ class scrub_service(scrub_control):
 			print('starting %s' % self.unitname)
 
 		try:
-			self.unit.Start('replace')
+			self.__dbusrun(lambda: self.unit.Start('replace'))
 			return self.wait()
 		except Exception as e:
 			print(e, file = sys.stderr)
@@ -245,7 +282,7 @@ class scrub_service(scrub_control):
 			print('stopping %s' % self.unitname)
 
 		try:
-			self.unit.Stop('replace')
+			self.__dbusrun(lambda: self.unit.Stop('replace'))
 			return self.wait()
 		except Exception as e:
 			print(e, file = sys.stderr)

