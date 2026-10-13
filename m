Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92B954A7E9
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 21:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791926341; cv=none; b=RRfSVOJ7P4h8PJH7ygWhgR5c/RswLsGmRh1YAI+BmHEsUwQ7IPNwMYkJgKFjXW3zxTgK0uuy5ZulfCXNo84ljIHArkh/t5k47rBQPNXhvEKCvnMUveUkOPxVuqihwKDrL6oxuSqjVf8fQ+8/tvX4SSxKCTTBjXqfHPt6Ef/2iDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791926341; c=relaxed/simple;
	bh=uNqW8wEIZuKLuKXkap5SjU3EUEZAi0Qtd4ZIbijNgGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l00oR3hgHB0PkZmOyUZm2gS0/jRO07wQL3ZiPE2EYdQheXEvMFHvr8TvNQZY6BBnB4EvheCgf4pIVkhKUaa2Isd+8uDeGWnqN+VBsk7uGckGKcFug60Be9iB8X0Z9ltD0BotX+yugeyGNoBbXhlSzbWic0jWKPUml6rqyePD3iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R9rOVghI; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y5WDf0P5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R9rOVghI";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y5WDf0P5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791926338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NoVv155ZYveJ7g4biYazQwwPdti+jdXLfoWwkrsadgc=;
	b=R9rOVghIG6HUmq7Hgk9D78qV6B2vqu27hgTg19rFd6zgqrNKYbWBLiy7tTHTQAatcv7oib
	xBOP1XBP5YYLP5M7rwMsWOC3ThQhjqSbBUCkCNJbH38U1piWCH+EYmoRfSRQQ1D3NKsQaP
	ZfmuaF3MfSYeyNQH+o7E3s4BzfHWLY4=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-221-7Hkw2x7YPneXALMUf63yeA-1; Tue, 13 Oct 2026 21:18:55 +0000
X-MC-Unique: 7Hkw2x7YPneXALMUf63yeA-1
X-Mimecast-MFC-AGG-ID: 7Hkw2x7YPneXALMUf63yeA_1791926335
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93cc0b31ecaso710947585a.1
        for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 14:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1791926335; x=1792531135; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NoVv155ZYveJ7g4biYazQwwPdti+jdXLfoWwkrsadgc=;
        b=Y5WDf0P5klQqePmFcY7GV99/rgSlpcXbnOYHU1Gh2cevlGw0PH+sWugC2PapEusvJZ
         7mpuGzcgmFGKbXhQNwMwgHzaW0L+aGq0H3DPmlVR9m5phnrvgjTXOA0qLA20cDFOQ8YG
         ZSoYCceZm2IwxLLrjWspbs3sUWlWETkxyacpNIws2vSQLvqLndefVQMIvBUVFuo0gXQC
         xBXJY6OXVNUYe2j7gfvTj9sLFHLyfcUBTNuD8Br3wfdFvhK23XbxiQ29k6Lg/DpdkPn5
         aAf5ZLlHblygi2PMOEwpvf5WdHgCre4Gtl3Sx3Bvl2pmuN+VQQt/YiRZYVEdEiyyTVAy
         +SfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791926335; x=1792531135;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NoVv155ZYveJ7g4biYazQwwPdti+jdXLfoWwkrsadgc=;
        b=tefNw5F+kiNT4y49CV27fUggsn9ru6RxrUTlwCYlc4AVGee+jECPJsAnXabaYcgFGT
         EnxDN/5Io/UkGZ8kpoMRXtkOG3RvPda0wr53kBGUigGPzf7I5sboL5LQ5HYDqAmbXz4g
         CT5G8Xgrd+rHVUdcLuaDBPYQ319SegcfFjo8H92cWCZAZ0BfqzPnxr3iPwqBQNS7siEW
         ZFk2N2uoWo23M0k3I5Ejc0gAr7N9oXm8GPQeqZ7gH8fN1msZYKfgVgPNkYskPdQT8YjK
         eOKTaLPHumM1zsHsou2olFmkI9T+qWq3ukdiOIGY4U+ZFp9T0CLshJlydcrGLlj9gHl/
         KnBw==
X-Gm-Message-State: AFq9FYIzSiuXmpmNpjqtEWWoyVEzseBbTaAXI404YuTkUREYu5sQrQoX
	x8JiRuGctnGQX02lrXYQnIzMHRS7GurQjwviShfkvAtZDQIcvB/UMoFqo2sTwLkPEBCht7PXxK5
	m57SdHAY0+CRlNwIxoKYDVpjc9F8z0LThY+k25mBbp4ZPRC9wBTRuxL1VdEyrLJxrifH5pjjslH
	NQzD9v6LesC9dgWpGSZC+6/9G99812ZoS22Qg5TfP04ZNe
X-Gm-Gg: AYBFou31+EDwY3XV2p0s8S11Vaj+AvbwcQudPCPjVzp+8+XUO9NIU9ZESf3EtvQW1TY
	YaBvzVC1bRJTVZEFzBwYneK/zt61Eeb2drbUH0IpomrW2UvKMCWVo3KlcacZkiFSN6uSo0OkC4Q
	f8I20zrLAcPjrpOWRN/elWJQPgYLsIZ3NiY+ntcOby1EZzdJiHnhofD6ro8TsnVXpTNrFdVDU4l
	UkPl25gtCK3uCqBrt4ruf2cyyCacHvkviwI2hHy7J04z/lXVVQNcDQw2mUKTauVRF/GzQt85MVa
	0GOv775/uD4Sg/6jyQ6eLMvyUrMMlFQW23dN1jWTOXKPzjSAuZARU13K/61tLPQ185kec+0hKUP
	m1N2GcXbba3A5PzUhGLukoFNAtxom4xMsVM6mDA==
X-Received: by 2002:a05:620a:4013:b0:939:f61c:c335 with SMTP id af79cd13be357-93ebd2253b8mr2400019985a.26.1791926334982;
        Tue, 13 Oct 2026 14:18:54 -0700 (PDT)
X-Received: by 2002:a05:620a:4013:b0:939:f61c:c335 with SMTP id af79cd13be357-93ebd2253b8mr2400015485a.26.1791926334269;
        Tue, 13 Oct 2026 14:18:54 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef5051333sm330030785a.28.2026.10.13.14.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 14:18:53 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	hch@lst.de,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/2] xfs: add missing cursor status check after xfs_get_rec
Date: Tue, 13 Oct 2026 16:07:46 -0500
Message-ID: <20261013211851.641256-2-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013211851.641256-1-sandeen@redhat.com>
References: <20261013211851.641256-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The xfs_inobt_get_rec() call in xfs_ialloc_count_ondisk fails to check
the &has_record return - if the record is not found, the next
conditional will read an uninitialized  or stale irec. Fix that.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index e705f681ed44..17699f7c009f 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2843,6 +2843,11 @@ xfs_ialloc_count_ondisk(
 		error = xfs_inobt_get_rec(cur, &irec, &has_record);
 		if (error)
 			return error;
+		if (XFS_IS_CORRUPT(cur->bc_mp, has_record != 1)) {
+			xfs_btree_mark_sick(cur);
+			return -EFSCORRUPTED;
+		}
+
 		if (irec.ir_startino > high)
 			break;
 
-- 
2.55.0

