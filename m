Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D531494DF
	for <linux-xfs@vger.kernel.org>; Thu, 24 Oct 2024 02:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729738310; cv=none; b=Nymdhl/Chk50Vl24bLtwYLRVROkeiS7Qc5vfYrqXjRsLmTaYSjI/IfWkE9Y1Tny5ywKRYqHHyf0NVAo2s1rDQmiHZ+FsuUIFamtUDgO74uCGzaL4QJtonwdRbh+Bg9CsKGdRcpSha2o4SRtYfLAD8So5xA7Z58fVrj0QvINNnoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729738310; c=relaxed/simple;
	bh=7p9qOVab9mUqKiCrMpPfasqlhXIZO9XRO05iSOCNdPE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQGSPI6wjCMNGNilaO+SdM2HNk/YqoVw0xfX6vwulDokG1XY4himJIhw0UYfduRbXtAm7AiaVmoWUjxDzd1PVoB5Qih8c/HlAgaW1fuS5cpA4rJXAqif6Ddfl84Jj0L+DivZJryTaMlaoucUpz6Ub6Eewysd3bO8s7R6+6fLmUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=LH/Mk+fl; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="LH/Mk+fl"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-71e6cec7227so374897b3a.0
        for <linux-xfs@vger.kernel.org>; Wed, 23 Oct 2024 19:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1729738307; x=1730343107; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Pv876Dy8Ajy7g5mfHuh133EW6I1k95G47jQYc8OWOCQ=;
        b=LH/Mk+flJtIc2ZwujaaU/bWKawm+hVZ6Dpyj552P142DBfWgiwL1hHLoAL8mCqF7bq
         vV+Gg+jf3Zm28DtsyrxbPKcq6WzrLhMDBHD0ArQS2lroaKkvNw5KfYoDJWn60BJHA7e9
         y78PkVQaaywioL964PxQYsaUFP9DxyC9TjImcOF1VIZ4xNVEKg33oYbJxSWEeCTPQjMZ
         MBZjCN3SkZNr45j/2w3W1EVUtWEyC2hR5nA7+kG2GidQM/R6Jt43fwaGPfeQcICsru0n
         OdUW+MHLBGOliQdFyqvDuO11kWk9byR880mOaiTML0YgrRww/A2AsxzXvDsjSrLp5xmW
         6UGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729738307; x=1730343107;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pv876Dy8Ajy7g5mfHuh133EW6I1k95G47jQYc8OWOCQ=;
        b=Zgf09WlluwEQE6xt9y8sKvgK25DKQTqYK0jRsHWtxha0aYImSZ0+Tco1mY+WC95K31
         +eWOfsxCG/DO5aoiLdPi3uIdSpzp1YuBwZTyF7lxdyZIUnVyOTmytj+voK/pfkdqhKE8
         tfbRvvaHXuXcL94Cs3oW4iRyaSEeu6x1U695OA2+QhBZqe35hFfFb5xhaqKRfKYp+26N
         HwbMl3/jk9EfPD/BscJYX7zPdtnEXgANmYJtclK4N3bcrLL2Jd8zSkNUq/L3nIAeZloW
         VN0+wdI3Gomdf2zJoI5hIsReEFyqcumHGMSWX4OXhNpLicJb5E+J8VgxNb2IkkP6V7wr
         /ptA==
X-Gm-Message-State: AOJu0YxLTDGv5vVch9zM2nUE7dKc0sewtvGXoC+969bdD4q9pTCu/Ce+
	SwRILwBZ6B4KkOB6uvqF7dmjD6uHBFpVbV2Yk88MGBojVVk6w6+vMOECrqQetrBvw4gY6PeH59K
	X
X-Google-Smtp-Source: AGHT+IF9qnwKd51AhWgQlwnc1x4YpN+HIERSmRT3j3Dytoc6wKC49NAJGkL/InP8b0X29Fw2dtgkdQ==
X-Received: by 2002:a05:6a00:895:b0:71e:768b:700a with SMTP id d2e1a72fcca58-72045f88494mr656769b3a.23.1729738307182;
        Wed, 23 Oct 2024 19:51:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7eaeabb9009sm7676216a12.59.2024.10.23.19.51.46
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 19:51:46 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1t3nwt-004xNr-2k
	for linux-xfs@vger.kernel.org;
	Thu, 24 Oct 2024 13:51:44 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.98)
	(envelope-from <dave@devoid.disaster.area>)
	id 1t3nwu-0000000H7zU-1Bgn
	for linux-xfs@vger.kernel.org;
	Thu, 24 Oct 2024 13:51:44 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] xfs: fix sparse inode limits on runt AG
Date: Thu, 24 Oct 2024 13:51:03 +1100
Message-ID: <20241024025142.4082218-2-david@fromorbit.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241024025142.4082218-1-david@fromorbit.com>
References: <20241024025142.4082218-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

The runt AG at the end of a filesystem is almost always smaller than
the mp->m_sb.sb_agblocks. Unfortunately, when setting the max_agbno
limit for the inode chunk allocation, we do not take this into
account. This means we can allocate a sparse inode chunk that
overlaps beyond the end of an AG. When we go to allocate an inode
from that sparse chunk, the irec fails validation because the
agbno of the start of the irec is beyond valid limits for the runt
AG.

Prevent this from happening by taking into account the size of the
runt AG when allocating inode chunks. Also convert the various
checks for valid inode chunk agbnos to use xfs_ag_block_count()
so that they will also catch such issues in the future.

Fixes: 56d1115c9bc7 ("xfs: allocate sparse inode chunks on full chunk allocation failure")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 271855227514..6258527315f2 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -855,7 +855,8 @@ xfs_ialloc_ag_alloc(
 		 * the end of the AG.
 		 */
 		args.min_agbno = args.mp->m_sb.sb_inoalignmt;
-		args.max_agbno = round_down(args.mp->m_sb.sb_agblocks,
+		args.max_agbno = round_down(xfs_ag_block_count(args.mp,
+							pag->pag_agno),
 					    args.mp->m_sb.sb_inoalignmt) -
 				 igeo->ialloc_blks;
 
@@ -2332,9 +2333,9 @@ xfs_difree(
 		return -EINVAL;
 	}
 	agbno = XFS_AGINO_TO_AGBNO(mp, agino);
-	if (agbno >= mp->m_sb.sb_agblocks)  {
-		xfs_warn(mp, "%s: agbno >= mp->m_sb.sb_agblocks (%d >= %d).",
-			__func__, agbno, mp->m_sb.sb_agblocks);
+	if (agbno >= xfs_ag_block_count(mp, pag->pag_agno)) {
+		xfs_warn(mp, "%s: agbno >= xfs_ag_block_count (%d >= %d).",
+			__func__, agbno, xfs_ag_block_count(mp, pag->pag_agno));
 		ASSERT(0);
 		return -EINVAL;
 	}
@@ -2457,7 +2458,7 @@ xfs_imap(
 	 */
 	agino = XFS_INO_TO_AGINO(mp, ino);
 	agbno = XFS_AGINO_TO_AGBNO(mp, agino);
-	if (agbno >= mp->m_sb.sb_agblocks ||
+	if (agbno >= xfs_ag_block_count(mp, pag->pag_agno) ||
 	    ino != XFS_AGINO_TO_INO(mp, pag->pag_agno, agino)) {
 		error = -EINVAL;
 #ifdef DEBUG
@@ -2467,11 +2468,12 @@ xfs_imap(
 		 */
 		if (flags & XFS_IGET_UNTRUSTED)
 			return error;
-		if (agbno >= mp->m_sb.sb_agblocks) {
+		if (agbno >= xfs_ag_block_count(mp, pag->pag_agno)) {
 			xfs_alert(mp,
 		"%s: agbno (0x%llx) >= mp->m_sb.sb_agblocks (0x%lx)",
 				__func__, (unsigned long long)agbno,
-				(unsigned long)mp->m_sb.sb_agblocks);
+				(unsigned long)xfs_ag_block_count(mp,
+							pag->pag_agno));
 		}
 		if (ino != XFS_AGINO_TO_INO(mp, pag->pag_agno, agino)) {
 			xfs_alert(mp,
-- 
2.45.2

