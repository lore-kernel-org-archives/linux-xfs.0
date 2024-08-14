Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65AB11D1F43
	for <linux-xfs@vger.kernel.org>; Wed, 14 Aug 2024 21:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723670784; cv=none; b=p/oEtDmexFDNSXR672VbPnmq8QJOpitkE7ujZkpoxOMxXRFIxs8sTujwzld97yr5cmpI7vZWpiWt4S4KuoMBN+v5yeSB29T4puAAxi3Pg5SV0XoBxtXWb+7FWXbAOZPrkIAxLSw1cUgi5IWZG9hb0hW4Z6UqE2vl6JXA0BTzlrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723670784; c=relaxed/simple;
	bh=NSHxxZRLFbsIgAXbtW5uSuQCtRZde7l6XJ/+Bc0hmhU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lju0iVikV8HyWFjF5tArJPmmOCvfznlEbGJ36EgY51P021Tai2enyp+khHni+qperZNWUy6/8EbTJLWBY4ITSz+iQoNBj8ABWKsFm39hGEo+gFA3LGcGnVUWBtzK9bWPgnQsXAgoqOSEymUYnSHLJe5SSvhQNX8Up/b4ARp6Ujo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=JkBpJjdH; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="JkBpJjdH"
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-5d8060662a1so235209eaf.2
        for <linux-xfs@vger.kernel.org>; Wed, 14 Aug 2024 14:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723670780; x=1724275580; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nOXg5Kh3dRzVUCha6XNrLJPIFEv9dDgQMOq3uyVXRLk=;
        b=JkBpJjdHT0nr8y7rL8HeY2I866l2ae0wbXcN22jjs8VfDIDzAU7TwCjd0SowQT0Pp9
         cH16jFw9xISJc3kn6MjOn+w/Bzkm1V970jOmuzvCTbD9vacuRiG0a9gtwpcnRwMz24Du
         MTP6wcx8anMOCNqYbIJWOo7bgNjY54IniLbtrBGePpdTAaV9p97fG60F9cApSCn8gofZ
         Ea8GDSl/14hEMp23KrnI874k+3gig+mrKcC98nTUmh0waf8jLw57j2B0N92xGbr59B7f
         twbESphI5/jr7Lkxx1tuWVF9g5HAMaLJYD6W51K8PHahW2K+w+9pfVEDo87m76zvNb++
         SeRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723670780; x=1724275580;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nOXg5Kh3dRzVUCha6XNrLJPIFEv9dDgQMOq3uyVXRLk=;
        b=wJTA8kw2r71xae5xVV4E7OrBMpc2D+BWTFftHD776F/xQmfct5U14Y/pnyeEJsUV95
         cNFnEmYKE2gzVMWRwCawMZgSQxPvW0EOIaMc3gxQn//hn+k/jNrYV5w4+UMokc33aJLK
         le9YfU26Mt7JHA01cDZ2FCCQwM92yAM58f4yFcxIJpA3IQshjHKsrHfdNPS+C0lhwN03
         rOSol2URluuSQiQJ7dVB0fnA8Yyc94sEW9lbovIWZSfTiisUAUZMYZ4h0tVFms4GcouW
         8+kqCSHHiH4XyTWBsA7ZzNvm8OldB1CzYhsSqfJL0kA45dSNtxhwR/zAdZhbJky95ZIb
         2q2g==
X-Forwarded-Encrypted: i=1; AJvYcCVIUxOkYAgobP/cste1nWWl6ukFgpjmU8Hr2HQu2NamlXv87EjAj4Ok1yf1Su8ci35Q/PLfCztAFEEya+dnNyuSMx+oC2ylMnbN
X-Gm-Message-State: AOJu0YxsNtX2ttN9qLy1tZhkWQSgXl2w2wpTgst0L3V6UD2aJAOzhQ/Y
	/fkQ0rg60ApZJOkcFLorzboYCJn16iUIqRcjXHCoubBSZiuw8qC/ftgyFINL8lE=
X-Google-Smtp-Source: AGHT+IH8MPr5SHX8NbOpfre4Dyt2H2WS5ph4VEJ8agevnX7RI8saF6DZ/UBE7sdnWVD/jUXsHLxmXQ==
X-Received: by 2002:a05:6358:6486:b0:1ac:ec74:a00a with SMTP id e5c5f4694b2df-1b1aab9017cmr527013655d.17.1723670780544;
        Wed, 14 Aug 2024 14:26:20 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a4ff0e5b09sm8115785a.73.2024.08.14.14.26.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 14:26:20 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v4 15/16] gfs2: add pre-content fsnotify hook to fault
Date: Wed, 14 Aug 2024 17:25:33 -0400
Message-ID: <2bd333be8352f31163eac7528fdcb8b47a1f97b4.1723670362.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1723670362.git.josef@toxicpanda.com>
References: <cover.1723670362.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

gfs2 takes the glock before calling into filemap fault, so add the
fsnotify hook for ->fault before we take the glock in order to avoid any
possible deadlock with the HSM.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/gfs2/file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 08982937b5df..d4af70d765e0 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -556,6 +556,10 @@ static vm_fault_t gfs2_fault(struct vm_fault *vmf)
 	vm_fault_t ret;
 	int err;
 
+	ret = filemap_maybe_emit_fsnotify_event(vmf);
+	if (unlikely(ret))
+		return ret;
+
 	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, 0, &gh);
 	err = gfs2_glock_nq(&gh);
 	if (err) {
-- 
2.43.0

