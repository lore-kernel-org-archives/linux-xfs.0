Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71BEF1822C9
	for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2024 17:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718213758; cv=none; b=LzQFQ0rUz2fBw1jpr3mGppZ2nG9uIdGU7jw2zy/9WAKPsRVUYBmgcB6ZisFKTghW+bLRIeuv4FTWZDl8zr7u6BoSV/Fpf9/zAWb2apnV/tSoBn1bgQwJ7YNm4NfXyd267g0Sdsohgz3Fciu/U75L/AbHnnWCF2gBgX9N91hD3vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718213758; c=relaxed/simple;
	bh=UC7Y9McedkNTi8JqfN3wECu+LZAlC2Nw6EAR/vfpvpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iwvqJk904kFJaqkK6b5W/QfBouRgAAFtbdvCv5mwJOFSJmWAfssn6uVasmlojh/WDHu8md3FC2I+hD3Fy0/2BFiQM5iWE8ibP5EpgGwRq/et7GXxU0DpXLNTYlZn868A5myfgz4kMfM11CpYPw5sVdXB+1+g8qr+SWUHl8lR/zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=I+AlDfvy; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="I+AlDfvy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Content-Transfer-Encoding:MIME-Version
	:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=i2fXGcXkyjtZP0fLCROAbXUOkPy1sjFn7SV6gZ1D7Go=; b=I+AlDfvyzdrGwqdnCD3x1Zxl7t
	6Ute5TMFx722J62zs+0JrocS/TYjcIpfPbhob2skGHXi4O2Wm7rKA1wy+StlL3kcYj3WZHTMcxzfi
	vgEUImHvADrYOhfv/2xRwQpbv2X/px8i/+m2VijEdht67qt47LJpJGsynYsdnq0SB2WbTT1TYPp5c
	yg8IddlZQLWOA+Ujgz3iJFIzcI/HCTZGou7iNJD3jY1IVXK7KvLbPwZTNO7JX1mpX35/oiFgFVFDd
	YZ11CsIxmZH0lGG8Guw7ORxkmIbjerxaOTEKj1rmttfHqttxMrI1B/7LrjlKrSP9YJgB4Bb+nIxoX
	95pnpL1A==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <bage@debian.org>)
	id 1sHRt5-008094-Ct; Wed, 12 Jun 2024 17:35:55 +0000
From: Bastian Germann <bage@debian.org>
To: linux-xfs@vger.kernel.org
Cc: Chris Hofstaedtler <zeha@debian.org>,
	Bastian Germann <bage@debian.org>
Subject: [PATCH 1/1] Install files into UsrMerged layout
Date: Wed, 12 Jun 2024 19:35:05 +0200
Message-ID: <20240612173551.6510-2-bage@debian.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240612173551.6510-1-bage@debian.org>
References: <20240612173551.6510-1-bage@debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Debian-User: bage

From: Chris Hofstaedtler <zeha@debian.org>

Signed-off-by: Chris Hofstaedtler <zeha@debian.org>
Signed-off-by: Bastian Germann <bage@debian.org>
---
 configure.ac                | 19 ++-----------------
 debian/local/initramfs.hook |  2 +-
 2 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/configure.ac b/configure.ac
index da30fc5c..a532d90d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -113,23 +113,8 @@ esac
 #
 test -n "$multiarch" && enable_lib64=no
 
-#
-# Some important tools should be installed into the root partitions.
-#
-# Check whether exec_prefix=/usr: and install them to /sbin in that
-# case.  If the user chooses a different prefix assume they just want
-# a local install for testing and not a system install.
-#
-case $exec_prefix:$prefix in
-NONE:NONE | NONE:/usr | /usr:*)
-  root_sbindir='/sbin'
-  root_libdir="/${base_libdir}"
-  ;;
-*)
-  root_sbindir="${sbindir}"
-  root_libdir="${libdir}"
-  ;;
-esac
+root_sbindir="${sbindir}"
+root_libdir="${libdir}"
 
 AC_SUBST([root_sbindir])
 AC_SUBST([root_libdir])
diff --git a/debian/local/initramfs.hook b/debian/local/initramfs.hook
index 5b24eaec..eac7e79e 100644
--- a/debian/local/initramfs.hook
+++ b/debian/local/initramfs.hook
@@ -45,7 +45,7 @@ rootfs_type() {
 . /usr/share/initramfs-tools/hook-functions
 
 if [ "$(rootfs_type)" = "xfs" ]; then
-	copy_exec /sbin/xfs_repair
+	copy_exec /usr/sbin/xfs_repair
 	copy_exec /usr/sbin/xfs_db
 	copy_exec /usr/sbin/xfs_metadump
 fi
-- 
2.45.2

