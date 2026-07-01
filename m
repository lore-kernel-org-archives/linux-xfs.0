Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27AD1B3B19
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 00:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782864720; cv=none; b=CTTN1xsc2sFcb/ZdBw1mOkqWDGy/KO/DchQaz6l3FAML6hVeXZRB8GnUJpHu5tJ5sh9RicbJcxVxYm8esaczNgfa2H0ylZ2oFVoWJQjmPopzQp8PDtP5v1PJvQVDIOhmAWQqB9dDpZWmSdO4bqcM7RqiZdB3+Rr+GBvWMpQYTe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782864720; c=relaxed/simple;
	bh=Bk0gnb8s+4fNHaZSMh2bvI7dTDe+1MXnsRAggVU7Xjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CyvDu0oouFSGpImxU5M6mOKs5mNkEb5iqoHXqwssu5LWeIt/KckLhHMYc3HkPIHdsnGTOXFPcOaM+hV8Rlry38kX3JZclaKqREhUS9kUcpmhBHehEu6vkpZydRSS7dzyAZAuImCc5UOCKaRAPUb6d44I8Qwk0nqw4zGv0L757cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LhXiwBZP; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LhXiwBZP"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7e9f6e7846bso70612a34.2
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 17:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782864718; x=1783469518; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EpaEcwn47Z6dq29I8xpdWLntonO2yCBkGdkKIRYVLBU=;
        b=LhXiwBZPE676n7q+K2xuQGq6jzUyNdkfylq2UqOKEhJouTfo4NppqPkkCFRjs0uIG2
         igIZSMU3H6D/wwyTlVFfCwEYXHyWa/MX3So749cA6fvzbisGDlyXguvQmOqVptHA8geF
         rDK9AFXKDkj+cXyV7LuEh+qmBbTN4L5obSV7YMT93RIqjOJ7NV5ROZHqK7mYGrpa5rLD
         Eo6XJKUTVfkf1gw7cHEVXQKVBB05WWkXWs2BVBqVZYMkchabbm/tuWxIDFfV2miX55wL
         uKoPXzUzAImwfChLegnIjSpNv9eH2NrDlUCYCvVJZQqjoO0kUVfPTkYq0nRngLJXQ7YE
         oorg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782864718; x=1783469518;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EpaEcwn47Z6dq29I8xpdWLntonO2yCBkGdkKIRYVLBU=;
        b=MWY3vXlXIQkoReJiU+Pll/JtXStW+g3tC1lYSI1lOyDfXDG7lLBWVpBpZnj5imwD9m
         25KZYGcv80YZfoCP1b0GaaTCL/PfXJZIjCRGdh8Egcznvot4omrqn0NOxu/2oFCWOtA6
         2D44cuf1aEo4pGZNu7hroG0rzOVca4NxxOnJsyhNLitc3Z98OfGQqHcCwQqJojKci5Dz
         F+5GfhKJoaZKUgtDFgGxS3YR7W+bMabFWzjaYQbzNwyYItesnB15cbHE8sa33l8ODYj1
         YczDirl+OhjvvGvsRgbYpwrBokQ2ASSDztW1ehRy160MT3uRkuVWrWer4qlLiPAWFFOK
         omYg==
X-Forwarded-Encrypted: i=1; AFNElJ+HmUhF8CsubJ0leG5IOqtx5NWFfW/U9MwPRr80Fr7462u75gyG0mj+XiVDyjl5LC93LDa/tAUjr30=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3BZucbqCwxK0eJszjq5kupiEZaqFfE43k4bsMiY0+ocKsqeBZ
	4LKfMInWWGutep1tO87XqKmXri65SgoB8lidg3ZB6oMkUIL6DN/+Jven
X-Gm-Gg: AfdE7cnlkd+8/8DtkSjbvjVEHD7quO/tnRZZVMYW7gF7cHck9RkOghycS0ETpN555PZ
	lJmNPD/uShKYKZrGrXVQZFq1RKURPap6XiIvzWpwTr/ruJ2IjXEeemJtcc0HuDhN93vX1VYq+q3
	L1NWe+ETaPQ34jqEGw66U5v4X2HJrk6U6kxziweYEljQVEuM9wzu4+tybDilxTn5S05UEkYHIyd
	RKZqY1vE3C8wFVl+V8JNkgVdI6bXeYA7AZPQQ98aJJTM6IWLVViTQnICZmneJocWFJU2pl0m2rj
	0HxlJE5rQcBv3X6c882pxvq6aQtGNMESjSYM9vOPgqymLrYqqfSdROAGsh8GtJQqFv6rzuwdHV4
	mt9kPPRIKYpNhnkRpjTYvuCAg926tS2qd1/tS3KW0OyODVvezllsq0Q5NtBg/CEW/w6p+RlPcn/
	bFKuEe4/Hb/DhCqyZd/3L0Hq8XLWiKFVMILMuQphf6ia3D6H4+wwrgNzSwRPW2EkU=
X-Received: by 2002:a05:6830:6814:b0:7e6:e022:4b44 with SMTP id 46e09a7af769-7e9ec6e04c8mr4644649a34.15.1782864717979;
        Tue, 30 Jun 2026 17:11:57 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:7::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7eaf495e0c7sm145938a34.13.2026.06.30.17.11.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 17:11:57 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: brauner@kernel.org,
	hch@lst.de
Cc: djwong@kernel.org,
	willy@infradead.org,
	hsiangkao@linux.alibaba.com,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>,
	linux-f2fs-devel@lists.sourceforge.net (open list:F2FS FILE SYSTEM),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 11/18] f2fs: convert iomap ops to ->iomap_next()
Date: Tue, 30 Jun 2026 17:09:26 -0700
Message-ID: <20260701000949.1666714-12-joannelkoong@gmail.com>
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

Convert f2fs iomap_ops to the new ->iomap_next() callback. This uses the
iomap_process() helper, which finishes the previous mapping if needed
and produces the next one. No functional changes are intended.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/f2fs/data.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index a765fda71536..afc9b2adaa98 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -4653,6 +4653,12 @@ static int f2fs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	return 0;
 }
 
+static int f2fs_iomap_next(const struct iomap_iter *iter, struct iomap *iomap,
+			   struct iomap *srcmap)
+{
+	return iomap_process(iter, iomap, srcmap, f2fs_iomap_begin, NULL);
+}
+
 const struct iomap_ops f2fs_iomap_ops = {
-	.iomap_begin	= f2fs_iomap_begin,
+	.iomap_next	= f2fs_iomap_next,
 };
-- 
2.52.0

