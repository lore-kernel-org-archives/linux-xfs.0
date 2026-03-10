Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603EA1547C0
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 03:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773114593; cv=none; b=Jq0U7npVKzu2suh4XI/ysTZDB6tZ744bI7hIywj0f9pFMyKwxSEXifpo9Dy7YUjCC26uySex/k9JghnWeSb5+gqlEJ4cvbaWK1hXvcasWrpLQK5+jw6E9jWodW0x5yAnH+rv0a1jqyDlyS1UqKp/hWW5uGHcFe7lLcHKXWXJajk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773114593; c=relaxed/simple;
	bh=oNhFsYIldooYC6beqP0Ry/gt4FDHDW0H46qRyDHZbkE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ASo1gwGRxXVT485GfyuRRwnRUI6vhghkNKF3SfBpfd5rcoDDu+4QUYOTDeA4KthZ3iug+aG79uDPfzpAwPhpkEid2i2GcmGunAJt1dAUtNwtjuBRjoty0c7hTLouMA0yIVviJg554a7H2j4Bb/PDBhflupphDp3jWCNuSX6nT1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O62E52IA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O62E52IA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F13C19423;
	Tue, 10 Mar 2026 03:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773114593;
	bh=oNhFsYIldooYC6beqP0Ry/gt4FDHDW0H46qRyDHZbkE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=O62E52IA/CljmC1uUxeY3KP2GGQbuIXIDhx8Xlb4Xg+RW8IF1CGoqlMKuKOgKyw53
	 OINeB2ozAE/yJDd6m1RQhkhJIM1/kZpcF9ESqCUh8bepoxKJkLoTjF1j5UgkYiGMv4
	 GUZIMDsRMPRe0g4m80LxGeNsql6fOvqFy916CzLe7g5ib6PeBdCZb+8LT+qSewq7iE
	 wvZlXcyRZ1X6yiJM0j4iNngeCi50Xe7moRLLk21DXiMD1OfDQ/XJc6GfcTV+71kDeF
	 IUidlOfruZJAMMd24z97veuJO8SjqpNglccnpYsW0Lya8rldV38BTJGnd5A452Ul+P
	 EnrpcR1XzD4kQ==
Date: Mon, 09 Mar 2026 20:49:52 -0700
Subject: [PATCH 28/28] debian: enable xfs_healer on the root filesystem by
 default
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <177311401966.1183235.18355245095682136285.stgit@frogsfrogsfrogs>
In-Reply-To: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
References: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
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

