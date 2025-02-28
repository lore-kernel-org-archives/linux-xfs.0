Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCDCE1FE44A
	for <linux-xfs@vger.kernel.org>; Fri, 28 Feb 2025 08:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740731189; cv=none; b=XUBT+rWeMyAjgSjN8dTzAyBah1X8DmjpHKwed4d3n6G9kKjqlyIY8R2tmN5FXSZ9K98nD9gEnf0DPeUx9sp8BTf9amEzAOq7fdENccxke7WgZmMKShNvrwenoqkZanDCaVuLq5MoCtsN3wAWhEdhWLsERAm9SSpioDl4lkl3Ozk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740731189; c=relaxed/simple;
	bh=UrFll57sFzbgHMRzQSRCFr5zsyGH3Hd0OIYgzb63W38=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XWCEDc3HBhiUZPvAhKysvOc4gLtOPwnKSYoqzqX7uTeWwO4wV0Rn6UkO74N97jcoexhpdBUAg6bZfk2Mj9UejN1Qm47L4+G/fmhncwGwFYESV6iaKFnYDJ5Ox5pzz8urTvSWCOBVytgCMUuaTt6udpzT3r2d/bMYE2/oKbOkNiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fNZ6YdeY; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fNZ6YdeY"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-22128b7d587so35834345ad.3
        for <linux-xfs@vger.kernel.org>; Fri, 28 Feb 2025 00:26:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740731187; x=1741335987; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=l7Po8DI1lD/Vqe7d5/SwAUkjkA92mRte+V24TQl9A3c=;
        b=fNZ6YdeY1s4axdJoAQ+i47MQSY/uHQQeQEAM6FR93XhstlPtEEwBrojZs4sPHMun+y
         TwL3mDHKnW1MeiuEvqcHoq9rZs3O4D+OeftpU+xLKokGM7JoLxp8JoGn7tkSmtsE3Ifj
         RRwQsCb3YHAePYgjVCgljIbby7Ke+oqeaTZ5SNLefMiK8RkEVNtclIAQCLYnUhieIQWB
         As9d2XrRDM/8UlRxEzMjITlMMYMNvjrGGJciAHBonyfuk92ky4VZdYxz5Sf41WhEnBVh
         ylyzTaP+NYLULg+cXTUyQSvwoT+iN5A+iuNmPj9VQ4kCyKmqx5u+jg9uMJHTykXdiAA1
         pWsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740731187; x=1741335987;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l7Po8DI1lD/Vqe7d5/SwAUkjkA92mRte+V24TQl9A3c=;
        b=rDhwjLf00FHfpIiE6BN0EhC7Zr20s8BBn78F500MLiCo2CMf3on5WcK8KGiCIxR1nH
         k9bRH2XGaTd2lbcImOQkBpuTlTQYx3cK2gGbDOQumbcn4xqj7y0gsaHWOlVR9GK18OFo
         qs4Sd2WcblMaQqO1x64BkNJxzKQMLwKaIJj49egSnqwLy3C13Ig1D8K+3VvzwFNCCZW0
         se8ST/rh7pvAJQA+ZMeo8bhwK/lS2s43Gynp2mtR8SohlX7jHTi+Xj4MVGpkGl/lOFKK
         Vm/MD4MluaNtET3xRmy8eLiZgF+vNX6JmiSuFKfAOIh6nnWcrGqRu7aK7or2xsP+Dxnl
         QMUg==
X-Gm-Message-State: AOJu0YzvA0G2SfLEh1C5x8dYA5CaqfOO5Ysx15UkA+QjYPcx8WjBPnJv
	ZFBsd4vx07gDb3X7dI+DFARfQNXMvj4gmG6VoAJ7MUUVfQ8Xixor79MjARMN
X-Gm-Gg: ASbGncsuRr5JMz3y6uHFPhgGFsUAicdn+kOZE0Tsv/Eo5vsI8IdWweigwYFyKLz9ri3
	rAY42i9bv+clrqt+6OduDz2ZlpeiYgTeUIJei7HQuObekIbg1zOpZXPraMqaJmV8Rz8G0wARfwM
	UDgbKN27U5LW+TKuXsx8zD0IFiBTiesEcUF5yRNNjfyVbsLwb7VP7ExjU+GWucLS8K0VIhqNPak
	uqktENM01RC4mcE9oOu2QlzgvXwD5E6cqjMaH3XgzEohjbnOGVf8hDWlf9G33TcRqQXlqdD9Q1K
	NjiICsmzyo8LOeaRTekrnjljCaCUiw==
X-Google-Smtp-Source: AGHT+IH/oKlDtNGRB0tRsm1UaBVQo9LlwupVj7WlVR5pFhbkD446ygj25hlAoHU6ca9PTKPhhKbqVw==
X-Received: by 2002:a17:903:1983:b0:220:f91a:4650 with SMTP id d9443c01a7336-22368fc0cd2mr35309895ad.19.1740731186587;
        Fri, 28 Feb 2025 00:26:26 -0800 (PST)
Received: from localhost ([114.242.33.243])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-223504c5a1csm28044675ad.137.2025.02.28.00.26.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 00:26:26 -0800 (PST)
From: Julian Sun <sunjunchao2870@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	Julian Sun <sunjunchao2870@gmail.com>
Subject: [PATCH 0/2] *** Code cleanup ***
Date: Fri, 28 Feb 2025 16:26:20 +0800
Message-Id: <20250228082622.2638686-1-sunjunchao2870@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit


Julian Sun (2):
  xfs: remove unnecessary checks for __GFP_NOFAIL allocation.
  xfs: refactor out xfs_buf_get_maps()

 fs/xfs/libxfs/xfs_da_btree.c |  4 ----
 fs/xfs/libxfs/xfs_dir2.c     |  8 --------
 fs/xfs/xfs_buf.c             | 15 +++------------
 fs/xfs/xfs_mru_cache.c       |  6 ------
 fs/xfs/xfs_super.c           |  2 --
 5 files changed, 3 insertions(+), 32 deletions(-)

-- 
2.39.5

