Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E793E8340
	for <linux-xfs@vger.kernel.org>; Tue, 29 Sep 2026 23:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790723601; cv=none; b=INQarVEfDB9otFRA9AWSB/eJ26u6AxLTryFJ0fEJNoo9xpq8MQdA0Iyj8Kj8VrxhzUvT0LuwzTmuHCmb8YzM++AYd6+fsQoUB4cysAHGLypM9P45H3n4r22rJCNnCRY0mZMGsduah5ARLpovSTy+sd+y3PNlzT10sBd1riPFVS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790723601; c=relaxed/simple;
	bh=/ilIA44JXqtZTmbwZrhsZ6ol+s0bdI8D0orE4ifmMGk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=f4wPg22aS757XY2O6a98xFC3bkWNGwoJN2Xi5cDBd6JFq23vbZAgU2Y62P4tiTGp+gNd51tLa1DoGS7EnxqL8Cda4gbXsaoM5RkPMOEjpgrfJjRyVU+zCz/9nMhGvubvWpRADdYObYzWg8/fKho3v6kmh5dh0+U3IJspbAMybZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Nkxis1Gc; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cg+WD3jN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nkxis1Gc";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cg+WD3jN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790723599;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=UPVYPqcakFBfmTodi2OB9ccSniDcRNe1kpqKnNDDYjE=;
	b=Nkxis1GcUl4zPcxcOueoNOkkvwgCiheXgp1CcfULUp1s6JPx4viWAz5fNsYRqJzMOS69ES
	/EJmsYOFbNRB/4FgMfzvpv7zMlGa0oPliE59WyPFn6XigG2BuIr+9bnu3Kfs1ysBnNvO5f
	pektVq+xNSdyktyd2a/p8VM35Q+I/UE=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-562-HgqDNw86NbiZTBgbpIGmJw-1; Tue, 29 Sep 2026 19:13:17 -0400
X-MC-Unique: HgqDNw86NbiZTBgbpIGmJw-1
X-Mimecast-MFC-AGG-ID: HgqDNw86NbiZTBgbpIGmJw_1790723597
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-5333a1b634bso70563131cf.0
        for <linux-xfs@vger.kernel.org>; Tue, 29 Sep 2026 16:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790723597; x=1791328397; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=UPVYPqcakFBfmTodi2OB9ccSniDcRNe1kpqKnNDDYjE=;
        b=Cg+WD3jNOaX3ZQFJc4g7V87NWqlRne9RK7uKglKjRwvCxk85y8eeF2BLa9BUjwGBeH
         UNmfrHek11QdJTkvaF/ot0YklQD2UefRoQeyCpaj8Z99USZ6OfP9fslLMa6f3Xnm/QdR
         hNzY45ow1B5P66dACVTVT3gQE5N9KdcxMgkt+t+D+k3oHf61tggRNMesTFeZM+AH/UEz
         +ytRcgodbzAJhbv//3Yq48Bda6bqRjNuWjer2ZJh7CVvFTmAukTTW1OLDrNUhWFNJ5SD
         VvN3ExN0zIsQiGTjnbAGBgHM7nQIqf/VieF3JyvVlXu25ws3Gv3ohTvfAnRrL5aljGjJ
         f+PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790723597; x=1791328397;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UPVYPqcakFBfmTodi2OB9ccSniDcRNe1kpqKnNDDYjE=;
        b=gphHEh4ptbpVpD3Pa+WIal1Xt/8bn1u41t2uxjI+NO/+ygmZunu0i8alSizOgpImBR
         aBYGPAFfOr5Ejg7AjIvPnCj86DJ1vcLR89DNkAUK0vcu/PGj5FQRZj1b67P8OquewPVv
         eMLC25IEH7sErz0EpQHOrqfmL8CsSIIaHsDDNcM0npuamBS1KD3TFsmxKPhqYQdQ6YNE
         FFDuXg9KeX7Qn1KrrW/A4K1F21wchc588ab803ZZm6DEFcVsRCVPI9b0uaj8PSoTObSE
         IX0q7qy2Woq4PdUxDVmqSOhh3uCrg9vIxdxC1eBELLm+mv7VaJfYqq7Puh1mYdyojkRB
         71Ew==
X-Gm-Message-State: AFuF++lp0ZUaE2L2rrM+AFTkkN0lVwJWQndPr95CNBiCgu6q5ePvPYKK
	nfBvTzYe7VeqHzSyKKww1M0xZgao+91jVKRBIGRDeDICZ8QwCafgvANgco3ghOm6yQCkZ8vZg1R
	3zZJSXRFo7359+lsphxOsfkb/qti+q505g/pm4drKU7zEJx9dBy2/eEx6mL+du0Z2xPIKoDAVhL
	uvPbk50pNJZsNax9PSltMUsv767r14d8oAKUkAtsQ2kkiYIRo=
X-Gm-Gg: AYBFou3aukgJT+vOMx0ruRTFYkswMdI3bMiwiOrmqf130TLJ67gj4eiw9GUA395PLU2
	NJos74Y09PILLTXbtjpy7k/mNKK5aajfi3xQmRziT0cvqez6/4FcWU9fLd8itTVvMIQBN8qn7rD
	H6x+FdJWLhRAx5L5pfTf4+fEsGTUNgIbBQjtEJrnBTQym7QAbYrVDGEILbTMDvdGsC6rUHB6Kbg
	ep/G/0Jz5JvT4tzus560cNJ8lDGyPmrSWnhpkGmvW1B+p58cMfi5Tgp9P8WtJFEJfIJWGYDfuFj
	wzh7Udu2z+8W94YItf4iT6VgkKDzEZkY+M69wdplFRvrEO/hPSwHQEz4WZMfum9nTSzu3aT3VDu
	ixWwfNOMCphb6X16Y39j0zyxKKKYN31kVA9n6Og==
X-Received: by 2002:a05:622a:2283:b0:530:cc3c:c62d with SMTP id d75a77b69052e-5336a60c0d2mr15624371cf.44.1790723596777;
        Tue, 29 Sep 2026 16:13:16 -0700 (PDT)
X-Received: by 2002:a05:622a:2283:b0:530:cc3c:c62d with SMTP id d75a77b69052e-5336a60c0d2mr15623821cf.44.1790723595987;
        Tue, 29 Sep 2026 16:13:15 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53369b67cfbsm6214761cf.16.2026.09.29.16.13.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 16:13:15 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	Eric Sandeen <sandeen@redhat.com>,
	stable@vger.kernel.org
Subject: [PATCH] xfs: validate rc_domain in xchk_rtrefcount_mergeable
Date: Tue, 29 Sep 2026 18:13:05 -0500
Message-ID: <20260929231305.1368713-1-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xchk_refcount_mergeable validates that the domains match, but this
was omitted from the realtime version of the check; fix it.

Fixes: c27929670de144 ("xfs: scrub the realtime refcount btree")
Cc: stable@vger.kernel.org # v6.14
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/scrub/rtrefcount.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/scrub/rtrefcount.c b/fs/xfs/scrub/rtrefcount.c
index 3d916d71a135..460e3f094adf 100644
--- a/fs/xfs/scrub/rtrefcount.c
+++ b/fs/xfs/scrub/rtrefcount.c
@@ -379,6 +379,8 @@ xchk_rtrefcount_mergeable(
 	if (r1->rc_blockcount == 0)
 		return false;
 
+	if (r1->rc_domain != r2->rc_domain)
+		return false;
 	if (r1->rc_startblock + r1->rc_blockcount != r2->rc_startblock)
 		return false;
 	if (r1->rc_refcount != r2->rc_refcount)
-- 
2.55.0

