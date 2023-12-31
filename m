Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A266C140
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ko4fszEw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC72C433C8;
	Sun, 31 Dec 2023 23:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063609;
	bh=LDUjVxAgze+c5fFyTUcSTVKl/qVMOTQQaChuDUZAqhk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ko4fszEwJf8OBbvqsd1h9/InObjL67t0Lf9PlOfTOfM2+Kx35VAC0kS0qaKzOHdoV
	 Rje/8eLA1jdekksExB+WkxK3G3FE/ZMSaYVd5eedvJKhCjQU1dEJQwlHN4BoAJPKAf
	 LzIsovoHApUXmCFmMErEUCGoE1j7A7lQwXZrnMYeqV8LSWTs31xAYlj71yCWlzIvpZ
	 Su+9A5EJI0o3w10qO0ECVteTVkIyo9DUFXydWIm78IO3wxusFKV2TJTJ9h3Aw4Gxdl
	 WkCCwgaKS66mpW86GRwApkRKrF3tm5EAJx4sxt9q+7u314Gqe5vRHeQfkdEi1ldjpO
	 zS+yUfbHtJJZQ==
Date: Sun, 31 Dec 2023 15:00:09 -0800
Subject: [PATCH 5/5] xfs_scrub_all: implement retry and backoff for dbus calls
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405003416.1801694.8275684292240483148.stgit@frogsfrogsfrogs>
In-Reply-To: <170405003347.1801694.9862582977773516679.stgit@frogsfrogsfrogs>
References: <170405003347.1801694.9862582977773516679.stgit@frogsfrogsfrogs>
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
index a09566efdcd..71726cdf36d 100644
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

