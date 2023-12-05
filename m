Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="gU656waJ"
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D7AAA
	for <linux-xfs@vger.kernel.org>; Mon,  4 Dec 2023 21:59:18 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-5c21e185df5so2950173a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 04 Dec 2023 21:59:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1701755957; x=1702360757; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HlsEF8HjcrD0vm5er1oT8WZvKcg7ME4zSDysaDBmuRU=;
        b=gU656waJnSolRaCCjEYbesb4/Y2E4s++J4riEcjTmmxZudo2bkcTL0Ud5on6w1MNSi
         oSB0YdOd6/FhFLMjJRsZlib9HM/Endr5Cp7dHrjaT64OJeERH1WP4QEjbAU7/6F+rumz
         R0+XIIFCMhcNvS+pFljL0alzC/om4ByA9du/ZyJXYJNFwOIphf2Iq1xTyLN6AhcjAL6D
         l6znh1rKq37lazrps0D0AlPZPjgQI79+eXn6ntof4JwDgJ5ettFs8X1vCyX5ZGb0y5jN
         DWUM/wjjGIsBL6KwaWoa/5VxeaWAZTb9J4mdDUUgo+0luS6q3+o/CyVESkK4JpoHway8
         tnJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701755957; x=1702360757;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HlsEF8HjcrD0vm5er1oT8WZvKcg7ME4zSDysaDBmuRU=;
        b=LtoAm5x4vx4GA6bQomgVE3itXKR1QaHVXsbdkirrsjylde+mEUeLs0PRHQ6Dy0fb+k
         0Ux54HNV45AWw70D9oGVLFUVysU0waxzfqnqirmQsemrVkAKeAtwondeA668oEHZlj6o
         pbdZ+d+BIBQ6pOzX3Zszsu76uZCpchVw3FvQqgf+XzIpFw1AJeiaDWGr9nWmp4QP0UeB
         FecpAcf5ysfHpq51BGVMVeouas38jtBLqZJ4aivArS7M5WPyfAfS0H9MMpwNp8Psefkx
         Becz/9Ex5b/uNp/c+Sq5NCsSimQ85x8aJB7gkOia0zAqe3BRt7cjtM4BcnNFF/rB5RZ2
         y0Aw==
X-Gm-Message-State: AOJu0YyfLikALpDN9hx1cZjV95MDDnsGj2gOylzdY3lpGAa/SCGe6rzB
	C9Seh330avHTcJCdNpYTTo0pnQ==
X-Google-Smtp-Source: AGHT+IG3WM0C8QSWzlA5REbLFumqEaXOOtiDvfkup/AoaEzkEL6TxjNIX+MytDyp2q2eqC3gJ74+DQ==
X-Received: by 2002:a05:6a20:a1a2:b0:14c:a2e1:65ec with SMTP id r34-20020a056a20a1a200b0014ca2e165ecmr5059457pzk.38.1701755957415;
        Mon, 04 Dec 2023 21:59:17 -0800 (PST)
Received: from localhost.localdomain ([61.213.176.5])
        by smtp.gmail.com with ESMTPSA id jb7-20020a170903258700b001d05bb77b43sm7111605plb.19.2023.12.04.21.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 21:59:17 -0800 (PST)
From: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Zhang Tianci <zhangtianci.1997@bytedance.com>,
	Brian Foster <bfoster@redhat.com>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xieyongji@bytedance.com,
	me@jcix.top,
	Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Subject: [PATCH v4 0/3] Fixes for ENOSPC xfs_remove
Date: Tue,  5 Dec 2023 13:58:57 +0800
Message-Id: <20231205055900.62855-1-zhangjiachen.jaycee@bytedance.com>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Recently, our use-case ran into 2 bugs in case doing xfs_remove when the
disk space is in-pressure, which may cause xfs shutdown and kernel crash
in the xfs log recovery procedure. Here are 2 patches to fix the
problem, and a patch adding a helper to optimize the code structure.

The 1st patch fixes an uninitialized variable issue.

The 2nd patch ensures the blkno in the xfs_buf is updated when doing
xfs_da3_swap_lastblock().

The 3rd patch adds a xfs_buf copy helper to optimize the code structure.

Changes of v2:
- directly set the *logflagsp value to make the code more robust in the
  1st commit,
- check xfs's crc-feature rather than magic in the 2nd commit, and
- fixed code style and rebased onto the master branch.

Changes of v3:
- fix code style, and
- add a new patch which does xfs_buf memcpy in a helper.

Changes of v4:
- optimize comments.

Thanks,
Jiachen


Jiachen Zhang (1):
  xfs: ensure logflagsp is initialized in xfs_bmap_del_extent_real

Zhang Tianci (2):
  xfs: update dir3 leaf block metadata after swap
  xfs: extract xfs_da_buf_copy() helper function

 fs/xfs/libxfs/xfs_attr_leaf.c | 12 ++----
 fs/xfs/libxfs/xfs_bmap.c      | 73 +++++++++++++++--------------------
 fs/xfs/libxfs/xfs_da_btree.c  | 69 +++++++++++++++------------------
 fs/xfs/libxfs/xfs_da_btree.h  |  2 +
 4 files changed, 68 insertions(+), 88 deletions(-)

-- 
2.20.1

