Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B58351C0B
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 22:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789425025; cv=none; b=YJ97EVj/l65ao4ND+DgwFUJsNNB+rp1pHha3/ShBiAuDk0QE/0hpM03eFgfJGWhb6ojIJQv4cg4sykU01pwFrsJhTSIZmEaYN4toNCrgqSJdanyARKOaIsrRl+NFta0PzhFiLlniyrwKxWMPYhCHnWg+FOZFpMobEpWGCrh6pBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789425025; c=relaxed/simple;
	bh=1U9MtmjQS8rTsFetd5f9gqtGeAgV5Hb2oCwC5wePK10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ksAO6aHdgzKPP2j6ybRGclVi/Zco/pzVl2eaA3VV22BChXWMkyqm1GJ5i31GaC9Bj5sDqHFFcrEoWi4E3GQPt0gl4mg6rVOZhHaE2F7/rArPNFuTCG6cKgebJSnwQmbLxAi0dZ6UqBMDR9CP9QZoOK+mR0IOggshI+oA/fI9DwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VBcVPvO/; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=tXxqyab1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VBcVPvO/";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="tXxqyab1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789425022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zdYN3TkuPCTA83dlb0z2HolmOPBsL0A+P6pUFC1TV6o=;
	b=VBcVPvO/YqoU8N26c0JoVSLfafioIOvekuaoMM//Y56aOTL4KkUZDXrCeJGr2rVCSgYvkk
	hrTv5k7KHVO0pIzAu/T2JmEPjOavYSufye/+kdPXcUFmGUVWDqcE9wShAJgTA/4cCZS6+f
	cRr07jUmxfeq8Hn1CKjTcN36ihSJQjA=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-Q0HyETMCO7WuEAv7jleCVQ-1; Mon, 14 Sep 2026 18:30:21 -0400
X-MC-Unique: Q0HyETMCO7WuEAv7jleCVQ-1
X-Mimecast-MFC-AGG-ID: Q0HyETMCO7WuEAv7jleCVQ_1789425021
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-530ef71ee55so30665241cf.0
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 15:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789425021; x=1790029821; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zdYN3TkuPCTA83dlb0z2HolmOPBsL0A+P6pUFC1TV6o=;
        b=tXxqyab1hndOb2pViLovaws16mZ2uq1BIEL7QZN0RqQVrQJxb6r8rTQN0lU46yf/K9
         dTpmgfE3ooXPfAFuyUjHhZQNDH7OSRLr6UYLMusxjoYiB+ofMLpTJYoYWIbtmnWZ2uqq
         3e02PJ8TqZCH4qt/5qmtpB/gT90N+A+vSgGTX0FdlMnzruPx7DKuN8k/G6D0BWSqQjRn
         tUIb66t4B2dtk+ztPj0AYmZ6Dhu1FD5EsoFlSRScQW0yBuEPUN9bXnaGnIsyGv3tHlbK
         o+WeHWOCqomc1xajfwDKFQ4WmL6LLB8t3pMTj/h+Tgkoz29xYr0hGHdccCZn82YVtdCd
         l56Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789425021; x=1790029821;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zdYN3TkuPCTA83dlb0z2HolmOPBsL0A+P6pUFC1TV6o=;
        b=rIAaHT0BwJYz0QjFsi9eszJwwiFBnpnSDZzBU2669n8cbDL7OEbQutjNTnkS9WB7b1
         4bQPfDFXzwjPi9LKFfTTfcoH+ZbKWkPb6VzXGweGdENa3KBZLxtwU9tBBRykloo6Gc3f
         BdDpiKmOv+oYX8XBoH3raruF0D79qEzR/CcLAfSYWSjw5Z3cFA/sq9RBtIQkeup0+UaF
         9hClv2yh5yo4jMxswteEQtGb+PmMSmCi2dbHYsQDwwK3j2VRq7HaYO+Aco8gaWZQOuA3
         PT7R4+whWbP51iXYy6s/WyB+d3mCMgEz9Fon6TTuJp5a3pKYXaBHvbZU59brvDUJUg3x
         u/Tw==
X-Gm-Message-State: AFuF++n7PYn2QhWnYXLuQs+9kkKa2fs23tkiMFnu0e2ltT3NMh1HrPVv
	R1AqxexV3Lxpus7rnsak23ABqjqNbB5PW7FptqJxfkLNW0G85L+taya52ZENdl0SbdOBLfMJOEc
	Ad/dsWc9yT+Vs/eBcFou86FbtsgZ8gMz+BxY3QkRW/ZYrLgcH5bKMHQ37v94hPI6wy+qCs2heFz
	7agOFL9Qqby4l/rw79ybEECCnpRSzEVnf+ZXs+YAdCWPdnfgU=
X-Gm-Gg: AYBFou0opSnSd7PK4P3BtvyO3zI6aTLIvR7KsFxtit1mLsQA6Fia1tOif2Z+NSsYKTV
	cwllQDYKZ8kM9kX44Xmyr8te8zsZ+BINs+OJ13u/qufBjHXTkC7IL5VCdfOmSzJv9oIzQsx+3ZH
	lsMfoEquFudsGU4b9dm1fUv6fDoYVps05HGL1iTjH0V9+2pyBlKY8Q3f9+m8iB0qTqOAl5QxSjS
	ZA1pVKA3pQSi/BCWZvup+vZtcMDW3KHakYhMnYqgI3OFV26FsmvqThwP8vQsM8G7CUF6lTFr+Ry
	2N1IECpCVib51bM5NWyj7LI0mPU/WH28h/YcTgD2WQ2fCGlnSQY5GvwespmUxdMdeao/+BQDKQn
	x3L5BWFiH+M3GOv+tPkYKj5JrYAWMyqmKH3qI0A==
X-Received: by 2002:a05:622a:1496:b0:531:190c:8600 with SMTP id d75a77b69052e-531190c8b3emr28292131cf.32.1789425021107;
        Mon, 14 Sep 2026 15:30:21 -0700 (PDT)
X-Received: by 2002:a05:622a:1496:b0:531:190c:8600 with SMTP id d75a77b69052e-531190c8b3emr28291161cf.32.1789425020406;
        Mon, 14 Sep 2026 15:30:20 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-530fa03dc30sm56084041cf.15.2026.09.14.15.30.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 15:30:19 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2 11/14] xfs: remove unused mp argument from xfs_calc_default_atomic_ioend_reservation()
Date: Mon, 14 Sep 2026 17:28:57 -0500
Message-ID: <20260914223007.1587017-12-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914223007.1587017-1-sandeen@redhat.com>
References: <20260914223007.1587017-1-sandeen@redhat.com>
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

