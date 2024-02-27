Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897A036D
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 00:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708992703; cv=none; b=I1PizGNl8zqCd8lmM2sxFjNxzWoVB4wBLQLV10Q7W09hymAg5RdZ0pN1szcSeqT2NF2YQoI/yKqefb2K8stWzOsPWGD3WzmadJHw41y8UYrwuCAio8QGQ1srFP9Rg2/Czu76Wprnb5A57G/CjwCDo875B6TWcDbw0e1d00K2olE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708992703; c=relaxed/simple;
	bh=64crXQSZ/5UBysia/CDsJkZHR+M7s0Dc783qcDeD8xI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XcgMaSsLaS90pCkAi9JbPzvO8CBBQp9PuveS7fgWSxpUjNSCMovtEqlQAT4tBj74q3XlaYLRu7RUW4WVEOy1cEG+es1ju8u5wx+nelrjd6zAeHfd5ThwKLmJXXwaeqfjYlTn27LYlQ6s4Rp5KNz+ABufOHKJs7PuufxuBFmTDcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=HLHBt1jw; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="HLHBt1jw"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-5d8ddbac4fbso3098173a12.0
        for <linux-xfs@vger.kernel.org>; Mon, 26 Feb 2024 16:11:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1708992701; x=1709597501; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9yQMzRR1nzPIzGwngfqpzOYB9IFBnYUZBhmD1GILZnY=;
        b=HLHBt1jwjgJ06KdPW2qfV00VegQyBj0jUen0xLpeys/g/Pc9O3xJUZiac25pVLX/H1
         7XSV9Yh/XwtA+UOscnLoDS4C79cG+T7GCy31olL2kfBCGQ5KXpTxxEgU+LpPlK3c6+0o
         vrh9n+jithbpob+PE8r4WuEPe/YtK00sqKli/SbYZdNC5ky8UShMdSNMPMwoBASoCF8S
         JGqE5QoCghkBscsI+jYG3BpMvLcFSZi3vEhRI+frvOjTAdfcPNZhm8HybL5hxM4Bl+ZT
         T9A2ylwURPU1PxOqc1DDQjE6JVTMhaT77XNqGJO5VI1LCYefE4p5gX/BAyh7aDzi8rS/
         z1oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708992701; x=1709597501;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9yQMzRR1nzPIzGwngfqpzOYB9IFBnYUZBhmD1GILZnY=;
        b=CMistMKDEz7+xoUF85HSs5z9Pr1+etpHQ8ER9PPK/mhkWHgAS7K/PCt2zMmL0j/tEw
         irX+s9ZnnMl0qrotpe04gmn4wpdxcSrGjdyySby+Xs8lVR7ywLQ9S/IWD39TeGeX00Nd
         2RpDGPQkLy4xX7nhSx90BRguFwv1RAGYNij6ybnnKXaH/rl9R4JNts4RxCP08a/otANw
         zY/tCHbCHOyeJhnOo+wL0Orig5N1kfX9/dk3h3DbF2O6497yP1T+iDMgCJ9Zj4rrmbmS
         DbyJlrqHt8O0VjHkxZ/BGfGlAG53dDeqxEVLwNHyl3S8xATCIEEW9j/v7a9a4jnnFQig
         VpPg==
X-Gm-Message-State: AOJu0YzSXYbTUssYQxvOzz+QYKxzbEYwS3+dRetPMM3yGQmdJckn1lxz
	QooAYMlUXSj5eFAzQf9md3Up2wS7wi+wvpioMN0IC8SubwABawBZDN6AWpriY30YRNYzengx7Qo
	K
X-Google-Smtp-Source: AGHT+IHabkE4OWnEWZcOWgki1mQRp9V5Vc5xz+aCbgUkRcSRAX0AQCb3XJkXf2silkf1lmr6+9bIcQ==
X-Received: by 2002:a05:6a21:398b:b0:1a0:60b2:451 with SMTP id ad11-20020a056a21398b00b001a060b20451mr1063069pzc.7.1708992700830;
        Mon, 26 Feb 2024 16:11:40 -0800 (PST)
Received: from dread.disaster.area (pa49-181-247-196.pa.nsw.optusnet.com.au. [49.181.247.196])
        by smtp.gmail.com with ESMTPSA id k9-20020aa79d09000000b006e4e66d6837sm4618916pfp.216.2024.02.26.16.11.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 16:11:40 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rel4L-00ByRR-1p;
	Tue, 27 Feb 2024 11:11:37 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rel4L-000000030ur-0IOc;
	Tue, 27 Feb 2024 11:11:37 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: chandanbabu@kernel.org
Subject: [PATCH 2/2] xfs: use kvfree() in xlog_cil_free_logvec()
Date: Tue, 27 Feb 2024 11:05:32 +1100
Message-ID: <20240227001135.718165-3-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240227001135.718165-1-david@fromorbit.com>
References: <20240227001135.718165-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

The xfs_log_vec items are allocated by xlog_kvmalloc(), and so need
to be freed with kvfree. This was missed when coverting from the
kmem_free() API.

Reported-by: Chandan Babu R <chandanbabu@kernel.org>
Fixes: 49292576136f ("xfs: convert kmem_free() for kvmalloc users to kvfree()")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index f15735d0296a..9544ddaef066 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -877,7 +877,7 @@ xlog_cil_free_logvec(
 	while (!list_empty(lv_chain)) {
 		lv = list_first_entry(lv_chain, struct xfs_log_vec, lv_list);
 		list_del_init(&lv->lv_list);
-		kfree(lv);
+		kvfree(lv);
 	}
 }
 
-- 
2.43.0

