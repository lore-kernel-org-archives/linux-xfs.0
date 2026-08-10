Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6D33B19D9
	for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 23:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786403199; cv=none; b=PekXKCIJljCRyqX0BpkM1dRqjO1EyisPBP7i9Hyq4hDrmHL5NL27or0FV9YJkC6qYvOJJtSX2ojkurJs82XImYZWSVojVfmfZdMT/Im6rsqit7VT8Y+62nz0p6r4IzKdtOvN6e7tr1lS9GtZjdUBM6UU9UyOb5CrAjrg/lDz6CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786403199; c=relaxed/simple;
	bh=ew41Ui+Mtu2XnI7H4myAGu1irg8mIu7VyIpeibPsk80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+CkLpHg06eBXm6KGx6vYrBdoi8zE45bFCa86ViN02D4UmwVAVb7qVtA8nt7mHoGLmEt/yvi4Q8Be2+WfBDSOxyEbB7IV+wNmJBh0zuwzeY3longnHDf3EDdCFrWlsRIk9NaN1quYR4f7lW70VmoiFpb3cCcftjVtmpEucbgMSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com; spf=pass smtp.mailfrom=peridio.com; dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b=sfkP9O6l; arc=none smtp.client-ip=209.85.217.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=peridio.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=peridio.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=peridio.com header.i=@peridio.com header.b="sfkP9O6l"
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-7395b602bb9so60402137.2
        for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 16:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=peridio.com; s=google; t=1786403188; x=1787007988; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0usgXpPODhk9hKOhk5YF9ap8MJxRZDFzD06C8UqMFw4=;
        b=sfkP9O6lLFSZnE4vCGuLS4uStO2b//FYDV0zuYfKFDXfSH2aORr2nqKNsS0cuuvChp
         tTEdU4dK9wKrgd1YcDhMVNEgMHKELpPc94KgVKiNsEd6RgDNVJvoiJEhxuxJVIpfzTUF
         PJoahhJk4eKA+Txei4UzCDsWItFYUmm2KTfgLbE3Wwy6QdGK667kqB537h2IQdogOZmO
         Yi5sCNG2AdcmugBjrmhVsKa79PJNz58icppFbfl34wXznfTgIdNrFv2RGHccqr0Zw0wp
         h0DMLCoyhHvFhYrCxh/v6nx01RgMsOYIisFpOHKh42Nb2CkdK0CryDYeOF/X2sDKZEOu
         QtZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786403188; x=1787007988;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0usgXpPODhk9hKOhk5YF9ap8MJxRZDFzD06C8UqMFw4=;
        b=QmM5EVPj/CAx/HZsezose1U1gmDZc/h/5Uv+utyekEpeHkkF0fzS3YegeD/1C0M/6J
         UJIWVpgwdsZBZORNxsK1cAN1M4Gv8hN8ARsQy1b1GdMSz8ovKUQeFv7DiEtufO5vchAl
         u7NeLBmz5yOfA3ZsX8nii8BNCBU43o8jE74V699cBIKK9lzoc9Nrr04kym3Nk8QjgMh/
         urzBg5skl1avL2MGLN3uw+uDYWV9CT8J/N3SouZw5EzU78aUN1x15Vsf8D5EVZ9jBEjl
         jWGV98MS7VodTdoocbES0ZHJtN79WHJh/pRncbPUxyz80ZYd94gyQeQvTPAb7R9RvW7E
         D+DQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp8K3ZLyhG2rIuQbi6CV2reTsgVSAXPTXk4Ya/8DY2ojx0a+Y6BYbhtTTHSrb5uS8BWPbTymhIj0WM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLRk0DCXTfczx7nuucprRZUFuOckbKSbvYh9DOKCpj6DpMZ/fC
	Rdskai7DhBbGK1k7H0WUud+36O9c+HVyzZ3qGkxLjEwCukz5jisISmfhcuJKvAoj4rY=
X-Gm-Gg: AR+sD11w8W0WCrTaTiWnLC3MEDzwG96wo0/mPPBByzhH7mI8Ji4jPcRIDqP9NcNEkSl
	JyN53vaUMsCS1QAUiVkHI4vgp2YOI3OMPuTFd+HgXyFCt/uShzpa9fFG3Vatt8OGUISE55TBnhc
	7RuLf7sv7KynS09GTL1edWC8Ar6gvjpka1/18HI42OiP31t7YvTJCzb3eYLaF5HKCle1acG6/PO
	DzDlqKg1lK2MnzawxA4RCUL+cQPCiOtSooFjsHLuICFjoKUWKZl9KMYxM7vBNfPWjygeK+r0/e5
	oCglsW75IZKRiSdDX/Q1lWt4paikVSquz/7XYfHz2rkAdb6eH5tOuftV0P0CsB2dbp4xAnMMJ8z
	f5q3SIyuNibnNMFJfqtXaGnZ1CHGAWVYyvrNvDhWJHXgJudDp4O9sba9YCfQdxnmtKmBR0O5f5b
	vb5kkYN6anAOmWVjcOnx51qOHxtK8C7UHLsKdmhKER++LkflBWPnKvhsp17j7mhSwY
X-Received: by 2002:a05:6102:3ed6:b0:738:9abd:9ebc with SMTP id ada2fe7eead31-760e79e969amr6666021137.0.1786403187350;
        Mon, 10 Aug 2026 16:06:27 -0700 (PDT)
Received: from localhost ([190.113.101.40])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-764013f3489sm5458692137.12.2026.08.10.16.06.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 16:06:27 -0700 (PDT)
Sender: Javier Tia <j.tia@peridio.com>
From: Javier Tia <javier@peridio.com>
X-Google-Original-From: Javier Tia <floss@jetm.me>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <achender@kernel.org>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 6/6] xfs: assert the reservation covers each da fork growth
Date: Mon, 10 Aug 2026 17:06:18 -0600
Message-ID: <20260810230611.2859909-14-floss@jetm.me>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260810230611.2859909-8-floss@jetm.me>
References: <20260810230611.2859909-8-floss@jetm.me>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1124; i=floss@jetm.me; h=from:subject; bh=ew41Ui+Mtu2XnI7H4myAGu1irg8mIu7VyIpeibPsk80=; b=owEB7QES/pANAwAKAbXuwwuoZ3cfAcsmYgBqelljtjemURn5LRpl6Wz+JZJUD6qD/0CqLlJto HUOpnbw1W+JAbMEAAEKAB0WIQSbE7ILzw7eI0VKk8m17sMLqGd3HwUCanpZYwAKCRC17sMLqGd3 HzrZC/91IQKPbjMT3p8vIklGy/xQ9Lior9axlrMh3lEthy5Zpwiz/hCOKjP77kZyxs1zfZvwDW/ QnTfns3MnXxv4cmZLEC0gxgsAd6K9gsLXk7L65XuVWJRP4Z4AdlzhFHH8oJjrMP+3G6nJK4vQ6k XtsJkN0AUHVuHVlgV3ze4erwUUCnjiT3Y3nli4U0KeuNE+ZubSx2kASv0br6X73MmvicSpubuTb qm6sBFmpmULN1PyYIjD8Ov/FNipxbgL0OhGigtlKUOKFaHH1Kv6K4mpQN3vL4pU3Kb2Gx+Q/8lb aKMID4915/N+dni9RIswOcT/E9XZgbKQAa9CibLrap6OR77zZr6ar3qAJlTM9hOCsSg0VSQ1zwa Q56AxfCBd8lR+0EOAAFc/FCeTejqx+sj0E2BGicHHzS08ua1T5oNSG3pZmC6Yc+Hpbyq9qz52zT UJvZPyt50o7olsvORStgAFX9wQ2NLHir6QerC4y6hHBVROutdCzHJ4tcB1ewMTpSRsATg=
X-Developer-Key: i=floss@jetm.me; a=openpgp; fpr=9B13B20BCF0EDE23454A93C9B5EEC30BA867771F
Content-Transfer-Encoding: 8bit

xfs_da_grow_inode_int() subtracts the blocks it just allocated from
args->total, the caller's remaining block reservation.  The subtraction
is unsigned, so a caller that reaches it with too small a total wraps
the field instead of failing, and every allocation afterwards runs with
a bogus reservation.  Assert the remaining reservation still covers the
step, so an under-reserved or uninitialised total trips in debug builds
instead of silently wrapping.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Javier Tia <floss@jetm.me>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_da_btree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index ad801b7bd2dd..9be407affc6e 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2385,6 +2385,7 @@ xfs_da_grow_inode_int(
 	}
 
 	/* account for newly allocated blocks in reserved blocks total */
+	ASSERT(args->total >= dp->i_nblocks - nblks);
 	args->total -= dp->i_nblocks - nblks;
 
 out_free_map:
-- 
Javier Tia

