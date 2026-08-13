Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED05E431E71
	for <linux-xfs@vger.kernel.org>; Thu, 13 Aug 2026 20:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786654178; cv=none; b=qDZ1DHx3v7LwPWPtx9+8ArOHcuNsUAIcBuNN3fmxAmjwctC+347a72abRq9g/e21Yssl2Li39+h/kIBMiadLZ2DQvC0pcdu56Mp3vkUIwAM8wdX3/oiTmMu3t4qBXneAOpdzEVSjKRGkUWs3SgJmvjLrEziKZnRqiXBl4UlbWTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786654178; c=relaxed/simple;
	bh=FBkevjT2E07/2mjjzr9EZrn7htrjAFPlpSa/HCHLXsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvPL5TYTBJ4wjaCO3iMXPhWuxTGMX0rAaNkDmVNE3oorhpZH4aoc8uDnBUHr+Rw0aV67BJGLiQJeSpkhuLp2nmJ7yuM0FqcPiZwYyf3empfyzPSHnX0DrOG9/McWAm2bmZi48cromC62XC3GMGn2KotNpLYOCbysNpeMibn+S/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cf80yUMq; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=AjnmWBxp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cf80yUMq";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="AjnmWBxp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786654176;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aONRfqKHiXc4KQKv9HOJe1ML1WHA3J2x2iZH/V6rhN8=;
	b=Cf80yUMq5aUuzAy/IPGOeVAlI7tlnPgEwcLLyyeiqRmRRLyC3KuVltb4UctC4i8LeN8rk3
	BVzpo2tJnZyV3OKtDUUijRw8yR0EjvTNBde9h+9qmexkRy/mM69VKYVRK5VzMrnzeBY2/e
	YDAD8obsj5rTeB9QvqGR95Y0nPNOewg=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-669-9P-tThLGP02ls0f1Qt6wCw-1; Thu, 13 Aug 2026 16:49:34 -0400
X-MC-Unique: 9P-tThLGP02ls0f1Qt6wCw-1
X-Mimecast-MFC-AGG-ID: 9P-tThLGP02ls0f1Qt6wCw_1786654174
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4ab4dd46ddeso140339b6e.3
        for <linux-xfs@vger.kernel.org>; Thu, 13 Aug 2026 13:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786654174; x=1787258974; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aONRfqKHiXc4KQKv9HOJe1ML1WHA3J2x2iZH/V6rhN8=;
        b=AjnmWBxpJ+YzZ+h74BMrZ5oYKSf05YDwz9s25Hm2G5HMmero5wAn22xgvfR5mMKW0B
         HbkPn786XTkpQhRk6EG7yymoZ1pro64GPn4J6RxuhsplGDWMn73QSHSmWVHavVc5Iwsn
         5dBVJLUE//EUAzIcJ76Anwpj2r1bLXe8lb42XDWQH2BGV0R9Qh33idXde9JZr3zC1JfA
         YgkFzpxUkarRuhabelY88yIhzc3DT5J80nBIMA4TqR1i59l8UqVOHLCJ4UAS1WESbLcI
         gzf/r6plom+Pg7xAzLflY0XUdGs2gBqC6UpHaLJnrU1CzO0Jw138fTAyHOdMMULJXnjO
         es2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786654174; x=1787258974;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aONRfqKHiXc4KQKv9HOJe1ML1WHA3J2x2iZH/V6rhN8=;
        b=EIGkRM2BgyZjEIJxVrBbPLv65bx4K40ApyuVPuYZ9Ue6gpajFH2caowqPqfLagYDvE
         fwvwimw/wGrg/D9zcu8B5n0VakFDhwCuYn1pmLlblz4Tf/Rw1I3hm/qigusTdhXdlEvs
         jwG0fyjirf8xOJFUoHCGl8cCE93cHMC3Scy3dD4WMtqiwU1xr1fYPJ5t0YyvCKM4ZAUf
         duX5ZqCWd4z5kQuaC9DCtKUugTsCkhn1L5tzYbP8K+SG/WD81/6TTcIDuRUGLSQMf/S/
         BVI63h+rGdUDHvy5Z+pfZgOq+oIbo96aYwC3HIXgV99CHyu3fbUc3iMKSe2SRgyUkqmW
         AxGA==
X-Gm-Message-State: AOJu0YyQP5yXSj2OAlXOedE83212sjYdO4HTq//9RH2Ss2clDNpjndCK
	dCHPp+rHnITSKJBs2F9AlmEcN+kxpze6AwzHh1ExOyCrum/gqV3HoRJxo07IRTK2jvN2ECSzG9C
	g8dXdK8RTdNxDPv9AMmwhNSrI0DaJ0Qq1eys0Lk7/iCOrEdYOERBr2tC1zEoaCREKO1shLQ2J05
	PrYFV1MY7mC+GAAAetIwp2F10biPM1jHMUhUMDwndP8hcVizm3pg==
X-Gm-Gg: AR+sD100IfcsD71lwydN6IkyGY5rMnOFU2CjP1Xm4jP5RvgwOB8CiV/EJPzw2s2OO5C
	2vyye0DyyKSwK79RemgMc3SxiVccVb/lXQGJX1NhEoitNTb511M8COJtJvrEThgHlTrXpVaoAI8
	HtXttwwGLxfCNMUX5UR1Y5nDLDXuh5fnonArPTQUZKJBUnYXzw2gHg2A0iG7P9K5onobxFc4ffQ
	kw9HG4CrNVbBQWHC0Hwa86hey7XvXoh4kIYOLZQvOp8cVtm5vfNjQHemCbQaC+5kpmZzWRi2Yzk
	NYu1mPc2ak6mUPbjJCwW+3HnNxZEtetXvqA0etwGDFzVku0gTQCQj4ba2RKm3/9zjqKkqoHTp+R
	pE6uYchtAT9xrnL5uz9l/qbR3yDr4qNrSNafXdOAZNYA=
X-Received: by 2002:a05:6808:191d:b0:4a3:d333:2258 with SMTP id 5614622812f47-4b241cf3d20mr715203b6e.14.1786654174053;
        Thu, 13 Aug 2026 13:49:34 -0700 (PDT)
X-Received: by 2002:a05:6808:191d:b0:4a3:d333:2258 with SMTP id 5614622812f47-4b241cf3d20mr715166b6e.14.1786654173544;
        Thu, 13 Aug 2026 13:49:33 -0700 (PDT)
Received: from big24.xxmyappdomainxx.com (97-127-68-83.mpls.qwest.net. [97.127.68.83])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b22d004c3csm2555958b6e.18.2026.08.13.13.49.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 13:49:33 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: linux-mm@kvack.org,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/2] xfs: mark kmalloc'd xfs_buf items as __GFP_RECLAIMABLE
Date: Thu, 13 Aug 2026 15:40:52 -0500
Message-ID: <20260813204929.2253988-2-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260813204929.2253988-1-sandeen@redhat.com>
References: <20260813204929.2253988-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_bufs have a shrinker and are therefore reclaimable; mark
them as such in the kmalloc path, so that they are accounted
for in this way.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_buf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 48d7dfd3e15f..2e00a33ebb62 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -145,7 +145,7 @@ xfs_buf_alloc_kmem(
 	ASSERT(is_power_of_2(size));
 	ASSERT(size < PAGE_SIZE);
 
-	bp->b_addr = kmalloc(size, gfp_mask);
+	bp->b_addr = kmalloc(size, gfp_mask | __GFP_RECLAIMABLE);
 	if (!bp->b_addr)
 		return -ENOMEM;
 
-- 
2.55.0

