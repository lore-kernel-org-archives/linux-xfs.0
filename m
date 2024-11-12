Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E772185A0
	for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 22:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731449968; cv=none; b=kZVerTTJbXO/29zO9aKyiy4q8GP+eFqV6fDxEvFPeoNnt21ygnjqZ9Tw5jRlHsuPC8VAAAgc0yEtz1UicV3Eu7Dqy0vgzveowFUJCCEyF/NsgwgCNuauoqXTC34I4BvLhHs6FtJHhfyFKpbARMMDsUnbC+VDwgMNG/zbODpib60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731449968; c=relaxed/simple;
	bh=7p9qOVab9mUqKiCrMpPfasqlhXIZO9XRO05iSOCNdPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+JVvTjnVZb3PraTu6754Fg2ntZq1BcKV1QSFXBNomAwfAZaB/rqXkwGyDtQknFHyHEhXPgG/DNxt5Ap2w70g6av2iWyJ1MxwsyhlivfL/vkKIDwmcG3KtIdHP/ni9pbrxaTMQO/eFmxbjlnU/R7FbmbA3d7AvuITOc0vFG9iZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=tzkV9QhI; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="tzkV9QhI"
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-5eb9ee4f14cso2658975eaf.1
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 14:19:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1731449965; x=1732054765; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pv876Dy8Ajy7g5mfHuh133EW6I1k95G47jQYc8OWOCQ=;
        b=tzkV9QhI8vdQp1EOI7CWCMsjiOGn1iQyZPP38P6zL6jZTAXhRUcZzjcDuxxWGlewHE
         GuvTZkwrnEPvOmJhJzHDKxu8GEP4bC9e7LSmCuEdNctWSawATq2dIwYpF80lqXeIpLni
         BU5npOj06V72iTFFN3LvO0rW+ZYW2GKiEi5qmAfU5QeHw4R6HcWfkbouGrpuRQCg08tw
         df1VjrWFf90mr+h6YVTgdVhxRIUKwIbWLMTOPMALDKuhXHMgICeuVg5OWO3/cZUL/QF6
         NaIlCGAqiFDnyGPxKVdgHd9kmSMcYFICH+YdXE0HVBxkHxIinKesobG/owP77/jgbBIS
         54jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731449965; x=1732054765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pv876Dy8Ajy7g5mfHuh133EW6I1k95G47jQYc8OWOCQ=;
        b=fbecyMr56ueSirDLBFC54af09wFIfWJ03ln/uy+CdGWKGPYOafWhwmwrPbvNzyyXp0
         IHKSTadrwDw4J/KplL8AmQDXpPP1dwQ2D0Z7QwoW6SqzHZTnATgE5zVxiigqU0vZDjMb
         LzinuY9JaJ66B1/BVgS4D6Gno+oIatOencKvNFb5TOY2qhkyvzfNgKPP+eC5XrcHfRpi
         G39Cn54dSWoJJfXHPs/I2rbUuTbXuB2X+MAJc0lZLUfFL6opU2U3cTP/MU4iy6M5AeNg
         3wi6XNN3Z8KvN1Lwc4aU/nrwintF/K6Q2gM+8G33aTOTcAIdIKuNxQN/cLpwtL8/zKG7
         7J2w==
X-Gm-Message-State: AOJu0YzvK2ivIMWANIMnnqv4DuYKnQp1+uJmgsPjbGS1sWpRbF3vSGzg
	u7UspQxJwtWCFXU/KgLY7z2E1UR8nZ6eXO2a3c9LkBLT/Bnvd5blEBdbKGx+cOG6pgFn6bBJyzs
	M
X-Google-Smtp-Source: AGHT+IH3foCqINOA6eT/AhAzu6OOhECiEIX9MYzdSIPp9jrN9MstpjLWeRjd+tPurZPSTUS8nueMsw==
X-Received: by 2002:a05:6830:620f:b0:710:ea11:3d35 with SMTP id 46e09a7af769-71a1c221985mr16850663a34.15.1731449965479;
        Tue, 12 Nov 2024 14:19:25 -0800 (PST)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7f41f5bab50sm9480064a12.25.2024.11.12.14.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 14:19:24 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1tAzEH-00Doos-0e;
	Wed, 13 Nov 2024 09:19:21 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.98)
	(envelope-from <dave@devoid.disaster.area>)
	id 1tAzEH-00000004e7y-2gvQ;
	Wed, 13 Nov 2024 09:19:21 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 1/3] xfs: fix sparse inode limits on runt AG
Date: Wed, 13 Nov 2024 09:05:14 +1100
Message-ID: <20241112221920.1105007-2-david@fromorbit.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241112221920.1105007-1-david@fromorbit.com>
References: <20241112221920.1105007-1-david@fromorbit.com>
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

