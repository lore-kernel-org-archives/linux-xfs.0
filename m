Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5EC346FA4
	for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2026 06:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775801843; cv=none; b=Rz5SHF7s4QefNyVMaGx2V9OW6SDcKOTAElXRFOu0V/vmVYKaUwBmKNKHdwEb0jJw/JaVDxhXD6OfZ3SvnZmwH9p+0mgEaFevF4V7fiqF7lcX6SuzsbkPD8EJ5/URXhDZ4BsDVrqlEI81+Jh359H2aW6iTM9FXCXr9z+bkS3GY8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775801843; c=relaxed/simple;
	bh=tH878BAhB56nvbLiToUqU3pqIAXXyPAWDtdHrH6/XrU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tpooxuD1+J8gSRtsUOpPBvYxSOF3H00Mnj6g55iD8zMhthZNMz3an/+UTvO3ZQ1K5jkuY0cww4MKv3MsVrIRJyRJO6tu8heyC/KXqnA3p4J5fcRzRBIuVDNKmMaKE4rZrHOP9bRJ+V+W54jEztk+41A8gkl6hEneDR05v7NzN6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ouEMrdJZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ouEMrdJZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58903C19421;
	Fri, 10 Apr 2026 06:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775801843;
	bh=tH878BAhB56nvbLiToUqU3pqIAXXyPAWDtdHrH6/XrU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ouEMrdJZLNHiyPQ8o45TO1qtmRgBQsli5DIT4QXM8iKSLmSt82LwLbYOAFez4h2ad
	 aODsFHgravuSj5XxuWw27m6fKUgIEch9J2hkk8JUsokeH0WPf8rPnpymgjjqU42sQ2
	 aFn7HA4O49vtv0g0bf2bbZMaWmVg74m0ooOpQB6gx3oGT5SM2Cjwi1p3UqStjGKSsu
	 L0KnIg4gVd+cIWz8od5lgUfGQsNudXN2WckTAb4IenOIrA+OzGP43+UHsZz9CZ414L
	 FTPmxZVRWMtRg75xBO+5vtJPzAmSLAgZ95vabQYatHs5JRC166KKXwZ3155v2BE8Ws
	 YWjHi8QdifeYg==
Date: Thu, 09 Apr 2026 23:17:22 -0700
Subject: [PATCH 26/26] debian: enable xfs_healer on the root filesystem by
 default
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177577384708.2089237.1298936327790756982.stgit@frogsfrogsfrogs>
In-Reply-To: <177577384104.2089237.6309276904931285911.stgit@frogsfrogsfrogs>
References: <177577384104.2089237.6309276904931285911.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that we're finished building autonomous repair, enable the healer
service on the root filesystem by default.  The root filesystem is
mounted by the initrd prior to starting systemd, which is why the
xfs_healer_start service cannot autostart the service for the root
filesystem.

dh_installsystemd won't activate a template service (aka one with an
at-sign in the name) even if it provides a DefaultInstance directive to
make that possible.  Hence we enable this explicitly via the postinst
script.

Note that Debian enables services by default upon package installation,
so this is consistent with their policies.  Their kernel doesn't enable
online fsck, so healer won't do much more than monitor for corruptions
and log them.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 debian/postinst |    8 ++++++++
 debian/prerm    |   13 +++++++++++++
 debian/rules    |    3 ++-
 3 files changed, 23 insertions(+), 1 deletion(-)
 create mode 100644 debian/prerm


diff --git a/debian/postinst b/debian/postinst
index d11c8d94a3cbe4..966dbb7626cab3 100644
--- a/debian/postinst
+++ b/debian/postinst
@@ -21,5 +21,13 @@ case "${1}" in
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
index 7c9f90e6c483ff..aaf99a95ce3df5 100755
--- a/debian/rules
+++ b/debian/rules
@@ -97,4 +97,5 @@ override_dh_installdocs:
 	dh_installdocs -XCHANGES
 
 override_dh_installsystemd:
-	dh_installsystemd -p xfsprogs --no-restart-after-upgrade --no-stop-on-upgrade system-xfs_scrub.slice xfs_scrub_all.timer
+	dh_installsystemd -p xfsprogs --no-restart-after-upgrade --no-stop-on-upgrade system-xfs_scrub.slice xfs_scrub_all.timer system-xfs_healer.slice
+	dh_installsystemd -p xfsprogs --restart-after-upgrade xfs_healer_start.service

