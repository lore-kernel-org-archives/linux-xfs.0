Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2C916415;
	Fri,  9 Aug 2024 01:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723168617; cv=none; b=cJOP6IAPPkkvIdfjmHkE/tAZRLvV2vY+6TIF3NehaIYYm1V6dZxEH61cbWon5qh6xKwCrwLpptKooXJbBbppowkU/jRitjp9Ca6G9tlgS0zUDBl57QXnyckgP334I7eZMjxfguws4bX0DWgTIm1dQcAhJarsEP7pDiwRihFGqvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723168617; c=relaxed/simple;
	bh=TebCwsEmwQL1p99BM8D5cTpfKlFlt8VHI6zszwVMMJo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DKw9MK+Ty8DtQ+T+FequgPcoU4d6NFsHfEndYiIy36pqkX9teA0IC+5hT9AX9K2RBKJBnq3K4zV43Ysd0mHmFVv+EdVFbtkqKnmy5qDnVwQi93mMhARRirKc5mYcaViMTYxxQ22TH/98M+Lc8u6LJNFZbQxnsKqncW5X+Q0Ylfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PfjYH6Fv; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PfjYH6Fv"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-70d2b921c48so1322228b3a.1;
        Thu, 08 Aug 2024 18:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723168615; x=1723773415; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QCn/gnfgkZMk6A/NO2nWqcFusTaL8xKL4P11sOGYUgM=;
        b=PfjYH6FvCUtSAuwj1JngDLBbIgRP5MsuqzbKvbQdIqiFhAFXMVnPfYOqpHhmeQ+gWm
         78GeCszSKpfKB7aFM4wG6VrXNsjQc1wYNBBwcGYIKJT3XfMGP0EXw5LsJNfNE5vCg4Vu
         B/M0Dt2NG1a0xHwGHWPp0wWjmXozLKGxlLgTAfz3533/dSh+U1I5wetpkouW36HsVuK1
         XkAmfoqGcYVlFFt+ketl4nddzZ+bikHvcIal2lKkhJutQnAovzkg7Cluxt8acnvZRWnr
         EGErt8pTNMDrh/M9aYyCQfoMT1kjMl0rjX2a1EqdAB3h1rX1sW9/PjLEO9c6fmr8/jol
         pdQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723168615; x=1723773415;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QCn/gnfgkZMk6A/NO2nWqcFusTaL8xKL4P11sOGYUgM=;
        b=u5FYEbiSpIepA90jgAqSGnCspafOHxf6SU+fYwCDXpGWydMEFf+L6PexYElsDc7Ins
         oy4gNaULgkKn6+uknJxXXInfWXW80FGy1NNGo8eyUaDvpIiR8UoapD4uWVeRKKCtk0zD
         jEKbGlkqRyG6udzUP6GlXzq0fogGGnfVTHzt5xK7WeHa0HeVXjUdGRCB9YhqkDORN7Og
         J5X/Ar4wJulHIoLuviyH3DBOYzbidNZykPr+aiIgz23PDYgo9k1Hti1V7+Ghn4lUCDS4
         7FBqrwJ545ruKAn0AhpImBZQawC+dwC16+xa0544qu9L6wuPa3csY1AtBFC2wCIWQn1y
         peAA==
X-Forwarded-Encrypted: i=1; AJvYcCU4k01YsTER4h09wBJqNt8P3FnSAogZ7lIunSZCdbZ5FTWZ3uJ0LYZhKPWf1t/PfqeGHLfI1TxwZjuq4AI=@vger.kernel.org, AJvYcCW57L0xXuCVw6uYKLv7bSvvRXMUJmpMLUxJj4Qki6LEH7cPYwe/vOt9Usoh4+fEgVWUXph0wwbj@vger.kernel.org, AJvYcCWwSS0qPrflzpE+pRrR9S4ZKrsKTOf+OQ/wv4/Y3sELyAyYHI8kneCV5jPY4cdbHi5Pg7pX7MbnHHUH@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0W3UHaXb8/jN4ruS9pqfDX9SLtNAHrzSAn+KAYmpdRgVsmCdg
	VMxyWsR5AhGBdZcOWz+JoLlXaTYNPm41cJe/uoi3qlz51kRuDf9b
X-Google-Smtp-Source: AGHT+IF/A7AlUoj6kX9bpqiQs5BeePEY9YlHB3NCcDXxN0EpOORvs1fuJO8BFV2NtB6w6RgAUPHYbg==
X-Received: by 2002:a05:6a00:1151:b0:706:2bd4:a68a with SMTP id d2e1a72fcca58-710dc70726fmr18689b3a.10.1723168615127;
        Thu, 08 Aug 2024 18:56:55 -0700 (PDT)
Received: from dev0.. ([2405:201:6803:30b3:a44c:f30f:9f0c:e535])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-710cb209f78sm1727976b3a.1.2024.08.08.18.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 18:56:54 -0700 (PDT)
From: Abhinav Jain <jain.abhinav177@gmail.com>
To: leah.rumancik@gmail.com,
	djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Abhinav Jain <jain.abhinav177@gmail.com>,
	syzbot+55fb1b7d909494fd520d@syzkaller.appspotmail.com
Subject: [PATCH 6.1.y] xfs: remove WARN when dquot cache insertion fails
Date: Fri,  9 Aug 2024 07:26:40 +0530
Message-Id: <20240809015640.590433-1-jain.abhinav177@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 4b827b3f305d ("xfs: remove WARN when dquot cache insertion fails")

Disk quota cache insertion failure doesn't require this warning as
the system can still manage and track disk quotas without caching the
dquot object into memory. The failure doesn't imply any data loss or
corruption.

Therefore, the WARN_ON in xfs_qm_dqget_cache_insert function is aggressive
and causes bot noise. I have confirmed there are no conflicts and also
tested the using the C repro from syzkaller:
https://syzkaller.appspot.com/text?tag=ReproC&x=15406772280000

Please do let me know if I missed out on anything as it's my first
backport patch.

Reported-by: syzbot+55fb1b7d909494fd520d@syzkaller.appspotmail.com
Signed-off-by: Abhinav Jain <jain.abhinav177@gmail.com>
---
 fs/xfs/xfs_dquot.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 8fb90da89787..7f071757f278 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -798,7 +798,6 @@ xfs_qm_dqget_cache_insert(
 	error = radix_tree_insert(tree, id, dqp);
 	if (unlikely(error)) {
 		/* Duplicate found!  Caller must try again. */
-		WARN_ON(error != -EEXIST);
 		mutex_unlock(&qi->qi_tree_lock);
 		trace_xfs_dqget_dup(dqp);
 		return error;
-- 
2.34.1

