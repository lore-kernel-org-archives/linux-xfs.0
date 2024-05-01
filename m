Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB341607B2;
	Wed,  1 May 2024 18:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714588900; cv=none; b=mkOiKGqjAmcc7oxcGoBcYvZ2b7vLZGeB2DmIkb5Zzsj4bE+MdDppHe9lhWwolBLR6Jphw6a4bUZXplKWsx+0QEHyMmj4h4hDQj5epVA8XnK9osTFO5f2VIxVHgF6gpEWh0MiWwlwjpjfCI0Iet0FiMaeXVZY/aZI7J53oycLF28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714588900; c=relaxed/simple;
	bh=fkoAsTijuitE0hGfZRxVNhSccSlxC7wgFRZxPigoL5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q/wwgcQCQExFOWTgkUvRh4Et3Sj0aq0KBfdabMm8NJETuPLiL+G5/O1Ow/pkAOz82buMCStHxj2EEqDs4yauWZuGlaMAfRnq7IjSNq7s7zfHX/Mg+hCiMpvxufPzt4JegNPjWLyd3Oc162dhiQA1tOao80MaQS9ANNEENyAFWXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KQxIMs0b; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KQxIMs0b"
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-36c60ff0322so5698745ab.1;
        Wed, 01 May 2024 11:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714588898; x=1715193698; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uhUid3on+fTbFyucjv2eM3kRqDwiVYdxsIEeGK+1+zI=;
        b=KQxIMs0bXYQQJC9kH9n6dInRhdNLs9EJdDDCaNqt+JA2jndwvGEfMncavKVPk29ASc
         j4g/Y+A6LscPC3OEIhOUPCVcKCIdrVJtWpinTYWsEhFM09vNPzOPp5BQE2BDdDL3jWd0
         BEH3Dwr/DkeLN7+l6JS0sT2H1g42/93W4DnyN/eFACeV6P418Rvp5L1PKpEOm0pXdwmN
         peh69TSqxUWJnr0lR8e3Jn0Gf9z5LDJR9B3ttpOV1kkACzciF5Qw73TPMr1H9/mbtf+A
         wuraqR02Q0ENybDvRCd4w2euxvvStGf6V57F3iv4T2r6Upyx0Y1JzQ5/jOpzdfmgWUnE
         MNOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714588898; x=1715193698;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uhUid3on+fTbFyucjv2eM3kRqDwiVYdxsIEeGK+1+zI=;
        b=kGnHPahIuikk9KJ9rrFRfdu5HMJDICgyPnyqMOhyXi/Xv5YW4dhG8Yr5PF50aR2nBv
         v0WTFWIvDv83UEjpR+SBiosnALyk0Tr0QtvH2+ejzDt/udUa9gDDU62ZEvT3geEVFHka
         UGCgJMuDt2vwJBjSrokVhkvSBXrwNW2dD6tPd+tQjobKXcLeeAszGLv9/Rk1kx+l6rId
         qB2qjkmxf0crYmyU6vw05/aET5Qk166RxZZMRXp4UE/RZYl4BZOCy8isW9e09rSdL4MS
         3XsjwMGrpLN+X25xGyBt0i8fa7HGOUob2swgHZPwtef600/VYnEYcleKJWi1HTlpbs2k
         ERww==
X-Gm-Message-State: AOJu0Yz/qwEMZ9BgcCeFjHTIcMv88/YdDuErHoQt5alp6f1q54m69M/n
	2mCcR8n0jVA7EW2SgIivZTRIarju1zcWazI6V6FNcwB/7rxZvwKMbuZS6yCg
X-Google-Smtp-Source: AGHT+IEVj1KmAXZ/d2GJD/SS8NwDCF6VgMK+14ahYE87BzIfSgsaGgBn9+MbJY/t+Y8MqAEccUoyoQ==
X-Received: by 2002:a05:6e02:1523:b0:36c:4eb4:3afb with SMTP id i3-20020a056e02152300b0036c4eb43afbmr3944985ilu.32.1714588898398;
        Wed, 01 May 2024 11:41:38 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:9dbc:724d:6e88:fb08])
        by smtp.gmail.com with ESMTPSA id j18-20020a62e912000000b006e681769ee0sm23687369pfh.145.2024.05.01.11.41.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 May 2024 11:41:38 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 20/24] xfs: invalidate xfs_bufs when allocating cow extents
Date: Wed,  1 May 2024 11:41:08 -0700
Message-ID: <20240501184112.3799035-20-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
In-Reply-To: <20240501184112.3799035-1-leah.rumancik@gmail.com>
References: <20240501184112.3799035-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit ddfdd530e43fcb3f7a0a69966e5f6c33497b4ae3 ]

While investigating test failures in xfs/17[1-3] in alwayscow mode, I
noticed through code inspection that xfs_bmap_alloc_userdata isn't
setting XFS_ALLOC_USERDATA when allocating extents for a file's CoW
fork.  COW staging extents should be flagged as USERDATA, since user
data are persisted to these blocks before being remapped into a file.

This mis-classification has a few impacts on the behavior of the system.
First, the filestreams allocator is supposed to keep allocating from a
chosen AG until it runs out of space in that AG.  However, it only does
that for USERDATA allocations, which means that COW allocations aren't
tied to the filestreams AG.  Fortunately, few people use filestreams, so
nobody's noticed.

A more serious problem is that xfs_alloc_ag_vextent_small looks for a
buffer to invalidate *if* the USERDATA flag is set and the AG is so full
that the allocation had to come from the AGFL because the cntbt is
empty.  The consequences of not invalidating the buffer are severe --
if the AIL incorrectly checkpoints a buffer that is now being used to
store user data, that action will clobber the user's written data.

Fix filestreams and yet another data corruption vector by flagging COW
allocations as USERDATA.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 56b9b7db38bb..0d56a8d862e8 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4058,7 +4058,7 @@ xfs_bmap_alloc_userdata(
 	 * the busy list.
 	 */
 	bma->datatype = XFS_ALLOC_NOBUSY;
-	if (whichfork == XFS_DATA_FORK) {
+	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK) {
 		bma->datatype |= XFS_ALLOC_USERDATA;
 		if (bma->offset == 0)
 			bma->datatype |= XFS_ALLOC_INITIAL_USER_DATA;
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog

