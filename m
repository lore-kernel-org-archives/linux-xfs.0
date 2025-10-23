Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47EB9A927
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178342; cv=none; b=fLvWXF4RpC06tyHIyAzDXv/q/CYcxwlKOUOQKtQMxEdNZ6vqEA9ZxfrCVIPuWle2q8umXyqkJRZMU9VKNkABMRyExMXDCInx93f9O2YuZTu65Cz0ATLAuJU5Je1ixlFhCuf8vKgAfjuoOOU08SDbNsUAjv8Dxf3k5mV3Ro/eKTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178342; c=relaxed/simple;
	bh=piglTFe/sh9fE2JH1MDKdVRCNaTRNsCv7EUW4H7Wh1Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GY81eFb3ZQnPyo7Jd3/2UJ0Ic8U8KoycnyCVHkGr/DX6ddzbmzcSNfB5FdWf+R15p2iYqlL3RhTQtohe0j8lmF1x6Ej21rygmpyM4CtME3cAcQw6Sj/OTXo+NT90UmCeFYkMs1twXO7qAmf+0p+C4hn/9yYb5P0D1WbsNSTIrDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QN6wI3gE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QN6wI3gE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD51DC4CEE7;
	Thu, 23 Oct 2025 00:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178340;
	bh=piglTFe/sh9fE2JH1MDKdVRCNaTRNsCv7EUW4H7Wh1Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QN6wI3gEYSMCajon+Jfwc6LV4CGmgvpPeexmvgNvrVspPp6X0F2YvKuHyihoeJ3Zf
	 huOd3MxvoNtW59pw2TmxN+vofUWY6GkYBFZ7XM8h8CxOksSj5zW6yG6ktW5EHJxWI1
	 Gb/aAcX7WykpIv/jkHWr8rExDsIs7d5qKWx1ratRUomgrx3+9a6Qjua3IqY076T1TC
	 7OQDYN57NWQPrHrG8k6T5Wei+f5dOOKEXsuQh9oHN9IxVhtP190twWFACCsmPGznfa
	 BadKVZvSIjvda3X6anqgV2MZr6625T7Vo/HCuk62It5cu84xGya0tqhkF7Ru4R7dBG
	 RoAHU1L1h2kIA==
Date: Wed, 22 Oct 2025 17:12:20 -0700
Subject: [PATCH 26/26] debian: enable xfs_healer on the root filesystem by
 default
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117747955.1028044.13749403596037457229.stgit@frogsfrogsfrogs>
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

Now that we're finished building autonomous repair, enable the service
on the root filesystem by default.  The root filesystem is mounted by
the initrd prior to starting systemd, which is why the udev rule cannot
autostart the service for the root filesystem.

dh_installsystemd won't activate a template service (aka one with an
at-sign in the name) even if it provides a DefaultInstance directive to
make that possible.  Use a fugly shim for this.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 debian/control  |    2 +-
 debian/postinst |    8 ++++++++
 debian/prerm    |   13 +++++++++++++
 debian/rules    |    2 +-
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
index 2ad9174658ceb4..e9ca1c22c43d25 100644
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
+		/bin/systemctl enable xfs_healer@.service || true
+	fi
+fi
 
 exit 0
diff --git a/debian/prerm b/debian/prerm
new file mode 100644
index 00000000000000..c526dcdd1d7103
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
+	/bin/systemctl disable xfs_healer@.service || true
+fi
+
+#DEBHELPER#
+
+exit 0
diff --git a/debian/rules b/debian/rules
index 7c9f90e6c483ff..2bf736f340c53d 100755
--- a/debian/rules
+++ b/debian/rules
@@ -97,4 +97,4 @@ override_dh_installdocs:
 	dh_installdocs -XCHANGES
 
 override_dh_installsystemd:
-	dh_installsystemd -p xfsprogs --no-restart-after-upgrade --no-stop-on-upgrade system-xfs_scrub.slice xfs_scrub_all.timer
+	dh_installsystemd -p xfsprogs --no-restart-after-upgrade --no-stop-on-upgrade system-xfs_scrub.slice xfs_scrub_all.timer system-xfs_healer.slice

