Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E416D1A680A
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 00:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782864734; cv=none; b=Fx/NK4C/lfeksPhuFSGmPARfztONaiC+sIEgtHgtUiHYyVZegxFzbj6VnRb+Q29lY/5uAo7eup/bLP/EXK15tHgVrtRTjBGigCHAJSHZjBDLWO7UumDQfpT+zCmmCAD3Bi8am/g8tQ+CCrmgf9nCtPxOOAdFDaOFKaa47UINbAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782864734; c=relaxed/simple;
	bh=h59JTdqn/42/gchFGAM3LUvGK0F8x7ML/DBAqwZs1EY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvgGwUkuRJ4M4/v0QRDLG6qXPsBuErUeBeWhrEj+iuOjsjO7TKnb+/i+ykPYnQnjbLo1LVd4ATAGfVdESb3xUsXhonTbXH+vgKOKZ3Ckoh7yf6peIHLdidWUPD5K9JcKhXvGp7w4m2qIVWFJg5DIHfkNUfvdrxLGoqes5qkdFD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dsKvZAIo; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dsKvZAIo"
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7e9d7464b71so42498a34.0
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 17:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782864732; x=1783469532; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uUC+pIYjnCyM2bPhe5VdWcXqL/RoPGRahY8oP++6v8c=;
        b=dsKvZAIosQidEDEPPCxtfJTrXwIYA0ndsmHDWF3hASj71ZRTLkdzGBjMTd3cqDbDqE
         3d74Fjihept9QpEh82UwQnnnurdtFXYGVr5lw8oA5y+TUXTyyB8l7scap8xyeHFGxwyP
         6TVfD88dFHRpJg7U/IgxyTu8X1w0FYaVZm4dwiPJm15srQRe4MhwghYzkLKM1Umd5cZF
         JmpY910cxXeGiie7GRLTJFsuuYXJ0o/Z6Y61QQ0jvtrPF45QuzsLviyfWNIbgUpB0BAq
         DUKQR+V9DSNCGjMu2oCakaGWBOFWSeYMTgQw2m69UBZL2YYXSbaRTKn2sQ+VguWXq/YR
         8rjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782864732; x=1783469532;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uUC+pIYjnCyM2bPhe5VdWcXqL/RoPGRahY8oP++6v8c=;
        b=CqJrRsDFcsUCMVQj/CflbB6FxNgZ6nSPKr+R2kyVc6k7gNUf+D4Mnks1XrCmhh7rLO
         bP+WsXATAnzfD70i2HNCwPEZX+S33q/yxV4RUCSfRFg5oNbgJFCmofkVv5jSjxp7tvCX
         pnqyxxYvE14+hm4MTh2jgfENpmizZyVrd7+nIbo7BX0JYBckvT3sLh4gBGkL20YikiRy
         1MioL0iTUc/u0ro+AfFRVrKw/XcSSRCU3hD+45bQYb8UawPlz2EJB6p/H2N0n/K8Y/rE
         Wf7F0y4I88hKCts1S5AXn2DJbJqfLBRCEfVdFZMLBqEGDgcDKocBZrayNaxfkC7pslso
         rCMQ==
X-Forwarded-Encrypted: i=1; AFNElJ8T3+dFNrz31TkBRyCYErbt1kd3PKGyCe2xWDLxObw4sbo99182ty9OeE3PGqv/ppfWe4Hh0ONBTcM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBJK/SUvwC2Y/FH1I62mIXf0eNmoE5MksdKENYFbQdvGHTNPqa
	RdxYigdhgywRaazhA6JMJt7f3E6+94ocSPqHuDNat+QSzXsqWOw47rt3
X-Gm-Gg: AfdE7ckAHcgPXJSk5M9Pj67nwUyqPoep2oVSrkezCFKiP9M194mB2OgqGgc1oZ4jSok
	K57yfemO9gN1w0Fp8bKbVylgS3jQRqwfoV2tqHhcBbwx0F2xxWJD6ELMkz7D9Trhgmi7UkpjJHv
	dtR2Y0bHB9mr+Nf6LxxxYWYbdiOqY8l5ZfAVf7DNesJBcBAm2b7acUcmhnj+9RP3ksqkTFuPOXf
	1k+K72azE62FA/fFRMHGO1eb96vCNwivAmNaO4jZq5bGYxDlttyLtQ2bHPvDF/wWoM1bHy/GwvQ
	BQ+ONSLg4pD8yg+sRmKSG2bJnFve/w7BI+/BJ2WnNg1yCn1VLg+gNJKrPMjcBsTIU2NU5dUj5QF
	0A/Tt6Y/wDUnPOmf4wIkIUYh/VQyvJNap6V+ajAJ7oD3yxuHa9aWAHPtXZdknrBNFJwLZKvW+lE
	HRk+XsSe69qJb+pEO30eeQuu0F4QTULnT8VUuYjeIMthTCkV5QOaDIHsVCbQkWD7Of
X-Received: by 2002:a9d:3e18:0:b0:7e9:f8e8:d8fe with SMTP id 46e09a7af769-7e9f8e8e560mr1802853a34.24.1782864732015;
        Tue, 30 Jun 2026 17:12:12 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:4c::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e9ec2ba18esm3690107a34.16.2026.06.30.17.12.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 17:12:11 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: brauner@kernel.org,
	hch@lst.de
Cc: djwong@kernel.org,
	willy@infradead.org,
	hsiangkao@linux.alibaba.com,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 15/18] exfat: convert iomap ops to ->iomap_next()
Date: Tue, 30 Jun 2026 17:09:30 -0700
Message-ID: <20260701000949.1666714-16-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260701000949.1666714-1-joannelkoong@gmail.com>
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert fuse iomap_ops to the new ->iomap_next() callback. This uses the
iomap_process() helper, which finishes the previous mapping if needed
and produces the next one. No functional changes are intended.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/exfat/iomap.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/exfat/iomap.c b/fs/exfat/iomap.c
index 1aac38e63fe6..8d33690a562d 100644
--- a/fs/exfat/iomap.c
+++ b/fs/exfat/iomap.c
@@ -151,8 +151,14 @@ static int exfat_write_iomap_begin(struct inode *inode, loff_t offset, loff_t le
 	return __exfat_iomap_begin(inode, offset, length, flags, iomap, true);
 }
 
+static int exfat_iomap_next(const struct iomap_iter *iter, struct iomap *iomap,
+		struct iomap *srcmap)
+{
+	return iomap_process(iter, iomap, srcmap, exfat_iomap_begin, NULL);
+}
+
 const struct iomap_ops exfat_iomap_ops = {
-	.iomap_begin = exfat_iomap_begin,
+	.iomap_next = exfat_iomap_next,
 };
 
 /*
@@ -186,9 +192,15 @@ static int exfat_write_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 	return written;
 }
 
+static int exfat_write_iomap_next(const struct iomap_iter *iter,
+		struct iomap *iomap, struct iomap *srcmap)
+{
+	return iomap_process(iter, iomap, srcmap,
+			exfat_write_iomap_begin, exfat_write_iomap_end);
+}
+
 const struct iomap_ops exfat_write_iomap_ops = {
-	.iomap_begin	= exfat_write_iomap_begin,
-	.iomap_end	= exfat_write_iomap_end,
+	.iomap_next	= exfat_write_iomap_next,
 };
 
 /*
-- 
2.52.0

