Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E58B2581;
	Sun, 22 Sep 2024 17:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727024884; cv=none; b=T5H+8V2TYlzbIYPfDW+i/zP0LWW8RXtBbFBkGszMWImeeRzTHp/qIY6CJHFcuHYUlUfAUM6sv+1iXHwQ0WTYbHraGOr0j+w1S+8Ig+oeVKFN/exgNhMdYbp6GnaJSuuUeuHw+0DTGkmRT/N5q15jOGBEE3+T6FuUV3ESt8oToHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727024884; c=relaxed/simple;
	bh=x7s8RISRd78v3+3BDolULM9nVmrkU4bjG9Pa+rjeYWU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NQVovl39yQCurI+eDmsI+8wfJahD3E17OHLOsmg6UfjFuzB6clkuXnjZxfXqo7QeSM7jnXR8QQOrTiVUqqK0pLhidv1yOJLrE9+lL5xFV3JSaEQVVOERkMk1e4jHLWGV0kuZ/TQvfpz5rKozIDFLEkNFEI3LeOsxTa1rfPhaPpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lsEXIJbe; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lsEXIJbe"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a8a789c4fc5so779020766b.0;
        Sun, 22 Sep 2024 10:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727024880; x=1727629680; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UfUFTKvz+3D7GwXrYdNdqlyY+ceafuxUEvLi56eVGDo=;
        b=lsEXIJbecYBYyF9H6af/z8xvewCER75qEMXCj3fcJSZwa5Dw/IdOW6Vabm/VAIcgUY
         4YXvKEEIRJx9x65HlZrkjonsd94O4w2RF43sqxJ36a76cLv9x2WwlYwrbjmUlKpAhCTN
         cv/FnVg2hxPxS4lGvpNAF3Nc7G8/l9Dlalq5TObBXlr1rbqDm+gvhOno7p5Li7DECd5A
         sGPdNn+aTFk1NfZYsYNNjkJkF/bf3cZTt0ae9EvH9BfCb89RKuWx7U9X61JA//aYvU6C
         kkb3JFJj3NNEWDiHXpbWDqGi9yq2YJSi0N+LJLMPgSSGpgbVN9qEPbH63D2i+agoUn8T
         JvIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727024880; x=1727629680;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UfUFTKvz+3D7GwXrYdNdqlyY+ceafuxUEvLi56eVGDo=;
        b=jbkaUY+kP6G0kXDRM8blHnXyX6G2K9KUQo5Q0W8QzNvDB3k4tucfy68aXuWvXMeQdD
         V3gLus87F3xutpX72x8QmPATrXIIpGMDFeekprGmOYtZ2hu8bkmGJMGvo1PcFjZuu7UF
         ioqJns3YZZMbo28HMp1ekn+uQ36y6uB/aZSW6ZsTMzVdDIxje/xEMXlGcV67Q7+dTuTM
         o7jcCBzmd/lbfx8pY5DHzWDHx2O50MmeOKINFzpgeaF7z6dCbzybBAIdDI0+GjNoH836
         g5yJUK80rj9d0jNtHIBIKjSiMbBEnkSTa3FUNYN1BKa/uiPWjU/AvMhtf42Smc6QN73k
         ENxA==
X-Forwarded-Encrypted: i=1; AJvYcCXhLCaQnBq15IKIiQB96FeX4uhSExwktVvL60VPp3aY6WPaIoMUZQh9ZwHnfEKjeuLTu+rlNehCZQItHr8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnEtzTwzf49MeJhSbHU7Ogq06QRpU14uGF+O7CATgNo2kA/Qpa
	6GxY5EhX7GsRnoihJ2tPNLGdzQfK71r0ahib2vQH2LXmZDA44WM7SzTk/IbT
X-Google-Smtp-Source: AGHT+IHhorG+TYexZcYTn6Yu61PuNduE83pZTN8Btpz4Dy0RGopV9j/L9lvjMv9tECSMa7GyDPcD0g==
X-Received: by 2002:a17:907:1b20:b0:a90:34e8:6761 with SMTP id a640c23a62f3a-a90c1c37176mr1416981866b.6.1727024879593;
        Sun, 22 Sep 2024 10:07:59 -0700 (PDT)
Received: from localhost.localdomain ([46.248.82.114])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a90610f429bsm1098376866b.61.2024.09.22.10.07.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Sep 2024 10:07:59 -0700 (PDT)
From: Uros Bizjak <ubizjak@gmail.com>
To: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Uros Bizjak <ubizjak@gmail.com>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2] xfs: Use try_cmpxchg() in xlog_cil_insert_pcp_aggregate()
Date: Sun, 22 Sep 2024 19:07:16 +0200
Message-ID: <20240922170746.11361-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.42.0
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
Cc: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
---
v2: Move cilpcp variable into the loop scope. Initialize cilcpc and
    old variables at the declaration time. Use alternative form of
    the while loop.
---
 fs/xfs/xfs_log_cil.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 391a938d690c..d4e06e6f050f 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -156,9 +156,8 @@ xlog_cil_insert_pcp_aggregate(
 	struct xfs_cil		*cil,
 	struct xfs_cil_ctx	*ctx)
 {
-	struct xlog_cil_pcp	*cilpcp;
-	int			cpu;
-	int			count = 0;
+	int	cpu;
+	int	count = 0;
 
 	/* Trigger atomic updates then aggregate only for the first caller */
 	if (!test_and_clear_bit(XLOG_CIL_PCP_SPACE, &cil->xc_flags))
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
2.42.0

