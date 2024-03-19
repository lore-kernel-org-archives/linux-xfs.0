Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1AE3363
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 00:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710808148; cv=none; b=U5cEH3zRy98gKLVQWuntsE+BZuqsuML9GoEv5MvZnDDhfJs3WcfJetnhoKAx8EgQsfcwdahVSNn2OM/jwwt//948aAhhw058zMaEcicwJdltEKzCaAp/v690eqeQWM2kMapmWjIDFrA5WlCW0GX7k5poEVMoOvub8bCsBCeEOY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710808148; c=relaxed/simple;
	bh=InG8Nbdpg6MYsdFrvNxXhxO/Vepg2V6Ep1OugZrMS3o=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=BpKYEacghfSj8qmw4tFRDQNd0IX/z4LaDkSkBl5q79KYTPvRLc8NI1g4rr+2zyn6gXAzd3nzlGG9uTqkJtsYjN16Am3UOYSRDBOQ7eMhk0ddyyIiDkJ4PLaWWbSvC3T9jt+KBRQIzYHM1O6GzMqcja+Rg1T0gOqDQ3QB79k5QEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Glw/3K9p; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Glw/3K9p"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1dde26f7e1dso35189275ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 17:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1710808146; x=1711412946; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aHMQrff8B8ROTcTnp7qRliKDke174PskVR5LmOMArlQ=;
        b=Glw/3K9ptid4OFLHYdmu7PTzC+5hTJMqnz+wCfqciQt16JYSdfINTfF3WrQxe/pTG7
         Np/lEj/kzbiQioNh9F3/KcdC8YCC49eR6TNZ0F0zitCcC32B+0qCtiy+Acwcp+DZ0i0S
         I7wNplyAFdSkawjdUYbwKUCMWu3sF35YbfyC4vTB79wlvoyqdtJutw0oCCA9m9ba3D7V
         ZD0exa+y/3HWSpfBvc/GnwTGE2KDybRUXkIW53EwxL5Cohkws4XZacuTI/0mnr1ywdC8
         vQzK2w0iSD8aUYcL7P4hElWqWbumiEGcO8e6HdxOcUISlpdImQEGtuOSxxDOIRTF5LAC
         Jt5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710808146; x=1711412946;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aHMQrff8B8ROTcTnp7qRliKDke174PskVR5LmOMArlQ=;
        b=rJ0igduxJO2ePZZWHyq834yM/5fGYhZKaz6HLwCb4CHokkv2B1kTd1duQZq3bbaRqe
         yqzGEBIE1HaQNkDbtq7Q2HKJOxqHzLKzNK1ndBkc1jkxzM1A5G9rhY73rlr5JkbKg1I4
         t3n12TEOCLGSJvoN2VBzGr5/jElOxc+aOxXV9seH7mO8Ev4oGWNtjWID8Ynp3oUvfqBF
         wc23RPfKWoE/fljpvPtqOsfj6dcZUzIxflrIk3lpewF6mjh8K0KM8PUcpmMwZIebn3pC
         X+jSZJ/JkGQd0WBnUvW08/aJlLTGVJd8jv8YeguZ9WUe59P+TB8FD9x3Ts/Bzvzcwxgb
         kzlQ==
X-Gm-Message-State: AOJu0YzSkKMI07Wvs6iigCd2QGgl4vGr9KwQ0t/1MIKLdQ1xbgmgS8hh
	w0cYeVVOpYTjPwo7U937HME6EiQBvdKPEdSW7Xn+TfOmR6AmsZg3gI9CtpTH+mttyKol4J/ciO9
	P
X-Google-Smtp-Source: AGHT+IEjL91dw4l9UJrswDSydUSZtdFT+RuqvQ6/iZzZfHEIi+KL73l0EqZjGGOtmcNw7iaw5+MSEA==
X-Received: by 2002:a17:902:c109:b0:1d7:4353:aba5 with SMTP id 9-20020a170902c10900b001d74353aba5mr11166488pli.58.1710808145764;
        Mon, 18 Mar 2024 17:29:05 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-185-123.pa.nsw.optusnet.com.au. [49.180.185.123])
        by smtp.gmail.com with ESMTPSA id j18-20020a170902c3d200b001ddce57bdbfsm9927381plj.308.2024.03.18.17.29.05
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 17:29:05 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rmNLj-003q8W-0B
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 11:29:03 +1100
Date: Tue, 19 Mar 2024 11:29:03 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfs: allow sunit mount option to repair bad primary sb
 stripe values
Message-ID: <ZfjcTxZEYl5Mzg9O@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


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
Version 2:
- reworded comment desribing xfs_validate_stripe_geometry() return
  value.
- renamed @primary_sb to @may_repair to indicate that the caller may
  be able to fix any inconsistency that is found, rather than
  indicate that this is being called to validate the primary
  superblock during mount.
- don't need 'extern' for prototypes in headers.

 fs/xfs/libxfs/xfs_sb.c | 40 +++++++++++++++++++++++++++++++---------
 fs/xfs/libxfs/xfs_sb.h |  5 +++--
 2 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index d991eec05436..73a4b895de67 100644
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
+ * won't be confused by values in error messages.  This function returns false
+ * if the stripe geometry is invalid and the caller is unable to repair the
+ * stripe configuration later in the mount process.
  */
 bool
 xfs_validate_stripe_geometry(
@@ -1332,20 +1335,21 @@ xfs_validate_stripe_geometry(
 	__s64			sunit,
 	__s64			swidth,
 	int			sectorsize,
+	bool			may_repair,
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
+	if (!may_repair)
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
index 2e8e8d63d4eb..37b1ed1bc209 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -35,8 +35,9 @@ extern int	xfs_sb_get_secondary(struct xfs_mount *mp,
 				struct xfs_trans *tp, xfs_agnumber_t agno,
 				struct xfs_buf **bpp);
 
-extern bool	xfs_validate_stripe_geometry(struct xfs_mount *mp,
-		__s64 sunit, __s64 swidth, int sectorsize, bool silent);
+bool	xfs_validate_stripe_geometry(struct xfs_mount *mp,
+		__s64 sunit, __s64 swidth, int sectorsize, bool may_repair,
+		bool silent);
 
 uint8_t xfs_compute_rextslog(xfs_rtbxlen_t rtextents);
 
