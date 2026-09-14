Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A94A3911DD
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 22:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789425035; cv=none; b=laF+kJ3sv3JOG/7iZvmKmxUGmku/Dd5Lv4L31GOsWKu6kHRd7Zn4IAMtB8MlBPRX4NyrprswfYP31TzD7/wlM40VAnv8k4UshmKjYk4IGNmAEM1GW/hcoKXWIpRt74c2DEPva5ROvYvXRU7tdjvL0mtMuPOcBEs81gcW6hsBz6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789425035; c=relaxed/simple;
	bh=SM6ja5Jg1TC5i4zFstQkMhg+PfmuiaM9pTiGPzZQkik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qzMIrJdReX8tXV0BD7iPrJDmpXnyRb73wMKBVHGZ16Nt2PsSoW2AMj1zPTq9/0tHYzhbaS7S4TPLTGMssfIkZL6hOUMGZorbNEIPqlb+fX2rJhZWLbFhYwcXPG+o59104GWCdpRMtNSHwgXigtsSCgQq/Iojq7ak0KIiVX698a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bchWsC5B; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=HdMHGhOm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bchWsC5B";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="HdMHGhOm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789425033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XhebEFh6NS0m4/mQw6eyCTfuKhMhmKYtKq5X0mqnFp4=;
	b=bchWsC5BFtoKn9auTf6FZBAl0q5TOpRJdv9OatyHMgOH/lpCChopirHv9u+gIuWznMxeY0
	8zMa4lAcJdk+a/SxCsl4uWXGi8BgM0lt6CsEmOFH8DM20bqK4STL1kQYPUWqyTa+ir3wOs
	vYFlVo5gOh2OzA2OJfaWAgv0RthUtnw=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-16-Z7uEEVpsMOu4JRnApw71Nw-1; Mon, 14 Sep 2026 18:30:31 -0400
X-MC-Unique: Z7uEEVpsMOu4JRnApw71Nw-1
X-Mimecast-MFC-AGG-ID: Z7uEEVpsMOu4JRnApw71Nw_1789425031
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-53001b668a6so115029271cf.1
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 15:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789425031; x=1790029831; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XhebEFh6NS0m4/mQw6eyCTfuKhMhmKYtKq5X0mqnFp4=;
        b=HdMHGhOm1p6QxhxnMaJQTqrWlgayhCObaLRuzF3kRYQnipt1ir6AU0K/sST+uVSK6R
         CUsZT4LScUVieQDCuCwZ6oQ650PRfka3kOVA7WF4CBZnoCdVHjqcxLjIFt0bHiYLJlDQ
         5M99Phw2SV0SjbtpiMEXty0OKxL5GF9kdBy7QjY1UBSIwGVKzDfOKKd/DIdE2VuFFwD8
         Ran4pJ80vdz1EQl57jT3S3WPCyfwa/PJyCtwV7oaV/w6m0S20/D2/d8wZ7lDOanK7GnN
         ucHfaWiTXRMaWpIhEv2saDaogLMXbvGInX0EXoNAluBs7OAFDyggNazJogHulEapkEj8
         v+OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789425031; x=1790029831;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XhebEFh6NS0m4/mQw6eyCTfuKhMhmKYtKq5X0mqnFp4=;
        b=xXXcHyBwHS0QyoM73u3BSJjthx026K3M3YvRu3r0i1iXPVsbAuKCq78NOW7zZOhmZa
         BxPtj0fWTLJhNdNUKjIoIuHEXw8+E9snYDvDU8nfODrj+ShpkrPUuz5xFbyABgaTi9aX
         By+XJ1mPxAe/X4LHQ5mRp3PyTxenbxjrvtEKvkJwL1+3z7pw5feCzLPhBYj8XQcjEZnZ
         uq9y/iNfDmwXeBxazZFafGqVRDq2pRo7EZcQOCZo00f8TjPSnt+NXz2jqm4o14F2KOkU
         D4gcGDgs7eyDpGEnPkO4bPsZiNny7I1D7eeyQkbCwqOGjbOMzZOWTW+/QHRZq/QawFxp
         lsRg==
X-Gm-Message-State: AFuF++ljBSeeK07f+2DhvFnRuEEY1myDV13tKD8Vr6zp7+ZO4tCxQZDM
	rvJETB9AM/PgxODL5WxvudA0e+6Qr26yHFwi+qx0NgUID3nxnu5tqt2EPyKV5zLpC6QTEJml19R
	KTRLH01YFvIMd6uX3shMq4jV2+hmnMWWMQxhgkt3URruq7k7rzDJIsn+881OlUO7VogMeKXpdwH
	nZ+avrY1TplLb4xXPM/+mauJhLo/hRB6O3vbtJNBT+iXq2lSI=
X-Gm-Gg: AYBFou0j8Ba507A6dnbqOb8ymFpGZa7m249NSMjvwO7hTYpdxE1xre2qxWvpMF7j5+7
	HnrmjHp1oQMEvvpsO/PC3VZ3vbbbl+sCtIWuAV5ax6LXxZ4pclTAI55FNY4M+W/WN2IaapwgeQx
	JpLCg/oihlpYJEOSs8tf4HcUOq5/wCPQs8XwSF56GD6I5HsPVHu5frSHU3e4zZV/VRpWbiWXXY9
	itCwIJFV2cA3ZgTs4zDgk2STcuZ4gPTLIqh9k+qrCtV+HxAPfjv/omHdSmcSoGsHXLKzP6H4NUZ
	laUlMkMIiN2g2U9Bghk4orDZZ8Ebqv2wWj/t9SdA3GTH1jQ2+QhVEeWX2S/otaykKA0xrJDoo9h
	6RXGvnXH5lK7hVjPp0arShhDUSQutEXRnBHSrKg==
X-Received: by 2002:ac8:5a51:0:b0:530:318f:3086 with SMTP id d75a77b69052e-5310cf3c86dmr70720931cf.17.1789425025139;
        Mon, 14 Sep 2026 15:30:25 -0700 (PDT)
X-Received: by 2002:ac8:5a51:0:b0:530:318f:3086 with SMTP id d75a77b69052e-5310cf3c86dmr70715491cf.17.1789425021698;
        Mon, 14 Sep 2026 15:30:21 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-530fa03dc30sm56084041cf.15.2026.09.14.15.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 15:30:20 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2 12/14] xfs: remove unused mp argument from xfs_verify_dablk()
Date: Mon, 14 Sep 2026 17:28:58 -0500
Message-ID: <20260914223007.1587017-13-sandeen@redhat.com>
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
 fs/xfs/libxfs/xfs_types.c | 1 -
 fs/xfs/libxfs/xfs_types.h | 2 +-
 fs/xfs/scrub/bmap.c       | 5 ++---
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index 67c947a47f14..b5b0b6334d11 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -222,7 +222,6 @@ xfs_verify_icount(
 /* Sanity-checking of dir/attr block offsets. */
 bool
 xfs_verify_dablk(
-	struct xfs_mount	*mp,
 	xfs_fileoff_t		dabno)
 {
 	xfs_dablk_t		max_dablk = -1U;
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index f6f4f2d4b5db..d217220d2054 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -277,7 +277,7 @@ bool xfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
 bool xfs_verify_rtbext(struct xfs_mount *mp, xfs_rtblock_t rtbno,
 		xfs_filblks_t len);
 bool xfs_verify_icount(struct xfs_mount *mp, unsigned long long icount);
-bool xfs_verify_dablk(struct xfs_mount *mp, xfs_fileoff_t off);
+bool xfs_verify_dablk(xfs_fileoff_t off);
 void xfs_icount_range(struct xfs_mount *mp, unsigned long long *min,
 		unsigned long long *max);
 bool xfs_verify_fileoff(struct xfs_mount *mp, xfs_fileoff_t off);
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 4f3c7f681bd9..868f502a44f2 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -453,18 +453,17 @@ xchk_bmap_dirattr_extent(
 	struct xchk_bmap_info	*info,
 	struct xfs_bmbt_irec	*irec)
 {
-	struct xfs_mount	*mp = ip->i_mount;
 	xfs_fileoff_t		off;
 
 	if (!S_ISDIR(VFS_I(ip)->i_mode) && info->whichfork != XFS_ATTR_FORK)
 		return;
 
-	if (!xfs_verify_dablk(mp, irec->br_startoff))
+	if (!xfs_verify_dablk(irec->br_startoff))
 		xchk_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 
 	off = irec->br_startoff + irec->br_blockcount - 1;
-	if (!xfs_verify_dablk(mp, off))
+	if (!xfs_verify_dablk(off))
 		xchk_fblock_set_corrupt(info->sc, info->whichfork, off);
 }
 
-- 
2.55.0

