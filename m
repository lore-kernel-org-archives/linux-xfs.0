Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3547F1D7E41
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 00:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782864700; cv=none; b=ahLp43I+D5MH9eyiA8hmdMksf4l2E7XoOXN4fnz22EK78M8PGR/rPUF7+yLHB1N7cv/vGuF9EvSeSmte+r+ajrFLaarvXB7xurK2bDMGvndnt+NaUGEaa9wb0tl9d7DdclEC/aZQvyMBjlWB3eKBDIhVGUXRRvt/iWk6G2YDa04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782864700; c=relaxed/simple;
	bh=UAK5oUiWMIcbyMwKSX2yaW8g3zJEjKE8bwxijrAtnjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hCNPV32l/QcC7HJ4rci9cQ2jgugVx3QuA1lrOJJdzPsFGAxnn2hc2kXyklNdW0twFkzdHeXgIUSe0HPwKz2fuN0E8+e+lyV7xGUX86Nqn4woG62Sd9C3T3y8hZG0AlrNYjQmQj2gvzYluiebIMf6UbrGjxRd6X3PY1VpmwzZSIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SgtrOeVB; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SgtrOeVB"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7e9fc3de7ceso47277a34.1
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 17:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782864698; x=1783469498; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N7+CcIiDetDTiagtbVpMn37s8DwFl6V2j0Jf9vPEZaw=;
        b=SgtrOeVBMyf8aTBkOw+Yu0WBLRlfFqsf+8Niaoab/o6tzS59mJ/XK1imUjCuethZGN
         fQVpqpo+K0M+WRfC6hMRjcO7Ii4hAPAMpMSAWlcz7yzxXOeq3j/0TWh0YvtulVuc/kVU
         sLupNzQ+wnCYejMH23zsmihA8bzmQTYA50BA5fDS8QCLt+74Ngrci3zsSAGJmjKbxntA
         enRXaDLwKDwn4HMz3kQSq08qcyunZHoUOdFRlxWe+r1QSHidSzMPL9/uQdG9QwDY2ruE
         XuiW2+nZL3gOQ9CVZGS3l7oi55Fqf6ndE9uBizP0vvMr7Hd3DH4eE8emTchIA8lw0WIj
         5bng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782864698; x=1783469498;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=N7+CcIiDetDTiagtbVpMn37s8DwFl6V2j0Jf9vPEZaw=;
        b=jV6nWeu6ANaBt39MD9s5/F2/deb9s1pcGe9eiGsfadTu5FdQgGw7zxmrVJJxkhxH05
         KzU/TNpbciT5Q9kb6j43sv/850LU8oYTQJpstHa/5vMmHQZHQ7I9ZsuR8zfguWPs34pi
         mDW+coUafa0007pTRaFsp7sw1JpZW+Zu528NyJnVv5MoJusefEJAQqN0GSze1ZJybbEa
         uE9C31pTc6hzFnTLDO0PDKfqqk5rrOKo0f2gb+0TvWNW2rX7eHxDdEt2oGRb14xp+pbn
         wTnvc26RbVBfXY4p+tO6P+H6zLoscYxv4a63FygIeswPI74gmLj7YLhVdIMc7mM2j2SH
         ujbg==
X-Forwarded-Encrypted: i=1; AFNElJ/RFeB/Seq+x6EE8p18h+7EnoiQaECm2Gz81XWf4Ct3GkrYwbrCMqA5wTat4DmRuGQsvwqA9t8qLa4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYC7McFgl+BY5gEIqrVHxORTNDvb672YUH/aSVRiaV+V7A73rH
	NOMB8wRRhzOmMylNyZH3zf9XJfBU9JYuiuTcIQVZi1zlBPnTzLnTPTi6b7FUFQ==
X-Gm-Gg: AfdE7clxXGfVx/OxeriqsATRWrJwKqckWB4mHd8F7rOr8AMcvNQuNAYBwDcY/rQdnZD
	GTv/h75xWP3oca/wK7YobWgNGdTGhIOEc2CxNZrAdX4C894Sf6ONIQYoXqMfvITDYqnUsjmhXpy
	U6wtfBH1BIfprieUCY5b86BCpOnyUkyju6GAPCNPvGXlGbnWD3Xqq02s6R7Mx4KpTV/JgyuxKc3
	C4NadGoms7x2d0DZFbUE3cnYogKdDD1Qrmd9CZH4CbiSuAz5Z7pb7DxeKAX3erIaGfW3CDntJdO
	KAt+qiOcDyOo94qtiSJeHdj1gFHfApe6h0rDeS+TURK96Wj6dBA/2QFJjsExHWVxtozUoQ66Udl
	czENnVvxLAA0ZcZ4TcrnQ5BGf6OpPXzFkjcnMxA8sols5QYF5MfwBgwqzY9L/IRwQalrFY0hW0m
	ZB1CPM394Hw4F+rupAkC2rTv3SrIesJ6oeWkyZTmpDEwDMLN7PPKkgllVvwn8tZblX
X-Received: by 2002:a05:6830:3808:b0:7dc:cdea:7d9 with SMTP id 46e09a7af769-7e9fc15ad0cmr1772936a34.22.1782864698251;
        Tue, 30 Jun 2026 17:11:38 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:4e::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e9ec2b96c0sm3558136a34.14.2026.06.30.17.11.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 17:11:37 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: brauner@kernel.org,
	hch@lst.de
Cc: djwong@kernel.org,
	willy@infradead.org,
	hsiangkao@linux.alibaba.com,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	linux-erofs@lists.ozlabs.org (open list:EROFS FILE SYSTEM),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 07/18] erofs: convert iomap ops to ->iomap_next()
Date: Tue, 30 Jun 2026 17:09:22 -0700
Message-ID: <20260701000949.1666714-8-joannelkoong@gmail.com>
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

Convert erofs iomap_ops to the new ->iomap_next() callback. This uses the
iomap_process() helper, which finishes the previous mapping if needed
and produces the next one. No functional changes are intended.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/erofs/data.c | 10 ++++++++--
 fs/erofs/zmap.c |  9 ++++++++-
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index 9aa48c8d67d1..47dba61ec576 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -380,9 +380,15 @@ static int erofs_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 	return written;
 }
 
+static int erofs_iomap_next(const struct iomap_iter *iter, struct iomap *iomap,
+			    struct iomap *srcmap)
+{
+	return iomap_process(iter, iomap, srcmap, erofs_iomap_begin,
+			     erofs_iomap_end);
+}
+
 static const struct iomap_ops erofs_iomap_ops = {
-	.iomap_begin = erofs_iomap_begin,
-	.iomap_end = erofs_iomap_end,
+	.iomap_next = erofs_iomap_next,
 };
 
 int erofs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index bab521613552..dd058413a0b6 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -821,6 +821,13 @@ static int z_erofs_iomap_begin_report(struct inode *inode, loff_t offset,
 	return 0;
 }
 
+static int z_erofs_iomap_next_report(const struct iomap_iter *iter,
+				     struct iomap *iomap, struct iomap *srcmap)
+{
+	return iomap_process(iter, iomap, srcmap, z_erofs_iomap_begin_report,
+			     NULL);
+}
+
 const struct iomap_ops z_erofs_iomap_report_ops = {
-	.iomap_begin = z_erofs_iomap_begin_report,
+	.iomap_next = z_erofs_iomap_next_report,
 };
-- 
2.52.0

