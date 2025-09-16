Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE825316905
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 15:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758035135; cv=none; b=Od2+XYhgIvd8MM8/xQiiJ5XsmevucgbVDQbfZ7dvoIBwC4Wr8QLo3fb4haEhsWX2hsO2K1+z0y0YCOXDMPAF46W4zL7Oq9MCXMsvivsO93tCkTyJNSK+Hkl+TMYAlzWGOA+DKV8d9pmv1B4oH7sJASWFCZt8DpbGYhFo/mIrDMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758035135; c=relaxed/simple;
	bh=rf1m2f4iUjHH0eQ1oqWqEAIfCxj+9MFyYeUboy1Tc3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PfzbLIf91ehVwDnU6wv/Dnp0QjZ/b7iRyKYLGHfmN7iLmubnr+bivnYGbYYOd8rNaAby9B3jKRO/5bs7HXHOITFZXfpbmBcXDbI07glPkqbMN8JEnkBi3u20JmlnUUx5Fjkawuje/ApQUk0S2/YEsuuHGkFYzLPEnatGGdS0aZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NxbJ3j/l; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NxbJ3j/l"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-25669596921so57656465ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 08:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758035132; x=1758639932; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BHAIL2Oax/vE44PIvxtgi5jncaQ24osFHZOKTbCofck=;
        b=NxbJ3j/l2Gh+pngpTBDt2fWWhQ3z1XY0t8SDItInx9YXFMaxMZXtT6qpVbsd7xTVp5
         pCUXBMjas0oty3enWKKonGr266BMOBlsOgYjsH59a5dAdVuZJgeish2g3duGLKYSHoOB
         DBTXXVWekXu5pl78/oQPqW6SitEHcTN30YQZjLbJPZIA3ukpT6RESXee/BOIU/bxuoBP
         WiHlcRPv2Vqj0SzB3ojITAW63lE1tfC1BXriHdUJmwl8JGBeUAQQyNLtknw4Hj/fCubt
         QIRri5z+jNKHm4/9exB8fxGYtmFGh8K1oIWNP/6fqmzygxwklBm6y1I8SIG3FPkMCt3/
         gp6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758035132; x=1758639932;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BHAIL2Oax/vE44PIvxtgi5jncaQ24osFHZOKTbCofck=;
        b=tAT3mdcfyhbF6AuA7bFLJbOJXy0ojiiLR/FSeSckzcK87suQB0w0TLxZZ/2emJwOL1
         L0zVCDWyPRPPwc6L0WKbNF81iCZhKzHwtHbOoHjRi67I7itMzRdfIDesl6+r80rUsGM7
         JkgqDn7zLb92tUWued9kM5hdTinv5mxET1SHbiJIqF0KA6WH7gVIxAp5kSqA94VoUrxe
         uIynKQN13Ew9DduP+7NfdjOUluEe+7jqbxqWFS4Ch8qwaK4Ahrqe03JohvwIbdcqtOuT
         1na59Pt7SLlmbAmT+OCfsV90l7dZFjzW6VwZHC5N23sCet/HQj1rPJM3AG26Kg1ODJEC
         wxJQ==
X-Gm-Message-State: AOJu0Yx6lH9papdHHH/UoODLC7k5Tr67xIwsf58HEyemn7naCZWj+aPG
	53MombhCK157NCAUhyDAsYk6nJ3GdHNh0P8nLnRHqkvK2wOlnfHXy3P753wJ5w==
X-Gm-Gg: ASbGncu08dFpPv4VIfNSyHiCgn2G6bYZmiX7eiiEIJYnmeN9Zwprl6ggNxOl3+4R0YY
	vIg1MplK1lFJ5rXESVm6Mued5ZLpOnsqxP8RlKEopiywUZ9yU/tYgoW5BJFLiHIuSOXA3vcHI6o
	6KVvMxb8whl91Ed43ameAGdZQV0GVn1/ZwaX7sQqnkD0gsnd3XlYhQFzqPPKCLgmw55Yuoe9Ez6
	sytic+eUVlsPFVd4IWl+vZ/+uIAY55ysyHL73Ux9/E2bgcgcgqTpaNssEY/gef86OEATXbprBtI
	yrwZS8ssz0me6A/N3klDOzSUBCoraijmrgZ7GaXv8i5+RMnt8TWI+HeBOg1UYfZ2ZfVMeGeU/ng
	UggAIQWvarF44O1L2lH/0XlqMw5DqgeIXEjEXeANlfkoIfqG0f8jC3FNczdkLeLzVOwdf4CBIgK
	s6
X-Google-Smtp-Source: AGHT+IGuOSrzv5WajGFRaBbdFFq2JY8MYN33nLTZtM0ta5uTATUxTjReCrypRYEoumT8dE4IL2hD1A==
X-Received: by 2002:a17:902:ec86:b0:267:6649:ec10 with SMTP id d9443c01a7336-2676649f0ecmr85988045ad.4.1758035132201;
        Tue, 16 Sep 2025 08:05:32 -0700 (PDT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.211.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-26263a76cd4sm94737175ad.31.2025.09.16.08.05.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 08:05:31 -0700 (PDT)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: nirjhar.roy.lists@gmail.com,
	ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	djwong@kernel.org,
	bfoster@redhat.com,
	david@fromorbit.com,
	hsiangkao@linux.alibaba.com
Subject: [RFC V2 1/3] xfs: Re-introduce xg_active_wq field in struct xfs_group
Date: Tue, 16 Sep 2025 20:34:07 +0530
Message-ID: <3e9795d41872f38b280a564ddb517ca6877bad6f.1758034274.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1758034274.git.nirjhar.roy.lists@gmail.com>
References: <cover.1758034274.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pag_active_wq was removed in
commit 9943b4573290
	("xfs: remove the unused pag_active_wq field in struct xfs_perag")
because it was not waited upon. Re-introducing this in struct xfs_group.
This patch also replaces atomic_dec() in xfs_group_rele() with

if (atomic_dec_and_test(&xg->xg_active_ref))
	wake_up(&xg->xg_active_wq);

The reason for this change is that the online shrink code will wait
for all the active references to come down to zero before actually
starting the shrink process (only if the number of blocks that
we are trying to remove is worth 1 or more AGs).

Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_group.c | 4 +++-
 fs/xfs/libxfs/xfs_group.h | 2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_group.c b/fs/xfs/libxfs/xfs_group.c
index 792f76d2e2a0..51ef9dd9d1ed 100644
--- a/fs/xfs/libxfs/xfs_group.c
+++ b/fs/xfs/libxfs/xfs_group.c
@@ -147,7 +147,8 @@ xfs_group_rele(
 	struct xfs_group	*xg)
 {
 	trace_xfs_group_rele(xg, _RET_IP_);
-	atomic_dec(&xg->xg_active_ref);
+	if (atomic_dec_and_test(&xg->xg_active_ref))
+		wake_up(&xg->xg_active_wq);
 }
 
 void
@@ -202,6 +203,7 @@ xfs_group_insert(
 	xfs_defer_drain_init(&xg->xg_intents_drain);
 
 	/* Active ref owned by mount indicates group is online. */
+	init_waitqueue_head(&xg->xg_active_wq);
 	atomic_set(&xg->xg_active_ref, 1);
 
 	error = xa_insert(&mp->m_groups[type].xa, index, xg, GFP_KERNEL);
diff --git a/fs/xfs/libxfs/xfs_group.h b/fs/xfs/libxfs/xfs_group.h
index 4423932a2313..21361508a5b7 100644
--- a/fs/xfs/libxfs/xfs_group.h
+++ b/fs/xfs/libxfs/xfs_group.h
@@ -11,6 +11,8 @@ struct xfs_group {
 	enum xfs_group_type	xg_type;
 	atomic_t		xg_ref;		/* passive reference count */
 	atomic_t		xg_active_ref;	/* active reference count */
+	/* woken up when xg_active_ref falls to zero */
+	wait_queue_head_t	xg_active_wq;
 
 	/* Precalculated geometry info */
 	uint32_t		xg_block_count;	/* max usable gbno */
-- 
2.43.5

