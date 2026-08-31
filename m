Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E718E3E7BBF
	for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 23:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788218796; cv=none; b=nSkSfuXnqgerndoBAQWbr5y1LUqgzpr569kTsL2Vp6akNXkF5pmnFt5ZtioYEXg+lXEwwFdZJ4MFMfhmzQ2BhqrwYZhRvjEJMd76hsNLBhe+4kmx7FlorD2W1VJUXbMXE8oFLXOOLTWgwxGuCO1OPPIbocWUTUUYSEpqRgmtBAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788218796; c=relaxed/simple;
	bh=Pj1dwmzAL+gsKEPyxETkiIHmd3PDigLyh6NZa+VRrvE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U9jxoIQLMX3jlC4W3a61KJXU+JI3IP+/aKGH3zCGVbO5QuZ8gExrSQD6IGnWPtbrg5Tt9KUJdeAvH8cwgBHyiIYjzuSrayYzSiiRlu8Fp9ciUiRTzdlhoKGMX3yEarvqqct/FcMd3faklpY5vPTXhWet3nEhYCg6RQKuor1r8JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n/jw2xru; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n/jw2xru"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6D82F1F000E9;
	Mon, 31 Aug 2026 23:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788218794;
	bh=4JEhzje89TiLVvoCaZwlvUj6eL9QLQP1Ub1XnPaVtJ4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=n/jw2xru3IrDOZx05vQRy2UUDxvgpy141CzR4TZd9calcyVMiAiYnSM5ayWcMmb+Z
	 YS7kk42l4YvuMFDpbevJSk1n6TG6QJBLqCmrXHDjfPxaUn8zlxanh4KH80A8hi1eyb
	 yRxOdsGrtdUJiWUD128u0UwOIGm/htAbPMjwkZnStdnMNsXZGHcwhvlZDdLjiHlurx
	 qqm0qPVAjFVj8PG3U9kxUEezutjbyLx9jJIO0JkSWDvsgF1VI5dEKAEVvrI2a+ywNI
	 /ozaM4TgqFyvvEmU3IgQAEPVwKmTwzcurSSC1MmIWkyrboid/sayQtOn84H6XmZTVw
	 F/hM/59icR92w==
Date: Mon, 31 Aug 2026 16:26:34 -0700
Subject: [PATCH 1/1] xfs_scrub: terminate systemd services if the sysadmin
 unmounts
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178821870256.2381099.4607775862934813829.stgit@frogsfrogsfrogs>
In-Reply-To: <178821870236.2381099.2561252941543842548.stgit@frogsfrogsfrogs>
References: <178821870236.2381099.2561252941543842548.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

We should make sure that any systemd services started on behalf of an
XFS mount are torn down when the mount goes away.  On a modern system,
calling umount(8) while there's an xfs_scrub service running on that
mount point will successfully remove the mount from the caller's mount
namespace, but the filesystem remains mounted in the service's private
mount namespace, with the effect that the filesystem stays mounted.
This is probably not what the user wants.

Per cks' blog, the way to fix this is through a BindTo= clause.

Note: This isn't needed for xfs_healer because it only maintains a soft
reference to the mounted filesystem and can reconnect to a filesystem if
its mounts move.

Link: https://utcc.utoronto.ca/~cks/space/blog/linux/SystemdStopOnFSUnmount
Cc: <linux-xfs@vger.kernel.org> # v6.10.0
Fixes: 0109639eede4dc ("xfs_scrub: tighten up the security on the background systemd service")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/xfs_scrub@.service.in       |    3 +++
 scrub/xfs_scrub_media@.service.in |    3 +++
 2 files changed, 6 insertions(+)


diff --git a/scrub/xfs_scrub@.service.in b/scrub/xfs_scrub@.service.in
index fb38319e95c148..3e4e79fe6a1913 100644
--- a/scrub/xfs_scrub@.service.in
+++ b/scrub/xfs_scrub@.service.in
@@ -19,6 +19,9 @@ ConditionCapability=CAP_SYS_RAWIO
 ConditionPathIsMountPoint=%f
 RequiresMountsFor=%f
 
+# Terminate service if someone unmounts the filesystem
+BindsTo=%i.mount
+
 [Service]
 Type=oneshot
 Environment=SERVICE_MODE=1
diff --git a/scrub/xfs_scrub_media@.service.in b/scrub/xfs_scrub_media@.service.in
index 98cd1ac44fbebd..954b8e92a1ce53 100644
--- a/scrub/xfs_scrub_media@.service.in
+++ b/scrub/xfs_scrub_media@.service.in
@@ -19,6 +19,9 @@ ConditionCapability=CAP_SYS_RAWIO
 ConditionPathIsMountPoint=%f
 RequiresMountsFor=%f
 
+# Terminate service if someone unmounts the filesystem
+BindsTo=%i.mount
+
 [Service]
 Type=oneshot
 Environment=SERVICE_MODE=1

