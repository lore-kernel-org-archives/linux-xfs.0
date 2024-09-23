Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C073545003;
	Mon, 23 Sep 2024 12:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727094211; cv=none; b=YpJjApG3zjCeWdOpy6OTkb22JErOgIvsK9fgBpO2D26vYmz8+5Wz/8JTBYxoBy1L2r4Vx7u2F1uqy5pUPymT5se7IMm7BaCfVlG6+vxY3qYOtlIzJ4v0Uz6Q3vmWHHuu3tqI6lopDPp7k/8v6vKz9/Xm6WHUPil8RoaXVG3tudQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727094211; c=relaxed/simple;
	bh=0SVd0zGyyh9qGrjrN2czD3IyjJNAo/bzeR+YGYsuev0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oH4O439o+ZwxAGDKzxgMAP9+rM18WF/1mdJpUX6MIyCggeBENd/mt+Bt2FdgecjHSnKPReWGQ+l2RgyLm3y8yurTyDT1tEm7uhs9n6ezMkjECsdrr35VKB7kWbfjgZu1siuCeKKMZ6/+j3IdueJvoOrrJdR8DpLErA/U1i2nF2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VwHN02O/; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VwHN02O/"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a8d3cde1103so297676566b.2;
        Mon, 23 Sep 2024 05:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727094207; x=1727699007; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Z3XKdtRE5qtz9cJHXcmgIftYO/sGI6l5+NatJXHoVAc=;
        b=VwHN02O/Ev+rHk7YZE20sWRpU1OeXUxLlGd3QbbGLHGF0TcPNIRxtWxZRfA5+gL+wW
         CNc0v10ByrN7N/CVsQhdQ/RvU4s0BjUKyHxXqcoImunQBy0jcSteTM6srEbDw/aKvN3d
         QTXUMnFf5BjGiZUuSoyN+MFDqmHZH4MSIYPYNnCc4cg5l16mm16+Mc3uXdWxmkuD7iOZ
         ZszemFRgEP3CC4mWMQJmW51rzGm6q/bBwGHA6+/BGu3XFJy/kqKpArYUZg0MvY0EGRge
         +vjkLUdKpB89+nje+pXrztqTubbz0+9EYk8uLTDL9lMosb/GmVsQ3fd0YOCHNMzYId7k
         +l4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727094207; x=1727699007;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z3XKdtRE5qtz9cJHXcmgIftYO/sGI6l5+NatJXHoVAc=;
        b=T3gruB5wcowhN2zs9x2BrndtLxkF/B3Jzb0xOaQPREdEfhg49z9inKOMF+VxIy6mcm
         PMDsAt+NDGqvQKBFc73BT+ZV1SGXdrE2dGKNjqJiuI6R8DICEMATlmlCVo/q0C+9bGPC
         dUeIjiMlAXlEBQneYdJOrZ7HC6T0REi/MNABcR7z20SkXKGHdK3NDJ24iRlX7F6nC3Jj
         w4ozUIcIvr1q7KQMgVfiwfz+ByxrGElvQ1g8K9LXxKuXpfBSSOXW1dG0w7OrbsFC/X6+
         UKj364z1LlbGDe/i/WYc4yuIHPcDUWjtbJT+E+2itwAUD7fgi/CMzCOTzMaOkvun3jnE
         7Bdw==
X-Forwarded-Encrypted: i=1; AJvYcCWPOF6NSAfl4sr3xJ/yMHv9U+vbtW41HhuImNnkzCNUaabEtSGCgjufxLd2n08gSnXkgkSWQhGghxcpnRY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxC/6KYd4QzIuUmgUWFLuoWcyAggeAi2N6Ub/T7EzgqD7d+Z1TX
	bGd22CyJjk/QECYBcNK0ArYr6fX1hZuZgaqBUlClq5WG4kDylHiKpGM8lfIn
X-Google-Smtp-Source: AGHT+IGbn9glsOBF0IKYgFxvCTz3POKB5ljAhE/ff1b62PtxZ+6iYHeIkm10ei4XYF5EpCH3rOSpKw==
X-Received: by 2002:a17:907:d3cd:b0:a86:820e:2ac6 with SMTP id a640c23a62f3a-a90d5614617mr1180551066b.22.1727094206963;
        Mon, 23 Sep 2024 05:23:26 -0700 (PDT)
Received: from fedora.iskraemeco.si ([193.77.86.250])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a90bce77c68sm665296166b.66.2024.09.23.05.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2024 05:23:26 -0700 (PDT)
From: Uros Bizjak <ubizjak@gmail.com>
To: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Uros Bizjak <ubizjak@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH v3] xfs: Use try_cmpxchg() in xlog_cil_insert_pcp_aggregate()
Date: Mon, 23 Sep 2024 14:22:17 +0200
Message-ID: <20240923122311.914319-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.46.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use !try_cmpxchg instead of cmpxchg (*ptr, old, new) != old in
xlog_cil_insert_pcp_aggregate().  x86 CMPXCHG instruction returns
success in ZF flag, so this change saves a compare after cmpxchg.

Also, try_cmpxchg implicitly assigns old *ptr value to "old" when
cmpxchg fails. There is no need to re-read the value in the loop.

Note that the value from *ptr should be read using READ_ONCE to
prevent the compiler from merging, refetching or reordering the read.

No functional change intended.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Reviewed-by: Christoph Hellwig <hch@infradead.org>
Cc: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
---
v2: Move cilpcp variable into the loop scope. Initialize cilcpc and
    old variables at the declaration time. Use alternative form of
    the while loop.
v3: Undo reformatting of variable declarations
---
 fs/xfs/xfs_log_cil.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 391a938d690c..80da0cf87d7a 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -156,7 +156,6 @@ xlog_cil_insert_pcp_aggregate(
 	struct xfs_cil		*cil,
 	struct xfs_cil_ctx	*ctx)
 {
-	struct xlog_cil_pcp	*cilpcp;
 	int			cpu;
 	int			count = 0;
 
@@ -171,13 +170,11 @@ xlog_cil_insert_pcp_aggregate(
 	 * structures that could have a nonzero space_used.
 	 */
 	for_each_cpu(cpu, &ctx->cil_pcpmask) {
-		int	old, prev;
+		struct xlog_cil_pcp	*cilpcp = per_cpu_ptr(cil->xc_pcp, cpu);
+		int			old = READ_ONCE(cilpcp->space_used);
 
-		cilpcp = per_cpu_ptr(cil->xc_pcp, cpu);
-		do {
-			old = cilpcp->space_used;
-			prev = cmpxchg(&cilpcp->space_used, old, 0);
-		} while (old != prev);
+		while (!try_cmpxchg(&cilpcp->space_used, &old, 0))
+			;
 		count += old;
 	}
 	atomic_add(count, &ctx->space_used);
-- 
2.46.1

