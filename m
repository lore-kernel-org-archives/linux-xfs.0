Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777CE42A152
	for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 16:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786380206; cv=none; b=iyqYpPhORD+imaSOHJPw18KZ7JUrpIDNvuiUeR0w1QeqrWgWTGTtqCS6AKEu4WytXtDEeGVkKc/7BPze0FTa9QFqHtXHU8YswGUeBSvTTCcOTi0PJYJTaBFMORV9zblWRds4ShYHDWAQdKbGxYlFrrbNHLAEQBodBj5KnrRxtzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786380206; c=relaxed/simple;
	bh=NNh5aG4w7LlGxuf1r7SXWUFUWOyJJe//FeT84ioNlzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jzHdzKL0o9+KQf42e7KrEi/+9Efq13Nrn2OkEVO7nbGuVO9AHZAlUX5mURaqlW9ix9R8ogCSKxPK7Tyi9hN5lQL2jn2RXtgQQHTO6W4gwywW9cNftIgN+wh+odKTDevCaTn01vTxBZehZdHKSt8m8KhKziVLp/6lilT6JxPpNHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com; spf=pass smtp.mailfrom=peridio.com; dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b=oxbg196x; arc=none smtp.client-ip=209.85.222.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=peridio.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b="oxbg196x"
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-977b2fcfdedso47563241.1
        for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 09:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=peridio.com; s=google; t=1786380202; x=1786985002; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wbXsisKh0qf4tkJequwBHZTpDXZaOCmKMrgCvRHqAvk=;
        b=oxbg196xPXE/kZhUuL8wHH51+vPjxwO5XPKHkpCBDe1CLdF0PEGmcwR78v6YDJBkVK
         Xxxhrc5uAo0Tvrl82jxmXOaISWQlodId0uvnGMFApR++kqBAMa7U1Xtenltfz3iJSBqK
         UA1DUD5VFMFTbdx6g0HssvPDkFXli15/VjqCTq81eOhlleuo1aAN97vUmf2JkRZEkUMm
         8vxzLqNYTpZ/OKZDkmeseD1mLzpl07tILTmzu0bozjKSAfrDyHShQtMwPfb7tFKXn+Xh
         SE+JqETML4tZIxBHRnyAlNz3fBRJiPJ7YNM++WTfYdofGr8DTKwzoive7CrShvFGiqu4
         QlIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786380202; x=1786985002;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wbXsisKh0qf4tkJequwBHZTpDXZaOCmKMrgCvRHqAvk=;
        b=oDOJItIGp2oC9IQTsKTPNPIVf9t7agQrqHHu6zYGT5jZupQQBU+DJbAsMhGtSeFlOI
         BCk6zWknf6+djzbV91bf8AvX/rzAaLrcpKFt3edpbs3JbQaqdBL4N6TvfPXKmNlu0ef+
         dpcZyiS/cvRyy/iv2Krexn7M+Md5+BfiknVcDfYWsoDDLowlefnsVCGR7mJ7EUsz9o76
         vvY2704UrBTTU3Vj3593nGYUP/QcAiWf2mbD5nUpm/wMIQt/gV1n9RaNIBJTD97cohlm
         +2Uwf3zaAUFnHGIIB3gYGPbAE1pYqY38iX0xA/+OXJJzoDs1lwTCgP9hB1OlpclE3tZv
         K9Zg==
X-Forwarded-Encrypted: i=1; AHgh+RqJMMWLT/a0Ue3Xr0655N2bKQQJ/nV4uweIaosKlKYupMiUZ21sxjZky1utqIioVaLc1tCifqB1cyU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6ZgYlvnag2tYmPFwMHx2X4gwu0/OxoA/o3Giq7+qjuC2dq8tB
	W3bgVzILetYFAftg8ZONtjdg0CTRxkkWffj9sJytsXJ0EQPbi2nOj5CiJn6l+vXqaAI=
X-Gm-Gg: AR+sD1147A2R8tJU0Zrg5HmeVqP4S4cLYRTHAYjbvn1eAJOpeLL/E6+EUd+GlRtQKNm
	DrWizD1rHUcgUbAfoidHRQ9M4pWh6sgZQqxOdwGBi9ltqU7qfXAJmMzX0sumrBYPKDfqtbPoPKN
	fLRsH4qtMLC8R2HWe+z2Fo+CNNtma8lL3GLcRYhKvTruGstoijHoA5ChzP8jRXklY5QWkMrY/+g
	ZUtIi6RakV1p6PBQ7u3TC3p6nr9COiR4opyXpMjqpdOMYmUfDKDwgXxVtblAcvFizZUuk8VHjX4
	JCv22oxZGQkRTpn76bl8zgxRZfCukMRsftYoxO84Oq/DFufFjGLOAwdp10ta4VbhypPtGQpPAUy
	+NdUvgTFXZmM++bkvpjYpLJ5jWrIJzJq7hQl30dmk8cTBLgAN/3yG+Buug5HbIQGjE1c1BdEMMV
	BWssdsXfKVW+iwf+oC5Y+bAAnco4Y50UJjrvTpOsEM3aP1SyLsS0I3EYY=
X-Received: by 2002:a05:6122:8001:b0:5c3:b339:7b19 with SMTP id 71dfb90a1353d-5c3d9089796mr3473437e0c.1.1786380202345;
        Mon, 10 Aug 2026 09:43:22 -0700 (PDT)
Received: from localhost ([190.113.101.40])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c40b1a8007sm4686085e0c.11.2026.08.10.09.43.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 09:43:21 -0700 (PDT)
Sender: Javier Tia <j.tia@peridio.com>
From: Javier Tia <javier@peridio.com>
X-Google-Original-From: Javier Tia <floss@jetm.me>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/6] xfs: correct the parent pointer space reservation comment
Date: Mon, 10 Aug 2026 10:43:17 -0600
Message-ID: <20260810164312.960721-12-floss@jetm.me>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260810164312.960721-8-floss@jetm.me>
References: <20260808234016.246054-7-floss@jetm.me>
 <20260810164312.960721-8-floss@jetm.me>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2488; i=floss@jetm.me; h=from:subject; bh=NNh5aG4w7LlGxuf1r7SXWUFUWOyJJe//FeT84ioNlzE=; b=owEB7QES/pANAwAKAbXuwwuoZ3cfAcsmYgBqef+hTRG87aijZKn3RyqSuNdDpFcbWIcNNA3Fv LL1n2VxtmaJAbMEAAEKAB0WIQSbE7ILzw7eI0VKk8m17sMLqGd3HwUCann/oQAKCRC17sMLqGd3 HxirDACZiE3oq3uoauqJ//X0CoAHzdyr+NN9AbCLlnXPaoQvfPLiUIJuQhYSs7zDzk4ojnKj1+5 n0g8GTC5FI33786Pfo/l0L0ilVna1itTy50uGgOC8VmcbncljswJu0RZDgX41aF14yGRjSbWARu Od1A9qztllg2XQMgmVxqj13srswq56nvrT2UtgKahfkvAAUte6C9mJL/731CE+D/zzV3obvIRVm N+DOxOAr+4HZl1RlXo8i1vy3oRtG4bzjk0H0XiSr2FjeqoXOAy2bgxPAuWSp7vMMu6pT9iZtpkV vQAFnUXo/g5k8lI529FuPw3pqkHF6QamzOb/ryMu6hIWlTM1y7WCZj4V/NhjsdBLZ3wIsWOlKfr cdegsBU4WVJAcxfCv478x1corFNA61HE9s8YQlUUuycvEX6uY5HAe0NtyIaSf8JQB1BDwDyAL5c 9uP7ccQzSknOU422CtmbFfMaqlhnCbHqZygTu1CvsoVFPU9t5yWkwLrOrCignY2058BJI=
X-Developer-Key: i=floss@jetm.me; a=openpgp; fpr=9B13B20BCF0EDE23454A93C9B5EEC30BA867771F
Content-Transfer-Encoding: 8bit

The comment on xfs_parent_calc_space_res() claims parent pointers are
"always the first attr in an attr tree".  They are not: a parent pointer
is recorded per dirent, so by the Nth hardlink the attr fork is already
in leaf or node format.  The reservation is still correct, because
XFS_DAENTER_SPACE_RES() covers a split at every level of a maximum-depth
attr dabtree whatever format the fork is in, but anyone auditing a
shortfall here is led by the comment to look for a bug that is not
there.

Rewrite the comment to state what actually bounds the result, and record
why the double split allowance and the extent-add term differ from
xfs_attr_calc_size().

Signed-off-by: Javier Tia <floss@jetm.me>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_trans_space.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_space.c b/fs/xfs/libxfs/xfs_trans_space.c
index 9b8f495c9049..c4cd547033e5 100644
--- a/fs/xfs/libxfs/xfs_trans_space.c
+++ b/fs/xfs/libxfs/xfs_trans_space.c
@@ -22,8 +22,23 @@ xfs_parent_calc_space_res(
 	unsigned int		namelen)
 {
 	/*
-	 * Parent pointers are always the first attr in an attr tree, and never
-	 * larger than a block
+	 * A parent pointer is recorded per dirent, so an inode with N links
+	 * carries N of them and the attr fork can already be in leaf or node
+	 * format when one is added.  That does not affect the reservation:
+	 * XFS_DAENTER_SPACE_RES covers a split at every level of a
+	 * maximum-depth attr dabtree, whatever format the fork is in now.
+	 *
+	 * The name is a dirent name and the value is a struct xfs_parent_rec,
+	 * so the leaf entry is always local and never exceeds 272 bytes.
+	 * Parent pointers require V5, hence a 1k minimum block size, so the
+	 * entry always stays under half a block and this needs none of the
+	 * double split allowance that xfs_attr_calc_size() makes.
+	 *
+	 * The second term hands a byte count to a macro whose parameter counts
+	 * mappings, so it asks for more extent-add allowance than the single
+	 * mapping a parent pointer adds - how much more depends on the block
+	 * size.  It over-reserves either way, which is why it is left alone:
+	 * correcting the unit would shrink a reservation that is only generous.
 	 */
 	return XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK) +
 	       XFS_NEXTENTADD_SPACE_RES(mp, namelen, XFS_ATTR_FORK);
-- 
Javier Tia

