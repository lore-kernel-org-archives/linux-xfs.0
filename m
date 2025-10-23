Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13A2125A0
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178232; cv=none; b=GcXs4g4JNJpE7NSc4t8NewZygX17xz5cApTIXqGr4xEtcLWoO61RQHfdy2UP8rL3DV/9bczHNfOEK26772q3r5vepUEFFoFgoD0uDzMlNqIO2JBW2p/HT+n+JiyRgG8N9ZZDJYgWkv76Qed7mQscgP2iI0YeCiNaL1XKj2fkNKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178232; c=relaxed/simple;
	bh=9R7arRR8VSvvwt2b/gTO+UUXzAFvSCtkyzj/7UWt5hg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ke6V5UpsxLO6TXZhcTYuX//MM/DJLZZ1ykP0YTKI9gmYSQyqVxqPHKeKppqClraJAJWQWwR0KVUY8Vpea6iVMyMhOvqX1qj/3GlJu7ghl49Ryp5yKNcW+UKB30txHgcOU8EJfhu+75TcdCVyEbihvOoXtBBpd7BoJvVbeMnSxuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eRDHroCJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eRDHroCJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E85C4CEE7;
	Thu, 23 Oct 2025 00:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178231;
	bh=9R7arRR8VSvvwt2b/gTO+UUXzAFvSCtkyzj/7UWt5hg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eRDHroCJdQZIN5Y1ZntPk++0CrrfricWmFtCB3hMH4tnoFzR0gDBJUM0ayWiRvyNx
	 KfNCfzrPUrDBtJpolK5fcuEYXbWYj2/Ejcg+0VEvp8piSGDu44LFYroZZ5Sx91MTGH
	 KDWsCGEyg9d0nyNdE/Y2RYeZ0JbhC2anmVINdDxHOXiFgWR/xB30AK9sV8AJRoHqux
	 FXV++pur7JszVDAPRpMn30Uxq1yiPsp8l2EfKucwYZr9TtsI0lUL5jGshHMLOm26UA
	 gJ79pkvGOOziKzdpK90eAG+aZcVQwv9ugA/x/Ixej9v4syMCQHq6cJbu2+3YesO4Vn
	 TeTapWyZUodtQ==
Date: Wed, 22 Oct 2025 17:10:30 -0700
Subject: [PATCH 19/26] xfs_healer: don't start service if kernel support
 unavailable
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117747824.1028044.14230598959336511271.stgit@frogsfrogsfrogs>
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

Use ExecCondition= in the system service to check if kernel support for
the health monitor is available.  If not, we don't want to run the
service, have it fail, and generate a bunch of silly log messages.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/xfs_healer.py.in       |   30 +++++++++++++++++++++++++++++-
 healer/xfs_healer@.service.in |    1 +
 2 files changed, 30 insertions(+), 1 deletion(-)


diff --git a/healer/xfs_healer.py.in b/healer/xfs_healer.py.in
index e594ad4fc2c53e..df4bd906d530fc 100644
--- a/healer/xfs_healer.py.in
+++ b/healer/xfs_healer.py.in
@@ -849,7 +849,27 @@ def handle_event(lines, fh):
 
 		repair_metadata(event, fh)
 
-def monitor(mountpoint, event_queue, **kwargs):
+def check_monitor(mountpoint, fd):
+	'''Check if the kernel can send us health events for the given mountpoint.'''
+
+	try:
+		mon_fd = open_health_monitor(fd, verbose = everything)
+	except OSError as e:
+		# Error opening monitor (or it's simply not there); monitor
+		# not available.
+		if e.errno == errno.ENOTTY or e.errno == errno.EOPNOTSUPP:
+			msg = _("XFS health monitoring not supported.")
+			eprintln(f"{mountpoint}: {msg}")
+		os.close(fd)
+		return 1
+
+	os.close(mon_fd)
+	os.close(fd)
+
+	# Monitor available; success!
+	return 0
+
+def monitor(mountpoint, event_queue, check, **kwargs):
 	'''Monitor the given mountpoint for health events.'''
 	global everything
 	global log
@@ -904,6 +924,12 @@ def monitor(mountpoint, event_queue, **kwargs):
 			msg = _("XFS online repair is less effective without parent pointers.")
 			printlogln(f"{mountpoint}: {msg}")
 
+	# Now that we know that we can repair if the user wanted to, make sure
+	# that the kernel supports reporting events if that was as far as the
+	# user wanted us to go.
+	if check:
+		return check_monitor(mountpoint, fd)
+
 	try:
 		fh = fshandle(fd, mountpoint) if want_repair or has_parent else None
 	except Exception as e:
@@ -1090,6 +1116,8 @@ def main():
 			help = argparse.SUPPRESS)
 	parser.add_argument("--repair", action = "store_true", \
 			help = _("Always repair corrupt metadata"))
+	parser.add_argument("--check", action = "store_true", \
+			help = _("Check that health monitoring is supported"))
 	args = parser.parse_args()
 
 	if args.V:
diff --git a/healer/xfs_healer@.service.in b/healer/xfs_healer@.service.in
index 1f74fc000ce490..5660050a1aa3e4 100644
--- a/healer/xfs_healer@.service.in
+++ b/healer/xfs_healer@.service.in
@@ -17,6 +17,7 @@ RequiresMountsFor=%f
 [Service]
 Type=exec
 Environment=SERVICE_MODE=1
+ExecCondition=@pkg_libexec_dir@/xfs_healer --check %f
 ExecStart=@pkg_libexec_dir@/xfs_healer --log %f
 SyslogIdentifier=%N
 

