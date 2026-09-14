Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85803B27F5
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 20:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789419159; cv=none; b=gcChBZDKxx+qj2jnt+mad3V2pgpHdiF9of2wvOszZFr+u3/z9E8DhS2tkawDYsx9hr3JIZiaiCIOfLGJhU7Lm2thv2HVsmOBxZzLl7npBNmzuu4RmQuP/2ClrOhzKDHok+OpEFJ1j5FDSoncJ7MSSqL13a8MokyNCwSiA4+xNnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789419159; c=relaxed/simple;
	bh=1U9MtmjQS8rTsFetd5f9gqtGeAgV5Hb2oCwC5wePK10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i1o3hdKkGQlHrQnw6G+5Zd/JpxETrNvoYRyp+ffpiMlVpwYoTo+93LcJzurlE3T5kRsU5ndi3rn7YOXLl/ayxINrEzTh0mOiS8pu0d6WdtwF/XVi1If6ZArQPzNfhb9/8CAhEL/vrsvAWWRkJv5r6DujvvO6Q6fHIaOws6mMO8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BJLTgqKa; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=cr32cgAQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BJLTgqKa";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="cr32cgAQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789419156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zdYN3TkuPCTA83dlb0z2HolmOPBsL0A+P6pUFC1TV6o=;
	b=BJLTgqKah38xVOWd0UivSxBgMHgma7O9WKlj0FKkJIC3eJaL0l316yfg4F8teEzEVJGPa6
	xwIbkLVlZ3RY9Z6w7nqZySR+Ej20ouXIBb1xHrDRIRkOWG4leDWh0/mEbX3z5iltmd003t
	iSE36bft+ujDKpG92b8jA18/nB+SNU8=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-364-cvj6r-bnOB-v-1ObHJ6DIg-1; Mon, 14 Sep 2026 16:52:35 -0400
X-MC-Unique: cvj6r-bnOB-v-1ObHJ6DIg-1
X-Mimecast-MFC-AGG-ID: cvj6r-bnOB-v-1ObHJ6DIg_1789419155
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93a08ff8451so376686085a.2
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 13:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789419155; x=1790023955; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zdYN3TkuPCTA83dlb0z2HolmOPBsL0A+P6pUFC1TV6o=;
        b=cr32cgAQopuZnPCrRd8qZmKP22x1Yt9Fz4Z6wa1KuHOJHteWAf1ztHFJcmMi8t0JVf
         uWLsSitE6fnvNkHoiyp2SEMF7tVWHGCe4BLGi75GLmEfcXQtDc0dY2ST6OmEe91HNGLY
         USJnfYva4+XLOG3jzdUeUk6MsZ7SnCgbUJUCU4yr37cUnYTsRxDsgFoePwduBK4gYjC2
         eA33jyr310p7VqSqSrT8YD4I58gJ/2yMcy2oTUeJ5mq7MOzrKuNndapfrnpZtR4m9dmK
         oxyKNO9cqhWqWYEmcVc8VbNa2TaKdWJ2VdheqHm95hr7cnxZBYLdJcZXGPyf7sVenwX/
         p+wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789419155; x=1790023955;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zdYN3TkuPCTA83dlb0z2HolmOPBsL0A+P6pUFC1TV6o=;
        b=DqDeOSQ54uQQak42cuxOMtGXsr0ii1aob1SVf0po5h9L+vO+bh8pebMWcBo6ZgD/sk
         Y+bjorz+79yy90JL9KwhxzQ536+5cJ6TzNk3HyTPIDdj+8muf9yhtzMcTLboLEZxe8bh
         zoLeeEB6DgtMsa2V+PbASw3W+dcry/fb7pLz3vwLzlNOohTUSvkdUhppP86z6Zqt9zIF
         CYboWzAScT5M7muZvMGrkhLsxz6x9OURpj7z35StkL1P23K7bsjtxoiKo4TnB46HoUlP
         1laRiQ3BqFsN9zzQV8+vLSY4p1cY4X8Ye/SLfM8y8JxDdPE4WC5KOU5owIjFWVSdKTbc
         hDVw==
X-Gm-Message-State: AFuF++mvvf00m1KyiuNshx7MS2s9BAqUagSViyyeJQL5U5hFRHKGC5Uk
	eMovwoDRy8YRT5yOLkhXIrR6H/YqyJQvClN70c0R3SRLFpefl0v106GlopSBUyT0KQHQiLf8m1V
	x/kC93tpoqXd5vueLf0SfAFlpmiSFGsZHoVddE/b3kzq8c7bMHJNL26S4HPnx5yIrK+ybPf4PYL
	qYhkCVyWBP113ijzg+d3OOxlut8bZN2D60AuYqu6Xdhp+Hu+Q=
X-Gm-Gg: AYBFou1OQ583JbPs09gzMYchjdnEP7ukswPmq4MMB6JO2Ltrhwe6X++dROpzu0xIegV
	kZ9vOkV7jCdsyXqz1k7j0EX5qB/yatqd9wt6k1lgA6G9nCApjpzxjeeOcyhPsUZgB7Qll+fMlDb
	Gcx2iZth28BGnZ/4KF4Qc3ozc8+zleAqMprX0+o1OyZIvb9oHgE9ttJnD6i9lNc/1tNcpUuXwnJ
	KM9n2ol+Jg0hd56m47iPMTKvuMRy90548v2RzDBGshn+FgptBXBBl2PsScAvkeYdDF8ucmRuYRg
	urqSacYRj2IHzfC4Daml/wdh1NpP1ebGgnuSqTO79F//Cdpbu2yHAuG5aQiz1bt8VwDPBzlMyLp
	JvIwpZVR59en5P55HefDrQQ15/S3PgnU9loxZOQ==
X-Received: by 2002:a05:620a:172a:b0:939:6dfc:8abd with SMTP id af79cd13be357-93a29c362efmr658679885a.52.1789419154816;
        Mon, 14 Sep 2026 13:52:34 -0700 (PDT)
X-Received: by 2002:a05:620a:172a:b0:939:6dfc:8abd with SMTP id af79cd13be357-93a29c362efmr658674985a.52.1789419154240;
        Mon, 14 Sep 2026 13:52:34 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939e7f1da12sm1099236785a.9.2026.09.14.13.52.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 13:52:33 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 11/14] xfs: remove unused mp argument from xfs_calc_default_atomic_ioend_reservation()
Date: Mon, 14 Sep 2026 15:46:16 -0500
Message-ID: <20260914205221.1516254-12-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914205221.1516254-1-sandeen@redhat.com>
References: <20260914205221.1516254-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_trans_resv.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 3151e97ca8ff..57f682f0b54a 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -1292,7 +1292,6 @@ xfs_calc_namespace_reservations(
 
 STATIC void
 xfs_calc_default_atomic_ioend_reservation(
-	struct xfs_mount	*mp,
 	struct xfs_trans_resv	*resp)
 {
 	/* Pick a default that will scale reasonably for the log size. */
@@ -1398,7 +1397,7 @@ xfs_trans_resv_calc(
 	 * Now that we've finished computing the static reservations, we can
 	 * compute the dynamic reservation for atomic writes.
 	 */
-	xfs_calc_default_atomic_ioend_reservation(mp, resp);
+	xfs_calc_default_atomic_ioend_reservation(resp);
 }
 
 /*
@@ -1508,7 +1507,7 @@ xfs_calc_atomic_write_log_geometry(
 
 	ASSERT(blockcount > 0);
 
-	xfs_calc_default_atomic_ioend_reservation(mp, M_RES(mp));
+	xfs_calc_default_atomic_ioend_reservation(M_RES(mp));
 
 	per_intent = xfs_calc_atomic_write_ioend_geometry(mp, &step_size);
 
@@ -1545,7 +1544,7 @@ xfs_calc_atomic_write_reservation(
 	 * use the defaults.
 	 */
 	if (blockcount == 0) {
-		xfs_calc_default_atomic_ioend_reservation(mp, M_RES(mp));
+		xfs_calc_default_atomic_ioend_reservation(M_RES(mp));
 		return 0;
 	}
 
-- 
2.55.0

