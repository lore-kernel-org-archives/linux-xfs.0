Received: from mail-oi2-f9.google.com (mail-oi2-f9.google.com [74.125.231.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A33D4D98EB
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 11:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791546321; cv=none; b=LZfOYp+xZ0cnaSTvBdKadVfHnH1JvoYgi7nBrx5clE3BB+qKyCh9gw6NQh99Qi5sIc6bU88Na2+w4CYbInPDU5VWtqY/fNkBQTY8gK75Xh1SbqTBdLk/YXnlBHt/2FJdFBqJOg2WYtXOTlyLXV9PAnYDuTGqCET1uV0iEZXjLFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791546321; c=relaxed/simple;
	bh=E1XMyad7VnkVzB7/p/Kp/l/hcMQbzp3Rdwh357Rvu5A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ESqg7HH/z+tY28UGxjC2q+sV87qphhQm+0zOU9q1smAnFui0htMH7YsRQlCFYkXtm+VQRVAQwyFpBAbSLP9lllghteIpwSOtKUx8T+/VJzM7dt49HYf/hOrK6IENkhYOu1nLyMc1CaR0aknKy0qv8/IuihV+Wyl4melMXTOanDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dzEDyHU2; arc=none smtp.client-ip=74.125.231.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dzEDyHU2"
Received: by mail-oi2-f9.google.com with SMTP id 5614622812f47-4f2a0576df3so480205b6e.0
        for <linux-xfs@vger.kernel.org>; Fri, 09 Oct 2026 04:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791546313; x=1792151113; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=aQv3jnCfnGYGyZdLu9hITrZVCdW0zrEfT+n6BY05h+8=;
        b=dzEDyHU2wxFXFDt6Me4PEeRfJQtoK8Ay4yAywJ+GG3mHldb40IqHL9e9Xeqci+WqOZ
         9OrSo3kvRB5s290L6damegaOlBHav0N2mBxyCJD9W7F7kxE1IrlebyAYkdGEfdT3ahUD
         dhXTvsJg6PJY7INY+mi9QVxXPYrUKiRRQD0887OcU9Kwx3/QTKYEwRpCeuDlK/RovHd2
         M2N4/KQvyIEDTCsjA7hdpejlcH3kGS2zqbli5IokLOI7bPNl4NaDV6QI5apjTH3jgC1a
         v5Htt7iRmyE7+1C0gA+fgrGw/Qo0LXamSlDCZOHgqavnmwNFoyPWVMdM7diisDRSHv0x
         18kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791546313; x=1792151113;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aQv3jnCfnGYGyZdLu9hITrZVCdW0zrEfT+n6BY05h+8=;
        b=n/BeW7XPurXjOVK6vieURsnMWexNqGykL2tsWE3qfvxfn/QCIqniUMaw0G4UzuBo/t
         hHUw5ayUSstGxpeXuYoMnTsGaPLQmjxh1me7uwnlm/2mNr+bob8hPnsGLUuISkouUAXy
         UqUitXiO4zNmKudhUetqrAnlO0Ae513Jp+9OhxfKp/H+dSz9k+lO0JEX/2vw/kxJnek3
         LiHcd/HDhDsIWy+zgbn8T4/YcwgwfAh2Fanby0G2nsbatxp7BzaKo+9IB+gLuFbz+qaF
         Nkd50YyTW28ynOrkPbQD9gKxz0gQ4mpdeoHCRzC69RPRh3/SphiX/Tn0a/JhLkZLw6uP
         9MLQ==
X-Gm-Message-State: AFuF++n+15TZm3Ux1PtqubrmbQ36Q9/rMFa6A7DMruDH/wpfaQJfpKUL
	SVK+joR5OCo/0Qw01eDbuFAZhQdIn6FTKYHAm5DFWvtEaSILdyZlTMKf
X-Gm-Gg: AYBFou3VQy1y2fOLrM5kZzh9XEaVtZcGFV2ASMiywmn3gLIJlRESaVKMZKBA0Mqxq7i
	GwXI2qkGrxCPe2aa65beD6MgkmvLPkgQKRWkpn9JSs9K3Da2Fv/oOlAMnCAeuVDLzW6/XG7NwHa
	xFzdgYeiQMKR8EPYiI8TnUc/a9o+dmM2co45vRGfAhX2pqYHsyJR1wUAiG5XLdY2/BJVUgjrRtj
	ggYRzlwryTwwRYZlVKGNRbUt2XhqVIG0GlE6FqBHLKSJinjMj84V5EcT7pRQO8rYegBFGSBEijL
	E9kcaGr+IhMkXqbgk9y/9baP3p7IYUb685ROvqZUstKmk8QaMu400Jf8WFymYiKAMgvL5NiULYq
	TstcsG5M0NX4uQ04x//dp98mu5R9m64C5q2pQhSi7Ly6BhBgAp1DfDcsXy8Z+GNOWDj3PgM75fs
	ujIPQmpFVhk3+pf+dZvLn8oBvo5KYklTzDdSbd5onQydcTDVuo5Lo0PBarGhOzX+UNwDCETBWsb
	wiZR00/4crqokiuwMspnfDWFiCJLsRE0GTX
X-Received: by 2002:a05:6808:1907:b0:4c3:cec9:fd18 with SMTP id 5614622812f47-50c4e681ad4mr1048459b6e.11.1791546312802;
        Fri, 09 Oct 2026 04:45:12 -0700 (PDT)
Received: from localhost.localdomain ([14.22.11.165])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-50c1a325a38sm1682405b6e.12.2026.10.09.04.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 04:45:11 -0700 (PDT)
From: Henry Martin <bsdhenrymartin@gmail.com>
To: "Darrick J . Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Henry Martin <bsdhenrymartin@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] xfs: fix out-of-bounds cursor access from rtrmap level off-by-one
Date: Fri,  9 Oct 2026 19:45:03 +0800
Message-ID: <20261009114503.3669142-1-bsdhenrymartin@gmail.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

m_rtrmap_maxlevels includes the inode root level, so a valid on-disk
bb_level is strictly less than m_rtrmap_maxlevels.  Both
xfs_rtrmapbt_verify() and xfs_iformat_rtrmap() compare with ">"
instead of ">=", letting a forged block with level == maxlevels pass
validation.  The cursor is then sized for maxlevels entries while
bc_nlevels is set to level + 1, so the generic btree code indexes one
element past bc_levels[] - an out-of-bounds read/write on the cursor
allocation.

xfs_rtrmapbt_mem_verify() in the same file (from commit
4a61f12eb1195 "xfs: create a shadow rmap btree during realtime rmap
repair") already uses ">=".

This vulnerability was discovered by Tencent CodeBuddy Security.

Cc: stable@vger.kernel.org
Fixes: fc6856c6ff086 ("xfs: introduce realtime rmap btree ondisk definitions")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
---
 fs/xfs/libxfs/xfs_rtrmap_btree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index a15e460a1ec7..6833c924a383 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -256,7 +256,7 @@ xfs_rtrmapbt_verify(
 	if (fa)
 		return fa;
 	level = be16_to_cpu(block->bb_level);
-	if (level > mp->m_rtrmap_maxlevels)
+	if (level >= mp->m_rtrmap_maxlevels)
 		return __this_address;

 	return xfs_btree_fsblock_verify(bp, mp->m_rtrmap_mxr[level != 0]);
@@ -888,7 +888,7 @@ xfs_iformat_rtrmap(
 	numrecs = be16_to_cpu(dfp->bb_numrecs);
 	level = be16_to_cpu(dfp->bb_level);

-	if (level > mp->m_rtrmap_maxlevels ||
+	if (level >= mp->m_rtrmap_maxlevels ||
 	    xfs_rtrmap_droot_space_calc(level, numrecs) > dsize) {
 		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		return -EFSCORRUPTED;
--
2.43.7

