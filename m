Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5A949E143
	for <linux-xfs@vger.kernel.org>; Tue,  6 Oct 2026 15:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791301221; cv=none; b=COIq/3YPCttLCUFdd0XxYFg/B/oGtrdwkEriHE3tBFNm6uTY17KfCq2u112i4GL9O3xVD4f+CJ6jPeIqCXAIsDDdv+3Fa3t4R5bwBQWcpuYceU9XfJtZ8SCUYejzDUzq0YJ1vepWQA4hrV1/7W/1ALsfQFo0ptIRwsn+CPY4v7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791301221; c=relaxed/simple;
	bh=REHjVogXIa6GL1Vv2G0GiJeIjII4qa/ZkiuDbr4SalE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D8p0owb4SCYPL2fCZSGrdElDuFGFuWK78rFQ2DtL3UZ5yrhX9RXeZnIIosgiLNCbBew0iLLvT8ClIidveBm1Z88cga2oOogoa6TDYRfx4fvdduFktJHDGU+qMtOxrUom3DARLbkjNkdr7zatIRjDzwn5ikUbX+pq4pOCjogeWQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sIpgrC6N; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sIpgrC6N"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48b03f23305so2687308f8f.1
        for <linux-xfs@vger.kernel.org>; Tue, 06 Oct 2026 08:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791301214; x=1791906014; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=m1zrwm7WEKGaGG+VaSydSHUeojXXWf2d+Tt9lDJlBnw=;
        b=sIpgrC6N/AHXodolYCeuBOSaYuVjg7/lsNrbiLq1K58Lu0cpcJNgDs6xdOLdJLrNiO
         IDNE6OI5M3aZ5EZQf788GYDWH7ixuRbaGtTwaapXdXHfQQaNpFGsWxiJMZfqv2edOx4s
         OUNvROQyN40Dj4k8brWPIQztbho6tUrG3GvXkmtQb+UHXevKPV10q1/GRUyVY8enfW+S
         785o6xRUFpMJ2sTRiN79uXKwcSQ707tBhwhPcYT/gVr7Z3pbClXTYTBzbgoG4ctSRYZU
         8ZvVGs5xuGrEVc8mRh4JhTQjZO9l+E4VxGCqbqL3o2zyzdXRRgKFzdUZTrO0/tDAPpWi
         MGPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791301214; x=1791906014;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=m1zrwm7WEKGaGG+VaSydSHUeojXXWf2d+Tt9lDJlBnw=;
        b=satwT/yMv93jkEAowDEzN39LofTQzNcPnuq6fb+6Ez27KU9smK7oDV9d39BMcCpFrg
         o+X5IJlAQYN5cUvHUCRQ5ARi/P0Ccs2ooOd9KM9mcV+RzAAGtSnljiiOT5g73EZRoVT0
         BsqRPrN9a6BKaBHPUG3qeDtyV8lZQuyszq/o6KTr3zs92m355Wc879ZAS+RjIEPJlN4b
         91bFAUPty/lZhpSC9GjM0k4nKnUVrN82y4bNzScXrerVpdrkreQWxB25RlM5drwaF5Kw
         kTta3zSMt2agsPX6x0hmpU5Ti+XqwAhQNXGgU54rL9NIqCqv4jF1aWtGo4NQAQj8zyea
         yPqQ==
X-Forwarded-Encrypted: i=1; AKwUvBwHTxWu5wCMVqK07hkIhLkzdUnb5yWHlAO2RMeOyGpJCu04riwxkiUbGqjKEkRfW/HdPMzxaNvSfz4=@vger.kernel.org
X-Gm-Message-State: AFq9FYJObrCvfj0Ckp3Fnf/uKlZshTxrQnrB9pPtlvTC13MrPcwv1xBm
	8hlN/ZUznsTJzJeHU3KkyKBwJJK9/e3ZTR1ebvobdIV3t5jF3dAY3gFG
X-Gm-Gg: AYBFou0Ho+0jtEDPWeOlDo5j6pud3TujHjegYjP4YDPQrzAKGo5qET3/yqYJBgMyv5v
	8EBVFxu3hlC5iJJ/fjn/IqC2CwHylZ35EdYQg6ey8xgldiC52hV7u7x27cCEjFC06L52yBQX12a
	ZRXpGkTBWaaAZG27Avttk4MjRAMyE+x2xEkKOg3jYQh6l2x92XGZI9l4t/+W/kGXgEccP0dAIkX
	RaN4DuMBW+YHX2qVzmIEOPhZD05VcbFraC5CzV6hmy+E7WsgSTH9Y2RPFNeDMBhVa/5oyC3AL4M
	A1A8eF+zyeUmBugRox7wL+uBogWFvAhcmPmd4JhZ0fi85JMY2RYUfXBRs/vkE0RO0Wz5nqr1SYD
	0KpMozON919327T8/qGmtCamByYtO66qZKoxAUk7V3p99QX4S7PUsdVAU+47+0nEvLnnYxqAMwN
	9TzV5Lobl3wJ341IfnVXcyDgJB80pFrbwFmCgnl/idEZyLeyNCk+vz4m65XWcNKFVE9F60DtqlD
	qBdOgiRY1l1D0E2iN0=
X-Received: by 2002:a05:6000:4b1b:b0:488:8ab9:f73e with SMTP id ffacd0b85a97d-48c47ff6561mr18053798f8f.24.1791301214146;
        Tue, 06 Oct 2026 08:40:14 -0700 (PDT)
Received: from fedora.domain.name ([217.218.153.210])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c71d1fec3sm293660f8f.37.2026.10.06.08.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 08:40:13 -0700 (PDT)
From: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
Subject: [PATCH] fs/iomap: document ret parameter of iomap_iter_continue
Date: Tue,  6 Oct 2026 19:10:05 +0330
Message-ID: <20261006154005.232338-1-ampr.mhd@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Document the ret parameter of iomap_iter_continue to avoid a
kernel-doc warning.

Signed-off-by: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
---
 fs/iomap/iter.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index c445a38b6..fd8791c49 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -51,6 +51,7 @@ static inline void iomap_iter_done(struct iomap_iter *iter)
  * @iter: iteration structure
  * @iomap: the mapping that was just processed
  * @srcmap: the source mapping that was just processed
+ * @ret: return value from the previous mapping's ->end() callback
  *
  * Helper normally called via iomap_iter_next(). Called after the previous
  * mapping has been finished to determine whether there is more of the file
-- 
2.55.0

