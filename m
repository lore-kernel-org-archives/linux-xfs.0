Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="bhZA9CJc"
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22540EA
	for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2023 21:34:29 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1cf7a8ab047so38874675ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2023 21:34:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1701149668; x=1701754468; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fxO33hgX7qudIID8yDsz8ucZ3gJV05i7WjPRt4ATm1c=;
        b=bhZA9CJchPrKFiQfbQF+NRJRfXVXkcAFEkGxZ7UABAQ1cfDqDCZbSPOzurpSk+scPc
         hQUC17nOc6sFrkYIFnANlXLljAnqoMLyZ8IsuHhUjz8zPTQaHuKgL6TfsGa948nxoA/s
         IWgg84LIqYD3zvi9L+9R5nogMayy0c1PwNm2Sbqv1gUDpYi56dUnzwXklqp6iws57fxa
         pmaFrp/fyFhjuKW5nt1F+GGhGqFA6rAx4hnIcczt1/k9XmUmHlJ3OAFTeQ09QlVailTJ
         Gp3nZo7d9vmhhUOMLTPHlXkBzagXVGTmutvEPFDycrfxhdBZY2LFOwVklLP0LFDDrY3m
         pelg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701149668; x=1701754468;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fxO33hgX7qudIID8yDsz8ucZ3gJV05i7WjPRt4ATm1c=;
        b=YG0gDLg3wo+v6C3lvQ+mwMdK15VEVleOmaZIIFQflBEWE/mbQ8zZ1mjT5CpAi0dy/i
         KWVAxofp8WhtvdWXAjBiy+ZLh/7M/tOeIxnS1m190Z3FCheQAXIGwBSWn/Sc2nyZUWdE
         lXN+zlfO66SptVxr5fE1pfC2cDhsba/w4C0hwUyv4jO4Pc+QOe9pb/BA0Mzy10euaUBC
         /3Ntsycmczqb8dUpdUfzBAZ2pdGeybs7bTb6OCYY9DwGPWErJCGwmNLiSP6qPBBLErKv
         4IOCz9bfUgasUW7rTVwMogwtzCVyL2ZzCog8QRIThGAsEyCMXOhsUKiOZ3cr+QIhAheQ
         0aRg==
X-Gm-Message-State: AOJu0YwWbwwuae57swhByfCcKaf4q7LXDLW1LmDT0Sb/gl5MQZTDiHq8
	EXcMsriYeTM9LD0z0BgQ4IQ5Ow==
X-Google-Smtp-Source: AGHT+IHAVwWhMA6v/POGZuJcshMw8zoXDI6R4vDpTtywy8ylzTugWHk11eEuOZ5m7x8RpjN2rWm3dQ==
X-Received: by 2002:a17:902:b401:b0:1cf:9790:f243 with SMTP id x1-20020a170902b40100b001cf9790f243mr12596195plr.61.1701149668646;
        Mon, 27 Nov 2023 21:34:28 -0800 (PST)
Received: from localhost.localdomain ([61.213.176.14])
        by smtp.gmail.com with ESMTPSA id u12-20020a17090341cc00b001cfb6bef8fesm5372899ple.186.2023.11.27.21.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 21:34:28 -0800 (PST)
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
Subject: [PATCH 1/2] xfs: ensure tmp_logflags is initialized in xfs_bmap_del_extent_real
Date: Tue, 28 Nov 2023 13:32:01 +0800
Message-Id: <20231128053202.29007-2-zhangjiachen.jaycee@bytedance.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20231128053202.29007-1-zhangjiachen.jaycee@bytedance.com>
References: <20231128053202.29007-1-zhangjiachen.jaycee@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the case of returning -ENOSPC, ensure tmp_logflags is initialized by 0.
Otherwise the caller __xfs_bunmapi will set uninitialized illegal
tmp_logflags value into xfs log, which might cause unpredictable error
in the log recovery procedure.

Fixes: 1b24b633aafe ("xfs: move some more code into xfs_bmap_del_extent_real")
Signed-off-by: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index be62acffad6c..7cb395a38507 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5048,8 +5048,10 @@ xfs_bmap_del_extent_real(
 	if (tp->t_blk_res == 0 &&
 	    ifp->if_format == XFS_DINODE_FMT_EXTENTS &&
 	    ifp->if_nextents >= XFS_IFORK_MAXEXT(ip, whichfork) &&
-	    del->br_startoff > got.br_startoff && del_endoff < got_endoff)
-		return -ENOSPC;
+	    del->br_startoff > got.br_startoff && del_endoff < got_endoff) {
+		error = -ENOSPC;
+		goto done;
+	}
 
 	flags = XFS_ILOG_CORE;
 	if (whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip)) {
-- 
2.20.1

