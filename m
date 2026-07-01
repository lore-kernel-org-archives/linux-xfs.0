Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E63233943
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 00:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782864723; cv=none; b=CVn6u6hmt0Z9okz0GKAvenkq0qpYhrkHyrHJpKH6dkIWY2pl/zRsSRnqKVHKVyLG0uWEc/MI6B3qIGKU4D/qGU21KVJu4h3zDrat5vr/fKPUrcLUl8VMPXD2es6VI9gxPWwFJzJfpyaame+0rYfST1AjJEzVb3scOWVEJR/2gqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782864723; c=relaxed/simple;
	bh=YSSocn/9Lzgta+zrc1Y3ogzo5RcF7lik+7d4HrX9T98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LscmspGm0hTdTP6u3RBNfv8ObhqmDeALimaf53CfU+lR/87G6obh66/noGfadxMbOXLVMPZTOxTWa7XP8VdZP7r9WOfgvEUf0jA7SU0nfDvbrpmlrWiu8+sda0mi1lMM1cxljN7BJKg/CndNppWUw/2F3IUGqqYNW/Eu5HDHOYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qntiyfn8; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qntiyfn8"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7e9483cd614so44769a34.1
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 17:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782864722; x=1783469522; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7zAJp8kY6IFFjt3pxCIPIq/VsrqKUfgyaUYuo526e7E=;
        b=Qntiyfn8IlLtRXapjn6bK46H9g08Hn4srIkUys0unppmQiOq2ANMa+39y5eWMTyhgH
         /rBfx0k79iLaPFD6DSRMpHGT63dO5RKcCKnECaZd2Oj+KMFeEMXSVGureJcA6kkpo6tC
         kzJ98huK/4du3DQfk87TFr9xhwOAaLYXGap7mzjT8ivFlsidVWAJJOgvQhVwePEdGDyv
         00AgJ6KTbce8fmZoXx0HtarJrAC29BUkTNa80B7rbklCY5ujksYOtu22a/TtFgyyg0tG
         p7aqmt8+YNFfrLYB2Sca8m4jMQCAh4uxfMv1ViC7jVsKpwDor5CBB8dJMzZgA6M0Kbnp
         /RRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782864722; x=1783469522;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7zAJp8kY6IFFjt3pxCIPIq/VsrqKUfgyaUYuo526e7E=;
        b=U5v39IP7KGvxRYm6fnjzdQb32sKuyGrEfbo+Q+wvdOpuOfkp4wSgXGCCAvyFsro4ya
         Y3IXNd67KfYcHKF4xdE1mlv2mi5oM0GMXibZcsjOOFUPXfzEVkWULeZKYxPVje80dbf1
         OEp10o954ikodecuC6foQs22jXXfW0WfzYNhIC6y9MgsfyzuraYy1N6YYX7q9vJ2o4/z
         9MHf0LEvRw8FLWx0mrgpL3S9/pBBqjRBAXSrAasviEwPaUOMhi9CamPkNC736867wjv7
         ZztiBs3PUiDwH6dIV5IAsG3flTHgmxI/j0mvxBmAenkiyvDtOpe8Lkaz2tvAXukznpKq
         MRSA==
X-Forwarded-Encrypted: i=1; AFNElJ8AJt1G3td9e92b/wgEpCC7z8+Ppdg0hacxufev0fUL4y+gSCtAAVweyrs6UNyfiYyOKJe0jGCfZeo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYNMdVUvBM32QfG81VvhqxN1l8MlMhAqtHoEAZ9syDIOXmMRTt
	ETL6T3AwkDFPRA7kytvoaRg8TrRXSTCxxSLniwZ9pPjU0KK+TRf5nth0
X-Gm-Gg: AfdE7ck4xhQS4LAFA2kkFiIR9qNHznS4tkALQEuGxxw9iayQ2MwPqtzUMgvAnzN0cf/
	LEqDczkVbI3viSQVRkKJPQpI8Nj37GV0WEyx6U9BUZu0Z9e+ak69Zrv2aTCwqbm7N4Ii1tjYCks
	HBYvbOMpfkauO1uyLunrl67me8fAw+8yey1LY5iTSgI6lTnOtZ9aAxM3udvu5qB1UBQUCHTSbUq
	4Ch4Nl9vr1JhpF1biLAjQ0Odazq56avWsyjCIAUKJvVDdmhe4bTtER4Qf3PaWWMPOco0BCdKcCD
	tkidFLs/2E6fBk8gtb+W+G/jgF3a+NunNZoXZMIclCiplMJJPa9m3x3koo1UUxXzES93i+tx3Ca
	XJGPJimoRtrp6ZNZJuKtFcxub8WMDNVBss/ICUcZNZjRE29QYqbfl85DSK5Qx0LWhm6BW8xzrKu
	tCz+A0B2m/U9j4PGg4I4Op90Se5bsQc3Q5vLd32p/ITp8kdcB8ABTs4Fj2Uh4SrwM=
X-Received: by 2002:a05:6820:1c88:b0:6a1:11fa:1b37 with SMTP id 006d021491bc7-6a1921d5a31mr1953624eaf.25.1782864721828;
        Tue, 30 Jun 2026 17:12:01 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:6::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a188f77891sm3095730eaf.0.2026.06.30.17.12.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 17:12:00 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: brauner@kernel.org,
	hch@lst.de
Cc: djwong@kernel.org,
	willy@infradead.org,
	hsiangkao@linux.alibaba.com,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Andreas Gruenbacher <agruenba@redhat.com>,
	gfs2@lists.linux.dev (open list:GFS2 FILE SYSTEM),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 12/18] gfs2: convert iomap ops to ->iomap_next()
Date: Tue, 30 Jun 2026 17:09:27 -0700
Message-ID: <20260701000949.1666714-13-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260701000949.1666714-1-joannelkoong@gmail.com>
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert gfs2 iomap_ops to the new ->iomap_next() callback. This uses the
iomap_process() helper, which finishes the previous mapping if needed
and produces the next one. No functional changes are intended.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/gfs2/bmap.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 51ac1fd44f78..6cb1d4513882 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1200,9 +1200,15 @@ static int gfs2_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 	return 0;
 }
 
+static int gfs2_iomap_next(const struct iomap_iter *iter, struct iomap *iomap,
+			   struct iomap *srcmap)
+{
+	return iomap_process(iter, iomap, srcmap, gfs2_iomap_begin,
+			     gfs2_iomap_end);
+}
+
 const struct iomap_ops gfs2_iomap_ops = {
-	.iomap_begin = gfs2_iomap_begin,
-	.iomap_end = gfs2_iomap_end,
+	.iomap_next = gfs2_iomap_next,
 };
 
 /**
-- 
2.52.0

