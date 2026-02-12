Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983BC3EBF1F
	for <linux-xfs@vger.kernel.org>; Thu, 12 Feb 2026 14:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770904976; cv=none; b=OfFnIzK1ZoHqX23aVPZu1YCZTAkne+q04RH82qUSBrTbK3EwN1fvfugAT1JQbdKAiXbWaY3+1oFW6y/SZXCywrUVjjizeYPaJ4IesY88Zds1NGomNeWdMWUsNy6zJfBadFI955w4slkxVvt8c7ZmgIrPpchzB2ZIWtv1A7dkkek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770904976; c=relaxed/simple;
	bh=FNTGq5odIoD6ux1Q2SQxxhwf4R5DiSMvaRiW7E2N8gE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bVsVikgd2XZDsRno+cgYLChmC0mpoG7yep/STwupOQQk5G9K2I9D7nA3QrrQvSVQwf3cV6bbZuPp3tTrWe/CoVn7wenK2+xwvd3MbyFsx1F6AgqEqJNWxeIzT/8vrsctOThVIVSUijvzG1WFxsaNgc78LrR5B+iAiCXWxn9DWKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XvpyNTua; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XvpyNTua"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-824b5f015bcso670786b3a.1
        for <linux-xfs@vger.kernel.org>; Thu, 12 Feb 2026 06:02:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770904975; x=1771509775; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bucPodXrYfixky5GBqiFMDbKsA1RMhFiOisELNmABw4=;
        b=XvpyNTuakuc4HETUN14OcYSosbZoImaiCiORtX9rBMjB+uaJvBcJORBu1mTRquEjO5
         Ee99Dk+SNch1ICeqyHU24PdKhZwPN6YaKL0Qkb7on5mabihh0KEFt9wa6g/BEFRJjLzZ
         etSz1uK2apuomBtae9KVYRdey0R1g3cICkJeO0YazY0E5C0Qgisuzp1GBx5x6fLUzv/V
         pTNCb38/uny++25eTqSOj7Nhz8zzrsvKScq87rpe0hOAlxqlz/k+6mo0hbqGSYmRT1D+
         Nie+B6HA9YbvkUGYylSnSz1VE2j964TQVTcs3CeIT4j4CZH1gwVRR5DjCgbm0eB5oKQm
         UhaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770904975; x=1771509775;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bucPodXrYfixky5GBqiFMDbKsA1RMhFiOisELNmABw4=;
        b=YvEGfAanqNIUb3FTIP6Yf51UnGw9qsPSiBWoeErYzIb9sX7wkP0k3vw3baJFdqQg4z
         hZsl7EEUKSwzpBkuvr/N9QSbr3gPXF3Z7rD5JOvMn7QTT832hwHgvlPl0zWq7If5hTu4
         2PPYJ7AaG5WKuckuJDRB6m8Jwq/GEdbaq0S9/AWnqgD/CYsUs6hceJJbZFulQr0E5DNl
         0UN6iXXfvCbDXSspEpeITrgY6rh200LFyBsKKWAV9btUeYgpWYigsQFedpssTPEyNI3z
         6qTBUl4Gr0ce/DxqSY1fqPV/ABrQmJJTdHS1iF/YftLCg6vgCMRhHLmu5NKJnxZ1s5af
         SEpw==
X-Gm-Message-State: AOJu0YzBKZn0+4sNVYKtToJqbmsps+RQNAOl+jcrTtru/eZBjTxmwAH7
	IdUlpTxrwJ/9wJRR/2WcRprB+kEgiLOY84wgBY3xr3l7tVfYCVKBIu+TZcphfA==
X-Gm-Gg: AZuq6aJAnY6Qnmct9aLC6Idu4sVBMtZ2vQRz30+oUMsSfWU1GLfdOyKaldziIiInu2N
	pRnmyjjyplFiBgFl93tJfEA+hKgYD6B7qWHQCRhABdhA4aYqNK//AXjt8sWLNhAyTkOYAFkGz2m
	h9JkbhetMY75a/A7iqZF/vkIii8NAQizS7UCjjivaxs/7DdHMta5G7yPiH60af1Mnq4fPTioXc3
	DirUEdWO1bBodMQE55ozykJJpHJZchUnthxyVlruSg9n8W5YueiHY8KRBuk1I4yDElQN9E18+X5
	EucDIahjUHb7uZYzAx1AYM26cAMcKv4Yg+TqutaU/HnO+NdcccjbN35bcDcYCbZ/GluooA4QERa
	TNbjED9MZf7S26HVfcGUKeMPkHA79o3ZSzuMKB3Sjl1DdXYwETTLIA+cvsEYjw4ActWyp76lYEo
	OxSMkt8A+D2r7kKCodkW29tYFG78+dChFG8ShVTUo/W09wXKInZC9eNJQIdkdkhKSFdmzaJxEM9
	SUgm1E7lA==
X-Received: by 2002:a05:6a00:e89:b0:823:5729:a12b with SMTP id d2e1a72fcca58-824b05975fbmr2288696b3a.50.1770904974830;
        Thu, 12 Feb 2026 06:02:54 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com ([49.207.226.188])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8249e367b7esm5116590b3a.4.2026.02.12.06.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Feb 2026 06:02:54 -0800 (PST)
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: djwong@kernel.org,
	hch@infradead.org,
	cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	ritesh.list@gmail.com,
	ojaswin@linux.ibm.com,
	nirjhar.roy.lists@gmail.com
Subject: [PATCH v1 3/4] xfs: Update lazy counters in xfs_growfs_rt_bmblock()
Date: Thu, 12 Feb 2026 19:31:46 +0530
Message-ID: <edd86fb5739483fb016fbde304d72bb7325782a0.1770904484.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1770904484.git.nirjhar.roy.lists@gmail.com>
References: <cover.1770904484.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lazy counters in xfs_growfs_rt_bmblock() similar to the way it
is done xfs_growfs_data_private().

Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 fs/xfs/xfs_rtalloc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index a7a0859ed47f..0aaa6b1afdaf 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1047,6 +1047,9 @@ xfs_growfs_rt_bmblock(
 	 */
 	xfs_trans_resv_calc(mp, &mp->m_resv);
 
+	if (xfs_has_lazysbcount(mp))
+		xfs_log_sb(args.tp);
+
 	error = xfs_trans_commit(args.tp);
 	if (error)
 		goto out_free;
-- 
2.43.5

