Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CC09449
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882548; cv=none; b=lwMl5JWxbHlMBcrRLWYICFtTZctjujAR8QZNtMPfwtSak7hCi8TsxPXzXYr1whsTJcdkvEcylEqA0AB/TgYDs32m3HVmSssFnRddz319Fav20raXt71GXTOEphRQ1+1w9ZJNVOVwnjzMwtjsjZriYVwzrLCQFGE+ANrGQF8Cnuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882548; c=relaxed/simple;
	bh=/13cmUZH5qZFXt1bOtFOHM3T3iDqZDEV3kKDJmvf6RE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JMfJuFKRPzRruxRpHoXxs7V7lZmrAm8YqCQU9Ax8ce+9Ed9voek1BY6ekIC+cq2PLXscy6ytBAVD7yQxoUm6J6Isz1FSBSkawNqtqT00+Y5DdVnFuJ7sloerLLcuXfeAdgCTXgXz/xnADtnxVP8u3PAYKxLcPx+UkKfhKTzuEWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=epnl5NEk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="epnl5NEk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09669C116B1;
	Tue,  2 Jul 2024 01:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882548;
	bh=/13cmUZH5qZFXt1bOtFOHM3T3iDqZDEV3kKDJmvf6RE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=epnl5NEk6+6ASLYh8s2RZC2UVPy/2qMLF6sWbfsT1VZsEgleH1OxB7Hu582NeEzc8
	 avF8wforRbbOSXDhNgQ+P2ig+/48qNoNQA6mjDAEtWE+/EZXENNbiQEaPzm7eABwxT
	 q++9L9XS0PA9Bq4BOByko6EUlUvGvFTSuCtRqLmC6LDLWsJRR18DRmrgauJag7Ql4B
	 6ygC0yuJn1b3OMcQzoRSYn8kw9mMthHLiJ0J+jKxw5w695dxuSR8xIik4t+NdXqBBb
	 SwP3WwuR3tDh6GgSXUB2dM2K6y5vEhLprHSS6TlQP+ZbC13E39mfH8zafRnMiNyu8u
	 c+ysgY+Y1qrJg==
Date: Mon, 01 Jul 2024 18:09:07 -0700
Subject: [PATCH 5/5] xfs_scrub_all: implement retry and backoff for dbus calls
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988119890.2008718.14517701027636602626.stgit@frogsfrogsfrogs>
In-Reply-To: <171988119806.2008718.11057954097670233571.stgit@frogsfrogsfrogs>
References: <171988119806.2008718.11057954097670233571.stgit@frogsfrogsfrogs>
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
---
 scrub/xfs_scrub_all.in |   43 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 40 insertions(+), 3 deletions(-)


diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index a09566efdcd8..71726cdf36d5 100644
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

