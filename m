Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="Ar6QsFEg"
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD1AE10EB
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 23:59:29 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1ce28faa92dso49890125ad.2
        for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 23:59:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1701244769; x=1701849569; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YauZ5nFY7F7io1hORv7LvgfYKOqlkddb830K39XSJwk=;
        b=Ar6QsFEgzh0w8kdputYDcWo2TnCJKb7Dcq9ZxbDvtO7xZC0g9ibnr7aW9PtIytmc3q
         oO4AIiYSlm8vjQCwj3sl1S4zvy9BXV3gdvauRBb4LxQXgPhD9AlXcvvBUV9M6b/GvFiy
         SIXPbxJ7sto4+cADBwFhy1EyP5Ssr6yU4e3aUhDzNr4g5gnEvOHL01CGKvB50awODAMn
         9Io/qgmTSbVQfaG3RV8dn/quYReo7gbXvcr9ReRC24EiqgGL4BjPaXx2Wzhy8hqXsXKn
         KpJdLUbDLoJ+ay9JlbniY32tZtIeZEJGPVOZd/NQACCRJBn7h54/ZF3esan2yC2DHm48
         fKig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701244769; x=1701849569;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YauZ5nFY7F7io1hORv7LvgfYKOqlkddb830K39XSJwk=;
        b=aMY8x8KahPMhLSi8USwSmODSZXsVghpIT3CpzlV3xnbldNQrDQ4yfLNlQHomuoBRC1
         31tLP3icmAdnZ7Ois3YILpu7nkaTHmVcAaFf5joyU8kXbczGYSXBFQsUom6rRQseaa1J
         6TPcDdOW5XTgNQCUAKpS9DI0L7Z3pdh6BOG0gwHMnT3eVPMZKsyg2Rt8OdqDG1p71QdS
         QyKJoXDvNdwatbBWA7P+CCxceqfOnzsR3tVh4MQI4jXK7mUlWOXv38UDrZeha0YwL6Pt
         HqTKEp90olR53A+ODw3iPjKxiQKy6JjjjCi4ARtaIsuq6RztCGCeMZjbFPRQJOzwhCEs
         SEiw==
X-Gm-Message-State: AOJu0YwNCKo6LuvtCBle3xVd6uC4OIjfFVTC84P1V3C+uxaqyVopYrP9
	ICDTxpB1JKwIHBDeBfJmFJg4lw==
X-Google-Smtp-Source: AGHT+IFaKO62tpVgLz7ZQW3WdVZvjkLFQ3+fYbURvJNMI1MHyODzmDZE9pRm6Tgt1d216kFDzkBR9g==
X-Received: by 2002:a17:902:e744:b0:1cf:bd98:633b with SMTP id p4-20020a170902e74400b001cfbd98633bmr13147413plf.64.1701244769204;
        Tue, 28 Nov 2023 23:59:29 -0800 (PST)
Received: from localhost.localdomain ([61.213.176.9])
        by smtp.gmail.com with ESMTPSA id s17-20020a170902989100b001cfd0ddc5d3sm4979419plp.277.2023.11.28.23.59.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 23:59:28 -0800 (PST)
From: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Zhang Tianci <zhangtianci.1997@bytedance.com>,
	Brian Foster <bfoster@redhat.com>,
	Ben Myers <bpm@sgi.com>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xieyongji@bytedance.com,
	me@jcix.top,
	Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Subject: [PATCH v2 0/2] Fixes for ENOSPC xfs_remove
Date: Wed, 29 Nov 2023 15:58:30 +0800
Message-Id: <20231129075832.73600-1-zhangjiachen.jaycee@bytedance.com>
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
problem.

The 1st patch fixes an uninitialized variable issue.

The 2nd patch ensures the blkno in the xfs_buf is updated when doing
xfs_da3_swap_lastblock().

Compared with the V1 patchset, this V2 patchset
- directly set the *logflagsp value to make the code more robust in the
  1st commit,
- check xfs's crc-feature rather than magic in the 2nd commit, and
- fixed code style and rebased onto the master branch.


Thanks,
Jiachen

Jiachen Zhang (1):
  xfs: ensure logflagsp is initialized in xfs_bmap_del_extent_real

Zhang Tianci (1):
  xfs: update dir3 leaf block metadata after swap

 fs/xfs/libxfs/xfs_bmap.c     | 26 ++++++++++++++------------
 fs/xfs/libxfs/xfs_da_btree.c | 11 ++++++++++-
 2 files changed, 24 insertions(+), 13 deletions(-)

-- 
2.20.1

