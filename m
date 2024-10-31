Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63031BD9DC
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730417122; cv=none; b=h48MbSAvwGM79M1vUm92NV2e7/oiXXIp5ZKApleN9kRS3/mZHuH9v53Zui4OlI0ON0a+nw8ZQsRSYo3bRNUC0o0Hvj+vGhf8iKh2ziPTY25Ylh7u2n3XFGJDQ7s+WSsIBIm9iuMECM94fNywT0N+9DSN9qbTyW+TDEhOQMo9o60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730417122; c=relaxed/simple;
	bh=TbYksIQ9NQ8Tc8Mvr69uvqUi8PslsHiT0FH+q/kDtuc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ThDR5i1sIj1Bb88Xvb3kdTUQoFXwXSkTb6jkakeGAfHqJzxvQaQHAH+ATdenKwnS95NjTx2fehV+Wo8ttIWgkPQ+TwS3JrcNJ7sNeKoVNKaWo8JazTB/XFxh7NZlY+v1lznCsw3QBbZiNWSZZ9FGOWzlU5FAkeKX46lHmIwySRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qkcHdBnt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qkcHdBnt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C57C4CEC3;
	Thu, 31 Oct 2024 23:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730417122;
	bh=TbYksIQ9NQ8Tc8Mvr69uvqUi8PslsHiT0FH+q/kDtuc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qkcHdBntvtwplGy0ofK0b6y7945EbHMYBrVXwAaT1hgdrMLmeK93kWnikqXv23zKz
	 S/2Sj6N9HX13ioUSX+upFc4IlOxyWHbaCwCwL+xVxKqGZiBtQESzQGP7cc4fjlvtwq
	 Q6yWbgxNEHi7+5o48Y6jEJ0xHU00hx4/KgBQxX8QY7huws8dkd0BLDFDr/AarikwRD
	 4/EgkioaqdQ2y+D1rclurUv4Re38+o8oTq+2Fal5WqrkVoHv/BCzFCQeV2aY+apmox
	 1WUd2deBB0tmfngUc23hx7usNlzc56g2Fu/A9CAKJftRpvmekLRGfe3PAnfNPedbE9
	 giB68oabM8QUQ==
Date: Thu, 31 Oct 2024 16:25:22 -0700
Subject: [PATCH 1/1] xfs_scrub_all: wait for services to start activating
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173041568518.964875.1217669604214257458.stgit@frogsfrogsfrogs>
In-Reply-To: <173041568502.964875.8254188626760061825.stgit@frogsfrogsfrogs>
References: <173041568502.964875.8254188626760061825.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

It seems that the function call to start a systemd unit completes
asynchronously from any change in that unit's active state.  On a
lightly loaded system, a Start() call followed by an ActiveState()
call actually sees the change in state from inactive to activating.

Unfortunately, on a heavily loaded system, the state change may take a
few seconds.  If this is the case, the wait() call can see that the unit
state is "inactive", decide that the service already finished, and exit
early, when in reality it hasn't even gotten to 'activating'.

Fix this by adding a second method that watches either for the inactive
-> activating state transition or for the last exit from inactivation
timestamp to change before waiting for the unit to reach inactive state.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Cc: <linux-xfs@vger.kernel.org> # v6.10.0
Fixes: 6d831e770359ff ("xfs_scrub_all: convert systemctl calls to dbus")
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/xfs_scrub_all.in |   52 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)


diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index 5e2e0446a99f89..fe4bca4b2edb11 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -249,6 +249,54 @@ class scrub_service(scrub_control):
 				print(e, file = sys.stderr)
 			return 'failed'
 
+	def last_activation(self):
+		'''Retrieve the last activation time, in microseconds since
+		boot.'''
+		global debug
+
+		l = lambda: self.prop.Get('org.freedesktop.systemd1.Unit',
+				'InactiveExitTimestampMonotonic')
+		try:
+			return self.__dbusrun(l)
+		except Exception as e:
+			if debug:
+				print(e, file = sys.stderr)
+			return 0
+
+	def wait_for_startup(self, last_active, wait_for = 30, interval = 0.5):
+		'''Wait for the service to start up.  This is defined as
+		exiting the inactive state.'''
+
+		for i in range(0, int(wait_for / interval)):
+			s = self.state()
+			if debug:
+				print('waiting for activation %s %s' % (self.unitname, s))
+			if s == 'failed':
+				return 1
+			if s != 'inactive':
+				return 0
+			# If the unit is inactive but the last activation time
+			# doesn't match, then the service ran so quickly that
+			# it's already gone.
+			if last_active != self.last_activation():
+				return 0
+			time.sleep(interval)
+
+		s = self.state()
+		if debug:
+			print('waited for startup %s %s' % (self.unitname, s))
+		if s == 'failed':
+			return 1
+		if s != 'inactive':
+			return 0
+
+		# If the unit is inactive but the last activation time doesn't
+		# match, then the service ran so quickly that it's already
+		# gone.
+		if last_active != self.last_activation():
+			return 0
+		return 2
+
 	def wait(self, interval = 1):
 		'''Wait until the service finishes.'''
 		global debug
@@ -278,7 +326,11 @@ class scrub_service(scrub_control):
 			print('starting %s' % self.unitname)
 
 		try:
+			last_active = self.last_activation()
 			self.__dbusrun(lambda: self.unit.Start('replace'))
+			ret = self.wait_for_startup(last_active)
+			if ret > 0:
+				return ret
 			return self.wait()
 		except dbus.exceptions.DBusException as e:
 			# If the unit was masked, the sysadmin doesn't want us

