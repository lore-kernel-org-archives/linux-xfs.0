Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4681312CDA5
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498421; cv=none; b=Hye+rsFynsNjXOzC4vMqT6lT/9ccHD3gIZalsjK5H4S5nU76sq8dEH3yKWE9FffVa1H8b+fsHENiwcxsPXzqJy/9GTBA5ltU9q68PVUShfaWNJPOJeDxaE3mncAn6UUTnPqnBUdJHBo+tXlKrSJSMcq0Pe4afY47GZI20d+iM+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498421; c=relaxed/simple;
	bh=Ysc2HuyNvms75fnIlAg2+NAgYoo7ITg1F1UOKkT71Yo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n+IRHgFXexrd0i9U3q9NpMzbgr1tFwW0ywLXW03uSQJOOZcVoV31VnbJ4sJtjoI2f83mO1sCfA44GCCdcw9EBjMopwCG+Zbz5uCR2ee8CxbVns9Cd+oLba8fj26ljuz8rQPbh0t79XDm1qDX6rXx3EKGB+CgW3AI0G6VNnSMwAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ecHaLXCv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ecHaLXCv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22915C19423;
	Tue,  3 Mar 2026 00:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498421;
	bh=Ysc2HuyNvms75fnIlAg2+NAgYoo7ITg1F1UOKkT71Yo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ecHaLXCvg5WP+aEgo1VFFVjX31USs6kHmW5sK65lXqbCbI6vY8bG3y1+xJcSAIBY0
	 EQ0CU/aECkBZPYRksWR07+jyrQyGrmbDiYiYMM6MwyaqedoXQZlNftriJYgb+NWHMi
	 kyVUL2YtXc3N5FVBStV4MbN3ludA3EY5h5Xz8bkUJrRGIRpW24qPlOySRxPT1UkaX4
	 xwoUH+g4xT/NaIpgctYLaQLkoa0ZhykHquWSy2D+VvFRxTyQkaIovG/NJKDETv8t5I
	 p8wxdFvXpHiqnhCDdkjTO5j2XZQPPT//+5aJ2qfzLUL1nMw4k+eIqqlVqzbffqEyBZ
	 Jy9i2QpNwCT6g==
Date: Mon, 02 Mar 2026 16:40:20 -0800
Subject: [PATCH 25/26] debian: enable xfs_healer on the root filesystem by
 default
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177249783748.482027.8553755838914398859.stgit@frogsfrogsfrogs>
In-Reply-To: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
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

