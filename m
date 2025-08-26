Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70862C3756
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 15:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756222858; cv=none; b=oc33+5iRm2bI6tfkNKEwdS8GoRADDZuqSI7AwNDwAVveE5D7KgzVwyJwL8mKZA/fAww5qHHdC9S38RLXqEak6YZ0CZsXtGfPArQTW1MbTwfDCZCb7GDHrGWEaRhmNhxpXl1s7QwZDTmIAGs3wYtx/AK4q8VBLhnf/05RieU1qYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756222858; c=relaxed/simple;
	bh=v4+k47Nq015FWctgvCs9vsg/V/TA5kz2ykNqZmvSZkA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PUXMTH5EBzggu7Bem6s9uFG+oeBNb5XsGYSjaU1wagVrREGXVWMolygn2h+MPvupfVmlJFxx+Js0AJAtehavfA3nyRb1frLF+6d+oi1DYIWjqm2luBgpYcFtnzDaCdR0b+obnzHFYZKiOj/gAjbnSOHtQpC7byV1Wzion0nzAVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=J1abHhTc; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="J1abHhTc"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-71d603a269cso43792407b3.1
        for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 08:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1756222856; x=1756827656; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6DuEK+Kk5sFprszwTHehPZviexNLAjFi3s4jagEjiXI=;
        b=J1abHhTclwAwQu8lYot9DKOf/qKsH15+PFnfdRNUhoNOoj18/RMTkG4rzHRkO3TRgc
         pkPVxOXYql/DSGoIRaOyuI8SHTwF2kajtLGOP7VZHhA3nFFCMo80UcAJrhBtQzMY/mX7
         yXHoK/Kmp1vO0OyCYu3VvZBlSIEmhq6s6yGEIaMAX98eacvCjLc9j+mpWmIjKarcaDPz
         pzS4T0EYzm6SD0WVHSAIp6pxtcrPDL2AHacYY7WEn1Bc67OCZbiOxR110BRAYuuh2mqc
         9JoBiYeKIoLq7/lz8lCNUu2YXmt+uI8qPrTW5qbREQLWLccvYibIFImUV/Twco6fU/bV
         Sv5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756222856; x=1756827656;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6DuEK+Kk5sFprszwTHehPZviexNLAjFi3s4jagEjiXI=;
        b=YKvW+GctJ9FAaIuclxKaUAUFwxsMzjCumNHLQDebgYDGcf+jqXUu9OBEGifMROplx3
         uDLCMJ2vpAAu1Hg5jXVSTgtesakbEp9CFsqhsnYb9QDUr39rh32qVTzXaf1trQjOCIMh
         cClKbIus0ZW0HGr6K7JSPanukkQ+9V03Zw0bAcX/20qWPs7IDVIBmBbQMB/6dmA1UtFz
         LbvM8Hz1yVweB14ZzaHK4ydg1lMkdpJGnkHBvL2aQwtHp1jIXu0RI/xD1/diVR9Hxjiq
         9cA2HGTC/HlIL9f9VuWmqu0+4FLZ7nYYNNxkkpyWi/lOW8YoARsWR1F0FS2ReCNKjDs7
         P2SA==
X-Forwarded-Encrypted: i=1; AJvYcCVoSybIwpiiEkoA05TxUzmk/xcaSpOQh7Uyk+1jADypUYIgpMBMUpN/Qos9Y3FQ0ZIasYJhHlZ24QQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxb09CO3G34jVHsLrpzyvH75NV+Zx5O3FhoNTDsUiJwJpmuvdZ/
	5RIzPrFmGY9+WEThZWCoMao4t9YCY7jRSWp09/vPLCqawlidlPhWoV2Xb/s/1m9W7sQ=
X-Gm-Gg: ASbGncuArf43FvfTSUMRhaXAoC59CBx3XNrpscwLXKAvV1TmEk6k4mxJjJV85OEJOHI
	YtB1Uw7pDvCPmXFwniyOn9Llxz43niLReTdLBNLV1oJNvAMmXjOOE0fE3NP/8QTV1g9zU0XF9UX
	CAcFqwYA6obdIUqaAiw3Ssx31DRjJf2OrNpQgUSU0qwYTCjy6CxwjGJB4xH9Ly2g9TH+lUUpt2v
	7g6Epau8yfQVgJ4Zi6okkAIbMfHTMmU+Kt0OG+0nByaiQ9ErqgRr19AMzK/xlQg8ExBBtwSHVUs
	fDo00dnsrBlxg7WkLG/RSBUswiwjpLgi8CujBLdych4EoEV1eGbk0fnH4uNWTlTzwnHsKkkMyDc
	SMITx1oRWdKzGMetjvplkON4wtvXIoLi0kxfaFtL0+QpNhISSPJhvxIxVDA6dphY41cpRVg==
X-Google-Smtp-Source: AGHT+IF1MI08diNCyXnNMWWu/+8R5wdOAhVg7UNfF70XcvUlTFYcLCsm4IxLYoWA+0GC1XqTbbEzGA==
X-Received: by 2002:a05:690c:c0b:b0:720:631:e778 with SMTP id 00721157ae682-7200631f13bmr110723557b3.30.1756222855550;
        Tue, 26 Aug 2025 08:40:55 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71ff18821e5sm25322837b3.44.2025.08.26.08.40.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 08:40:54 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk,
	amir73il@gmail.com
Subject: [PATCH v2 05/54] fs: hold an i_obj_count reference in wait_sb_inodes
Date: Tue, 26 Aug 2025 11:39:05 -0400
Message-ID: <94e7ea33eef40e407b2bef6a200c9474472bc778.1756222465.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1756222464.git.josef@toxicpanda.com>
References: <cover.1756222464.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In wait_sb_inodes we need to hold a reference for the inode while we're
waiting on writeback to complete, hold a reference on the inode object
during this operation.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/fs-writeback.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index b6768ef3daa6..acb229c194ac 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -2704,6 +2704,7 @@ static void wait_sb_inodes(struct super_block *sb)
 			continue;
 		}
 		__iget(inode);
+		iobj_get(inode);
 		spin_unlock(&inode->i_lock);
 		rcu_read_unlock();
 
@@ -2717,6 +2718,7 @@ static void wait_sb_inodes(struct super_block *sb)
 		cond_resched();
 
 		iput(inode);
+		iobj_put(inode);
 
 		rcu_read_lock();
 		spin_lock_irq(&sb->s_inode_wblist_lock);
-- 
2.49.0

