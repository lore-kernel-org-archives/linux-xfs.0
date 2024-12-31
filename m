Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F8E1B0425
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735689191; cv=none; b=S3OBadJD/7TTB8dJnCPvUDMAeN5tYz6SINjBmHwExYFxcNsymaClahjLohbGEZ545iOwMT/caj2P+OZDvKSG+TfJUHWr940R2YoVdU/BLe6/IZaJsyFN1cRPet7p3LN/+wXVUS8a070nADKAxUa+iunPy73aUCfRnoltI+ZkCA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735689191; c=relaxed/simple;
	bh=Unuf4bLFsU7llW5bSf5CAC0dxUN102zmN9OReMlZChE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T7gMP4hdmvJwdNfDMBMjPZIg+jfexhpDlMmeQYtj8TaoMM+0IWXEQ4WY0SwYKv1C1fuJnNExFxvY/Nh1k/P68TESp4VnLzRjtCLlOiO5DL1MQqRue+VN5yo+pixWx1G1Bvca5Y727H7n96gvMOXp+3UeVnwybWDF0S+Pwq3YCU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N5xSmmp1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N5xSmmp1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D240C4CED2;
	Tue, 31 Dec 2024 23:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735689191;
	bh=Unuf4bLFsU7llW5bSf5CAC0dxUN102zmN9OReMlZChE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=N5xSmmp1VXcHV+DMt9O5K0zMkk/yCEQL7L/tb0O3muAb95pHwwj8lMH4X7xPFCTED
	 fqEmY850DlAUEpedKzBZHgaVRWuAXHTfpnd82EYqGhrIlNJT4GIJ3z8fzHv/79KXfy
	 wuwk+gdnZ1Ua9Vrl6aSKbFOHWc6eGOP9u1E8InxrSK2MxYG7/hy2zPHL6QYBjyHONX
	 HQ/YGOGOoX2FVc2YEFrI8iymqcELdtdlH6701QyDXpbKQgmbFKpCSVwUYV3XWoBDVF
	 YFY03+Jn7LAvB1ZXLekWoxP4v8pcXEtkroGwyP3U/lza+6PfHCq/Cc8XZDKxXe+ViY
	 dn6u/zdd8lSZg==
Date: Tue, 31 Dec 2024 15:53:11 -0800
Subject: [PATCH 21/21] debian: enable xfs_scrubbed on the root filesystem by
 default
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568778785.2710211.3816113785296897483.stgit@frogsfrogsfrogs>
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

Now that we're finished building autonomous repair, enable the service
on the root filesystem by default.  The root filesystem is mounted by
the initrd prior to starting systemd, which is why the udev rule cannot
autostart the service for the root filesystem.

dh_installsystemd won't activate a template service (aka one with an
at-sign in the name) even if it provides a DefaultInstance directive to
make that possible.  Use a fugly shim for this.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 debian/control                 |    2 +-
 debian/postinst                |    8 ++++++++
 debian/prerm                   |   13 +++++++++++++
 scrub/xfs_scrubbed@.service.in |    2 +-
 4 files changed, 23 insertions(+), 2 deletions(-)
 create mode 100644 debian/prerm


diff --git a/debian/control b/debian/control
index 66b0a47a36ee24..31ea1e988f66be 100644
--- a/debian/control
+++ b/debian/control
@@ -10,7 +10,7 @@ Homepage: https://xfs.wiki.kernel.org/
 Package: xfsprogs
 Depends: ${shlibs:Depends}, ${misc:Depends}, python3-dbus, python3:any
 Provides: fsck-backend
-Suggests: xfsdump, acl, attr, quota
+Suggests: xfsdump, acl, attr, quota, python3-jsonschema
 Breaks: xfsdump (<< 3.0.0)
 Replaces: xfsdump (<< 3.0.0)
 Architecture: linux-any
diff --git a/debian/postinst b/debian/postinst
index 2ad9174658ceb4..4ba2e0c43b887e 100644
--- a/debian/postinst
+++ b/debian/postinst
@@ -24,5 +24,13 @@ case "${1}" in
 esac
 
 #DEBHELPER#
+#
+# dh_installsystemd doesn't handle template services even if we supply a
+# default instance, so we'll install it here.
+if [ -z "${DPKG_ROOT:-}" ] && [ -d /run/systemd/system ] ; then
+	if [ "$1" = "configure" ] || [ "$1" = "abort-upgrade" ] || [ "$1" = "abort-deconfigure" ] || [ "$1" = "abort-remove" ] ; then
+		/bin/systemctl enable xfs_scrubbed@.service || true
+	fi
+fi
 
 exit 0
diff --git a/debian/prerm b/debian/prerm
new file mode 100644
index 00000000000000..48e8e94c4fe9ac
--- /dev/null
+++ b/debian/prerm
@@ -0,0 +1,13 @@
+#!/bin/sh
+
+set -e
+
+# dh_installsystemd doesn't handle template services even if we supply a
+# default instance, so we'll install it here.
+if [ -z "${DPKG_ROOT:-}" ] && [ "$1" = remove ] && [ -d /run/systemd/system ] ; then
+	/bin/systemctl disable xfs_scrubbed@.service || true
+fi
+
+#DEBHELPER#
+
+exit 0
diff --git a/scrub/xfs_scrubbed@.service.in b/scrub/xfs_scrubbed@.service.in
index afd5c204327946..5bf1e79031af8c 100644
--- a/scrub/xfs_scrubbed@.service.in
+++ b/scrub/xfs_scrubbed@.service.in
@@ -19,7 +19,7 @@ RequiresMountsFor=%f
 Type=exec
 Environment=SERVICE_MODE=1
 ExecCondition=@pkg_libexec_dir@/xfs_scrubbed --check %f
-ExecStart=@pkg_libexec_dir@/xfs_scrubbed --log %f
+ExecStart=@pkg_libexec_dir@/xfs_scrubbed --autofsck --log %f
 SyslogIdentifier=%N
 
 # Run scrub with minimal CPU and IO priority so that nothing else will starve.

