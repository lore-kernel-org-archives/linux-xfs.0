Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B0818AED
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2024 02:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721788985; cv=none; b=hhJhOnngbq7ux/unTtivwU+ic5JHI2ayAnfeG//WeOOFZZvG1xNCrFm4h9pm+Z0msupkvRMkU8SkIoUc+WWlSU7+JXnmzMnTgctvQ8ViqfC6Y+d8dwZbC5Uk2g4KKWcCAz1FKkZxETm8chOpR5QertleKrTysd6l1QGHWE/DhSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721788985; c=relaxed/simple;
	bh=HjAksamMwITly5i18w+aXDFpwEtfPIQXyuR0adASWtE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sUTFFlAp9ISQ8DeCkb97Gv+2gTbCT9tNk1lp2tIS5bgSlbdiPoRHObew850YDHksdRSIR/wvi07JpO5qdw5bwiDwCS1UVilLyj73cg9OIcahi+QMyZaLTzH/2rFo7AfziRG+JMiBvqvN0rHG8eauYxVC+DHH47F8bm8vwhl5+Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YS6Pj/1H; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YS6Pj/1H"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1fd65aaac27so2945045ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 23 Jul 2024 19:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721788982; x=1722393782; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ciSySePXWqtv1iSz9j5eb4MWUhegsn2/5OXwqKP4loA=;
        b=YS6Pj/1H+7bTiHb5i5X4kRdOqbxXXp8cnPkHP50ORgixsyZ6ldRP9fx5VwJbc91EL5
         GqErlt4onr6NIdVjaqOghNJTlbkeptPlA3refzd3XG5tHQ24OG4NAEMOJwIQwxbzJNom
         g6ozdLndIcOarqW+kHb4h5PWIQulLG8pcGL3brPaHKD4RS+V0Pg93RwmKE9fDuoZnIzm
         7qWgVcoHv8Ydfmcxg1cya6FPWiFhehwDKLIeQXpINAZ4oHACpOC7NXiKu4Q3KA+eenmx
         wrrQNn6n5/cemPnBbACH++plXD4wRcZtt92mzPzO7p6n1lTeLxeG9h7Sz/HWxSIvzKTI
         EZBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721788982; x=1722393782;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ciSySePXWqtv1iSz9j5eb4MWUhegsn2/5OXwqKP4loA=;
        b=kW1pwpKLID7EBBCVAP2Vg2cczkuLfZlnFsrRePo/ctONzg31iD2CmeytWNHsRh/wd2
         sUSNGpkby+F6v8BJ+1ASWcreXMRcRyIzN7JpXBk24u/qJOC+x230PZqx45cYUFREOau6
         l9C8dS+z2CVC7mLSDK5QEg+DPMrGAIWqSAXAitr1peFmrR/Pp2SR2TdJvFhOMY/XEMCG
         kTuxHE0tOED68pRI2Q47+LyqMcynjf/8zdQHwyUa3g/IOzAXjJOAcBo3SWgI+TjY2arQ
         fI1VtSU2FjeFHSSibBMkNtwxoEM2SDYHyki4YEVHg9IT6+fx3DMn3Jfv837rpKeFaEre
         LWiw==
X-Gm-Message-State: AOJu0YzcitpERAiIr3gHoxtx2YH0wt0JDzZQFPXwg5+3ty6EYtcjpHfs
	tT/B4vfJ0BNZuhQ95e0ZWsPyYq6S9rYAeco9oYndK5n65jhWVyWP4TtvDVwAZCA=
X-Google-Smtp-Source: AGHT+IFebsd/FPx8L7ffWC0xbYHGrwCgtmOpfzysJUre4XHno1WmE7ZMSW1qMsrhrVKf//ltMyWg7w==
X-Received: by 2002:a17:902:c407:b0:1fb:2ebc:d17a with SMTP id d9443c01a7336-1fdd6e7610fmr8557825ad.23.1721788982517;
        Tue, 23 Jul 2024 19:43:02 -0700 (PDT)
Received: from localhost ([114.242.33.243])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fd6f319763sm82949815ad.158.2024.07.23.19.43.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jul 2024 19:43:02 -0700 (PDT)
From: Julian Sun <sunjunchao2870@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	chandan.babu@oracle.com,
	Julian Sun <sunjunchao2870@gmail.com>
Subject: [PATCH 2/2] xfs: remove unused macros
Date: Tue, 23 Jul 2024 22:42:57 -0400
Message-Id: <20240724024257.168917-1-sunjunchao2870@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Macros XFS_RMAP_IS_ATTR_FORK and XFS_RMAP_IS_UNWRITTEN
were currently no longer used, so remove them.

This patch has only passed compilation test, but it should be fine.

Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
---
 fs/xfs/libxfs/xfs_format.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index e1bfee0c3b1a..86cdb0e13113 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1551,8 +1551,6 @@ struct xfs_rmap_rec {
 #define XFS_RMAP_OFF(off)		((off) & XFS_RMAP_OFF_MASK)
 
 #define XFS_RMAP_IS_BMBT_BLOCK(off)	(!!((off) & XFS_RMAP_OFF_BMBT_BLOCK))
-#define XFS_RMAP_IS_ATTR_FORK(off)	(!!((off) & XFS_RMAP_OFF_ATTR_FORK))
-#define XFS_RMAP_IS_UNWRITTEN(len)	(!!((off) & XFS_RMAP_OFF_UNWRITTEN))
 
 #define RMAPBT_STARTBLOCK_BITLEN	32
 #define RMAPBT_BLOCKCOUNT_BITLEN	32
-- 
2.39.2

