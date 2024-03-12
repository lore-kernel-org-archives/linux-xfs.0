Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EDB26286
	for <linux-xfs@vger.kernel.org>; Tue, 12 Mar 2024 23:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710286213; cv=none; b=OE7ce62LDBDDz+0wYlazy/m3PhMMx1gU0ID+cHyORdLwcdEZK1tyVyB9l2qBho2YGkcO/FNfbv7JQNCg+XRqY/c0l3oKIk8Szcd1r8e4l7HnoD0D1Sj+cb0XPMhaychC4kqo5yKrOCIg00zRP64UEtRyu6RMKABPChuQm2ra2jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710286213; c=relaxed/simple;
	bh=A4uUbp83/qY60EuHFvy/xoQlk+wh7O7sVAkTDBWe0iQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=hXDl/ANFp9EhRLGkPkOjGSU9kW6To+9FLyX41MjtboaFBbCwOTh3TTrZwceuSuZRSih63sXtowoW9R3JiMCJDBZ2K+NFBK+Z0IR7t0vs9k3dHIDuIpZ1zDFw4zI67KWSvXrrcoBwBDf5QDoqqpnQZ4LPaYVIslwj8PIEw8cWgt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=dEmcmv12; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="dEmcmv12"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-5d8b70b39efso3844383a12.0
        for <linux-xfs@vger.kernel.org>; Tue, 12 Mar 2024 16:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1710286211; x=1710891011; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=pvntceOJl7R2zIBmJU83RL/CVdm4XPxlIVLHHnBqoS8=;
        b=dEmcmv12RwdgTXeFDih47hmfFHYA61hC1ZYilRG1mg3Ul09G2NXgEzs4/E7BqzD5rT
         jXBYeDvKEKiTluNIhE8H4WifriraCYM38mrcm72BfvYZUEtsDx8iXkJsFM3zxJZ4+hfp
         rFRMWj+VCWWS+kcOmUzoEzHR+pwFIVwxZ3t3/zbIjM87iap3LJq0JYXUIXfKalmJ9nP5
         wuMGDa4ni4dgh1lf9j0odi2tNx+CibxrZMLhAb3KRs/VPGxjIRSWj1fU0T6L9llmCYHw
         hX+ZPT7sHVCScikqhtsWVr7zAbwzik3gw9si2J+SFKlwPPXaRZ5LONyCwDcOkzS8LD8D
         /amQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710286211; x=1710891011;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pvntceOJl7R2zIBmJU83RL/CVdm4XPxlIVLHHnBqoS8=;
        b=GEeVohc/+Z9EzE1tdqvbz1mWW66y/35pO3Q2TUNt7zcl/zQMx8o/tuO0xhNXUSQh4g
         gWBL6/YGyqKp7Uh2+QgZZAuTB+sGfMSNXpHVFexv+2WAyA++JFWtbFQuSANa+3wFChtr
         Sy7e5bzMzYzjkFod9U+5e9jEQ1TArwaxgODl6SsQcswOEFXQZqp1R2L8bO+cssYy3pP9
         R6hnZTv112/+WxUcIGC4ZOAIbHGp9GmZSnO0JK+bzbBilJMtQcUJayMiHG/jKlypxnXE
         4tElJEHoMpDkVSg00zribzM2Y7lsva6zOmGtx1spnJ+rw+7rCvPon5hdFvnunohBDLq7
         OsZw==
X-Gm-Message-State: AOJu0YzAa4RBVe+J2q6/buRUmBOIRv6JUYAKIiONzDViut29mjQo3C2G
	6WZiV95nzfypkITc/rrM6DVpFzN2UkPMF9ujTwA2gU+Kq3vnDSEajapF0yOK3hbgyIaBbNRZh0v
	M
X-Google-Smtp-Source: AGHT+IEPmJtf0YIj62ESlYYjMNx2Oa9/XSzmIE1vI21NXctPL3YGORvFvRfTpzLKAC89u0Jn+e+9pQ==
X-Received: by 2002:a05:6a20:ba9:b0:1a1:51e0:8665 with SMTP id i41-20020a056a200ba900b001a151e08665mr7683612pzh.55.1710286210635;
        Tue, 12 Mar 2024 16:30:10 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-47-118.pa.nsw.optusnet.com.au. [49.179.47.118])
        by smtp.gmail.com with ESMTPSA id gu17-20020a056a004e5100b006e572d86152sm6805151pfb.91.2024.03.12.16.30.09
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Mar 2024 16:30:09 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rkBZP-0016xl-07
	for linux-xfs@vger.kernel.org;
	Wed, 13 Mar 2024 10:30:06 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rkBZO-0000000AKR6-2G0y
	for linux-xfs@vger.kernel.org;
	Wed, 13 Mar 2024 10:30:06 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: allow sunit mount option to repair bad primary sb stripe values
Date: Wed, 13 Mar 2024 10:30:06 +1100
Message-ID: <20240312233006.2461827-1-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

If a filesystem has a busted stripe alignment configuration on disk
(e.g. because broken RAID firmware told mkfs that swidth was smaller
than sunit), then the filesystem will refuse to mount due to the
stripe validation failing. This failure is triggering during distro
upgrades from old kernels lacking this check to newer kernels with
this check, and currently the only way to fix it is with offline
xfs_db surgery.

This runtime validity checking occurs when we read the superblock
for the first time and causes the mount to fail immediately. This
prevents the rewrite of stripe unit/width via
mount options that occurs later in the mount process. Hence there is
no way to recover this situation without resorting to offline xfs_db
rewrite of the values.

However, we parse the mount options long before we read the
superblock, and we know if the mount has been asked to re-write the
stripe alignment configuration when we are reading the superblock
and verifying it for the first time. Hence we can conditionally
ignore stripe verification failures if the mount options specified
will correct the issue.

We validate that the new stripe unit/width are valid before we
overwrite the superblock values, so we can ignore the invalid config
at verification and fail the mount later if the new values are not
valid. This, at least, gives users the chance of correcting the
issue after a kernel upgrade without having to resort to xfs-db
hacks.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_sb.c | 40 +++++++++++++++++++++++++++++++---------
 fs/xfs/libxfs/xfs_sb.h |  3 ++-
 2 files changed, 33 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index d991eec05436..f51b1efa2cae 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -530,7 +530,8 @@ xfs_validate_sb_common(
 	}
 
 	if (!xfs_validate_stripe_geometry(mp, XFS_FSB_TO_B(mp, sbp->sb_unit),
-			XFS_FSB_TO_B(mp, sbp->sb_width), 0, false))
+			XFS_FSB_TO_B(mp, sbp->sb_width), 0,
+			xfs_buf_daddr(bp) == XFS_SB_DADDR, false))
 		return -EFSCORRUPTED;
 
 	/*
@@ -1323,8 +1324,10 @@ xfs_sb_get_secondary(
 }
 
 /*
- * sunit, swidth, sectorsize(optional with 0) should be all in bytes,
- * so users won't be confused by values in error messages.
+ * sunit, swidth, sectorsize(optional with 0) should be all in bytes, so users
+ * won't be confused by values in error messages. This returns false if a value
+ * is invalid and it is not the primary superblock that going to be corrected
+ * later in the mount process.
  */
 bool
 xfs_validate_stripe_geometry(
@@ -1332,20 +1335,21 @@ xfs_validate_stripe_geometry(
 	__s64			sunit,
 	__s64			swidth,
 	int			sectorsize,
+	bool			primary_sb,
 	bool			silent)
 {
 	if (swidth > INT_MAX) {
 		if (!silent)
 			xfs_notice(mp,
 "stripe width (%lld) is too large", swidth);
-		return false;
+		goto check_override;
 	}
 
 	if (sunit > swidth) {
 		if (!silent)
 			xfs_notice(mp,
 "stripe unit (%lld) is larger than the stripe width (%lld)", sunit, swidth);
-		return false;
+		goto check_override;
 	}
 
 	if (sectorsize && (int)sunit % sectorsize) {
@@ -1353,21 +1357,21 @@ xfs_validate_stripe_geometry(
 			xfs_notice(mp,
 "stripe unit (%lld) must be a multiple of the sector size (%d)",
 				   sunit, sectorsize);
-		return false;
+		goto check_override;
 	}
 
 	if (sunit && !swidth) {
 		if (!silent)
 			xfs_notice(mp,
 "invalid stripe unit (%lld) and stripe width of 0", sunit);
-		return false;
+		goto check_override;
 	}
 
 	if (!sunit && swidth) {
 		if (!silent)
 			xfs_notice(mp,
 "invalid stripe width (%lld) and stripe unit of 0", swidth);
-		return false;
+		goto check_override;
 	}
 
 	if (sunit && (int)swidth % (int)sunit) {
@@ -1375,9 +1379,27 @@ xfs_validate_stripe_geometry(
 			xfs_notice(mp,
 "stripe width (%lld) must be a multiple of the stripe unit (%lld)",
 				   swidth, sunit);
-		return false;
+		goto check_override;
 	}
 	return true;
+
+check_override:
+	if (!primary_sb)
+		return false;
+	/*
+	 * During mount, mp->m_dalign will not be set unless the sunit mount
+	 * option was set. If it was set, ignore the bad stripe alignment values
+	 * and allow the validation and overwrite later in the mount process to
+	 * attempt to overwrite the bad stripe alignment values with the values
+	 * supplied by mount options.
+	 */
+	if (!mp->m_dalign)
+		return false;
+	if (!silent)
+		xfs_notice(mp,
+"Will try to correct with specified mount options sunit (%d) and swidth (%d)",
+			BBTOB(mp->m_dalign), BBTOB(mp->m_swidth));
+	return true;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index 67a40069724c..58798b9c70ba 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -35,7 +35,8 @@ extern int	xfs_sb_get_secondary(struct xfs_mount *mp,
 				struct xfs_buf **bpp);
 
 extern bool	xfs_validate_stripe_geometry(struct xfs_mount *mp,
-		__s64 sunit, __s64 swidth, int sectorsize, bool silent);
+		__s64 sunit, __s64 swidth, int sectorsize, bool primary_sb,
+		bool silent);
 
 uint8_t xfs_compute_rextslog(xfs_rtbxlen_t rtextents);
 
-- 
2.43.0

