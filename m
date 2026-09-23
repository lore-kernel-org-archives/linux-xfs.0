Received: from mail-vs2-f43.google.com (mail-vs2-f43.google.com [74.125.227.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E094ACC6F
	for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 11:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790164723; cv=none; b=g3QPo5coCzcl7BH8fsDvv8yQVpdPc7SsFXrQWrreGbr0Q46NKfIl6dAFxR7in6DWT7mgJzWmVPJnoaSzqezxSt//U8svsultYnmE5XNDr2PgP+FD8tZlJQfVyPXr0Krrn+amCoRCyAa+QBs+XN8Dfo3KqUB2KAuLD+mDHm5L8nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790164723; c=relaxed/simple;
	bh=J3Qov41MlfghPvhRovLY0AKfP5UMN0aeIFvDOXPBh5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WMnxvSB+DOr8gow+f6q8lFHE+g1S5fqsWLMDaCZcdS5chaV5VDxLDCRWIOfT/R8lHHceJ8uD+j/VmMffBNqNjQWMWqukBhzYqT6LNNJWpiSaoqAVCoyZ6qme2zDGjtK3g+hoxznX5uoPQVbQ6uxWIlCGk/3CCmDDtNfFyr84Cqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ac/lmtWx; arc=none smtp.client-ip=74.125.227.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ac/lmtWx"
Received: by mail-vs2-f43.google.com with SMTP id ada2fe7eead31-7856441f7d8so467465137.0
        for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 04:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790164715; x=1790769515; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nj94AZGep7yfFM2zqSs8rxQVirPiCBiLnqyMKAGPXrw=;
        b=Ac/lmtWxeuFne/DEBAHBEUJovI9UngNj9PvkWkJIdNRleLj8YDzroi0KyMhRtuiD9d
         Tb0WrEBNKZ+m3IDnQTBxaLBzav0v1JCkxPqejU/pC6Hnoyx1VJdYbnlEL17AlC6XnEn8
         efOgV48kduZBZldvxCGzr3T7hQQTM5QKA1ywUddEP8owodwqY3kZ6m0gVLiO8t+Gm6xz
         Jf6YD6XJK0SZYrTiZPkqi6Ff9IG3frsWDzemKSV7xZ0igAwjz9lV+u6WajMdWY04Oi1Y
         BT2cxrUqogWBBLuAjnBxS925N+GkvL/Hi1SnBqHv1sqkjKaKTlAck+ocQll0s0OQzB+a
         tq0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790164715; x=1790769515;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nj94AZGep7yfFM2zqSs8rxQVirPiCBiLnqyMKAGPXrw=;
        b=ny97pAGAlgb9dhq8ZvitcYkpy8aX3l3Q7MM6l16Mj9tRH0urPPIdTy7xWM6VC26KsU
         FlJwxdhNcv/5yBKH7N13y2+O2YML6GjVmszJuYnFktb3BHhsI5liPQp8LvCCR7gHjYgL
         O/hTz9E0ZN67QZvzjDGqmpXTIxMCIOgQdxAig68bYxMRqk5golagsJCv7pohx5W/rywt
         dBmBxMsjIe6juRmZNVuipwgH7B3/8x569vRxdfHDQ6kZFhE6UfeTWil3/CdimfZFQWCO
         x8N+FlFKH995MHOfMEKJYZgKkTrFQkrzQdLUGw5osNHByi4I2abClt9o9tKoJ9En+nwF
         FS5Q==
X-Gm-Message-State: AFuF++mUJNd4snV8QwYwdkv+oPOp8Wu1xeZmTuVCmoQJMXHhm0jkBkIE
	PDk10p/+XMol4uWZjNPI+witvWVtb2Y7V6LwDrkgVZ3IYY1EFP/PtSu5yhkZXg==
X-Gm-Gg: AYBFou2gWxE6P6JiuN9NzASjyVbXOuU9NMeag86FcRF4c1b0YJRxZLGScyZzjivZ3kN
	Tx+h6K4ZmoZUOm02b+0sUEfP1BuWb93DqmEUfA0edRtNglirFcYWdqBGVlzk3Wp2H74hC2Q5Tuf
	8lgYX2qQRSZejz48dl/noAs0+6JCC2e+6jC6kecjq2/bdX78Q69C9markMJ9sEjI9KEUsI6dGXf
	UAgeosEqI+6ligjMthDH89KLVclwJGB4x2dg4wjFlcgctzUHMALKzRaKKpllHyU3nfDyzs48g7y
	fwqPu4lsschAXVvB7YhXsRf/AUPg6+XyduYWZ4A4RxcWG3+12cYFs45She7wfUq+nirMcWH9h99
	8lSvDojVbw2BfTxsjtezsaNe0aiLTSvYXAucKjAVgDzUW75Oo9zn22VLeNUPqB7vGOXj/gBzBp1
	BnA/sRRvax8NepQP/7b4BJWICMqfn1NWpFMPjPskUm1FeA1H4zcpsBs7XVvPDrXDh9ZUkI2nyH3
	g==
X-Received: by 2002:a05:6102:a158:b0:7ae:c2ca:906 with SMTP id ada2fe7eead31-7aec2ca1672mr19473137.13.1790164715537;
        Wed, 23 Sep 2026 04:58:35 -0700 (PDT)
Received: from beelink.. ([187.13.30.172])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-985167e6fcfsm3257250241.0.2026.09.23.04.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 04:58:35 -0700 (PDT)
From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
To: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-kernel@vger.kernel.org,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 RESEND 1/2] xfs: reject out-of-range attribute value lengths in xfs_attr_copy_value
Date: Wed, 23 Sep 2026 08:58:22 -0300
Message-ID: <20260923115823.3305596-2-qwe.aldo@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260923115823.3305596-1-qwe.aldo@gmail.com>
References: <20260923115823.3305596-1-qwe.aldo@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_attr_copy_value() takes the value length as a signed int and, for a
remote xattr, is handed args->rmtvaluelen.  That field is filled from the
on-disk __be32 xfs_attr_leaf_name_remote.valuelen in
xfs_attr3_leaf_getvalue(), so a crafted length such as 0x80000000 is
stored into the signed rmtvaluelen as a negative number.

The "buffer too small" guard in xfs_attr_copy_value() is a signed
comparison:

	if (args->valuelen < valuelen)
		return -ERANGE;

A negative valuelen therefore compares as smaller than the caller's
buffer size, skips the -ERANGE path, and is then used as a copy length,
leading to an out-of-bounds copy of a full remote block into a small
getxattr(2) buffer on a mounted crafted image.

Reject a value length that is negative or larger than the maximum xattr
size before it is used, so a bogus on-disk length can no longer slip
through the value copier.

Fixes: 9df243a1a9e6 ("xfs: consolidate attribute value copying")
Cc: <stable@vger.kernel.org>
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
---
v2: new patch (see the 0/2 cover letter).  Fixes the signed value-length
    check in the consumer, xfs_attr_copy_value(), which is the root
    cause Darrick pointed at in his review of the v1 verifier patch.

 fs/xfs/libxfs/xfs_attr_leaf.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 86c5c09a5db4..d0f7753659c9 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -628,6 +628,17 @@ xfs_attr_copy_value(
 	unsigned char		*value,
 	int			valuelen)
 {
+	/*
+	 * A value length that is negative or larger than the maximum xattr
+	 * size is on-disk corruption.  The remote value length is an on-disk
+	 * __be32 stored into the signed args->rmtvaluelen, so a crafted value
+	 * such as 0x80000000 becomes negative and would slip past the
+	 * "args->valuelen < valuelen" check below and be used as a copy
+	 * length.  Reject it before that can happen.
+	 */
+	if (valuelen < 0 || valuelen > XFS_XATTR_SIZE_MAX)
+		return -EFSCORRUPTED;
+
 	/*
 	 * Parent pointer lookups require the caller to specify the name and
 	 * value, so don't copy anything.
-- 
2.53.0

