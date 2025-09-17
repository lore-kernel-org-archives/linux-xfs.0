Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6763DA55
	for <linux-xfs@vger.kernel.org>; Wed, 17 Sep 2025 22:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758147895; cv=none; b=Mq3pDy+hl6PP4H2re/xFz2cNTuLvYgtPfaYx+4/VK8+PsG+p6p5DUJX1uoAA5gLkrLEBHMak9XNCLHuUzKP4FygMMwMnrKoC02UwsM7Cfb2fohTkPiPW33r1KUKj/5qCZ4V7E8MW8nUSN7iYBVGPlFs9YiyBq1HpGsDu83JnTG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758147895; c=relaxed/simple;
	bh=R+NOQyyWKO1CNYcH7NKw4Ws3ydIhRoRaj9BgGJCkTPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HuhnYbyO4ufU5exg+1xBYM44X8j83KYJ00KZ6w4sYuybUdGist/peg8Vp0UKqeHWSpTFXz53sYLYKFbtYKRKm+yU3cu53gv4tbNLZx8VJ7bNKdHBT06gWiAf9/+up99bnr8c1bpKvR495zc9UwZcfHahAlFzs0WHvDb9Zje3ueg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=yEn0xoyp; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="yEn0xoyp"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b54b0434101so238792a12.2
        for <linux-xfs@vger.kernel.org>; Wed, 17 Sep 2025 15:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1758147893; x=1758752693; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TODd7bUg2ZmMGAGLmAZ9qFpucIb34zAYJ/C+je4cMxU=;
        b=yEn0xoypeKMwg5TU+b3Ok3aYj8ARYTYkmPDEUBSdxKOK11N0bokvou/ZRLvqQdN3Ar
         usmDm/6q+1IVKocabA28JJVcDLa2ntwi2PyC2Hu3lRtDXmhjOqyPj6MbzLYg+QM6XTl4
         tT5snLL41cuBPpbU3SBZliyuNPWUHm5ZVFvw5UL7r8p8It4z5ZMPihpVCGy/3V0Vyyll
         Jjxv9KdRVrRQxs54oiEB+JGU+YIZR4bLU1Uf7M1SrWIuVTJNC6R407eOjxA4+z2Vu2k+
         q0XlxVJLw25dlBmE+wut3U6ld/Qm+iVeOFtDm2tGyHSCGhA0XquVoXVFo7/FaiUdtYnU
         c6YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758147893; x=1758752693;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TODd7bUg2ZmMGAGLmAZ9qFpucIb34zAYJ/C+je4cMxU=;
        b=PRCqqX0BI5jXgXmLrWg3bLYsZMWnjHQHWGU+5jRlibpZWNxnzfMwIvDqWbYMktslk3
         KaDEHRo0FN8ka8zWF69HYeGg0kR0ZYO5ga+N2B7hk5XDHEbWX0V3YZ9ZAzf/j/RZqyLs
         j0KHFHnEbKs8+2zIodjo4DD1cKlnB4W1rNaWwFIFC0A21JtKkFPHPjsbF1H7u31ZQ7gk
         9acDKlqIfTwIM7xHM5DXTIyP2dm5QCsqdvhi1cPWVndDghoY7HDTZzQQXe2eKm1ANEDV
         dL3Xl66WWcsBVDdvPnpWgeKdqkGRICJHQkoYAAQ4kg90xT6QXL3DUIy+OoZ+ajleOGmi
         pjIw==
X-Gm-Message-State: AOJu0YwIhwNNCOLXPjED/A13QzjmVTK7/aZ9YiK8lpJ5dfMS4asOCbKr
	J9sxFEuFLyk/ZBdE735Z/Qxh0uW7PSFBWj52g7+EiYYv/ikv3YAzFMIkjCiKBc5N09+W9anR/OH
	9dPE0
X-Gm-Gg: ASbGncs5U/gH0zfXjzOP6IolIJfMFNJXgzISpea7i1ly7w3Z0Drzo9IsvMrQjKYhPKF
	aOpANbONbRw9tz6ktVfM0q/TMDl/tMrrZhxxHYYQs2e9BwfNnBkPEI6l+/DAl20d7OJ5UwIIkM9
	+dNRHWnwWt8ogjMA0TRS5m21Mt+poShtaghQTXZ5Ewl0leM6DR7+BbOZeZXPtrJjM5KGxntaZiF
	cPFDrxnvH3WHG1FLhO7H2ezYo0Qh08vjkwwpvow50IN5/kRiaFnaHpAUqTY/eKuCFw3KtxJVZ20
	RuRIQVJ2OH6pvwFffLDefEJU2Rc1fN4savKJOIjUOJYL6Nv/po214qestd2SX/GAWNyQhYvlcTV
	Sl3HvGT9qWgjfTYd7/mobAVn1/WVcwBwETzFmsZnRdFMbir+IZXZ541ginUoV+pcSV5bZPXQR6j
	6ib1K913XdLLFWF1A=
X-Google-Smtp-Source: AGHT+IEMNl7xJoJqqtb+jUA8jS4s55pbvbFjUdS9wndY5SxJeFkR9GpzcWrUTtGsPOlvOFukuLQKJw==
X-Received: by 2002:a17:903:1ace:b0:268:500:5ec7 with SMTP id d9443c01a7336-268118b4286mr52192695ad.2.1758147892712;
        Wed, 17 Sep 2025 15:24:52 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2698033a3e5sm5629555ad.126.2025.09.17.15.24.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Sep 2025 15:24:52 -0700 (PDT)
Received: from devoid.disaster.area ([192.168.253.111])
	by dread.disaster.area with esmtp (Exim 4.98.2)
	(envelope-from <dave@fromorbit.com>)
	id 1uz0a1-00000003I2Z-404I;
	Thu, 18 Sep 2025 08:24:49 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.98.2)
	(envelope-from <dave@devoid.disaster.area>)
	id 1uz0a1-00000005a9D-3R9i;
	Thu, 18 Sep 2025 08:24:49 +1000
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: jack@suse.cz,
	lherbolt@redhat.com
Subject: [PATCH 1/2] xfs: rearrange code in xfs_inode_item_precommit
Date: Thu, 18 Sep 2025 08:12:53 +1000
Message-ID: <20250917222446.1329304-2-david@fromorbit.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250917222446.1329304-1-david@fromorbit.com>
References: <20250917222446.1329304-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

There are similar extsize checks and updates done inside and outside
the inode item lock, which could all be done under a single top
level logic branch outside the ili_lock. The COW extsize fixup can
potentially miss updating the XFS_ILOG_CORE in ili_fsync_fields, so
moving this code up above the ili_fsync_fields update could also be
considered a fix.

Further, to make the next change a bit cleaner, move where we
calculate the on-disk flag mask to after we attach the cluster
buffer to the the inode log item.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode_item.c | 65 ++++++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 36 deletions(-)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index afb6cadf7793..318e7c68ec72 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -131,46 +131,28 @@ xfs_inode_item_precommit(
 	}
 
 	/*
-	 * Inode verifiers do not check that the extent size hint is an integer
-	 * multiple of the rt extent size on a directory with both rtinherit
-	 * and extszinherit flags set.  If we're logging a directory that is
-	 * misconfigured in this way, clear the hint.
+	 * Inode verifiers do not check that the extent size hints are an
+	 * integer multiple of the rt extent size on a directory with
+	 * rtinherit flags set.  If we're logging a directory that is
+	 * misconfigured in this way, clear the bad hints.
 	 */
-	if ((ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
-	    (ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) &&
-	    xfs_extlen_to_rtxmod(ip->i_mount, ip->i_extsize) > 0) {
-		ip->i_diflags &= ~(XFS_DIFLAG_EXTSIZE |
-				   XFS_DIFLAG_EXTSZINHERIT);
-		ip->i_extsize = 0;
-		flags |= XFS_ILOG_CORE;
+	if (ip->i_diflags & XFS_DIFLAG_RTINHERIT) {
+		if ((ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) &&
+		    xfs_extlen_to_rtxmod(ip->i_mount, ip->i_extsize) > 0) {
+			ip->i_diflags &= ~(XFS_DIFLAG_EXTSIZE |
+					   XFS_DIFLAG_EXTSZINHERIT);
+			ip->i_extsize = 0;
+			flags |= XFS_ILOG_CORE;
+		}
+		if ((ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) &&
+		    xfs_extlen_to_rtxmod(ip->i_mount, ip->i_cowextsize) > 0) {
+			ip->i_diflags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
+			ip->i_cowextsize = 0;
+			flags |= XFS_ILOG_CORE;
+		}
 	}
 
-	/*
-	 * Record the specific change for fdatasync optimisation. This allows
-	 * fdatasync to skip log forces for inodes that are only timestamp
-	 * dirty. Once we've processed the XFS_ILOG_IVERSION flag, convert it
-	 * to XFS_ILOG_CORE so that the actual on-disk dirty tracking
-	 * (ili_fields) correctly tracks that the version has changed.
-	 */
 	spin_lock(&iip->ili_lock);
-	iip->ili_fsync_fields |= (flags & ~XFS_ILOG_IVERSION);
-	if (flags & XFS_ILOG_IVERSION)
-		flags = ((flags & ~XFS_ILOG_IVERSION) | XFS_ILOG_CORE);
-
-	/*
-	 * Inode verifiers do not check that the CoW extent size hint is an
-	 * integer multiple of the rt extent size on a directory with both
-	 * rtinherit and cowextsize flags set.  If we're logging a directory
-	 * that is misconfigured in this way, clear the hint.
-	 */
-	if ((ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
-	    (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) &&
-	    xfs_extlen_to_rtxmod(ip->i_mount, ip->i_cowextsize) > 0) {
-		ip->i_diflags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
-		ip->i_cowextsize = 0;
-		flags |= XFS_ILOG_CORE;
-	}
-
 	if (!iip->ili_item.li_buf) {
 		struct xfs_buf	*bp;
 		int		error;
@@ -204,6 +186,17 @@ xfs_inode_item_precommit(
 		xfs_trans_brelse(tp, bp);
 	}
 
+	/*
+	 * Record the specific change for fdatasync optimisation. This allows
+	 * fdatasync to skip log forces for inodes that are only timestamp
+	 * dirty. Once we've processed the XFS_ILOG_IVERSION flag, convert it
+	 * to XFS_ILOG_CORE so that the actual on-disk dirty tracking
+	 * (ili_fields) correctly tracks that the version has changed.
+	 */
+	iip->ili_fsync_fields |= (flags & ~XFS_ILOG_IVERSION);
+	if (flags & XFS_ILOG_IVERSION)
+		flags = ((flags & ~XFS_ILOG_IVERSION) | XFS_ILOG_CORE);
+
 	/*
 	 * Always OR in the bits from the ili_last_fields field.  This is to
 	 * coordinate with the xfs_iflush() and xfs_buf_inode_iodone() routines
-- 
2.50.1

