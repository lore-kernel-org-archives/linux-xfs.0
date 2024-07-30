Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F782881E
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302253; cv=none; b=VqPXB7Mj39AE1cPN3N+u9pJm97wt1SBXnJpvJ5L0sXDAdwAQanWskwpU2CYSGrbm8hrcStXkRgQjS9I3jSLU37Yx0uEjq9wf4/Vn8X/01FSXgcmP549jf7y1mhKFhgu5oQutI33W2bAu2w/qSuGiheEFrrY8dN7sqMMw7UnJECw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302253; c=relaxed/simple;
	bh=5B5eF+TkujdaoJdxutQVCkKp4IWuNS0J04iIKVwzhRo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aBA5M/cFSFMUh8InGn5nB5T5CakcG/Gl9W+7TTwhf3vOuUTMBVZ2un5pBEeX7W2vadLCMr3dbuzne+YNF0IOXuwNA10JTiuJCaqrz3zDv5PYhwP1dZN1x5QMxYlZFXw7l+yKdVI7i4c76JpAk7vQq36QCMeRrTSyYpCG/riye40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h0ALb5Ej; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h0ALb5Ej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0775CC32786;
	Tue, 30 Jul 2024 01:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302253;
	bh=5B5eF+TkujdaoJdxutQVCkKp4IWuNS0J04iIKVwzhRo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=h0ALb5Ejs1AASK7TqlalKYf/hEr/ZK+lvun0qAQ9+NNp6n2Iy7AyM5VHFKoJFMUxe
	 ff1k7TcwWWomdYPB31iwj+1ncAm0G9qLjtcwgIuKssDadDREG49AVPATmBXoX5R0Kq
	 F9TTCvSCwqLGzYmgZD0zoJPEQhmmXUBwD6DikXR96yQ7dwS7BeRd54ePN4+srq4T3U
	 ILLl4tDPCCu0E6YKQvJbCHaPlhonp1VAyJylY+c4n4Ahx2iWg5R2ISOAdg1VbSMEST
	 npMg6Bvjrb4rV3lJzEbOLDFj91tyw6a5QvqvbJcrO5xLmwwlZy5fR9JCyDPArcg7Bm
	 nRvP5T0WkEiag==
Date: Mon, 29 Jul 2024 18:17:32 -0700
Subject: [PATCH 1/6] xfs_scrub_all: fail fast on masked units
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172229850069.1350643.14681171051215463285.stgit@frogsfrogsfrogs>
In-Reply-To: <172229850048.1350643.5520120825070703831.stgit@frogsfrogsfrogs>
References: <172229850048.1350643.5520120825070703831.stgit@frogsfrogsfrogs>
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

If xfs_scrub_all tries to start a masked xfs_scrub@ unit, that's a sign
that the system administrator really didn't want us to scrub that
filesystem.  Instead of retrying pointlessly, just make a note of the
failure and move on.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/xfs_scrub_all.in |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)


diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index 5440e51c0..5e2e0446a 100644
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

