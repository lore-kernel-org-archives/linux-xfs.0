Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6D918732B;
	Mon,  4 Nov 2024 01:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730684722; cv=none; b=Z0YACUYrffM9FWvC+aIiXMaoJaaVjC6D6LVyeiLAGhCNFEfEq4My9ysEws/7HbV7KQ+IMACFghccAD6Ueu/S/Mraxys0+GEtms+vro5/3uopl9sLN2Aak7cGjDPrjAnXFLNeE2Br+6cQT33DoicPhB1STxqYynixVsLvYqF6cO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730684722; c=relaxed/simple;
	bh=sD9QONmCZspB9Zc6QOAK0N4fAfgLhVox8koPW9vJLSk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XpIg+vDyzGcTxkQKkdidlURlalLLndjA4QfKC92ybkzmCnp5WJEU7SpwRWd0Q50s2Ifw2WDExNbCvZxtUjEBJnToRNCOBlQlTwzIBV6NLTFtX07OF2G0dcmD1UPJuLVTolIf3Erl18S7S7br8hfxq1NycIjJ+D9t9x6qapwJVZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jhugICGo; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jhugICGo"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-720d01caa66so1949651b3a.2;
        Sun, 03 Nov 2024 17:45:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730684720; x=1731289520; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xitybgapCtabUaUYpxoDtyGnJUvnyr68olN5vz5Y+nM=;
        b=jhugICGoipY3hkV6u6xVyNuvlvl1S7nvZR7IcScy5gQWkddFl/+NiBjMVkTDAw7bk4
         Ltim0rNexZqifmsWIT5MdUm+CQ+AftzJZ1MQQ2+WoDSugaUM0P9FvbX7zuoZlLrz1VrR
         EjGLDxtTY2/25d87aReUSEpDw/kdKeVOfPoIqLK4Qm2LDiJAzuXuKY/VQK3tTSd64TiN
         /eehLbCNYG0fMP2oR4tCMtJ9FE+Wa8T7Cggx8yL8Ys1HapeuUQugRYjar6Phah4X4nat
         d2HitVHliUXGoa1hBKl6lsG1p5kEiMucM9foZ42u45qTaxtKjmoj9MezTG/+4zfDE8OW
         qhmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730684720; x=1731289520;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xitybgapCtabUaUYpxoDtyGnJUvnyr68olN5vz5Y+nM=;
        b=G3xIx6Yl14O6OIV6WyhOg4l4EV3gZJ0vrV2qpAHXgJvMsCnGsiXJkW4Ia8Z+JcBZhz
         FNILuE2KkGZ2Vj+HhXG3URlBZollaLFaq62Cs/BMPNEofHiuNmDo5krWBe1qTK1ufyPo
         ka3lMJPSX8eZo1V6EyG7grN+EhGUCNAlIocLpuYbbFHZt8h22k77xRXV6d1de7LepqZE
         aAKi98GssRj+ut463YYnJOBG/VIhP/xI1z2/l+uHxHrnCUtekQjTPPM/I2LM0WRRcXQi
         39+1g13I7npIdKronjVKoY6VnMwRX8OzTev00wJ7YttYY7exqWt8hGm0RC0ksieg3MJ2
         nh1Q==
X-Forwarded-Encrypted: i=1; AJvYcCVy98Sil6Z4/1CZyBvxFOk5XZL5sncb+Ea/OUuoF6KsOSBQLcCU3hbxWPalnFJiyfK6McKnc8rfDPS4NkM=@vger.kernel.org
X-Gm-Message-State: AOJu0YziLD5kJth6RkDvRVRQftdMxJzg3PcoND3mFyhDs4ulUtYGr0Th
	macPqORTyF6OjE9BP9oOGp0S2Uwe9cB3FrKOQS1cyCWN5D8UDGfE
X-Google-Smtp-Source: AGHT+IE94FTfuYMU8CLRKkMfIDeifsIHOg9D7ohYmLWVOOGohhqq6PY9e2GbXBjD1t363PnwjrvGgg==
X-Received: by 2002:a05:6a00:4653:b0:71e:77e7:d60 with SMTP id d2e1a72fcca58-720b9ddb788mr20889511b3a.23.1730684720150;
        Sun, 03 Nov 2024 17:45:20 -0800 (PST)
Received: from localhost.localdomain ([2607:f130:0:105:216:3cff:fef7:9bc7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-720bc1eb3a7sm6360030b3a.81.2024.11.03.17.45.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2024 17:45:19 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: djwong@kernel.org,
	dchinner@redhat.com,
	leo.lilong@huawei.com,
	wozizhi@huawei.com,
	osandov@fb.com,
	xiang@kernel.org,
	zhangjiachen.jaycee@bytedance.com
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH 4/5] xfs: add infrastructure to support AF allocation algorithm
Date: Mon,  4 Nov 2024 09:44:38 +0800
Message-Id: <20241104014439.3786609-5-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241104014439.3786609-1-zhangshida@kylinos.cn>
References: <20241104014439.3786609-1-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shida Zhang <zhangshida@kylinos.cn>

Add a function to search through all the AFs in a alloction.

Add two members in *args* to trace the current AF.

And properly initialize these members so as to keeping the
behavior exacly the same with the original code logic.

And for those bmbt alloction, we can slightly break the roles
imposed by AF, since it's allocating one block at a time.

Remember our goal to propose the concept of AF is to avoid a
badly fragmented filesystem to consume all the continuous free
space.

So just initialize it in a way like this alloctions are in a
AF ranging from [0, ag_count).

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 fs/xfs/libxfs/xfs_alloc.h      |  2 ++
 fs/xfs/libxfs/xfs_bmap.c       | 34 ++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_bmap_btree.c |  2 ++
 3 files changed, 38 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 0165452e7cd0..ab34aceecc72 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -56,6 +56,8 @@ typedef struct xfs_alloc_arg {
 	bool		alloc_minlen_only; /* allocate exact minlen extent */
 	struct xfs_owner_info	oinfo;	/* owner of blocks being allocated */
 	enum xfs_ag_resv_type	resv;	/* block reservation to use */
+	xfs_agnumber_t	curr_af;	/* start agno of the allocation field */
+	xfs_agnumber_t	next_af;	/* next point of the allocation field */
 } xfs_alloc_arg_t;
 
 /*
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 36dd08d13293..b55b8670730c 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -683,6 +683,8 @@ xfs_bmap_extents_to_btree(
 	args.minlen = args.maxlen = args.prod = 1;
 	args.wasdel = wasdel;
 	*logflagsp = 0;
+	args.curr_af = 0;
+	args.next_af = mp->m_sb.sb_agcount;
 	error = xfs_alloc_vextent_start_ag(&args,
 				XFS_INO_TO_FSB(mp, ip->i_ino));
 	if (error)
@@ -830,6 +832,8 @@ xfs_bmap_local_to_extents(
 	 */
 	args.total = total;
 	args.minlen = args.maxlen = args.prod = 1;
+	args.curr_af = 0;
+	args.next_af = args.mp->m_sb.sb_agcount;
 	error = xfs_alloc_vextent_start_ag(&args,
 			XFS_INO_TO_FSB(args.mp, ip->i_ino));
 	if (error)
@@ -3630,6 +3634,8 @@ xfs_bmap_btalloc_low_space(
 
 	if (args->minlen > ap->minlen) {
 		args->minlen = ap->minlen;
+		args->curr_af = 0;
+		args->next_af = args->mp->m_sb.sb_agcount;
 		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
 		if (error || args->fsbno != NULLFSBLOCK)
 			return error;
@@ -3735,6 +3741,32 @@ xfs_bmap_btalloc_best_length(
 	return xfs_bmap_btalloc_low_space(ap, args);
 }
 
+static int
+xfs_bmap_btalloc_best_length_iterate_afs(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args,
+	int			stripe_align)
+{
+	struct xfs_mount	*mp = ap->ip->i_mount;
+	int			error;
+	unsigned int i;
+
+	args->curr_af = 0;
+
+	for (i = 0; args->curr_af < mp->m_sb.sb_agcount; i++) {
+		args->next_af = mp->m_sb.sb_agcount - mp->m_af[i];
+		error = xfs_bmap_btalloc_best_length(ap, args, stripe_align);
+		if (error || args->fsbno != NULLFSBLOCK)
+			break;
+
+		args->curr_af = args->next_af;
+		/* Exit LOWMODE when going to the next AF. */
+		ap->tp->t_flags &= ~XFS_TRANS_LOWMODE;
+	}
+
+	return error;
+}
+
 static int
 xfs_bmap_btalloc(
 	struct xfs_bmalloca	*ap)
@@ -3751,6 +3783,8 @@ xfs_bmap_btalloc(
 		.datatype	= ap->datatype,
 		.alignment	= 1,
 		.minalignslop	= 0,
+		.curr_af        = 0,
+		.next_af        = mp->m_sb.sb_agcount,
 	};
 	xfs_fileoff_t		orig_offset;
 	xfs_extlen_t		orig_length;
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 3464be771f95..4e57b6f897e8 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -234,6 +234,8 @@ xfs_bmbt_alloc_block(
 		args.minleft = xfs_bmapi_minleft(cur->bc_tp, cur->bc_ino.ip,
 					cur->bc_ino.whichfork);
 
+	args.curr_af = 0;
+	args.next_af = args.mp->m_sb.sb_agcount;
 	error = xfs_alloc_vextent_start_ag(&args, be64_to_cpu(start->l));
 	if (error)
 		return error;
-- 
2.33.0

