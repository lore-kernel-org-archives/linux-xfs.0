Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBED3B27F5
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 20:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789419153; cv=none; b=Ya30oR2p+SBkP92ozeDyp4FkAqMg0mBguDLnrQbnN8ToUutX6FY3V+LqI2vbdxsGE3hfi9anDbE3lSi6y5X0F+rSwvaMot28apE9fv/C0gjN/uqVmkXem6WdOBhDEjQJ/8v4eONFNiaZgtxVN/qoCbqLmcGQ1Maych6hpV8OUlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789419153; c=relaxed/simple;
	bh=v5cHALhYG1bWZsG/TmHUVVMcIoM330CH65YGyNN6BUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KysaZzUxlkNQYDih7CcfbKScMbZdxZuR3eHiaLyFscQ4GMqjsHAZPQLUS2L8xXgaPNaCN2SvvcIMNQ6u5eefy85SeUQew5ANH5f41kKhYLYPhEdXg3bYUCzDLuSDwh/hABRLcHRytvIfuvwllrxakaParjipKpifMWCHrSv+D20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FSjVMWfR; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=SAZHwour; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FSjVMWfR";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="SAZHwour"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789419151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qsZ7KqaivgFO05w/WoxAJWzcSFZfGxKT39iye3ay5yM=;
	b=FSjVMWfR3Gz3LZoGy6/cKTpZrMda9GYkt/ur24WTi4yPau02kYucybFPxfTyF9lOd1lYTq
	3Ogth3iLYGXQBMpF6D57EdiLDXj999cuxhshbBstgcg5OSNeevaZASzTwHARUA9aXKgaRH
	K5MOVPuFJY6k5FTXOIaGhvtYtIDkXwg=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-H9NU6vxAPXW3IMPvHpCq9w-1; Mon, 14 Sep 2026 16:52:30 -0400
X-MC-Unique: H9NU6vxAPXW3IMPvHpCq9w-1
X-Mimecast-MFC-AGG-ID: H9NU6vxAPXW3IMPvHpCq9w_1789419149
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-939665a1ae6so952882885a.0
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 13:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789419149; x=1790023949; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qsZ7KqaivgFO05w/WoxAJWzcSFZfGxKT39iye3ay5yM=;
        b=SAZHwouroSiP/9FtPHGJTHJkO3SLhw7x36o0egJg5acQQlUVFilxE37yX9H7QhlUtG
         KAcvyfqSJcBhAfG5lXFV6Z+ooO9Nuou/c83dAEyU4a2XnYEABG+dUUOf1swds0NxQTLY
         PlrkMDDTzmfg4GZvIdi1pfnWBja9zaCCN4sOVyZcUOSdeK1aurKrcAD1V8/NWpo+w1Tt
         b3Owk+8JWrgFNWkUxnx/IFsOGdhf2x5ry+8XPF62tfP67xQDPXj0L6EZtvaT0Ni2T4/w
         tVaM6Jv/hjJ5GZS7G1xm7JT8AZZ569e+Dh2nR9Nq0S9Z+RBq2dCXFR3FOvKHmv7/zy95
         U19g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789419149; x=1790023949;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qsZ7KqaivgFO05w/WoxAJWzcSFZfGxKT39iye3ay5yM=;
        b=VyUfMdMo8p39tRsB+cpNBhSbsntGfzcYU6aILcJdYoFNAG7xugsuC06EL/uccvf64a
         x21QJ9dsVh2jDZaUbV9WTJ6OtA7PGLHISnIQZQMxy1gxNBqgmXXPPqQVoSaHZQ4Rcj1Z
         jMdT2hexujoxiFX4k1gfVqoKMlF/ko50ftUCV5pN/GZ92G+CcCPdz0zo9S5xDRjUI2Vr
         O6Jyk6JEKFLkDiNCzOgqFUdm47nt0+j8OY+2rn6offGE6P17qy5KAM5cjcss8Lhtdohj
         hd10RPgojLj1Hk4w6HRhBg+1Kyu2vgN5D1SC32w8pLl46BWafVuQgehl0oGrbWU3zGlX
         WDCw==
X-Gm-Message-State: AFuF++mmsbC+eahHlDnRktiXZz5axRgL4LwpDuZGnRcZnFivbRVPHHnE
	rYJ/j8s+Gm1N9mmwfq3cZ6HH29CE9B5akvveHXxlm+YeWKkg+W50WuSa9UBBWGJt7flWQGjpoGH
	zwyDVAEwgPS4olkHIdSFNkseG9WYUgGpO1WEBXu0okiHgu+M6fPp/edq+XxD7qjRpLKpzxbW8xd
	eYrZxLCgOlYQynAwOYDxZnY0mlFDwwxPF+4U7+V/0oBzFQLRc=
X-Gm-Gg: AYBFou1sH51eWMT6npz1WzE8MO+htuKRxGNzyjB5HiwDlqF0KX/2j1dd+yCwt7Gz5jr
	cDtoLa2RXTGRolCmg3HbZOBJiFLIFOgFWBtJHbWfDA5fzXZABiGnqFyrYVxnYahjczItdFB8qjK
	rsMxwMM2sRaljmVfwCbCXVaMKxEEhsSty/FvsG5hmhQ/TfSHie15O0q97Ezq5TNJJpawtC8bEjZ
	M7POUMKH0+X2AIhyQbV31W4cXxBnjHvHzq+I1mR91kvU0TjPSbWJMgVravJx+8I1R1vsWXC2M3c
	m1Uyzk3mZGYQ8/ljr3tjD9VPY7b2c7bsL7jQ+Cg7V8mUljC22Rq2ik/ia9Bk+sFY24C64QfxPji
	pNpLGXNUXLq6bAd8SPasj4qGro+VJSFiFq19JWg==
X-Received: by 2002:a05:620a:2a08:b0:937:27fb:96f8 with SMTP id af79cd13be357-93a29b94d58mr643317585a.41.1789419147304;
        Mon, 14 Sep 2026 13:52:27 -0700 (PDT)
X-Received: by 2002:a05:620a:2a08:b0:937:27fb:96f8 with SMTP id af79cd13be357-93a29b94d58mr643308785a.41.1789419146648;
        Mon, 14 Sep 2026 13:52:26 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939e7f1da12sm1099236785a.9.2026.09.14.13.52.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 13:52:26 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 03/14] xfs: remove unused mp and ops arguments from xfbtree_rec_bytes()
Date: Mon, 14 Sep 2026 15:46:08 -0500
Message-ID: <20260914205221.1516254-4-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914205221.1516254-1-sandeen@redhat.com>
References: <20260914205221.1516254-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_btree_mem.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree_mem.c b/fs/xfs/libxfs/xfs_btree_mem.c
index 37136a70e56d..f5207c2e261e 100644
--- a/fs/xfs/libxfs/xfs_btree_mem.c
+++ b/fs/xfs/libxfs/xfs_btree_mem.c
@@ -73,9 +73,7 @@ xfbtree_destroy(
 
 /* Compute the number of bytes available for records. */
 static inline unsigned int
-xfbtree_rec_bytes(
-	struct xfs_mount		*mp,
-	const struct xfs_btree_ops	*ops)
+xfbtree_rec_bytes(void)
 {
 	return XMBUF_BLOCKSIZE - XFS_BTREE_LBLOCK_CRC_LEN;
 }
@@ -117,7 +115,7 @@ xfbtree_init(
 	struct xfs_buftarg		*btp,
 	const struct xfs_btree_ops	*ops)
 {
-	unsigned int			blocklen = xfbtree_rec_bytes(mp, ops);
+	unsigned int			blocklen = xfbtree_rec_bytes();
 	unsigned int			keyptr_len;
 	int				error;
 
-- 
2.55.0

