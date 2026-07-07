Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900D538AC72
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jul 2026 19:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783450856; cv=none; b=oSl3jbPcAWbdJ/1oNX4FAvo3cCNy3cSTCnm4ZYi2eZtrm1C1KKFOOeDOif3BPdny6MeOGwBbZ2tlaZysH3FiSaBF2JPwoqTf65eQ7qrDskW/d8LNjZ3iR6x8frSODezcco26iCxsGEYfkg09qM7/b3ahZ9TyELyLQJNdxgGcwvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783450856; c=relaxed/simple;
	bh=J3Qov41MlfghPvhRovLY0AKfP5UMN0aeIFvDOXPBh5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jBVb3ZkHWriaaVLgPViNlVIYI3icaveE+kEUgsw/6q5T2mzMeKJdFBEf7ZcqvIlI3Kg0LipYlRlF99n/qLKBQh2qhDKK8MNp7nWmOtwuOp9ec1uWkSxXFGlS6cd+KLzJr5z4sd3LlBsKpchhJmw2n56a8Azvtxm4+vunQskRzl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fJ44j4x0; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fJ44j4x0"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-381b831d535so5223586a91.0
        for <linux-xfs@vger.kernel.org>; Tue, 07 Jul 2026 12:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783450855; x=1784055655; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nj94AZGep7yfFM2zqSs8rxQVirPiCBiLnqyMKAGPXrw=;
        b=fJ44j4x0GwLSO7XZoi/CWtFUWmVpTxkuPj4v2h1/J7dBimfuIHY1Y9fBL0wqOOQ5hX
         75pPj1/x2GB/uTB9MmRLnVKKfRH1gRA0yRwOCuAqyO3h4N8b87UMdNWsQ9aG4tunqP9F
         ftZSb0FMzAND17fDAAr2T2cUZOA6AaHvxyzkAtMWPjwHysLhYhllvpI1E0GWKrkQ3PUy
         1EBBSV7cORPweej69haEKjLYwuYjtqvVX65fpT6YVWyf6MF/4EzbXWzr01xL2DfkAf7B
         YYKrlc9pEGJU9GLHoOUB4jkMcCvMgfpAPMKMw/76vQk2qCsRU/d83OynXty65CkFhbk2
         wqLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783450855; x=1784055655;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nj94AZGep7yfFM2zqSs8rxQVirPiCBiLnqyMKAGPXrw=;
        b=KdYSF4j/mFoZFUMUYm/f28iPEmyWzyh5FhqAvU3LVj3FIeU9g1vnjCdbRdBPdAMHOr
         XQ0FSkeQ45gp0gbxLZU7xBszanpx/j0BgnBLRE/c/hnx+Gr3/SyJbqSeYyEYxRn2TDqd
         LR9y05x7nbaXWmrW7X/nwQzO6S7OoojSuFWLY1Iq/fCkOWl7TsTobUh7rNvCk6tM1tMB
         985+vzZDvteJxnCUlWIbB9dkxBz66n7AG47TVkrx+oApPsct1cav0Z8trZFkCefnciVI
         8D0oImwps+HgF8s42wv0ZTM7BPow6bn09f+V2VKkBr3q+j5Ia0HLDf5JDZmdFCauPxoY
         bCEw==
X-Gm-Message-State: AOJu0YziNw5NA7kY01P4UQawdsLhZ4uRPfmFmrApms00wWF0z0CScp4f
	cTlnev8MtdR+JMNCWDup1r6w/QbgO+ycJWzRjX0Rq0FgQYIYkKegEnfrpueG5TG+5rU=
X-Gm-Gg: AfdE7cmhFbzxoMnHHFTzBRy/cB8xRn1xHwZjN1s4DKbJqbhXoNDva9UDqcqmk1FtwFj
	6K5qBjkJk3RhPZeRo6jngeaHk4+3v7XnYZowo1UaPcToOGMdRhG4IbGgzo4uZJXQ9Ze+EJ3nBBj
	2l195bXH0cAFK/SiQzBDlb7paMZhKbLognXvCMkcfLH/aj1wAnRfno/ynfD4Bj+Jd5CHcAp7hkG
	ioUAiyEbZakmHq21X7W51ZIa0kqPjT8d0yRDfVcNouYVfmj2mY19qi32QvUhIBWLR83Nyr2/19U
	eA4V0toJ7eoM9DrMXg5nfCZnRsdqAtoBrTTKyjmbFCvcIzovbWDbT50FCn5ob0MGUecNATc7IDy
	CwjxhcCga0fR5aEUspLCPttOdhP2AVqi0ZG9MsflRLo0HctmMw+tkR3c93fH3bb7j2BzNCA3IfT
	DhMaLV
X-Received: by 2002:a17:90b:1a8b:b0:381:29f2:481b with SMTP id 98e67ed59e1d1-387568fe4bbmr6362442a91.11.1783450854954;
        Tue, 07 Jul 2026 12:00:54 -0700 (PDT)
Received: from beelink.. ([186.22.57.86])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31174a583bcsm12305248eec.19.2026.07.07.12.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 12:00:54 -0700 (PDT)
From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
To: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-kernel@vger.kernel.org,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/2] xfs: reject out-of-range attribute value lengths in xfs_attr_copy_value
Date: Tue,  7 Jul 2026 16:00:37 -0300
Message-ID: <20260707190038.3811440-2-qwe.aldo@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260707190038.3811440-1-qwe.aldo@gmail.com>
References: <20260707140118.3217585-1-qwe.aldo@gmail.com>
 <20260707190038.3811440-1-qwe.aldo@gmail.com>
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

