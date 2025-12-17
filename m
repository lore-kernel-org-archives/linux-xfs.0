Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91F135BDA6
	for <linux-xfs@vger.kernel.org>; Wed, 17 Dec 2025 16:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765989371; cv=none; b=WYq0EmjBafrxDav8gyVZQlw+iCBptKoVPeUtX/ZlNZB/1sGv+oDqxhs5/97orpxcvfM8SCAeCsyXwwrZlK1Vof+NWnp7vMeCjAiId0dNXG7xrpRVDky30hefMT948apA7B/cZ959ODOIBg90rrZp+lACwDzUHJUQBJ2Ktqq9p/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765989371; c=relaxed/simple;
	bh=Q6SvLbobJ9tToUWMV0ZCVzLbWgrsgqyaw3SXlLm9afQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PysIizDCfDsxG3qVVsInaNPBiVCPFO7Ey5kq2vIB+gW4Lc3SlQWK1OTghNyo4e+lUi4WhSYY3Njt2qZltSmAif7pXlCufl1ggPQySezqagx8UozXrXdJOwUnrnArJwSIWi2xT7IkyS8wvu6WVP+G+D6nvn/sU5fxXcqU0U8e310=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LfxB0FDQ; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LfxB0FDQ"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7b8eff36e3bso8751854b3a.2
        for <linux-xfs@vger.kernel.org>; Wed, 17 Dec 2025 08:36:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765989365; x=1766594165; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jtn3VjIZKARjWl/6SMhsSy93JOhAKIxs03Sm7FLh0g0=;
        b=LfxB0FDQguWPHVVTGJ4nU9mcxKSKXsDAOjGYVHRN1syD9zqOXf075ARyM8XSfV6HX7
         tdeZb+I0pzLAJHp5sVFINrW6EVnAxoO6QI2zSO4ohI8PiPeOnm7Hsk5VAL3HTOePGwXJ
         mVE4wuBbe1E9fqOy+xK1ehkFgKDvqhsRtcSn6vaTxwmFddXATOKQfoYzdqGRXmr1rpp3
         w29eKmhaBNgJ4mSJYMvuTxDykz7hV4W82kj9EXfQX0+/V6vIaPh7qOdBBh9jyJeDADLg
         X7xaKjIh6YHaX/K27qcyYLEFW/VLMlrWV8c+z5nbz66O9CxoKk45dQcNUswpcJA9J+Af
         JLXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765989365; x=1766594165;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jtn3VjIZKARjWl/6SMhsSy93JOhAKIxs03Sm7FLh0g0=;
        b=AZWpgIRwFaXWRmxZVFRuYb+g9OUUy4O+w6fHwuaWXLxeMzE4faL+y1O2FqlzBDQasr
         whF5aW0ip5SR6SdIUwwAX83h8st2g8UtFFUA8QnWHsmJJRknxclnte5jrwkePGl8lRkr
         Nj3KfeHGDGSTWTE8t6cY/m3KCQessBykKw0lRlUXVdCnPIF4cGbLJ1ATp8I5lWRhwEZc
         JgtP67Pg6ICRLU92onzPTBJwKkMZhlXzDQhrFGhnXXcdDLuHGG6r94JsGmm2WSM6tiBO
         sG6E4Rfa56e/BrE+KoiCv0Qrb5gD0PL89a+lI7WT27cQxjY1jron/pTn3sNov5P+TjZ+
         7gXQ==
X-Gm-Message-State: AOJu0YzcuueFpr0fKVUOPf74zw5FN2UR/+/lbcKXhMu9A1fnEZ3RKOUG
	4rb7ho70x1V3g7gom74eiaKX1X5rJci/g5tLB6n2GLYlwDnn7ePmpevQQ83DBw==
X-Gm-Gg: AY/fxX5pLp/VTR5ZCQPL3A4/a9KuPTfMeIieaRNDuuy+5dWxMdUwwJ+77h0QhKkWzPc
	TV5HifSiUwnMHOJH4ApDULt0GkYE5gi6UiHAcryf8VnSifhFzocFZPKoz28IYZRIbSwOykBiaiR
	h7uDvl9GQXrwtaG4rvnrLyasejllQT15tZXEsQ5EbeT4xl7B/IjeEMA6FlGyRPKUmjsWBYK9vlx
	x4r4w4giKaS5vO8Do1y+FxFQ9tUCiOycHn+h94ncxCb6cE/db5GDKV0XAhiGzM915KmbPr7dCUE
	JzQzfK2g6KZ6mkpgl2v/XKfyOmW+HhUXzqOsY4q6uyLBTSvW4hFYvzc2L5JMvDY3BKJ/CkK9DAz
	IwYxXiyZBP6WZCmMBYTfUUnewQFHswLdGlGCJ/S/s3V2I4UFDHX2oYmAfiRAWdYefjRSNKOWVM2
	j2TdOMLWxUOO7/m7GBaw/kUbnN+X0DLoAwRFKPpLupcFqxHvmtXNFH+LlAegxY4Gio/hAFo5dA4
	1Q=
X-Google-Smtp-Source: AGHT+IEgstnuC4BATHd8Me7IQ3mW7SlTBhtZFHw5VQhAeXWuhamau2BFSDFKLz1KpkLKAZE2kD8cMQ==
X-Received: by 2002:a05:6a20:430e:b0:34e:a801:8166 with SMTP id adf61e73a8af0-369ae48c59cmr21043379637.32.1765989364656;
        Wed, 17 Dec 2025 08:36:04 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.205.246])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a099e77889sm135190335ad.22.2025.12.17.08.36.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 08:36:04 -0800 (PST)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	djwong@kernel.org,
	hch@infradead.org,
	nirjhar.roy.lists@gmail.com
Subject: [PATCH v3] xfs: Fix the return value of xfs_rtcopy_summary()
Date: Wed, 17 Dec 2025 22:04:32 +0530
Message-ID: <83545465b4db39db08d669f9a0a736fdac473f4a.1765989198.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_rtcopy_summary() should return the appropriate error code
instead of always returning 0. The caller of this function which is
xfs_growfs_rt_bmblock() is already handling the error.

Fixes: e94b53ff699c ("xfs: cache last bitmap block in realtime allocator")
Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Cc: <stable@vger.kernel.org> # v6.7
---
 fs/xfs/xfs_rtalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 6907e871fa15..bc88b965e909 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -126,7 +126,7 @@ xfs_rtcopy_summary(
 	error = 0;
 out:
 	xfs_rtbuf_cache_relse(oargs);
-	return 0;
+	return error;
 }
 /*
  * Mark an extent specified by start and len allocated.
-- 
2.43.5

