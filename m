Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5381CF7C9
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 12:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727871854; cv=none; b=sUHEdG81CiMfq03QboSQZZJrqGfXMwb7MA4TrJU+RoRc+uV8cDU2uYhlqLQt8ddLJZOZNHsQAdGDW0Fa7zQin8gOgFGXDglijQAsXXMsG6IE2fgKq6D12BoHcovX8x4T4FsP4PCxVhy/Sw5LcA89vWeYDbj2etG/E/yVmG+GQyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727871854; c=relaxed/simple;
	bh=L9+1a4Nvhl4tzEYVdSqhW0osk5/oToIvRvPo4KJU228=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kxiMrDq3K9RTCZGqJgSkIyXR6ZlKD/XeIN7MQAcoeR27/S3k1Gmf7GiuKWl65gvcv9wZndRr51oOUkTJOZp3gMsQZAFTtMSma6mL99AQQdOP42ZzYjIjbBLFdp+tnVcKZndLxhyNg3x1UmkqJbpteQRGzRX5EkktqAz2qJntbKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com; spf=pass smtp.mailfrom=shopee.com; dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.b=jAkW0I2x; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shopee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.b="jAkW0I2x"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-20b90984971so33037275ad.3
        for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 05:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1727871852; x=1728476652; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lSRpGgRiOL4V7C0v24EhN3UDSCpKvNuqNV1m3ZjKLE0=;
        b=jAkW0I2xxb4HrDS825RLiYGeHBgKtNd0oncymsY4hnVBOylwrJhCXA2PGUS4E0LiHk
         7QaDW+FBEcCENayIbTW/bHRtKB2BjFjEJd5dqqySf/LeacdQ+jU/tukgkMnHUyUQXckH
         EH9cOU0iIMQAhE5yLLSPOihc5JdZsO+ZtAmZJFoy7aTg42J8Q4GNjyMQsYjnp9lpwL/A
         xsKqGUziwSr3VpwjiwZLwgmaBG5NNnWux/UoPmSq7iH9KuBwqEQwH6v1hr0rot+9vuDJ
         d3dFOci4Qi6xK5EymVKPGSWApbVR3l1g+N9Q3lPXKSbfGiypUn474apwLy3SBYzDNpL5
         TnGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727871852; x=1728476652;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lSRpGgRiOL4V7C0v24EhN3UDSCpKvNuqNV1m3ZjKLE0=;
        b=PafdcVmpkphYzONimPJUJQHL3WQ7i75gqlt9OdDFPP7Xsv6XpCQLiLyqQ2h2LuoI1W
         G39efWNVwWyFE3u31Lj/qIOXE+9q+dcjz4CGEdIeWLKi7PbmWVL/zafcpwvqww8gwZrH
         u06+/oXdwOwLQcBD2j30MOoFSShJSPibjp3CpN9gZWUnNaOAs2YDsLOfQ/WniJzoybsz
         yRScMbeK7sl5cIsWbdr2Fe93XkXZJjB2qIMgpN42fj4+XJiHSaHXSMfXBQteRMVg1J7i
         etdnFapTDZPPdlHbvunBt+toFwGW0/ozn3Cl1HW5XS/C6kWcdkntdXj/tOhOVErH/5xC
         7NjQ==
X-Forwarded-Encrypted: i=1; AJvYcCVlaoyQfDoS1Em6XRLebJ9xaOxpcey0HpahYY8v0A5xNgBWrunFG1kdh1HQAJR1DeUV2loBUXZMvuI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkJUmgd4vnCyrKr+Y+0BygScI/Wx5yR8Whb5mwLvQ2Z1owGYKf
	ZM1rW0uxFDB5+8eX3jAClExVShVZW7IE4a5XfvK9MliThNEY+FHDv2pWmxGT+ifurf6BFALCjoZ
	R
X-Google-Smtp-Source: AGHT+IEwQwMtyKjJs5mIPiMJsYOnVLsxcA/9aIPnlYTc9sY8VpaQdegvup3iaqWg5jZXNodocqXfoA==
X-Received: by 2002:a17:902:e88f:b0:20b:c258:2a74 with SMTP id d9443c01a7336-20bc5a3d3cemr40438745ad.29.1727871852063;
        Wed, 02 Oct 2024 05:24:12 -0700 (PDT)
Received: from localhost.localdomain ([143.92.64.18])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20b37e33852sm83508625ad.199.2024.10.02.05.24.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2024 05:24:11 -0700 (PDT)
From: Tang Yizhou <yizhou.tang@shopee.com>
X-Google-Original-From: Tang Yizhou
To: willy@infradead.org,
	akpm@linux-foundation.org,
	chandan.babu@oracle.com
Cc: linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Tang Yizhou <yizhou.tang@shopee.com>
Subject: [PATCH 0/3] Cleanup some writeback codes
Date: Wed,  2 Oct 2024 21:00:01 +0800
Message-Id: <20241002130004.69010-1-yizhou.tang@shopee.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tang Yizhou <yizhou.tang@shopee.com>

Rename BANDWIDTH_INTERVAL to UPDATE_INTERVAL and update some comments.

Tang Yizhou (3):
  mm/page-writeback.c: Rename BANDWIDTH_INTERVAL to UPDATE_INTERVAL
  mm/page-writeback.c: Fix comment of wb_domain_writeout_add()
  xfs: Fix comment of xfs_buffered_write_iomap_begin()

 fs/xfs/xfs_iomap.c  |  2 +-
 mm/page-writeback.c | 18 +++++++++---------
 2 files changed, 10 insertions(+), 10 deletions(-)

-- 
2.25.1

