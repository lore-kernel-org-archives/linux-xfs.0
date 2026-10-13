Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743084AD4AA
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 21:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791926341; cv=none; b=NScRj+jrvHoXwXJam5+4llzCHPCIv/SuOcGufVWvqdIeiHTRvYbpq9PhaeaCb/w78xSm4kuj0ATI30HEuno/N10nUTLl0Dqn8Lbr+U7eVKXHggSeGxBsgWpbkvQVRfr2G3+fUylMii1OxcXt5ZzYqKyQmQuGT8htbHR0Od7pnew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791926341; c=relaxed/simple;
	bh=FENZ0bOApYW89D6YCATs6NuA07/6l/g0ltGJb2prZUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZo9Qxa8YD6JcsWk+pa/iadLak35hTU8trstu9SNu3QskT9d1ZTazbFNLLuv9O2cUyZ0NMO8v2hr+fq63tOxeMUtgyFktLrkd5eD9xVNXbzhd0p9uzyBYi8mdrjkRBokJ93gZuCiHGNTherSkmVCUnHif9DSZq6KPOYfJqooXSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XOc9Tz0Y; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=k/ejbl5x; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XOc9Tz0Y";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="k/ejbl5x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791926338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yIArp4yLtuHTkcHmOK9aSxtwUQ49n09EaJUJOpnBb4Y=;
	b=XOc9Tz0Y3JFZlvdagm8CIH7Xczrlc92flSgZquU70gGKOy/M9l0iJ3a/Z4RvYBytiqytmm
	ONNMfCTez97xehWhfEfGT5PEDClDUcj5850krMYt3yIBxt/E5lANQGu3SNZxEo4XU13usx
	vh5umj5Rdpbut1GikVMwkYCx/sP+qNI=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-232-R0y59zzMNouRMf6jMFfoPw-1; Tue, 13 Oct 2026 21:18:56 +0000
X-MC-Unique: R0y59zzMNouRMf6jMFfoPw-1
X-Mimecast-MFC-AGG-ID: R0y59zzMNouRMf6jMFfoPw_1791926336
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93cbacbb996so556728685a.2
        for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 14:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1791926336; x=1792531136; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yIArp4yLtuHTkcHmOK9aSxtwUQ49n09EaJUJOpnBb4Y=;
        b=k/ejbl5x2cyCXG4GFhRqWsCQsR6cjzdzr2dTN1vgujoD998bGckXLl5tCT2TT+gxAd
         VSUPwI1kv73rEpnDgeQtV345Sl+Svp4mMKK7Km0x40b5JgOUSXWRKwtPGYi/XasnvicH
         oEqtHhy5LD60mXj+G19NCOKaGn4xyi2mm2zGdo1PI6V5AQpbfEqUQT0OHNTVc7PGGkq0
         FtytKdnZ7+vQK7IepemJstzVRlZ8fi6cP20xLxSOL93ZEbzEqTd7V4HB/4hzdNKFNEVN
         cxhjs0t5tnw03wOWcMISCCDQfscWlGc3FjAlki5JTJRMn/x50vfr9oDlqnp2FBWqpZoC
         ifhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791926336; x=1792531136;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yIArp4yLtuHTkcHmOK9aSxtwUQ49n09EaJUJOpnBb4Y=;
        b=PxoI5SB6x9bBRn7nB9eEaJKo/1n3l+7TvtrM2wMuMaDSCrPpzseThwx1McZXiW7Int
         eyjU+iElRTw6D3p3WramazyupRffHpzOPTWXALQZ6cKY1ZgekIySCPjQXFt2wCrm9wP2
         HL+YXttxmZ2lDEaMCDUsTdm1v6Uk0tE4u+utBGEaH2hpccC87vKeBE5S+56sRVqJoC+P
         XxSzincxpkkWd2m4/up8ORrjcCKFpYz6d1Qyv/y1B+1kg1cG5k+IBLj211hvtVcn3k7Z
         wYWQd2IE1k+lioj/f/V/DiyWkaFdjS4E4rDV8sC3ZXAc+GNvHi/FngtNkZ6f2ujbaMlU
         ogxA==
X-Gm-Message-State: AFq9FYK9aP0Zw5Q2fED04OtArCrivuaBWCNdMa0gYclwrwJdh88ywbUd
	k6Qzr2Gha7BScbLEsGjk6HtzYNZtHc8PZYO7o6dJOgwbFz8sApdsdjn1rzM8DHo4q7yrvLox1Oa
	0+Yr0UNAyzyholguTGltYE0XAVOrS0p3sPlbotCUt8A1y8xDItiT1uyvF4W/IHywAQMmGz0KzZ9
	7dGqFducE70C9E61hinmHLkhncAGLOmhOZVH7HGEyGhiUZ
X-Gm-Gg: AYBFou2ihycSxB2R129HNw7crR/XOj2b55un19vMz8zHVqHksz3LMQRTxQylGT/Alcm
	NG87OwErbVTnbBzJPbxAmQBzMehLbIpYZFvmq/tyMwEBfvBQaBjybPpakyebEcBIcVM5RVPEG4q
	/T3cLzjTGYc5MTcpNKlMG4Tny6v+5wloAX2UT2lXzw9y5nSi2DcDfpvw8cAq1I7d49+VC3G3uEw
	b9FNPTzFQzOEq0MFU075d4l57adEaoGvSwmApkL9p6Cdneij6tjQdA/6pbQ4nrOhlSiF6MU10MW
	A1ZV1qb7HdHCoOafSqt0TApeeP8ygDj9K+OyUZylkZtGx0G6Nap58ykeuu0fmb7RZXJNeRkZKka
	79EfXL5+R9vM+QV1FwNp1jbhmS/41Zn89ppkh8w==
X-Received: by 2002:a05:620a:2248:20b0:93e:c12c:9dce with SMTP id af79cd13be357-93ec12ca060mr1540370685a.78.1791926336101;
        Tue, 13 Oct 2026 14:18:56 -0700 (PDT)
X-Received: by 2002:a05:620a:2248:20b0:93e:c12c:9dce with SMTP id af79cd13be357-93ec12ca060mr1540365685a.78.1791926335162;
        Tue, 13 Oct 2026 14:18:55 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef5051333sm330030785a.28.2026.10.13.14.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 14:18:54 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	hch@lst.de,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/2] xfs: add missing cursor stat checks after xfs_btree_delete
Date: Tue, 13 Oct 2026 16:07:47 -0500
Message-ID: <20261013211851.641256-3-sandeen@redhat.com>
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

Three xfs_btree_delete() calls in xfs_ialloc.c fail to check the status
returns indicating whether a record was actually deleted. If the cursor
was pointing to something that couldn't be deleted or didn't exist,
something has gone wrong, so mark the fs as sick and return
EFSCORRUPTED.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 17699f7c009f..bb6e684f5467 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1626,12 +1626,20 @@ xfs_dialloc_ag(
 	 */
 	rec.ir_free &= ~XFS_INOBT_MASK(offset);
 	rec.ir_freecount--;
-	if (rec.ir_freecount)
+	if (rec.ir_freecount) {
 		error = xfs_inobt_update(cur, &rec);
-	else
+		if (error)
+			goto error_cur;
+	} else {
 		error = xfs_btree_delete(cur, &i);
-	if (error)
-		goto error_cur;
+		if (error)
+			goto error_cur;
+		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
+			error = -EFSCORRUPTED;
+			goto error_cur;
+		}
+	}
 
 	/*
 	 * The finobt has now been updated appropriately. We haven't updated the
@@ -2164,6 +2172,11 @@ xfs_difree_inobt(
 				__func__, error);
 			goto error0;
 		}
+		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
+			error = -EFSCORRUPTED;
+			goto error0;
+		}
 
 		error = xfs_difree_inode_chunk(tp, pag, &rec);
 		if (error)
@@ -2290,7 +2303,11 @@ xfs_difree_finobt(
 		error = xfs_btree_delete(cur, &i);
 		if (error)
 			goto error;
-		ASSERT(i == 1);
+		if (XFS_IS_CORRUPT(mp, i != 1)) {
+			xfs_btree_mark_sick(cur);
+			error = -EFSCORRUPTED;
+			goto error;
+		}
 	} else {
 		error = xfs_inobt_update(cur, &rec);
 		if (error)
-- 
2.55.0

