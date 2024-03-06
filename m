Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8055A1BDD6
	for <linux-xfs@vger.kernel.org>; Wed,  6 Mar 2024 05:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709703059; cv=none; b=XsOSU/3SLXhA0+U+E4bLbHOpi0EGxOQ6iX/1b5PvFGGvcSgSqNiy+iy2T0m/vfc3znQy9e2jjSerg3edU1jmEXCMYlcV0jyqOxV/u0oPi6lkmN+gSiFWvbfG+DgVb/L+8DxMnfRPbyO8ZcvxTlBGxWhfKJ0oX8+8Z6h/PfbX9bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709703059; c=relaxed/simple;
	bh=8V/UNrq6anFxrcLsstoH28hj/LpgQW7e9LuklhLINRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PRvpsnXg/6cblNkyosLU4VqopzL9BKz/izCbu4Q5yk6lMODZ5i6AxyP8XcxHRF696oPN4kwRoZBImmke1p32GbAe2dPWLDDoHR2eg23xJFXdlQV5Nol4bxF4gflp5snC+y2YLMbZ6XwETDL/hl10vyLnK7O5Pa1v3GATN4hwtN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=xYJ/OjvF; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="xYJ/OjvF"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1dc49b00bdbso58449085ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 05 Mar 2024 21:30:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1709703057; x=1710307857; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+qH3gbB+If+3pSpMLmVxmMDFt37zGR941038IrgIW/M=;
        b=xYJ/OjvFAOo/IKEO+T3tkCbSSiBXJaKTvIvTNaNPAqFn2Hq/0Hl4DK7cHv9aOUoVYD
         YAQUiCnkpattPRmgoHe+T0op2zEtRrnn0vNR+dqcv/DnKTFqVudaBgF5lrjtdqvxk2bd
         EwAFAGDri/MU2kmyv3a2ExLVkdduYCUoCV1kY4ygSe6gX+m7yVwkP/hD4950nUgK4r+/
         0thD+Np8wOmFgdklwq6mYLUWa8q5V7Fonyg2iKBokXSKSDTQiDmhRKJai4c8FcH6CH83
         1ehu5f/sZ/WFV6CbP4ByEgTyx9Cz4Kz+x+a4ODoLaUTwQj4G+HZwQJ14wU5XfUxqfC1x
         NxMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709703057; x=1710307857;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+qH3gbB+If+3pSpMLmVxmMDFt37zGR941038IrgIW/M=;
        b=oi8kCpNW6NBH0vLQia2iPIeW6m6dJa2U9CTYwSU4VfN7ZRrMh/pDFJMhcDDUCIgm07
         4rqMXd+fqydRpTro/cDxv4VswzetWZo7w3wli0oRmabQyuqD9J8aYRx/pIB3Tz8wfunz
         xf+q91E231ef7Qbaf4nOOtjaITrVIH1OlhlizPRqT4tLz+Gm2sonkW3L6eLVb73AO+To
         tZvfRZPEUu5Z/s7jb0qWxYXRTXRChBy0cgnhXAlfodJLXrP9cXssV7TwZ5N9HqD/85fY
         qq2DavxfyJK1A+KkXRSa6WjmwvzUaEApzWajrowDEkkVO5jMe7dH1lsB6xJst0XELUnN
         UI4A==
X-Gm-Message-State: AOJu0YxBBrjfOniDBxS//w2SWevRMFk3NyRGfJNTTNHB+eONiZqNqSnb
	xXfOwFNnssR4BfamTdJpM0Ajw6QrT09y/0KmrzIxeOu6chMPgSa1MfR5aa8KST5UUufbKC6Z3mA
	A
X-Google-Smtp-Source: AGHT+IEj8hahOqCoyFVQQNg3KRD65aiOeLE5xP7mGy1U1e4grz2/RDAdnK260AH3cHYloAZDFfVIAw==
X-Received: by 2002:a17:902:b48b:b0:1dc:7b6:867a with SMTP id y11-20020a170902b48b00b001dc07b6867amr3371201plr.21.1709703056627;
        Tue, 05 Mar 2024 21:30:56 -0800 (PST)
Received: from dread.disaster.area (pa49-181-192-230.pa.nsw.optusnet.com.au. [49.181.192.230])
        by smtp.gmail.com with ESMTPSA id x11-20020a170902a38b00b001dcdb39613fsm11660820pla.244.2024.03.05.21.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Mar 2024 21:30:55 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rhjrg-00FfkK-1j;
	Wed, 06 Mar 2024 16:30:52 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rhjrg-00000006xMA-0HPB;
	Wed, 06 Mar 2024 16:30:52 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: john.g.garry@oracle.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com
Subject: [PATCH 3/3] xfs: introduce forced allocation alignment
Date: Wed,  6 Mar 2024 16:20:13 +1100
Message-ID: <20240306053048.1656747-4-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240306053048.1656747-1-david@fromorbit.com>
References: <ZeeaKrmVEkcXYjbK@dread.disaster.area>
 <20240306053048.1656747-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

When forced allocation alignment is specified, the extent will
be aligned to the extent size hint size rather than stripe
alignment. If aligned allocation cannot be done, then the allocation
is failed rather than attempting non-aligned fallbacks.

Note: none of the per-inode force align configuration is present
yet, so this just triggers off an "always false" wrapper function
for the moment.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.h |  1 +
 fs/xfs/libxfs/xfs_bmap.c  | 29 +++++++++++++++++++++++------
 fs/xfs/xfs_inode.h        |  5 +++++
 3 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index aa2c103d98f0..7de2e6f64882 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -66,6 +66,7 @@ typedef struct xfs_alloc_arg {
 #define XFS_ALLOC_USERDATA		(1 << 0)/* allocation is for user data*/
 #define XFS_ALLOC_INITIAL_USER_DATA	(1 << 1)/* special case start of file */
 #define XFS_ALLOC_NOBUSY		(1 << 2)/* Busy extents not allowed */
+#define XFS_ALLOC_FORCEALIGN		(1 << 3)/* forced extent alignment */
 
 /* freespace limit calculations */
 unsigned int xfs_alloc_set_aside(struct xfs_mount *mp);
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c2ddf1875e52..7a0ef0900097 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3411,9 +3411,10 @@ xfs_bmap_alloc_account(
  * Calculate the extent start alignment and the extent length adjustments that
  * constrain this allocation.
  *
- * Extent start alignment is currently determined by stripe configuration and is
- * carried in args->alignment, whilst extent length adjustment is determined by
- * extent size hints and is carried by args->prod and args->mod.
+ * Extent start alignment is currently determined by forced inode alignment or
+ * stripe configuration and is carried in args->alignment, whilst extent length
+ * adjustment is determined by extent size hints and is carried by args->prod
+ * and args->mod.
  *
  * Low level allocation code is free to either ignore or override these values
  * as required.
@@ -3426,11 +3427,18 @@ xfs_bmap_compute_alignments(
 	struct xfs_mount	*mp = args->mp;
 	xfs_extlen_t		align = 0; /* minimum allocation alignment */
 
-	/* stripe alignment for allocation is determined by mount parameters */
-	if (mp->m_swidth && xfs_has_swalloc(mp))
+	/*
+	 * Forced inode alignment takes preference over stripe alignment.
+	 * Stripe alignment for allocation is determined by mount parameters.
+	 */
+	if (xfs_inode_has_forcealign(ap->ip)) {
+		args->alignment = xfs_get_extsz_hint(ap->ip);
+		args->datatype |= XFS_ALLOC_FORCEALIGN;
+	} else if (mp->m_swidth && xfs_has_swalloc(mp)) {
 		args->alignment = mp->m_swidth;
-	else if (mp->m_dalign)
+	} else if (mp->m_dalign) {
 		args->alignment = mp->m_dalign;
+	}
 
 	if (ap->flags & XFS_BMAPI_COWFORK)
 		align = xfs_get_cowextsz_hint(ap->ip);
@@ -3617,6 +3625,11 @@ xfs_bmap_btalloc_low_space(
 {
 	int			error;
 
+	if (args->alignment > 1 && (args->datatype & XFS_ALLOC_FORCEALIGN)) {
+		args->fsbno = NULLFSBLOCK;
+		return 0;
+	}
+
 	args->alignment = 1;
 	if (args->minlen > ap->minlen) {
 		args->minlen = ap->minlen;
@@ -3668,6 +3681,8 @@ xfs_bmap_btalloc_filestreams(
 
 	/* Attempt non-aligned allocation if we haven't already. */
 	if (!error && args->fsbno == NULLFSBLOCK && args->alignment > 1)  {
+		if (args->datatype & XFS_ALLOC_FORCEALIGN)
+			return error;
 		args->alignment = 1;
 		error = xfs_alloc_vextent_near_bno(args, ap->blkno);
 	}
@@ -3726,6 +3741,8 @@ xfs_bmap_btalloc_best_length(
 
 	/* Attempt non-aligned allocation if we haven't already. */
 	if (!error && args->fsbno == NULLFSBLOCK && args->alignment > 1)  {
+		if (args->datatype & XFS_ALLOC_FORCEALIGN)
+			return error;
 		args->alignment = 1;
 		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
 	}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 0f9d32cbae72..94fa79ae1591 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -312,6 +312,11 @@ static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
 	return ip->i_diflags2 & XFS_DIFLAG2_NREXT64;
 }
 
+static inline bool xfs_inode_has_forcealign(struct xfs_inode *ip)
+{
+	return false;
+}
+
 /*
  * Return the buftarg used for data allocations on a given inode.
  */
-- 
2.43.0

