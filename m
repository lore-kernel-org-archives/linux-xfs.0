Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D58392A6B
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 20:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807690; cv=none; b=YoY/rX7G4bmxLv0Hy9FR26LyYTa2nAagjGmHlJpAh36JFiVtOvJ/vSob+Ks68LdKfpdfxDn/C98Tr6sVu9Jhe53S80NrHPvSpraM1KEMboHH/IlMhIOett6RpXceq3nC9fQrDZj1suL8WpSiZdKrTGUVDs4gE5pnmADJQsYIdmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807690; c=relaxed/simple;
	bh=MRbjz58EJk2DIV/CMfsuQeru3Gjlj5upRwbvX0t3mqA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zv0WoGp9ya4iKDJ8kXFwwsO/pPhN8bHmTw7KgX64XUhlx/lny/NhVQ4JeKLeT7wBmxzHBUpEO5RM18OeNZcZidphwFgd2dp41E+H2upDYkLBfhH5aq4bnZX4NxSzIeDZHK8ST6J17cjojqsOnhs7WWcDA3hHOhJLBI3wv1YITHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=KZ4kpj0e; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="KZ4kpj0e"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-71e6eb6494eso13052437b3.3
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 13:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1755807688; x=1756412488; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h6Y2vCrhkZTJ22Wp+VyocA6nDD0iA/acEwKo6i4LTMQ=;
        b=KZ4kpj0e+2nHxJkJfRRElwV/CGxxfwb2mzTyZ/Eo4Wk1OAJv0kQBcEsMBjZN+B0xk7
         sygR3Edm5/gldHlW/wGto0rv6MSQMWQrJDTvSm4AsOGnxGc438pY1862gpqlPHPUdxpQ
         PA9z0x5e4/bync/fbeLJ3FKHvBu7mCwEQvclxtHb5Pa/q2jJ5Lj++uQ3KgWqBMeJRB6U
         cbvfdzfaRx0duO7M1xJfBAA8lhgO9DriMnTJCA/E6hGVbK+QWsbhtNhhXdOSsjyqscfW
         RJT9eyGl3zevXuUhq/MBf839M4AeyOEFsU83Q9QpeqkqZInfNiv1nOh7EGTs9dG+28dw
         YSjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807688; x=1756412488;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h6Y2vCrhkZTJ22Wp+VyocA6nDD0iA/acEwKo6i4LTMQ=;
        b=uG8o9IrW9DLlnYC61OrfpeihzmDNW/SNvvSeNlvyao4pjA2Ey38PMHuCjnbSus7Ux8
         atL2hoLuy/NZrfHCuDN7aUSh2ONDs8LCbQ3RZBfmkvcpuOeY3evtsmxtnsw84W18RSev
         tw4/T/SGhMyKYY63FM4wAfNFdlLzkfqDdyAlYLq+oemV8lfec6d0ltvmtYwYUw+Qn8ie
         gCWTSuFenjJw2NpMxVhg5nSACA6s3NhKiwox1/CHzINM/RwvNOP7N0Ek8piUDpX5z5qP
         rieBmBLEOcbdUKfck1NxY0mdPpA9pDKpUVJyWjS2DOV2c+P7TTv4V8dFFJ3jMhpf1+3r
         Em2Q==
X-Forwarded-Encrypted: i=1; AJvYcCXhT6I/0v53C/mluzyLRUgJZhNT3bl7G+wW8WIQuChD2IE8W9wIKuasZJHVeHXND8W4e0WMfO/TDN4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTQO8SrT7WSIk2IMIBWLf5uUujZeRR954I4QFs9dv8SA1V7dMR
	W191kXPzzoSGpzDMQ8wKZRBTv9QnL4z3ffws9B1djYrvM/zU+jo813SjUJDdUuLNLwA=
X-Gm-Gg: ASbGncvt3F55bYKuYgNZ+m9j0j2LfIzuv4SXnjFQbSPOI+WH4vWTGQktk40+TktlXB/
	Uv21efJnxaKExLhwsEBuHJYLxl5tFEdkZE78oH0YAonHeqtVAPjqWBOeRyrakePXCBEhaYtlFbg
	2p4yg/MVr9S0vUVsokP6C7/EmmDjObR/TOGzZJ5N4pod0eYEFwHy0uWY7tFcLHwsxIwRiHA2OT9
	2XuaclZZeojOGbPtGGebwKWu2N8k/CzEXy7NxiMVG8D5RDzepnwWobXwcAR/7gO1v94mRfWLTjc
	gVourwSoVYdIQ4ux3CD01/Ag3m3ug94lkjXHhSEipvWHeVJpac2cCr68/lldandk24yjQAub4nR
	jkm29uIgYJQ8ws0Mg3wkaz0NXYqsWvPy8XPtrDP0P1yJAxKLzXLmSysKXqPk=
X-Google-Smtp-Source: AGHT+IHKd05hnDdE6pxXbgnF50bB6qaOk+UowOaZiUTYV+EFuPk1zkORqkQfdOZSuLjXIecq80ZgtQ==
X-Received: by 2002:a05:690c:6211:b0:71e:814e:c2d4 with SMTP id 00721157ae682-71fdc312ff5mr7198057b3.23.1755807688184;
        Thu, 21 Aug 2025 13:21:28 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71e6e107145sm46178057b3.70.2025.08.21.13.21.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 13:21:27 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk
Subject: [PATCH 47/50] xfs: remove reference to I_FREEING|I_WILL_FREE
Date: Thu, 21 Aug 2025 16:18:58 -0400
Message-ID: <2d12a5a95496c71929b90c298bab06fdd81d75d8.1755806649.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755806649.git.josef@toxicpanda.com>
References: <cover.1755806649.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs already is using igrab which will do the correct thing, simply
remove the reference to these flags.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/xfs/scrub/common.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 2ef7742be7d3..b0bb40490493 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -1086,8 +1086,7 @@ xchk_install_handle_inode(
 
 /*
  * Install an already-referenced inode for scrubbing.  Get our own reference to
- * the inode to make disposal simpler.  The inode must not be in I_FREEING or
- * I_WILL_FREE state!
+ * the inode to make disposal simpler.  The inode must be live.
  */
 int
 xchk_install_live_inode(
-- 
2.49.0

