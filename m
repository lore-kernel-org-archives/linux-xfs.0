Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33AB363082
	for <linux-xfs@vger.kernel.org>; Fri, 31 Jul 2026 06:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785478640; cv=none; b=nsAsHGDA6SmyHQl0nlJ53iB1Tf8TZKkN2hKBJvMMohsD0mA2aVofRNT5Uan0oPLqM97ais78FB0OciZVLHb92KGQXK9g+1xkHq+bxXT1NNY4mxM5JRAjzYQqa+0SOiQ0+WGybRZZDpJJAp9324K0UR0Mpht+3eNhxDTKppUixq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785478640; c=relaxed/simple;
	bh=+5QYk5EiYjuebP9ZG2Pg7OKoEiKdDmMnOGBCN99Tbpo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gzEkn2SUz5X+yjuMyVdkYvPeIbqyw5Nsu9ZqvtxiLHIJ3vnUaqi/u456zisgnz2SHqRy8u68H/IydpEL8icc82Sr3isvW6pkCHhGHDv5+bwdGWn5Jfq/Ab2qwK2RA2N/r4falWF1Td0seHQoOcjUBzp4dti4jecEpCfz/BjpEVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UjzbeKiU; arc=none smtp.client-ip=209.85.217.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UjzbeKiU"
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-7389cff36bdso204607137.1
        for <linux-xfs@vger.kernel.org>; Thu, 30 Jul 2026 23:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785478638; x=1786083438; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=iHW4TV4tTuaZdEfu4Qe5VuaxQkpgoHCigu/4rFxdTdg=;
        b=UjzbeKiUJwM3l/C6HuTTH19R6n8k56k4noBlFNP3nbXyCQbrnp+F1Q6uJqJhc1tEZd
         h7TLoW3vJYb7xJG99QjQ42pDVqgMVKy+F8VG9PiqyVpu0GcXhBg2446j2AnB+dNhPIxF
         edAvCcKbL4Rs1np11qqQ2+mgAqLslTgYdIE5NQifwiH0bzKLJU1BeLu8nTiDhQ4U/K1B
         KG/J9pREALbyQw43/SI6zEbjC8/QGU5xNARqH7kReuTDaDEd/pBFCGP4DsKDvcx0MIWF
         n6TSlwAY3GE6s2kyREYt2DBm9W6GHWub3cT9vLhedEilSjrrtdiFIb5rObr3R2t14V5F
         8NjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785478638; x=1786083438;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iHW4TV4tTuaZdEfu4Qe5VuaxQkpgoHCigu/4rFxdTdg=;
        b=ReyZj295da4yVRwViOjV2WZ30OD7F1boQ0H7Lhm47Z5eAtPiEhUTX7dIGQpEpisYk6
         3ZeKaEkHQm1nDnoL+tfIsv6Qvwws++faMibpkjW8SfN386A8iztLVGjTS0KgChgYJHHS
         /gQTFXj82fN7O8vuvowToRjiQUZzizr4oUO2OSziunp8p8ic/rQpFXuapbg6wVs7EoR0
         HBRuXDHLHZt/XJN6af8WZwT809trEiaCSwfboDXZ5o/ysr87ej6MmzxXea9MejIttVpl
         7rAs3xWJo0t5F2edgTRe2GwCe7eYk4VdHuduJuLFHg62u6rerhF1VuqpwPnKZkn7SnFb
         4Cpg==
X-Gm-Message-State: AOJu0YyNw07Rj1KmD3n8t+UwakCumhYNrSLUrzfkMTtk4p5yUyvD8gQq
	106F80R5D+wWVme4pI2X54CGi4BgLyxdiI0aSNY+/A9sQiISw+XWD+Qy
X-Gm-Gg: AR+sD11Y/99kHzdxWpm/mRepYLgrXQUZYrh3F2o/QMWDfVVH9Px8kgQJfQZlzR+QOwE
	qheTzoVRolCL1tqILclUWF5JN9ct6dbqbR1x7uz7CnaMrW6LcGNGgvYsb0V+r84HxW/tlUtY+Ki
	TOqd7lYq1xU95Sd5an7ycHDMmBVY04/i8kuVPBqJZk3OYAlGIsd9IeDVvFay+6SiS44HEAfZq+E
	bgnzPDr048uN5RwIPsJ7vt3PI73EvQgFlK9jUeKGI7AprdfykElF6pALihhG2k4QmI7yjTsX9FG
	r8fadSOZmYzGNr6r44hl6dqCuYi8IlrPk2wtQiQYjmDscd4AT7b0Lau2zziht7T7Q436NSk2XHJ
	rGdfF58v72TDpEpq2sLsmPVgZy9j7xF7YXYcTdVCVj7PhOUKyLYiBwFQFquU005Uvom4wE6Er/5
	ykVgUZ7zmCIcLaT0+f5TjK/vLE55au1ahAH6NLAkVRZ8Yk4ba4h/z85UgxJiHGL1/vjg==
X-Received: by 2002:a05:6102:38ce:b0:74c:9177:35bc with SMTP id ada2fe7eead31-758f6974abdmr203607137.2.1785478637579;
        Thu, 30 Jul 2026 23:17:17 -0700 (PDT)
Received: from fedora ([2804:1b3:a8c3:8ee5:1c39:64d9:e257:73dc])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-977e6aa5d2csm62806241.12.2026.07.30.23.17.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 23:17:16 -0700 (PDT)
From: Marcelo Mendes Spessoto Junior <marcelomspessoto@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Marcelo Mendes Spessoto Junior <marcelomspessoto@gmail.com>,
	syzbot+4e6ee73c0ae4b6e8753f@syzkaller.appspotmail.com
Subject: [PATCH] xfs: add guard before freeing buffer log item
Date: Fri, 31 Jul 2026 03:14:48 -0300
Message-ID: <20260731061448.192010-1-marcelomspessoto@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A buffer's write completion can race with the CIL walking the same
checkpoint's item list during a forced shutdown's simulated commit
callbacks. Whichever side reaches the item last should be the one to
free it; right now completion frees it unconditionally, so the CIL
walk can end up touching memory that's already gone.

Fixes: d2fe5c4c8d25 ("xfs: rearrange code in xfs_buf_item.c")
Reported-by: syzbot+4e6ee73c0ae4b6e8753f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4e6ee73c0ae4b6e8753f
Tested-by: syzbot+4e6ee73c0ae4b6e8753f@syzkaller.appspotmail.com
Signed-off-by: Marcelo Mendes Spessoto Junior <marcelomspessoto@gmail.com>
---
 fs/xfs/xfs_buf_item.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index f4c5be67826e..c86c4387f52b 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1072,6 +1072,9 @@ void
 xfs_buf_item_done(
 	struct xfs_buf		*bp)
 {
+	if (atomic_read(&bp->b_log_item->bli_refcount) != 0)
+		return;
+
 	/*
 	 * If we are forcibly shutting down, this may well be off the AIL
 	 * already. That's because we simulate the log-committed callbacks to
-- 
2.55.0

