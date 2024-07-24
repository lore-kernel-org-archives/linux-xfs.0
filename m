Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84FA210FB
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2024 04:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721796763; cv=none; b=RyqRLsaCfj/Olk8tdliYix+4SYvREu7j6WeYOwqpBodS7bNEOhk5qK0LYJti6LRfdrv8DenBJ3TGzP/6itQEPfIPS2n3jzt7ILVwGQD6UGjIQLYx2e9348N7jca9RmsC5Tel+P9ZDs/FBcugxDBIG0SJcDPosXusDJ8jTJ+Mh24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721796763; c=relaxed/simple;
	bh=a7lg8h2xklbKrFjTAoCRy5gDi0KR5yRMo0a7TB1Xhto=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=WBSdq64hQ9nDAjr9tC3YVjMAw3WVSVef0BJMgLcM+Tr6+O7huFFnHfq8O/8GQBa+2RjhaPrppHcMiaRdHCRqhFPzlruGxYNVKCQ8V9HUiGJFlmmdiY6jySuBn+scfeFoN1/cKQepZE8bNKuSzt9MVZwj5bZ0xr+laEwO7ODOTjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S/83xlX4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S/83xlX4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F54FC32782;
	Wed, 24 Jul 2024 04:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721796762;
	bh=a7lg8h2xklbKrFjTAoCRy5gDi0KR5yRMo0a7TB1Xhto=;
	h=Date:From:To:Cc:Subject:From;
	b=S/83xlX4icNUgT+HofhfhE++U3eGi0UDCR/5IhuTFoOcHyKdUJqomtbI+mNJHUpPu
	 Pl4cw7vX2s8cDKvyiH3bDhHl2bql8UgziVGJO82FKqvNFgI28O2vakyB3P3d0F+sTn
	 5nxpZWw8suBcwc7F8Z6rLSR4OZjRFb4ro9Dkc4+AD0U/n/Pd4ld3z6o3cf0T1zc0jy
	 CWB8MM/Z3iT/jxDC7//XvitdFtnHHQkIsSqkX8QsIJoikHdvSQ0svqqV8siFRG5/Cq
	 09A/OgwVMvi0QGtzUOIns9Kg80PLJ3NmRTsa8SnoJXA8+Pgl0ui0pWtzxvRe78ntFM
	 PYASFS+e0CHDQ==
Date: Tue, 23 Jul 2024 21:52:41 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs_scrub_all: fail fast on masked units
Message-ID: <20240724045241.GW612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

If xfs_scrub_all tries to start a masked xfs_scrub@ unit, that's a sign
that the system administrator really didn't want us to scrub that
filesystem.  Instead of retrying pointlessly, just make a note of the
failure and move on.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub_all.in |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index 5440e51c0791..5e2e0446a99f 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -181,6 +181,10 @@ def fibonacci(max_ret):
 		y = z
 		z = x + y
 
+def was_unit_masked(ex):
+	'''Decide if this dbus exception occurred because we tried to start a masked unit.'''
+	return ex.get_dbus_name() == "org.freedesktop.systemd1.UnitMasked"
+
 class scrub_service(scrub_control):
 	'''Control object for xfs_scrub systemd service.'''
 	def __init__(self, mnt, scrub_media):
@@ -219,6 +223,12 @@ class scrub_service(scrub_control):
 				if debug:
 					print(e)
 				fatal_ex = e
+
+				# If the unit is masked, there's no point in
+				# retrying any operations on it.
+				if was_unit_masked(e):
+					break
+
 				time.sleep(i)
 				self.bind()
 		raise fatal_ex
@@ -270,6 +280,13 @@ class scrub_service(scrub_control):
 		try:
 			self.__dbusrun(lambda: self.unit.Start('replace'))
 			return self.wait()
+		except dbus.exceptions.DBusException as e:
+			# If the unit was masked, the sysadmin doesn't want us
+			# running it.  Pretend that we finished it.
+			if was_unit_masked(e):
+				return 32
+			print(e, file = sys.stderr)
+			return -1
 		except Exception as e:
 			print(e, file = sys.stderr)
 			return -1
@@ -317,6 +334,10 @@ def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 		# are running as a systemd service.
 		if 'SERVICE_MODE' in os.environ:
 			ret = run_service(mnt, scrub_media, killfuncs)
+			if ret == 32:
+				print("Scrubbing %s disabled by administrator, (err=%d)" % (mnt, ret))
+				sys.stdout.flush()
+				return
 			if ret == 0 or ret == 1:
 				print("Scrubbing %s done, (err=%d)" % (mnt, ret))
 				sys.stdout.flush()
