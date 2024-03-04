Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B677C083
	for <linux-xfs@vger.kernel.org>; Mon,  4 Mar 2024 19:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709579550; cv=none; b=OIgAUWkeezSoJ6kEkleVij2tdhq9Ome5nWODV48Q7EmgxjseuE5osCdoaYBIuE6N5c290SRNuq2ab4Ixgkp9y0y9/3KNg+BebBb4+f92DdrDT/OOlb3lEL95GSXOPlzhrkK9xRd2DKEf5du3nizOZROXwBO9Hv0wBBcJUAvmpu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709579550; c=relaxed/simple;
	bh=R4yx8qPBsT6oFy9V3t0TmLDLaTl9LfPwUZGazsRbRmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I/j/vkDsIF2KWHfk8zKaXPgX+aFJU1nGAHkD5mTNZMW2zuLiZw1S1gDmjAjlJ75rfnlcGVCMh5XR5+pgeMbBo646nPq7PYBKD+k9gB5SMHjNTek74JoQ4qm5iJDaNo8TBUotZLn30h2zNICrhS3BGNIKcKS5DaukfIH8BcC1z2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N/bQ12il; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N/bQ12il"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709579547;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y/DVvRiqyNvnHobA7Dl65jX1eWvv52XzmYNOVCQE0Ls=;
	b=N/bQ12ilBKb86e+qKed/AEaCwBTdMghKXW7knmGzBABE/baNl6OnL+pfQ/8F26qHyLak9S
	rjXdHoh2lHS9T+tjIjnwQ75an4VDgqFD134hrSApRX9p+Revv6+eP1hSyFcWPK67SB0dea
	dn4I4APRMCQEa08Fd50lZC/UrDm8h38=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-EE_ZZ4qLN4OQGznV3UM8aQ-1; Mon, 04 Mar 2024 14:12:25 -0500
X-MC-Unique: EE_ZZ4qLN4OQGznV3UM8aQ-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5131eb8137aso4045190e87.3
        for <linux-xfs@vger.kernel.org>; Mon, 04 Mar 2024 11:12:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709579544; x=1710184344;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y/DVvRiqyNvnHobA7Dl65jX1eWvv52XzmYNOVCQE0Ls=;
        b=nMo1OdyL/+FzX8UKHdGy29SFm4KbSSP/CWAD3g4pVz9U0sSE0wpMIa74M20lHLoOwA
         ZrHkLcoCz3yoNDArfeXfp9W2JTkXzmHb+uVzfYmwPUEGYnJl9eOgJ8FphsDSpnAr7sjG
         rtw+3cMuik7pDTKsMnLn9RZ/XXq4K/hDTQimzk6vsaoVQMwlAM8ti334ZIAo4lxX8YND
         jJjPwdBznroJlSicvPZG9Y6O/7cE9pxnarO6GKDJk922/i7gwpuXZCvsgUmG5JKgXyz+
         9hLk8qmBU8ams4Vac2gZobWzpC8CITrWfmmRuGBcP6cp1mjdKqs40LpMSmwh/0VALDIY
         iUDQ==
X-Forwarded-Encrypted: i=1; AJvYcCUCqbccd3DzwL5eAYVriky6BhDKWkbybb3PNyvgRlXWskfGrChuSOhNTxwXXok2Y2ANqtKgh/kKNVf3extmDy+nPyqQrqgHyoe8
X-Gm-Message-State: AOJu0Yx/YQQjN6k0rEnm73fZKpnsgxH77wGnTHWWq3DXuBTw4AaXHWJG
	23vQVenEjZHJj68X+k800ZioKUNd2qtIdAMYIZxUDJeeQUsJ1EmdmbPkLC0r6LXFlWIclhhfghu
	4D1+/uJaARou9wiSX4zT6xCYyHoazkMTa3gSkTtWPMZiBNKqEXYRHTrKN
X-Received: by 2002:a05:6512:118d:b0:513:40eb:b422 with SMTP id g13-20020a056512118d00b0051340ebb422mr4082410lfr.34.1709579544285;
        Mon, 04 Mar 2024 11:12:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEBr8j2SGz5TnSfldxisRXVuJY3n+1hKwwCgX1qbv2Q/ubk3JHEqnyRHDsd0ZjF4pdMmuBcCA==
X-Received: by 2002:a05:6512:118d:b0:513:40eb:b422 with SMTP id g13-20020a056512118d00b0051340ebb422mr4082391lfr.34.1709579543671;
        Mon, 04 Mar 2024 11:12:23 -0800 (PST)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id a11-20020a1709064a4b00b00a44a04aa3cfsm3783319ejv.225.2024.03.04.11.12.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Mar 2024 11:12:23 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	chandan.babu@oracle.com,
	djwong@kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v5 14/24] xfs: make xfs_buf_get() to take XBF_* flags
Date: Mon,  4 Mar 2024 20:10:37 +0100
Message-ID: <20240304191046.157464-16-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240304191046.157464-2-aalbersh@redhat.com>
References: <20240304191046.157464-2-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow passing XBF_* buffer flags from xfs_buf_get(). This will allow
fs-verity to specify flag for increased buffer size.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/libxfs/xfs_attr_remote.c | 2 +-
 fs/xfs/libxfs/xfs_btree_mem.c   | 2 +-
 fs/xfs/libxfs/xfs_sb.c          | 2 +-
 fs/xfs/xfs_buf.h                | 3 ++-
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 4b44866479dc..f15350e99d66 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -526,7 +526,7 @@ xfs_attr_rmtval_set_value(
 		dblkno = XFS_FSB_TO_DADDR(mp, map.br_startblock),
 		dblkcnt = XFS_FSB_TO_BB(mp, map.br_blockcount);
 
-		error = xfs_buf_get(mp->m_ddev_targp, dblkno, dblkcnt, &bp);
+		error = xfs_buf_get(mp->m_ddev_targp, dblkno, dblkcnt, 0, &bp);
 		if (error)
 			return error;
 		bp->b_ops = &xfs_attr3_rmt_buf_ops;
diff --git a/fs/xfs/libxfs/xfs_btree_mem.c b/fs/xfs/libxfs/xfs_btree_mem.c
index 036061fe32cc..07df43decce7 100644
--- a/fs/xfs/libxfs/xfs_btree_mem.c
+++ b/fs/xfs/libxfs/xfs_btree_mem.c
@@ -92,7 +92,7 @@ xfbtree_init_leaf_block(
 	xfbno_t				bno = xfbt->highest_bno++;
 	int				error;
 
-	error = xfs_buf_get(xfbt->target, xfbno_to_daddr(bno), XFBNO_BBSIZE,
+	error = xfs_buf_get(xfbt->target, xfbno_to_daddr(bno), XFBNO_BBSIZE, 0,
 			&bp);
 	if (error)
 		return error;
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index d991eec05436..a25949843d8d 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1100,7 +1100,7 @@ xfs_update_secondary_sbs(
 
 		error = xfs_buf_get(mp->m_ddev_targp,
 				 XFS_AG_DADDR(mp, pag->pag_agno, XFS_SB_DADDR),
-				 XFS_FSS_TO_BB(mp, 1), &bp);
+				 XFS_FSS_TO_BB(mp, 1), 0, &bp);
 		/*
 		 * If we get an error reading or writing alternate superblocks,
 		 * continue.  xfs_repair chooses the "best" superblock based
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 2a73918193ba..b5c58287c663 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -257,11 +257,12 @@ xfs_buf_get(
 	struct xfs_buftarg	*target,
 	xfs_daddr_t		blkno,
 	size_t			numblks,
+	xfs_buf_flags_t		flags,
 	struct xfs_buf		**bpp)
 {
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
 
-	return xfs_buf_get_map(target, &map, 1, 0, bpp);
+	return xfs_buf_get_map(target, &map, 1, flags, bpp);
 }
 
 static inline int
-- 
2.42.0

